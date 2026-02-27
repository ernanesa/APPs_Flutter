import { BrowserContext, chromium } from 'playwright';

export const USER_DATA_DIR = process.env.PLAY_CHROME_USER_DATA || 'C:\\Users\\Ernane\\AppData\\Local\\Google\\Chrome\\User Data';
export const PROFILE_DIR = process.env.PLAY_CHROME_PROFILE || 'Profile 4';

/**
 * Launch a persistent Chrome context using the system Chrome (channel: 'chrome')
 * and remove some automation flags to reduce "untrusted browser" detections.
 * headless: when true, will run headless (useful for CI). Default: false.
 */
export async function launchProfile(headless = false): Promise<BrowserContext> {
    try {
        return await chromium.launchPersistentContext(USER_DATA_DIR, {
            channel: 'chrome',
            headless,
            // Attempt to reduce automation detection
            ignoreDefaultArgs: ['--enable-automation'],
            args: [`--profile-directory=${PROFILE_DIR}`, '--disable-blink-features=AutomationControlled'],
            viewport: { width: 1400, height: 900 },
        });
    } catch (err) {
        console.error('Failed to launch persistent Chrome profile:', err);
        throw err;
    }
}
