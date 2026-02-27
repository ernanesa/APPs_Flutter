import fs from 'node:fs';
import path from 'node:path';
import { chromium } from 'playwright';

function parseArgs(argv) {
  const args = {
    out: '',
    appHint: '',
    timeoutMinutes: 15,
    pollSeconds: 3,
    channel: 'chrome',
    allowFallback: false,
    startUrl: 'https://admob.google.com/v2/apps/list',
  };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--out') args.out = argv[++i] || '';
    else if (a === '--app-hint') args.appHint = argv[++i] || '';
    else if (a === '--timeout-minutes') args.timeoutMinutes = Number(argv[++i] || '15');
    else if (a === '--poll-seconds') args.pollSeconds = Number(argv[++i] || '3');
    else if (a === '--channel') args.channel = (argv[++i] || '').trim();
    else if (a === '--allow-fallback') args.allowFallback = true;
    else if (a === '--start-url') args.startUrl = (argv[++i] || '').trim();
  }
  return args;
}

function uniq(arr) {
  return [...new Set(arr)];
}

function extractIds(text) {
  const re = /ca-app-pub-\d{10,}([~/]\d{6,})/g;
  const out = [];
  let m;
  while ((m = re.exec(text)) !== null) out.push(m[0]);
  return out;
}

function classify(rowText, id) {
  const t = (rowText || '').toLowerCase();
  if (id.includes('~')) return 'app_id';
  if (t.includes('app open') || t.includes('appopen')) return 'app_open';
  if (t.includes('interstitial')) return 'interstitial';
  if (t.includes('rewarded')) return 'rewarded';
  if (t.includes('banner')) return 'banner';
  return 'unknown';
}

async function scanPage(page) {
  const [bodyText, html] = await Promise.all([
    page.evaluate(() => document.body?.innerText || ''),
    page.content(),
  ]);

  const rawIds = uniq([...extractIds(bodyText), ...extractIds(html)]).sort();

  const contexts = await page.evaluate(() => {
    const ids = [];
    const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_ELEMENT);
    const nodes = [];
    while (walker.nextNode()) nodes.push(walker.currentNode);

    for (const el of nodes) {
      const text = (el.innerText || '').trim();
      if (!text || !text.includes('ca-app-pub-')) continue;
      const m = text.match(/ca-app-pub-\\d{10,}([~\\/]\\d{6,})/);
      if (!m) continue;
      const id = m[0];

      const row =
        el.closest('tr') ||
        el.closest('[role=\"row\"]') ||
        el.closest('mat-row') ||
        el.closest('div[role=\"row\"]') ||
        el.parentElement;
      const rowText = (row?.innerText || text).trim();

      ids.push({ id, rowText });
    }
    return ids;
  });

  return {
    url: page.url(),
    rawIds,
    contexts,
    bodySample: bodyText.slice(0, 5000),
  };
}

async function main() {
  const args = parseArgs(process.argv.slice(2));

  console.log('Opening AdMob (Chromium, headed)...');
  console.log('When Google asks for login, do it in the browser window.');
  console.log('IMPORTANT: use the Chrome window opened by THIS script (Playwright profile).');
  console.log('Goal: open Apps -> (your app) -> Ad units (list).');
  if (args.appHint) console.log(`App hint: ${args.appHint}`);
  console.log(`This script will auto-scan the current page every ${args.pollSeconds}s for ca-app-pub-* IDs (timeout: ${args.timeoutMinutes} min).`);
  console.log('When it finds enough IDs (App ID + 3+ ad units), it will print them and exit.');

  const channel = args.channel || 'chrome';
  console.log(`Browser channel: ${channel}`);

  // Prefer a persistent Chrome profile (project standard) to reduce Google login friction.
  // Use env vars PLAY_CHROME_USER_DATA and PLAY_CHROME_PROFILE to override defaults.
  let context;
  let page;
  const chromeUserData = process.env.PLAY_CHROME_USER_DATA || path.resolve(process.env.LOCALAPPDATA || 'C:\\Users\\Ernane\\AppData\\Local', 'Google\\Chrome\\User Data');
  const chromeProfile = process.env.PLAY_CHROME_PROFILE || 'Profile 4';
  try {
    console.log(`Trying persistent Chrome profile: ${chromeUserData} (${chromeProfile})`);
    context = await chromium.launchPersistentContext(chromeUserData, {
      channel,
      headless: false,
      viewport: { width: 1400, height: 900 },
      // Best-effort: reduce automation fingerprints (not guaranteed).
      ignoreDefaultArgs: ['--enable-automation'],
      args: [`--profile-directory=${chromeProfile}`, '--disable-blink-features=AutomationControlled'],
    });
    page = context.pages()[0] ?? (await context.newPage());
  } catch (e) {
    if (!args.allowFallback) {
      console.error('\nFailed to open the persistent Chrome profile.');
      console.error('Most common cause: a previous Playwright Chrome window is still open and is locking the profile.');
      console.error(`Close any Chrome window that was opened with this profile: ${userDataDir}`);
      console.error('Then run again. (Use --allow-fallback only if you accept logging in again.)');
      throw e;
    }

    console.log('Persistent profile failed; falling back to a fresh session (--allow-fallback).');
    const browser = await chromium.launch({
      channel,
      headless: false,
      // Best-effort: reduce automation fingerprints (not guaranteed).
      ignoreDefaultArgs: ['--enable-automation'],
      args: ['--disable-blink-features=AutomationControlled'],
    });
    context = await browser.newContext({ viewport: { width: 1400, height: 900 } });
    page = await context.newPage();
  }

  // Go straight to Apps list to minimize clicks.
  await page.goto(args.startUrl, { waitUntil: 'domcontentloaded' });

  const deadline = Date.now() + args.timeoutMinutes * 60_000;
  let lastUrl = '';
  let lastCount = -1;

  while (Date.now() < deadline) {
    const url = page.url();
    if (url !== lastUrl) {
      lastUrl = url;
      console.log(`\nURL: ${url}`);
    }

    const scan = await scanPage(page);
    const ids = scan.rawIds;

    if (ids.length !== lastCount) {
      lastCount = ids.length;
      console.log(`Found ${ids.length} unique ca-app-pub-* IDs on this page.`);
      if (ids.length) {
        for (const id of ids) console.log(`- ${id}`);
      }
    }

    const appIds = ids.filter((x) => x.includes('~'));
    const unitIds = ids.filter((x) => x.includes('/'));
    if (appIds.length >= 1 && unitIds.length >= 3) {
      // Build a best-effort classification using row context.
      const classified = {};
      for (const c of scan.contexts) {
        const kind = classify(c.rowText, c.id);
        if (!classified[kind]) classified[kind] = [];
        classified[kind].push({ id: c.id, rowText: c.rowText.split('\n').slice(0, 3).join(' | ') });
      }
      for (const k of Object.keys(classified)) {
        classified[k] = uniq(classified[k].map((x) => JSON.stringify(x))).map((s) => JSON.parse(s));
      }

      console.log('\nBest-effort classification (by row text):');
      for (const kind of Object.keys(classified).sort()) {
        console.log(`\n[${kind}]`);
        for (const item of classified[kind]) console.log(`- ${item.id}  (${item.rowText})`);
      }

      const result = {
        url: scan.url,
        ids,
        classified,
        foundAt: new Date().toISOString(),
      };

      if (args.out) {
        fs.writeFileSync(args.out, JSON.stringify(result, null, 2), 'utf8');
        console.log(`\nSaved: ${args.out}`);
      }

      await context.close();
      return;
    }

    await page.waitForTimeout(Math.max(1, args.pollSeconds) * 1000);
  }

  console.log('\nTimeout: did not find enough IDs. Tip: open the Ad units list or the details page for each unit.');
  await context.close();
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});
