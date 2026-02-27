import { test } from '@playwright/test';
import path from 'path';
import * as readline from 'readline';

// CONFIGURATION
const APP_NAME = 'White Noise - Sleep Sounds';
const SHORT_DESC = 'Relax with soothing sounds for better sleep and focus.'; // Trimmed to fit 80 char limit
const FULL_DESC = `🎵 White Noise - Sleep Sounds Transform your environment with our collection of high-quality white noise sounds. Perfect for sleep, focus, relaxation, and productivity. 🌙 SLEEP BETTER • Fall asleep faster with calming sounds • Block out distractions and noise • Create the perfect sleep environment 🎯 BOOST FOCUS • Improve concentration during work/study • Mask background noise in busy environments • Enhance productivity with ambient sounds 🔊 SOUND LIBRARY • Rain - Gentle rainfall for relaxation • Ocean - Waves crashing on the beach • Forest - Birds and nature sounds • White Noise - Pure soothing static • Fan - Cooling fan simulation • Cafe - Coffee shop ambiance • Fireplace - Crackling fire sounds • Thunder - Distant storm effects ⚙️ CUSTOMIZATION • Volume control for each sound • Mix multiple sounds together • Timer for automatic shutoff • Save custom sound combinations 📱 EASY TO USE • Simple, intuitive interface • Works offline - no internet required • Battery efficient • Free to download and use Download now and discover the power of white noise for better sleep and focus! 💤`;

const ASSETS_PATH = 'C:\\Users\\Ernane\\Personal\\APPs_Flutter_2\\DadosPublicacao\\white_noise';
const ICON = path.join(ASSETS_PATH, 'store_assets', 'icon_512.png');
const FEATURE_GRAPHIC = path.join(ASSETS_PATH, 'store_assets', 'feature_graphic.png');
const SCREENSHOTS_DIR = path.join(ASSETS_PATH, 'store_assets', 'screenshots');
const AAB_FILE = path.join(ASSETS_PATH, 'app-release.aab');

// Helper to wait for user input
async function waitForUserConfirmation(message: string): Promise<void> {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return new Promise((resolve) => {
    rl.question(message, () => {
      rl.close();
      resolve();
    });
  });
}

import { launchProfile } from './playwright_profile';

test('Publish White Noise - Interactive', async () => {
  console.log('\n🚀 WHITE NOISE PUBLICATION - INTERACTIVE MODE\n');

  const headless = process.env.PLAY_USE_PROFILE_HEADLESS === 'true';
  const context = await launchProfile(headless);
  const page = context.pages()[0] ?? (await context.newPage());
  try {

    // PHASE 1: MANUAL LOGIN
    console.log('📋 PHASE 1: AUTHENTICATION');
    console.log('Opening Google Play Console...\n');

    await page.goto('https://play.google.com/console');

    console.log('⚠️  PLEASE LOG IN MANUALLY');
    console.log('   - Complete all 2FA steps');
    console.log('   - Wait until you see the "Todos os apps" dashboard');
    await waitForUserConfirmation('   - Press ENTER when you are logged in and see the dashboard: ');

    console.log('\n✅ Proceeding with automated publication...\n');

    // PHASE 2: NAVIGATE TO APP
    console.log('📋 PHASE 2: FINDING APP');

    const searchInput = page.getByPlaceholder('Pesquisar por app ou nome do pacote');
    await searchInput.waitFor({ state: 'visible', timeout: 10000 });
    await searchInput.fill('White Noise');
    await page.keyboard.press('Enter');
    await page.waitForTimeout(2000);

    const appLink = page.getByRole('link', { name: /White Noise - Sleep Sounds/i });
    if (await appLink.isVisible()) {
      console.log('✅ App found, clicking...');
      await appLink.click();
    } else {
      console.error('❌ App not found on dashboard');
      throw new Error('App not found');
    }

    await page.waitForTimeout(2000);

    // PHASE 3: STORE LISTING
    console.log('\n📋 PHASE 3: UPDATING STORE LISTING');

    console.log('Navigating to Store Listing...');
    await page.getByRole('button', { name: /Aumentar número de usuários/i }).click();
    await page.waitForTimeout(1000);
    await page.getByRole('button', { name: /Presença na loja/i }).click();
    await page.waitForTimeout(1000);
    await page.getByRole('link', { name: /Páginas de detalhes do app/i }).click();
    await page.waitForTimeout(2000);

    console.log('Filling metadata...');
    await page.getByLabel('Nome do app').fill(APP_NAME);
    await page.getByLabel('Breve descrição').fill(SHORT_DESC);
    await page.getByLabel('Descrição completa').fill(FULL_DESC);

    console.log('Uploading icon...');
    const iconButton = page.getByRole('button', { name: /Adicionar recursos/i }).first();
    const [iconChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      iconButton.click(),
    ]);
    await iconChooser.setFiles(ICON);
    await page.waitForTimeout(2000);

    console.log('Uploading feature graphic...');
    const featureButton = page.getByRole('button', { name: /Adicionar recursos/i }).nth(1);
    const [featureChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      featureButton.click(),
    ]);
    await featureChooser.setFiles(FEATURE_GRAPHIC);
    await page.waitForTimeout(2000);

    console.log('Uploading screenshots...');
    const screenshots = [
      '01_home.png', '02_mix.png', '03_presets.png', '04_settings.png',
      '05_achievements.png', '06_timer.png', '07_themes.png', '08_sounds.png'
    ].map(f => path.join(SCREENSHOTS_DIR, f));

    const screenshotButton = page.getByRole('button', { name: /Adicionar recursos/i }).nth(2);
    const [screenshotChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      screenshotButton.click(),
    ]);
    await screenshotChooser.setFiles(screenshots);
    await page.waitForTimeout(3000);

    console.log('Saving store listing...');
    await page.getByRole('button', { name: /Salvar/i, exact: true }).click();
    await page.waitForTimeout(3000);

    console.log('✅ Store listing saved');

    // PHASE 4: PRODUCTION RELEASE
    console.log('\n📋 PHASE 4: CREATING PRODUCTION RELEASE');

    console.log('Navigating to Production...');
    await page.getByRole('button', { name: /Testar e lançar/i }).click();
    await page.waitForTimeout(1000);
    await page.getByRole('link', { name: /Produção/i }).click();
    await page.waitForTimeout(2000);

    console.log('Creating new release...');
    await page.getByRole('button', { name: /Criar nova versão/i }).click();
    await page.waitForTimeout(2000);

    console.log('Uploading AAB file...');
    const [aabChooser] = await Promise.all([
      page.waitForEvent('filechooser'),
      page.getByRole('button', { name: /Enviar/i }).click(),
    ]);
    await aabChooser.setFiles(AAB_FILE);

    console.log('⏳ Waiting for AAB upload to complete (this may take several minutes)...');
    await page.waitForSelector('text=/Upload concluído|concluído/i', { timeout: 600000 });
    console.log('✅ AAB uploaded successfully');

    console.log('Setting release details...');
    await page.getByLabel('Nome da versão').fill('1.0.0 (1)');
    await page.getByLabel('Notas da versão').fill('<pt-BR>Versão inicial do White Noise - Sleep Sounds.</pt-BR>');

    console.log('Saving release as draft...');
    await page.getByRole('button', { name: /Salvar/i }).click();
    await page.waitForTimeout(3000);

    console.log('\n✅ PUBLICATION COMPLETE!');
    console.log('📝 The release has been saved as a DRAFT');
    console.log('🔍 Please review it in the Play Console before final submission');

    await waitForUserConfirmation('\nPress ENTER to close the browser: ');
  } finally {
    await context.close();
  }
});
