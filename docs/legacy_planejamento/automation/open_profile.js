const { chromium } = require('playwright');

(async () => {
    try {
        const userDataDir = process.env.PLAY_CHROME_USER_DATA || 'C:\\Users\\Ernane\\AppData\\Local\\Google\\Chrome\\User Data';
        const profile = process.env.PLAY_CHROME_PROFILE || 'Profile 4';

        console.log(`Opening Chrome with userDataDir=${userDataDir} profile=${profile} (headed)...`);

        const context = await chromium.launchPersistentContext(userDataDir, {
            channel: 'chrome',
            headless: false,
            ignoreDefaultArgs: ['--enable-automation'],
            args: [`--profile-directory=${profile}`, '--disable-blink-features=AutomationControlled'],
            viewport: { width: 1400, height: 900 },
        });

        const page = context.pages()[0] ?? (await context.newPage());
        await page.goto('https://play.google.com/console');

        console.log('✅ Play Console opened in specified profile. Close the browser to end this script.');
    } catch (err) {
        console.error('Error while opening profile:', err);
        process.exit(1);
    }
})();
