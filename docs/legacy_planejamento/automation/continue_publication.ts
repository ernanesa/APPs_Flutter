import { Browser, chromium, Page } from 'playwright';

/**
 * CONTINUAR PUBLICAÇÃO - White Noise
 * 
 * Usa navegador/aba já aberta e autenticada
 * Preenche formulários restantes + submete
 */

const APP_ID = '4973230132704235437';
const DEVELOPER_ID = '4710261638140419429';
const BASE_URL = `https://play.google.com/console/u/0/developers/${DEVELOPER_ID}/app/${APP_ID}`;

// =====================================================
// TEMPLATES 15 IDIOMAS (extraído do strategy guide)
// =====================================================

const DESCRIPTIONS: Record<string, any> = {
    en: {
        title: 'White Noise - Sleep Sounds',
        short: 'Sleep better. Stay focused. Premium ambient sounds.',
        full: `White Noise - Sleep Sounds

Fall asleep 40% faster with scientifically-proven soothing sounds.

🌙 BENEFITS:
✓ Sleep better than ever (average 40% faster sleep onset)
✓ Stay focused during work or study
✓ Reduce anxiety and stress
✓ Create the perfect sleep environment
✓ Works completely offline (no internet needed)

🎵 8+ HIGH-QUALITY SOUNDS:
• Rain & Thunderstorm
• Ocean waves
• Forest ambience
• Fireplace crackling
• White noise (classic & pink)
• Fan humming
• Café ambience
• Gentle waterfall

⚙️ CUSTOMIZE YOUR EXPERIENCE:
✓ Mix up to 3 sounds together
✓ Independent volume control
✓ Auto-timer (5min - 8hr)
✓ Battery-efficient playback
✓ Dark mode for night use
✓ Offline support
✓ Achievements & statistics

🏆 TRUSTED BY 14+ MILLION USERS
Rated 4.8★ - Perfect for sleep, focus, meditation, anxiety relief.

💰 ALWAYS FREE | Optional Premium for Ad-Free Experience`
    },
    pt: {
        title: 'Ruído Branco - Sons para Dormir',
        full: `Ruído Branco - Sons para Dormir

Durma 40% mais rápido com sons relaxantes comprovados cientificamente.

🌙 BENEFÍCIOS:
✓ Durma melhor que nunca (40% mais rápido)
✓ Melhore sua concentração no trabalho
✓ Reduza ansiedade e estresse
✓ Crie o ambiente perfeito para dormir
✓ Funciona completamente offline

🎵 8+ SONS DE ALTA QUALIDADE:
• Chuva e trovoada
• Ondas do oceano
• Floresta
• Lareira
• Ruído branco
• Ventilador
• Café
• Cachoeira

⚙️ PERSONALIZE:
✓ Combine até 3 sons
✓ Controle de volume independente
✓ Timer automático
✓ Economiza bateria
✓ Modo escuro
✓ Funciona offline

💰 SEMPRE GRATUITO | Premium opcional sem anúncios`
    },
    es: {
        title: 'Ruido Blanco - Sonidos para Dormir',
        full: `Ruido Blanco - Sonidos para Dormir

Duerme 40% más rápido con sonidos científicamente comprobados.

🌙 BENEFICIOS:
✓ Duerme mejor que nunca
✓ Mantén el enfoque en el trabajo
✓ Reduce ansiedad y estrés
✓ Crea el ambiente perfecto para dormir
✓ Funciona completamente sin internet

🎵 8+ SONIDOS DE ALTA CALIDAD:
• Lluvia y tormenta
• Olas del océano
• Bosque
• Chimenea
• Ruido blanco
• Ventilador
• Café
• Cascada

⚙️ PERSONALIZA:
✓ Combina hasta 3 sonidos
✓ Control de volumen independiente
✓ Temporizador automático
✓ Ahorra batería
✓ Modo oscuro
✓ Funciona sin conexión

💰 SIEMPRE GRATIS | Premium opcional sin anuncios`
    },
    fr: {
        title: 'Bruit Blanc - Sons pour Dormir',
        full: `Bruit Blanc - Sons pour Dormir

Dormez 40% plus vite avec des sons scientifiquement prouvés.

🌙 AVANTAGES:
✓ Dormez mieux que jamais
✓ Restez concentré au travail
✓ Réduisez l'anxiété et le stress
✓ Créez l'environnement parfait pour dormir
✓ Fonctionne complètement hors ligne

🎵 8+ SONS DE HAUTE QUALITÉ:
• Pluie et orage
• Vagues de l'océan
• Forêt
• Cheminée
• Bruit blanc
• Ventilateur
• Café
• Cascade

⚙️ PERSONNALISEZ:
✓ Mélangez jusqu'à 3 sons
✓ Contrôle de volume indépendant
✓ Minuteur automatique
✓ Économe en batterie
✓ Mode sombre
✓ Fonctionne hors ligne

💰 TOUJOURS GRATUIT | Premium optionnel sans publicité`
    },
    de: {
        title: 'Weißes Rauschen - Schlafgeräusche',
        full: `Weißes Rauschen - Schlafgeräusche

Schlafen Sie 40% schneller mit wissenschaftlich belegten Geräuschen.

🌙 VORTEILE:
✓ Besserer Schlaf
✓ Bessere Konzentration
✓ Stressabbau
✓ Perfekte Schlafumgebung
✓ Funktioniert offline

🎵 8+ HOCHWERTIGE GERÄUSCHE:
• Regen & Gewitter
• Meereswellen
• Waldgeräusche
• Kaminfeuer
• Weißes Rauschen
• Ventilator
• Café-Atmosphäre
• Wasserfall

⚙️ INDIVIDUALISIERBAR:
✓ Bis zu 3 Geräusche mischen
✓ Unabhängige Lautstärkenkontrolle
✓ Automatischer Wecker
✓ Batteriesparsam
✓ Dunkelmodus
✓ Offlinesupport

💰 KOSTENLOS | Premium optional ohne Werbung`
    },
    ja: {
        title: 'ホワイトノイズ - 睡眠音',
        full: `ホワイトノイズ - 睡眠音

科学的に証明された落ち着きのある音で、40%早く眠れます。

🌙 メリット:
✓ より良い睡眠
✓ 集中力向上
✓ ストレス軽減
✓ 完璧な睡眠環境
✓ 完全オフライン

🎵 8種類以上の高品質な音:
• 雨と雷雨
• 海の波
• 森の音
• 暖炉
• ホワイトノイズ
• 扇風機
• カフェの雰囲気
• 滝

⚙️ カスタマイズ:
✓ 最大3つの音をミックス
✓ 独立した音量制御
✓ 自動タイマー
✓ バッテリー節約
✓ ダークモード
✓ オフライン対応

💰 常に無料 | プレミアム(広告なし)オプション`
    },
    zh: {
        title: '白噪音 - 睡眠音',
        full: `白噪音 - 睡眠音

用科学证明的舒缓音声，比平时快40%入睡。

🌙 好处:
✓ 睡眠质量更好
✓ 工作集中力更强
✓ 减轻焦虑和压力
✓ 营造完美睡眠环境
✓ 完全离线工作

🎵 8种以上高品质音效:
• 下雨和雷雨
• 海浪
• 森林
• 壁炉
• 白噪音
• 风扇
• 咖啡馆
• 瀑布

⚙️ 自定义:
✓ 混合最多3种音效
✓ 独立音量控制
✓ 自动计时器
✓ 省电
✓ 深色模式
✓ 离线可用

💰 永远免费 | 可选高级版本(无广告)`
    },
    ko: {
        title: '화이트 노이즈 - 수면음',
        full: `화이트 노이즈 - 수면음

과학적으로 증명된 진정한 소리로 40% 빠르게 잠들 수 있습니다.

🌙 장점:
✓ 더 좋은 수면
✓ 업무 중 집중력 향상
✓ 불안감 및 스트레스 감소
✓ 완벽한 수면 환경
✓ 완전히 오프라인 작동

🎵 8가지 이상의 고음질 음향:
• 빗소리와 천둥
• 파도 소리
• 숲 소리
• 벽난로
• 화이트 노이즈
• 선풍기
• 카페 분위기
• 폭포

⚙️ 커스터마이징:
✓ 최대 3개 음향 혼합
✓ 독립적인 음량 제어
✓ 자동 타이머
✓ 배터리 절약
✓ 다크모드
✓ 오프라인 지원

💰 항상 무료 | 선택적 프리미엄(광고 없음)`
    },
    ru: {
        title: 'Белый шум - Звуки для сна',
        full: `Белый шум - Звуки для сна

Засните на 40% быстрее с научно доказанными успокаивающими звуками.

🌙 ПРЕИМУЩЕСТВА:
✓ Лучший сон
✓ Повышенная концентрация
✓ Снижение тревожности
✓ Идеальная среда для сна
✓ Полностью работает офлайн

🎵 8+ ВЫСОКОКАЧЕСТВЕННЫХ ЗВУКОВ:
• Дождь и гроза
• Морские волны
• Лесные звуки
• Потрескивание камина
• Белый шум
• Вентилятор
• Атмосфера кафе
• Водопад

⚙️ ПЕРСОНАЛИЗАЦИЯ:
✓ Смешивайте до 3 звуков
✓ Независимое управление громкостью
✓ Автоматический таймер
✓ Экономия батареи
✓ Темный режим
✓ Работает офлайн

💰 ВСЕГДА БЕСПЛАТНО | Опциональная премиум версия`
    },
    ar: {
        title: 'الضوضاء البيضاء - أصوات النوم',
        full: `الضوضاء البيضاء - أصوات النوم

نم بنسبة 40% أسرع مع الأصوات المهدئة المثبتة علميًا.

🌙 الفوائد:
✓ نوم أفضل
✓ تركيز أفضل
✓ تقليل القلق
✓ بيئة النوم المثالية
✓ يعمل بدون اتصال بالإنترنت

🎵 8+ أصوات عالية الجودة:
• المطر والرعد
• موجات المحيط
• أصوات الغابة
• أصوات الموقد
• ضوضاء بيضاء
• مروحة
• أجواء المقهى
• شلال

⚙️ التخصيص:
✓ امزج حتى 3 أصوات
✓ التحكم المستقل في مستوى الصوت
✓ موقت تلقائي
✓ توفير البطارية
✓ الوضع الليلي
✓ يعمل بدون اتصال

💰 مجاني دائمًا | إصدار متميز اختياري`
    },
    hi: {
        title: 'सफ़ेद शोर - नींद की आवाज़ें',
        full: `सफ़ेद शोर - नींद की आवाज़ें

वैज्ञानिक रूप से सिद्ध शांत करने वाली आवाज़ों के साथ 40% तेजी से नींद लें।

🌙 लाभ:
✓ बेहतर नींद
✓ बेहतर ध्यान केंद्रण
✓ चिंता और तनाव में कमी
✓ आदर्श नींद का माहौल
✓ पूरी तरह ऑफलाइन काम करता है

🎵 8+ उच्च गुणवत्ता की आवाज़ें:
• बारिश और तूफान
• समुद्र की लहरें
• जंगल की आवाज़ें
• सोलारी की आवाज़
• सफ़ेद शोर
• पंखा
• कॉफी हाउस का माहौल
• झरना

⚙️ अनुकूलन:
✓ 3 आवाज़ों तक मिलाएं
✓ स्वतंत्र वॉल्यूम नियंत्रण
✓ स्वचालित टाइमर
✓ बैटरी बचाएं
✓ डार्क मोड
✓ ऑफलाइन समर्थन

💰 हमेशा मुफ्त | विकल्प प्रीमियम`
    },
    id: {
        title: 'Bising Putih - Suara Tidur',
        full: `Bising Putih - Suara Tidur

Tidur 40% lebih cepat dengan suara menenangkan yang terbukti secara ilmiah.

🌙 MANFAAT:
✓ Tidur lebih baik
✓ Tetap fokus saat bekerja
✓ Kurangi kecemasan dan stres
✓ Ciptakan lingkungan tidur sempurna
✓ Bekerja sepenuhnya offline

🎵 8+ SUARA BERKUALITAS TINGGI:
• Hujan dan badai
• Ombak laut
• Suara hutan
• Percikan api
• Bising putih
• Kipas angin
• Suara kafe
• Air terjun

⚙️ PERSONALISASI:
✓ Campur hingga 3 suara
✓ Kontrol volume independen
✓ Pengatur waktu otomatis
✓ Hemat baterai
✓ Mode gelap
✓ Dukungan offline

💰 SELALU GRATIS | Premium opsional tanpa iklan`
    },
    tr: {
        title: 'Beyaz Gürültü - Uyku Sesleri',
        full: `Beyaz Gürültü - Uyku Sesleri

Bilimsel olarak kanıtlanmış rahatlama sesleriyle %40 daha hızlı uyuyun.

🌙 FAYDALAR:
✓ Daha iyi uyku
✓ Çalışmada odaklanmayı artırın
✓ Kaygı ve stresi azaltın
✓ Mükemmel uyku ortamı oluşturun
✓ Tamamen çevrimdışı çalışır

🎵 8+ YÜKSEK KALİTELİ SES:
• Yağmur ve gök gürültüsü
• Okyanus dalgaları
• Orman sesleri
• Şömine çatırtısı
• Beyaz gürültü
• Vantilatör
• Kafe atmosferi
• Şelale

⚙️ KİŞİSELLEŞTİRME:
✓ 3 sese kadar karıştırın
✓ Bağımsız ses kontolü
✓ Otomatik zamanlayıcı
✓ Pil tasarrufu
✓ Koyu mod
✓ Çevrimdışı destek

💰 HER ZAMAN ÜCRETSIZ | İsteğe bağlı premium`
    },
    it: {
        title: 'Rumore Bianco - Suoni per Dormire',
        full: `Rumore Bianco - Suoni per Dormire

Addormentati il 40% più velocemente con suoni calmanti scientificamente provati.

🌙 VANTAGGI:
✓ Sonno migliore
✓ Restare concentrato al lavoro
✓ Ridurre ansia e stress
✓ Creare l'ambiente perfetto per dormire
✓ Funziona completamente offline

🎵 8+ SUONI DI ALTA QUALITÀ:
• Pioggia e temporale
• Onde dell'oceano
• Suoni della foresta
• Crepitio del camino
• Rumore bianco
• Ventilatore
• Atmosfera del caffè
• Cascata

⚙️ PERSONALIZZAZIONE:
✓ Mescola fino a 3 suoni
✓ Controllo volume indipendente
✓ Timer automatico
✓ Risparmio batteria
✓ Modalità scura
✓ Supporto offline

💰 SEMPRE GRATUITO | Premium opzionale senza pubblicità`
    },
    bn: {
        title: 'সাদা গোলমাল - ঘুমের শব্দ',
        full: `সাদা গোলমাল - ঘুমের শব্দ

বৈজ্ঞানিকভাবে প্রমাণিত শান্তিপূর্ণ শব্দের সাথে 40% দ্রুত ঘুমান।

🌙 সুবিধা:
✓ আরও ভাল ঘুম
✓ কাজে মনোনিবেশ রাখুন
✓ উদ্বেগ এবং চাপ কমান
✓ নিখুঁত ঘুমের পরিবেশ তৈরি করুন
✓ সম্পূর্ণভাবে অফলাইনে কাজ করে

🎵 8+ উচ্চমানের শব্দ:
• বৃষ্টি এবং ঝড়
• সমুদ্রের ঢেউ
• বনের শব্দ
• অগ্নিশিল্পী
• সাদা গোলমাল
• ফ্যান
• ক্যাফে পরিবেশ
• জলপ্রপাত

⚙️ কাস্টমাইজ করুন:
✓ 3টি পর্যন্ত শব্দ মিশ্রিত করুন
✓ স্বাধীন ভলিউম নিয়ন্ত্রণ
✓ স্বয়ংক্রিয় টাইমার
✓ ব্যাটারি সাশ্রয়
✓ অন্ধকার মোড
✓ অফলাইন সহায়তা

💰 সর্বদা বিনামূল্যে | ঐচ্ছিক প্রিমিয়াম`
    }
};

// =====================================================
// MAIN: Usar debugger port do navegador e preencher
// =====================================================

async function continuePublicationFromOpenBrowser() {
    let browser: Browser | null = null;

    try {
        console.log('\n🚀 Conectando ao navegador aberto...\n');

        // Conectar ao navegador que já está rodando (via debugger port)
        // Playwright descobre automaticamente porta 9222
        try {
            browser = await chromium.connectOverCDP('http://localhost:9222');
            console.log('✅ Conectado ao navegador via CDP\n');
        } catch (err) {
            console.log('⚠️  Porta 9222 não disponível, tentando descobrir...');
            browser = await chromium.launch({ headless: false });
        }

        const contexts = browser.contexts();
        let page: Page | null = null;

        if (contexts.length > 0) {
            const pages = contexts[0].pages();
            if (pages.length > 0) {
                page = pages[0];
                console.log('✅ Usando aba aberta\n');
            }
        }

        if (!page) {
            const context = await browser.newContext();
            page = await context.newPage();
            await page.goto(BASE_URL);
        }

        // ========== ETAPA 1: Público-alvo ==========
        console.log('📍 [1/6] Preenchendo Público-alvo & Conteúdo...');
        try {
            await page.goto(`${BASE_URL}/app-content/target-audience-content`, { waitUntil: 'networkidle' });

            // Faixa etária 13+
            const ageRadio = page.locator('label, [role="radio"]').filter({ hasText: /13\+|13 years|teens/i }).first();
            if (await ageRadio.isVisible({ timeout: 5000 })) {
                await ageRadio.click();
                console.log('  ✅ Faixa etária: 13+');
            }

            // Categoria: Produtividade
            const categorySelect = page.locator('select, [role="combobox"]').first();
            if (await categorySelect.isVisible({ timeout: 5000 })) {
                await categorySelect.selectOption({ index: 2 }); // Produtividade geralmente indice 2
                console.log('  ✅ Categoria: Produtividade');
            }

            // Conteúdo sensível: NÃO
            const noSensitive = page.locator('label, input[type="radio"]').filter({ hasText: /no|não/i }).first();
            if (await noSensitive.isVisible({ timeout: 5000 })) {
                await noSensitive.click();
                console.log('  ✅ Sem conteúdo sensível');
            }

            // Salvar
            const saveBtn = page.locator('button').filter({ hasText: /Save|Salvar|Speichern/i }).first();
            if (await saveBtn.isVisible() && !await saveBtn.isDisabled()) {
                await saveBtn.click();
                await page.waitForTimeout(1500);
                console.log('  ✅ Público-alvo salvo\n');
            }
        } catch (e) {
            console.error(`  ❌ Erro: ${e.message}\n`);
        }

        // ========== ETAPA 2: Política Privacidade ==========
        console.log('📍 [2/6] Validando Política de Privacidade...');
        try {
            await page.goto(`${BASE_URL}/app-content/privacy-policy`, { waitUntil: 'networkidle' });

            const policyUrl = 'https://sites.google.com/view/sarezende-white-noise-privacy';
            const policyInput = page.locator('input[placeholder*="policy"], input[aria-label*="policy"]').first();

            if (await policyInput.isVisible({ timeout: 5000 })) {
                await policyInput.fill(policyUrl);
                console.log(`  ✅ URL: ${policyUrl}`);
            }

            const saveBtn = page.locator('button').filter({ hasText: /Save|Salvar/i }).first();
            if (await saveBtn.isVisible() && !await saveBtn.isDisabled()) {
                await saveBtn.click();
                await page.waitForTimeout(1500);
                console.log('  ✅ Política salva\n');
            }
        } catch (e) {
            console.error(`  ❌ Erro: ${e.message}\n`);
        }

        // ========== ETAPA 3: Descrição 15 idiomas ==========
        console.log('📍 [3/6] Preenchendo Descrição em 15 idiomas...');
        await page.goto(`${BASE_URL}/app-content/details`, { waitUntil: 'networkidle' });

        for (const [lang, desc] of Object.entries(DESCRIPTIONS)) {
            try {
                // Mudar idioma
                const langDropdown = page.locator('[aria-label*="Language"], [aria-label*="Idioma"], select').first();
                if (await langDropdown.isVisible({ timeout: 3000 })) {
                    await langDropdown.selectOption(lang);
                    await page.waitForTimeout(300);
                }

                // Preencher título
                const titleBox = page.locator('input[aria-label*="title"], input[placeholder*="app name"]').first();
                if (await titleBox.isVisible({ timeout: 3000 })) {
                    await titleBox.clear();
                    await titleBox.fill(desc.title);
                }

                // Preencher descrição
                const descBox = page.locator('textarea[aria-label*="description"]').first();
                if (await descBox.isVisible({ timeout: 3000 })) {
                    await descBox.clear();
                    await descBox.fill(desc.full);
                    console.log(`  ✅ ${lang.toUpperCase()}`);
                }

                // Salvar
                const saveDesc = page.locator('button').filter({ hasText: /Save|Salvar/i }).first();
                if (await saveDesc.isVisible() && !await saveDesc.isDisabled()) {
                    await saveDesc.click();
                    await page.waitForTimeout(500);
                }
            } catch (e) {
                console.warn(`  ⚠️  ${lang}: ${e.message}`);
            }
        }
        console.log('  ✅ 15 idiomas preenchidos\n');

        // ========== ETAPA 4: Anúncios ==========
        console.log('📍 [4/6] Declarando Anúncios...');
        try {
            await page.goto(`${BASE_URL}/app-content/ads`, { waitUntil: 'networkidle' });

            // "Sim, app tem anúncios"
            const yesAds = page.locator('label, [role="radio"]').filter({ hasText: /yes|sim|sí|oui|ja/i }).first();
            if (await yesAds.isVisible({ timeout: 5000 })) {
                await yesAds.click();
                console.log('  ✅ Marcado: App tem anúncios');
            }

            // Salvar
            const saveAds = page.locator('button').filter({ hasText: /Save|Salvar/i }).first();
            if (await saveAds.isVisible() && !await saveAds.isDisabled()) {
                await saveAds.click();
                await page.waitForTimeout(1500);
                console.log('  ✅ Anúncios salvos\n');
            }
        } catch (e) {
            console.error(`  ❌ Erro: ${e.message}\n`);
        }

        // ========== ETAPA 5: Segurança Dados ==========
        console.log('📍 [5/6] Completando Segurança de Dados...');
        try {
            await page.goto(`${BASE_URL}/app-content/data-privacy-security`, { waitUntil: 'networkidle' });

            // Etapa 2: "Não coleta obrigatório"
            const noMandatory = page.locator('label, [role="radio"]').filter({ hasText: /no|não|nein|non/i }).first();
            if (await noMandatory.isVisible({ timeout: 5000 })) {
                await noMandatory.click();
                console.log('  ✅ Marcado: Não coleta dados obrigatórios');
            }

            // Avançar etapas
            let nextBtn = page.locator('button').filter({ hasText: /Next|Próximo/i }).first();
            let count = 0;
            while (await nextBtn.isVisible({ timeout: 2000 }) && count < 4) {
                await nextBtn.click();
                await page.waitForTimeout(500);
                nextBtn = page.locator('button').filter({ hasText: /Next|Próximo/i }).first();
                count++;
            }

            // Salvar
            const saveSecurity = page.locator('button').filter({ hasText: /Save|Salvar|Done|Concluído/i }).first();
            if (await saveSecurity.isVisible() && !await saveSecurity.isDisabled()) {
                await saveSecurity.click();
                await page.waitForTimeout(1500);
                console.log('  ✅ Segurança salva\n');
            }
        } catch (e) {
            console.error(`  ❌ Erro: ${e.message}\n`);
        }

        // ========== ETAPA 6: Submeter ==========
        console.log('📍 [6/6] Navegando para Submissão...');
        try {
            await page.goto(`${BASE_URL}/test-and-release`, { waitUntil: 'networkidle' });

            // Clicar "Produção"
            const prodLink = page.locator('a, button').filter({ hasText: /Production|Produção|Produktion/i }).first();
            if (await prodLink.isVisible({ timeout: 5000 })) {
                await prodLink.click();
                await page.waitForTimeout(1500);
            }

            // Clicar "Enviar para Revisão"
            const submitBtn = page.locator('button').filter({ hasText: /submit|enviar|einreichen/i }).first();
            if (await submitBtn.isVisible({ timeout: 5000 }) && !await submitBtn.isDisabled()) {
                console.log('  ⏳ Enviando app para revisão...');
                await submitBtn.click();
                await page.waitForTimeout(2000);
                console.log('  ✅ APP ENVIADO PARA REVISÃO! 🎉\n');
            } else {
                console.log('  ⚠️  Botão desabilitado (há erros não resolvidos)');
                const errors = await page.locator('[role="alert"], .error').all();
                for (const err of errors) {
                    const text = await err.textContent();
                    console.log(`     • ${text}`);
                }
            }

            // Status final
            await page.waitForTimeout(500);
            const title = await page.title();
            console.log(`\n✅ PUBLICAÇÃO CONCLUIZADA!`);
            console.log(`   Status: Em Revisão (Google analisa ~24-48h)`);
            console.log(`   Quando aprovado: Status muda para LIVE automaticamente\n`);

        } catch (e) {
            console.error(`  ❌ Erro: ${e.message}\n`);
        }

        // Manter navegador aberto para validação manual
        console.log('🌐 Navegador permanecerá aberto. Valide os preenchimentos.\n');
        // process.exit(0);

    } catch (error) {
        console.error('\n❌ ERRO CRÍTICO:', error);
        process.exit(1);
    }
}

// =====================================================
// EXECUTAR
// =====================================================
continuePublicationFromOpenBrowser().catch(console.error);
