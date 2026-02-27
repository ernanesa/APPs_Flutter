import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

// This script is for ONE-TIME manual authentication.
// It opens a browser, lets you login, and saves the session state.

const AUTH_FILE = path.join(__dirname, '../config/auth_session.json');

import { launchProfile } from '../playwright_profile';

test('AdMob Manual Login Setup', async () => {
  const headless = process.env.PLAY_USE_PROFILE_HEADLESS === 'true';
  const context = await launchProfile(headless);
  const page = context.pages()[0] ?? (await context.newPage());

  // 1. Go to AdMob
  await page.goto('https://apps.admob.com/v2/home');

  // 2. Pause to allow user to login manually (Handle 2FA etc)
  console.log('🚨 PLEASE LOGIN MANUALLY IN THE BROWSER WINDOW 🚨');
  console.log('Waiting for "Home" dashboard to appear...');

  // Wait for a specific element that appears only after login
  // The 'Home' dashboard usually has sidebar text "Home" or specific ID
  try {
    await page.waitForURL('**/home**', { timeout: 300000 }); // 5 minutes to login
  } catch (e) {
    console.log('Login timeout or failure.');
    throw e;
  }

  console.log('✅ Login detected! Saving session...');

  // 3. Save storage state (cookies, local storage)
  await context.storageState({ path: AUTH_FILE });

  console.log(`🎉 Session saved to ${AUTH_FILE}`);
  console.log('You can now run automation scripts headless!');
} finally {
  await context.close();
}
});
