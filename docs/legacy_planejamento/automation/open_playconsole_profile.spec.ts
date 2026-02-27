import { launchProfile } from './playwright_profile';

(async () => {
    const headless = process.env.PLAY_USE_PROFILE_HEADLESS === 'true';
    const context = await launchProfile(headless);
    const page = context.pages()[0] ?? (await context.newPage());

    await page.goto('https://play.google.com/console');
    console.log('✅ Play Console aberto no perfil Profile 4. Verifique o status do app White Noise.');
    console.log('Pressione Ctrl+C no terminal para fechar quando terminar.');
})();
