import { test } from '@playwright/test';
import fs from 'fs';
import path from 'path';


// CONFIGURATION
const APP_NAME = 'White Noise - Sleep Sounds';
const SHORT_DESC = 'Relax with soothing white noise sounds for better sleep and focus. Choose from rain, ocean, forest, and more.';
const FULL_DESC = `🎵 White Noise - Sleep Sounds Transform your environment with our collection of high-quality white noise sounds. Perfect for sleep, focus, relaxation, and productivity. 🌙 SLEEP BETTER • Fall asleep faster with calming sounds • Block out distractions and noise • Create the perfect sleep environment 🎯 BOOST FOCUS • Improve concentration during work/study • Mask background noise in busy environments • Enhance productivity with ambient sounds 🔊 SOUND LIBRARY • Rain - Gentle rainfall for relaxation • Ocean - Waves crashing on the beach • Forest - Birds and nature sounds • White Noise - Pure soothing static • Fan - Cooling fan simulation • Cafe - Coffee shop ambiance • Fireplace - Crackling fire sounds • Thunder - Distant storm effects ⚙️ CUSTOMIZATION • Volume control for each sound • Mix multiple sounds together • Timer for automatic shutoff • Save custom sound combinations 📱 EASY TO USE • Simple, intuitive interface • Works offline - no internet required • Battery efficient • Free to download and use Download now and discover the power of white noise for better sleep and focus! 💤`;

const REPO_ROOT = path.resolve(__dirname, '..');

// Prefer publishing assets inside the app folder (source of truth for repo).
const DEFAULT_PUBLISHING_DIR = path.join(REPO_ROOT, 'apps', 'media', 'white_noise', 'publishing');
const PUBLISHING_DIR = process.env.PLAY_PUBLISHING_DIR || DEFAULT_PUBLISHING_DIR;
const STORE_ASSETS_DIR = process.env.PLAY_STORE_ASSETS_DIR || path.join(PUBLISHING_DIR, 'store_assets');

// Release bundle is usually generated/kept under DadosPublicacao (ignored by git).
const DEFAULT_AAB_FILE = path.join(REPO_ROOT, 'DadosPublicacao', 'white_noise', 'app-release.aab');
const AAB_FILE = process.env.PLAY_AAB_FILE || DEFAULT_AAB_FILE;

const ICON = path.join(STORE_ASSETS_DIR, 'icon_512.png');
const FEATURE_GRAPHIC = path.join(STORE_ASSETS_DIR, 'feature_graphic.png');
const SCREENSHOTS_DIR = path.join(STORE_ASSETS_DIR, 'screenshots');

const AUTH_FILE = path.join(__dirname, 'config', 'auth_session.json');

// Use saved storage state for Play Console auth. If missing, instruct to run auth script.
if (!fs.existsSync(AUTH_FILE)) {
  throw new Error('Play Console auth not found. Run `npm run play:auth` and complete login to save the session to automation/config/auth_session.json.');
}

test.use({ storageState: AUTH_FILE });

test('Publish White Noise - Sleep Sounds', async ({ page }) => {
  if (!fs.existsSync(AAB_FILE)) {
    throw new Error(`AAB not found: ${AAB_FILE}. Build it first (flutter build appbundle --release) and/or set PLAY_AAB_FILE.`);
  }
    if (!fs.existsSync(ICON)) throw new Error(`Missing icon: ${ICON}`);
    if (!fs.existsSync(FEATURE_GRAPHIC)) throw new Error(`Missing feature graphic: ${FEATURE_GRAPHIC}`);
    if (!fs.existsSync(SCREENSHOTS_DIR)) throw new Error(`Missing screenshots dir: ${SCREENSHOTS_DIR}`);

    // 1. Load session if exists, or wait for manual login
    // Note: auth_setup should have been run or we can handle it here if headless: false

    await page.goto('https://play.google.com/console');

    // Find app
    console.log('Waiting for Dashboard (Searching for app input)...');
    const searchInput = page.getByPlaceholder('Pesquisar por app ou nome do pacote');
    try {
      await searchInput.waitFor({ state: 'visible', timeout: 300000 });
    } catch (e) {
      await page.screenshot({ path: 'dashboard_error.png' });
      console.log('Dashboard not found. Screenshot saved to dashboard_error.png. Ensure you are logged in.');
      throw e;
    }
    await searchInput.fill('White Noise');
    await page.keyboard.press('Enter');

    const appLink = page.getByRole('link', { name: /White Noise - Sleep Sounds/i });
    if (await appLink.isVisible()) {
      await appLink.click();
    } else {
      console.error('App not found on dashboard. Please ensure it is created.');
      return;
    }

    // 2. Main Store Listing
    console.log('Navigating to Main Store Listing...');
    await page.getByRole('button', { name: /Aumentar número de usuários/i }).click();
    await page.getByRole('button', { name: /Presença na loja/i }).click();
    await page.getByRole('link', { name: /Páginas de detalhes do app/i }).click();

    // Fill metadata
    console.log('Filling metadata...');
    await page.getByLabel('Nome do app').fill(APP_NAME);
    await page.getByLabel('Breve descrição').fill(SHORT_DESC);
    await page.getByLabel('Descrição completa').fill(FULL_DESC);

    // Upload Icon
    console.log('Uploading icon...');
    const [iconChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      page.getByRole('button', { name: /Adicionar recursos/i }).first().click(),
    ]);
    await iconChooser.setFiles(ICON);

    // Upload Feature Graphic
    console.log('Uploading feature graphic...');
    const [featureChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      page.getByRole('button', { name: /Adicionar recursos/i }).nth(1).click(),
    ]);
    await featureChooser.setFiles(FEATURE_GRAPHIC);

    // Upload Screenshots
    console.log('Uploading screenshots...');
    const screenshots = [
      '01_home.png', '02_mix.png', '03_presets.png', '04_settings.png',
      '05_achievements.png', '06_timer.png', '07_themes.png', '08_sounds.png'
    ].map(f => path.join(SCREENSHOTS_DIR, f));

    const [screenshotChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      page.getByRole('button', { name: /Adicionar recursos/i }).nth(2).click(),
    ]);
    await screenshotChooser.setFiles(screenshots);

    // Save
    console.log('Saving store listing...');
    await page.getByRole('button', { name: /Salvar/i, exact: true }).click();

    // 3. Create Release
    console.log('Creating production release...');
    await page.getByRole('button', { name: /Testar e lançar/i }).click();
    await page.getByRole('link', { name: /Produção/i }).click();
    await page.getByRole('button', { name: /Criar versão/i }).click();

    // Upload AAB
    console.log('Uploading AAB...');
    const [aabChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      page.getByRole('button', { name: /Enviar/i }).click(),
    ]);
    await aabChooser.setFiles(AAB_FILE);

    // Wait for upload (can take time)
    console.log('Waiting for AAB upload to finish...');
    await page.waitForSelector('text=Upload concluído', { timeout: 600000 }); // 10 mins

    // Set release details
    await page.getByLabel('Nome da versão').fill('1.0.0 (1)');
    await page.getByLabel('Notas da versão').fill('<pt-BR>Versão inicial do White Noise - Sleep Sounds.</pt-BR>');

    // Click Next
    await page.getByRole('button', { name: /Próximo/i }).click();

    console.log('Release ready for review!');
});
