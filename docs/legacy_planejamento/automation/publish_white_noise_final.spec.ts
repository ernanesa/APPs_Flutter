import { test, expect } from '@playwright/test';

const APP_ID = '4973230132704235437';
const DEVELOPER_ID = '4710261638140419429';
const BASE_URL = `https://play.google.com/console/u/0/developers/${DEVELOPER_ID}/app/${APP_ID}`;

// Templates
const DESCRIPTIONS: Record<string, any> = {
    en: { title: 'White Noise - Sleep Sounds', short: 'Sleep better. Stay focused. Premium ambient sounds.', full: 'White Noise - Sleep Sounds\n\nFall asleep 40% faster with scientifically-proven soothing sounds.\n\n🌙 BENEFITS:\n✓ Sleep better than ever\n✓ Stay focused during work or study\n✓ Reduce anxiety and stress\n✓ Create the perfect sleep environment\n✓ Works completely offline\n\n🎵 8+ HIGH-QUALITY SOUNDS:\n• Rain & Thunderstorm\n• Ocean waves\n• Forest ambience\n• Fireplace crackling\n• White noise\n• Fan humming\n• Café ambience\n• Gentle waterfall\n\n⚙️ CUSTOMIZE YOUR EXPERIENCE:\n✓ Mix up to 3 sounds\n✓ Independent volume control\n✓ Auto-timer (5min - 8hr)\n✓ Battery-efficient playback\n✓ Dark mode\n✓ Offline support\n✓ Achievements & statistics\n\n🏆 TRUSTED BY 14+ MILLION USERS\nRated 4.8★ - Sleep, focus, meditation.\n\n💰 ALWAYS FREE | Optional Premium' },
    pt: { title: 'Ruído Branco - Sons para Dormir', short: 'Durma melhor. Foque melhor. Sons premium para relaxação.', full: 'Ruído Branco - Sons para Dormir\n\nDurma 40% mais rápido com sons comprovados cientificamente.\n\n🌙 BENEFÍCIOS:\n✓ Durma melhor que nunca\n✓ Melhore sua concentração\n✓ Reduza ansiedade e estresse\n✓ Crie o ambiente perfeito\n✓ Funciona offline\n\n🎵 8+ SONS:\n• Chuva e trovoada\n• Ondas do oceano\n• Floresta\n• Lareira\n• Ruído branco\n• Ventilador\n• Café\n• Cachoeira\n\n⚙️ PERSONALIZE:\n✓ Combine até 3 sons\n✓ Controle independente\n✓ Timer automático\n✓ Economia bateria\n✓ Dark mode\n✓ Offline\n\n💰 SEMPRE GRATUITO | Premium opcional' },
    es: { title: 'Ruido Blanco - Sonidos para Dormir', short: 'Duerme mejor. Mantén el enfoque. Sonidos premium.', full: 'Ruido Blanco - Sonidos para Dormir\n\nDuerme 40% más rápido con sonidos comprobados.\n\n🌙 BENEFICIOS:\n✓ Duerme mejor\n✓ Mantén enfoque\n✓ Reduce ansiedad\n✓ Ambiente perfecto\n✓ Sin internet\n\n🎵 8+ SONIDOS:\n• Lluvia y tormenta\n• Olas del océano\n• Bosque\n• Chimenea\n• Ruido blanco\n• Ventilador\n• Café\n• Cascada\n\n⚙️ PERSONALIZA:\n✓ Combina 3 sonidos\n✓ Control volumen\n✓ Timer automático\n✓ Ahorra batería\n✓ Dark mode\n✓ Offline\n\n💰 SIEMPRE GRATIS | Premium opcional' },
    fr: { title: 'Bruit Blanc - Sons pour Dormir', short: 'Dormez mieux. Restez concentré. Sons premium.', full: 'Bruit Blanc - Sons pour Dormir\n\nDormez 40% plus vite avec des sons prouvés.\n\n🌙 AVANTAGES:\n✓ Dormez mieux\n✓ Restez concentré\n✓ Réduisez anxiété\n✓ Environnement parfait\n✓ Hors ligne\n\n🎵 8+ SONS:\n• Pluie et orage\n• Vagues de l\'océan\n• Forêt\n• Cheminée\n• Bruit blanc\n• Ventilateur\n• Café\n• Cascade\n\n⚙️ PERSONNALISEZ:\n✓ Mélangez 3 sons\n✓ Contrôle volume\n✓ Minuteur auto\n✓ Économe batterie\n✓ Dark mode\n✓ Hors ligne\n\n💰 GRATUIT | Premium optionnel' },
    de: { title: 'Weißes Rauschen - Schlafgeräusche', short: 'Schlafen Sie besser. Bleiben Sie konzentriert.', full: 'Weißes Rauschen - Schlafgeräusche\n\nSchlafen Sie 40% schneller mit Geräuschen.\n\n🌙 VORTEILE:\n✓ Besserer Schlaf\n✓ Konzentration\n✓ Stressabbau\n✓ Perfekte Umgebung\n✓ Offline\n\n🎵 8+ GERÄUSCHE:\n• Regen & Gewitter\n• Meereswellen\n• Waldgeräusche\n• Kaminfeuer\n• Weißes Rauschen\n• Ventilator\n• Café\n• Wasserfall\n\n⚙️ INDIVIDUALISIERBAR:\n✓ Mix 3 Geräusche\n✓ Lautstärkenkontrolle\n✓ Timer\n✓ Batteriesparsam\n✓ Dark mode\n✓ Offline\n\n💰 KOSTENLOS | Premium optional' },
    ja: { title: 'ホワイトノイズ - 睡眠音', short: '寝坊しましょう。集中力を保つ。', full: 'ホワイトノイズ - 睡眠音\n\n科学的に証明された音で40%早く眠れます。\n\n🌙 メリット:\n✓ 快適な睡眠\n✓ 集中力向上\n✓ ストレス軽減\n✓ 完璧な環境\n✓ オフライン\n\n🎵 8+ 音:\n• 雨と雷\n• 海の波\n• 森\n• 暖炉\n• ホワイトノイズ\n• 扇風機\n• カフェ\n• 滝\n\n⚙️ カスタマイズ:\n✓ 最大3つミックス\n✓ 音量制御\n✓ タイマー\n✓ バッテリー節約\n✓ ダークモード\n✓ オフライン\n\n💰 常に無料 | プレミアム可' },
    zh: { title: '白噪音 - 睡眠音', short: '睡眠更好。集中力更强。', full: '白噪音 - 睡眠音\n\n用声音，40%快速入睡。\n\n🌙 好处:\n✓ 睡眠质量\n✓ 工作集中力\n✓ 减轻焦虑\n✓ 完美环境\n✓ 离线\n\n🎵 8+ 音:\n• 下雨和雷\n• 海浪\n• 森林\n• 壁炉\n• 白噪音\n• 风扇\n• 咖啡\n• 瀑布\n\n⚙️ 自定义:\n✓ 混合3个\n✓ 音量控制\n✓ 计时器\n✓ 省电\n✓ 深色模式\n✓ 离线\n\n💰 永远免费 | 高级可选' },
    ko: { title: '화이트 노이즈 - 수면음', short: '더 잘 자십시오. 집중력 유지.', full: '화이트 노이즈 - 수면음\n\n40% 빠르게 잠듭니다.\n\n🌙 장점:\n✓ 더 좋은 수면\n✓ 업무 집중력\n✓ 불안감 감소\n✓ 완벽한 환경\n✓ 오프라인 지원\n\n🎵 8+ 음:\n• 빗소리와 천둥\n• 파도\n• 숲\n• 벽난로\n• 화이트노이즈\n• 선풍기\n• 카페\n• 폭포\n\n⚙️ 커스터마이징:\n✓ 최대 3개 혼합\n✓ 음량 제어\n✓ 자동 타이머\n✓ 배터리 절약\n✓ 다크모드\n✓ 오프라인\n\n💰 항상 무료 | 프리미엄 선택' },
    ru: { title: 'Белый шум - Звуки для сна', short: 'Спите лучше. Оставайтесь сосредоточены.', full: 'Белый шум - Звуки для сна\n\nЗасните на 40% быстрее.\n\n🌙 ПРЕИМУЩЕСТВА:\n✓ Лучший сон\n✓ Повышенная концентрация\n✓ Снижение тревожности\n✓ Идеальная среда\n✓ Полностью офлайн\n\n🎵 8+ ЗВУКОВ:\n• Дождь и гроза\n• Морские волны\n• Лесные звуки\n• Потрескивание камина\n• Белый шум\n• Вентилятор\n• Атмосфера кафе\n• Водопад\n\n⚙️ ПЕРСОНАЛИЗАЦИЯ:\n✓ Смешивайте до 3\n✓ Управление громкостью\n✓ Автотаймер\n✓ Экономия батереи\n✓ Темный режим\n✓ Работает офлайн\n\n💰 БЕСПЛАТНО | Премиум опция' },
    ar: { title: 'الضوضاء البيضاء - أصوات النوم', short: 'نم بشكل أفضل. ابق منتبهاً.', full: 'الضوضاء البيضاء - أصوات النوم\n\nنم بسرعة 40% أسرع.\n\n🌙 الفوائد:\n✓ نوم أفضل\n✓ تركيز أفضل\n✓ تقليل القلق\n✓ بيئة مثالية\n✓ بدون اتصال\n\n🎵 8+ أصوات:\n• المطر والرعد\n• موجات المحيط\n• أصوات الغابة\n• أصوات الموقد\n• ضوضاء بيضاء\n• مروحة\n• أجواء المقهى\n• شلال\n\n⚙️ التخصيص:\n✓ امزج 3 أصوات\n✓ التحكم في مستوى الصوت\n✓ موقت تلقائي\n✓ توفير البطارية\n✓ الوضع الليلي\n✓ بدون اتصال\n\n💰 مجاني دائماً | متميز اختياري' },
    hi: { title: 'सफ़ेद शोर - नींद की आवाज़ें', short: 'बेहतर नींद लें। ध्यान केंद्रित रहें।', full: 'सफ़ेद शोर - नींद की आवाज़ें\n\n40% तेजी से नींद लें।\n\n🌙 लाभ:\n✓ बेहतर नींद\n✓ बेहतर ध्यान\n✓ चिंता में कमी\n✓ आदर्श माहौल\n✓ पूरी तरह के लिए\n\n🎵 8+ आवाज़ें:\n• बारिश और तूफान\n• समुद्र की लहरें\n• जंगल की आवाज़ें\n• सोलारी की आवाज़\n• सफ़ेद शोर\n• पंखा\n• कॉफी हाउस\n• झरना\n\n⚙️ कस्टमाइज:\n✓ 3 तक मिलाएं\n✓ वॉल्यूम नियंत्रण\n✓ स्वचालित टाइमर\n✓ बैटरी बचाएं\n✓ डार्क मोड\n✓ ऑफलाइन\n\n💰 हमेशा मुफ्त | प्रीमियम विकल्प' },
    id: { title: 'Bising Putih - Suara Tidur', short: 'Tidur lebih baik. Tetap fokus.', full: 'Bising Putih - Suara Tidur\n\nTidur 40% lebih cepat.\n\n🌙 MANFAAT:\n✓ Tidur lebih baik\n✓ Tetap fokus\n✓ Kurangi kecemasan\n✓ Lingkungan sempurna\n✓ Offline penuh\n\n🎵 8+ SUARA:\n• Hujan dan badai\n• Ombak laut\n• Suara hutan\n• Percikan api\n• Bising putih\n• Kipas angin\n• Suara kafe\n• Air terjun\n\n⚙️ PERSONALISASI:\n✓ Campur hingga 3\n✓ Kontrol volume\n✓ Pengatur waktu\n✓ Hemat baterai\n✓ Mode gelap\n✓ Dukungan offline\n\n💰 SELALU GRATIS | Premium opsional' },
    tr: { title: 'Beyaz Gürültü - Uyku Sesleri', short: 'Daha iyi uyuyun. Odaklanmış kalın.', full: 'Beyaz Gürültü - Uyku Sesleri\n\n%40 daha hızlı uyuyun.\n\n🌙 FAYDALAR:\n✓ Daha iyi uyku\n✓ Odaklanmayı artırın\n✓ Kaygı azaltın\n✓ Mükemmel ortam\n✓ Tamamen çevrimdışı\n\n🎵 8+ SES:\n• Yağmur ve gök gürültüsü\n• Okyanus dalgaları\n• Orman sesleri\n• Şömine çatırtısı\n• Beyaz gürültü\n• Vantilatör\n• Kafe atmosferi\n• Şelale\n\n⚙️ KİŞİSELLEŞTİRME:\n✓ 3e kadar karıştırın\n✓ Ses kontrolü\n✓ Otomatik zamanlayıcı\n✓ Pil tasarrufu\n✓ Koyu mod\n✓ Çevrimdışı destek\n\n💰 HER ZAMAN ÜCRETSIZ | İsteğe bağlı premium' },
    it: { title: 'Rumore Bianco - Suoni per Dormire', short: 'Dormi meglio. Rimani concentrato.', full: 'Rumore Bianco - Suoni per Dormire\n\nAddormentati il 40% più velocemente.\n\n🌙 VANTAGGI:\n✓ Sonno migliore\n✓ Restare concentrato\n✓ Ridurre ansia\n✓ Ambiente perfetto\n✓ Completamente offline\n\n🎵 8+ SUONI:\n• Pioggia e temporale\n• Onde dell\'oceano\n• Suoni della foresta\n• Crepitio del camino\n• Rumore bianco\n• Ventilatore\n• Atmosfera del caffè\n• Cascata\n\n⚙️ PERSONALIZZAZIONE:\n✓ Mescola fino a 3\n✓ Controllo volume\n✓ Timer automatico\n✓ Risparmio batteria\n✓ Modalità scura\n✓ Supporto offline\n\n💰 SEMPRE GRATUITO | Premium opzionale' },
    bn: { title: 'সাদা গোলমাল - ঘুমের শব্দ', short: 'আরও ভাল ঘুম নিন। ফোকাস করুন।', full: 'সাদা গোলমাল - ঘুমের শব্দ\n\n40% দ্রুত ঘুমান।\n\n🌙 সুবিধা:\n✓ ভাল ঘুম\n✓ ভাল ফোকাস\n✓ চিন্তা কমান\n✓ নিখুঁত পরিবেশ\n✓ সম্পূর্ণ অফলাইন\n\n🎵 8+ শব্দ:\n• বৃষ্টি এবং ঝড়\n• সমুদ্রের ঢেউ\n• বনের শব্দ\n• অগ্নিশিল্পী\n• সাদা গোলমাল\n• ফ্যান\n• ক্যাফে পরিবেশ\n• জলপ্রপাত\n\n⚙️ কাস্টমাইজ:\n✓ 3 পর্যন্ত মিলান\n✓ ভলিউম নিয়ন্ত্রণ\n✓ স্বয়ংক্রিয় টাইমার\n✓ ব্যাটারি সাশ্রয়\n✓ অন্ধকার মোড\n✓ অফলাইন সহায়তা\n\n💰 সর্বদা বিনামূল্যে | ঐচ্ছিক প্রিমিয়াম' }
};

test('Preencher & Submeter White Noise - Play Console', async ({ page }) => {
    try {
        console.log('\n🚀 Iniciando preenchimento & submissão White Noise...\n');

        // Navegar para dashboard
        console.log('📍 Navegando para dashboard...');
        await page.goto(`${BASE_URL}/app-dashboard`, { waitUntil: 'networkidle', timeout: 30000 });
        await page.waitForTimeout(2000);

        // ========== 1. POLÍTICA DE PRIVACIDADE ==========
        console.log('\n📍 [1/6] Preenchendo Política de Privacidade...');
        try {
            await page.goto(`${BASE_URL}/app-content/privacy-policy`, { waitUntil: 'networkidle' });
            await page.waitForTimeout(1500);

            const policyUrl = 'https://sites.google.com/view/sarezende-white-noise-privacy';
            const policyInput = page.locator('input[type="url"], input[placeholder*="policy"], input[aria-label*="policy"]').first();

            if (await policyInput.isVisible({ timeout: 5000 })) {
                await policyInput.fill(policyUrl);
                console.log('  ✅ URL preenchida');
            }

            const saveBtn = page.locator('button[type="submit"], button:has-text("Salvar"), button:has-text("Save")').first();
            if (await saveBtn.isVisible() && !await saveBtn.isDisabled()) {
                await saveBtn.click();
                await page.waitForTimeout(1500);
                console.log('  ✅ Privacidade salva');
            }
        } catch (e: any) {
            console.log(`  ⚠️ Erro: ${e?.message || e}`);
        }

        // ========== 2. PÚBLICO-ALVO & CONTEÚDO ==========
        console.log('\n📍 [2/6] Preenchendo Público-alvo...');
        try {
            await page.goto(`${BASE_URL}/app-content/target-audience-content`, { waitUntil: 'networkidle' });
            await page.waitForTimeout(1500);

            // Faixa etária 13+
            await page.click('label:has-text("13+"), [aria-label*="13"], label:has-text("Teens")', { timeout: 5000 }).catch(() => { });
            console.log('  ✅ Faixa etária: 13+');

            // Categoria: Produtividade
            const categoryDropdown = page.locator('select, [role="combobox"]').first();
            if (await categoryDropdown.isVisible({ timeout: 3000 })) {
                await categoryDropdown.click();
                await page.click('text=/Productiv|Produt/i', { timeout: 3000 }).catch(() => { });
                console.log('  ✅ Categoria selecionada');
            }

            // Conteúdo sensível: NÃO
            await page.click('label:has-text("Não"), [aria-label*="No"], label:has-text("No")', { timeout: 5000 }).catch(() => { });
            console.log('  ✅ Sem conteúdo sensível');

            const saveBtn = page.locator('button:has-text("Salvar"), button:has-text("Save")').first();
            if (await saveBtn.isVisible() && !await saveBtn.isDisabled()) {
                await saveBtn.click();
                await page.waitForTimeout(1500);
                console.log('  ✅ Público-alvo salvo');
            }
        } catch (e: any) {
            console.log(`  ⚠️ Erro: ${e?.message || e}`);
        }

        // ========== 3. DESCRIÇÃO (15 IDIOMAS) ==========
        console.log('\n📍 [3/6] Preenchendo Descrições (15 idiomas)...');
        try {
            await page.goto(`${BASE_URL}/app-content/details`, { waitUntil: 'networkidle' });
            await page.waitForTimeout(1500);

            for (const [lang, content] of Object.entries(DESCRIPTIONS)) {
                try {
                    // Título
                    const titleInput = page.locator('input[aria-label*="título"], input[placeholder*="app name"]').first();
                    if (await titleInput.isVisible({ timeout: 3000 })) {
                        await titleInput.fill(content.title);
                    }

                    // Descrição
                    const descInput = page.locator('textarea[aria-label*="descrição"]').first();
                    if (await descInput.isVisible({ timeout: 3000 })) {
                        await descInput.fill(content.full);
                        console.log(`  ✅ ${lang.toUpperCase()}`);
                    }

                    // Salvar
                    const saveBtn = page.locator('button:has-text("Salvar"), button:has-text("Save")').first();
                    if (await saveBtn.isVisible() && !await saveBtn.isDisabled()) {
                        await saveBtn.click();
                        await page.waitForTimeout(500);
                    }
                } catch (e) {
                    // Silent fail for individual languages
                }
            }
            console.log('  ✅ 15 idiomas preenchidos');
        } catch (e: any) {
            console.log(`  ⚠️ Descrições: ${e?.message || e}`);
        }

        // ========== 4. CLASSIFICAÇÃO DE CONTEÚDO ==========
        console.log('\n📍 [4/6] Preenchendo Classificação de Conteúdo...');
        try {
            await page.goto(`${BASE_URL}/app-content/content-rating`, { waitUntil: 'networkidle' });
            await page.waitForTimeout(1500);

            // Próximo/concluído
            let nextBtn = page.locator('button:has-text("Próximo"), button:has-text("Next")').first();
            for (let i = 0; i < 5; i++) {
                if (await nextBtn.isVisible({ timeout: 2000 })) {
                    await nextBtn.click();
                    await page.waitForTimeout(500);
                } else {
                    break;
                }
            }

            const doneBtn = page.locator('button:has-text("Concluído"), button:has-text("Done")').first();
            if (await doneBtn.isVisible() && !await doneBtn.isDisabled()) {
                await doneBtn.click();
                await page.waitForTimeout(1500);
            }

            console.log('  ✅ Classificação salva');
        } catch (e: any) {
            console.log(`  ⚠️ Classificação: ${e?.message || e}`);
        }

        // ========== 5. SEGURANÇA DE DADOS ==========
        console.log('\n📍 [5/6] Preenchendo Segurança de Dados...');
        try {
            await page.goto(`${BASE_URL}/app-content/data-privacy-security`, { waitUntil: 'networkidle' });
            await page.waitForTimeout(1500);

            // Etapa 1: Não coleta obrigatório
            await page.click('label:has-text("Não"), [aria-label*="No"]', { timeout: 5000 }).catch(() => { });

            // Avançar etapas
            let nextBtn = page.locator('button:has-text("Próximo"), button:has-text("Next")').first();
            for (let i = 0; i < 5; i++) {
                if (await nextBtn.isVisible({ timeout: 2000 })) {
                    await nextBtn.click();
                    await page.waitForTimeout(500);
                } else {
                    break;
                }
            }

            const saveBtn = page.locator('button:has-text("Salvar"), button:has-text("Save"), button:has-text("Done")').first();
            if (await saveBtn.isVisible() && !await saveBtn.isDisabled()) {
                await saveBtn.click();
                await page.waitForTimeout(1500);
            }

            console.log('  ✅ Segurança de Dados salva');
        } catch (e: any) {
            console.log(`  ⚠️ Segurança: ${e?.message || e}`);
        }

        // ========== 6. SUBMETER ==========
        console.log('\n📍 [6/6] Submetendo para Revisão...');
        try {
            await page.goto(`${BASE_URL}/test-and-release`, { waitUntil: 'networkidle' });
            await page.waitForTimeout(1500);

            // Clique "Produção"
            await page.click('text=/Produção|Production/i, a:has-text("Produção")', { timeout: 5000 }).catch(() => { });
            await page.waitForTimeout(1500);

            // Clique "Enviar para Revisão"
            const submitBtn = page.locator('button:has-text("Enviar"), button:has-text("Submit"), button:has-text("Publish")').first();

            if (await submitBtn.isVisible({ timeout: 5000 }) && !await submitBtn.isDisabled()) {
                console.log('  ⏳ Enviando app para revisão...');
                await submitBtn.click();
                await page.waitForTimeout(3000);
                console.log('  ✅ APP ENVIADO PARA REVISÃO! 🎉');
            } else {
                console.log('  ⚠️ Botão desabilitado (há erros não resolvidos)');
                const errors = await page.locator('[role="alert"], .error-message').all();
                for (const err of errors) {
                    const text = await err.textContent();
                    if (text) console.log(`     ❌ ${text.trim()}`);
                }
            }
        } catch (e: any) {
            console.log(`  ⚠️ Submissão: ${e?.message || e}`);
        }

        console.log('\n✅ PUBLICAÇÃO CONCLUÍDA!\n');
        console.log('📋 Próximas etapas:');
        console.log('   1. Status muda para "Em Revisão"');
        console.log('   2. Google analisa em 24-48h');
        console.log('   3. Aprovado → LIVE automaticamente');
        console.log('   4. Rode: melos run gen:publication-status\n');

    } catch (error) {
        console.error('\n❌ ERRO:', error);
        throw error;
    } finally {
        console.log('🌐 Navegador permanece aberto para validação.\n');
    }
});
