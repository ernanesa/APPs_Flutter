import { test } from '@playwright/test';
import path from 'path';
const AUTH_FILE = path.join(__dirname, 'config', 'auth_session.json');

test('Google Play Console Manual Login Setup (Persistent CDP)', async () => {
  const { chromium } = require('playwright');
  let browser;

  try {
    browser = await chromium.connectOverCDP('http://localhost:9222');
    console.log('✅ Connected to persistent browser (CDP 9222)');
  } catch (err) {
    console.error('❌ CDP failed, fallback launch:', err.message);
    // Fallback if no persistent browser
    browser = await chromium.launch({ headless: false, channel: 'chrome' });
  }

  const context = await browser.newContext();
  const page = await context.newPage();

  await page.goto('https://play.google.com/console');
  console.log('🚨 LOGIN MANUALLY IN THE EXISTING BROWSER TAB 🚨');
  console.log('Follow all 2FA. Press Ctrl+C after dashboard loads.');
  console.log('Dashboard indicator: URL contains /developers/ & app-list');

  // Wait for dashboard
  await page.waitForURL('**/developers/**/app-list**', { timeout: 300000 });

  await context.storageState({ path: AUTH_FILE });
  console.log(`🎉 Session saved to ${AUTH_FILE}`);

  // Don't close browser
  console.log('✅ Browser stays open for reuse.');
});
