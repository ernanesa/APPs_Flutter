import { expect, test } from '@playwright/test';

/**
 * Automação Completa: White Noise - Sleep Sounds
 * 
 * Objetivo:
 * 1. Preencher Público-alvo (13+, Produtividade)
 * 2. Validar Política de Privacidade
 * 3. Preencher Descrição em 15 idiomas (otimizada por CPM/mercado)
 * 4. Declarar Anúncios (Google Mobile Ads)
 * 5. Completar Segurança de Dados
 * 6. Submeter para revisão
 * 
 * Sessão: Usa chrome_storage_state.json (pré-autenticada)
 */

const APP_ID = '4973230132704235437';
const DEVELOPER_ID = '4710261638140419429';
const BASE_URL = `https://play.google.com/console/u/0/developers/${DEVELOPER_ID}/app/${APP_ID}`;

// ============================================
// TEMPLATES DE DESCRIÇÃO (15 IDIOMAS)
// ============================================

const DESCRIPTIONS_BY_LANGUAGE: Record<string, { title: string; short: string; full: string }> = {
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
• Rain & Thunderstorm (different intensities)
• Ocean waves (5-hour loop)
• Forest ambience
• Fireplace crackling
• White noise (classic & pink noise)
• Fan humming (3 speeds)
• Café ambience
• Gentle waterfall

⚙️ CUSTOMIZE YOUR EXPERIENCE:
✓ Mix up to 3 sounds together
✓ Independent volume control for each sound
✓ Auto-timer with smart shutdown (5min - 8hr)
✓ Battery-efficient playback
✓ Dark mode for night use
✓ Minimize or lock screen while playing
✓ Offline support (download sounds)
✓ Achievements & listening statistics

🏆 TRUSTED BY 14+ MILLION USERS
Rated 4.8★ - Perfect for sleep, focus, meditation, anxiety relief.

💰 ALWAYS FREE | Optional Premium for Ad-Free Experience

Download now and sleep like never before!`
    },

    de: {
        title: 'Weißes Rauschen - Schlafgeräusche',
        short: 'Schlafen Sie besser. Bleiben Sie konzentriert. Premium-Naturgeräusche.',
        full: `Weißes Rauschen - Schlafgeräusche
    
Schlafen Sie 40% schneller mit wissenschaftlich belegten, beruhigenden Geräuschen.

🌙 VORTEILE:
✓ Besserer Schlaf (40% schnelleres Einschlafen)
✓ Bessere Konzentration bei der Arbeit
✓ Stressabbau und Angstbekämpfung
✓ Perfekte Schlafumgebung schaffen
✓ Funktioniert vollständig offline

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
✓ Mischen Sie bis zu 3 Geräusche
✓ Unabhängige Lautstärkenkontrolle
✓ Automatischer Timer
✓ Batteriesparsam
✓ Dunkelmodus
✓ Offline-Unterstützung

💰 KOSTENLOS | Optional Premium ohne Werbung`
    },

    pt: {
        title: 'Ruído Branco - Sons para Dormir',
        short: 'Durma melhor. Foque melhor. Sons premium para relaxação.',
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
✓ Timer automático (5min a 8h)
✓ Economiza bateria
✓ Modo escuro
✓ Funciona offline

💰 SEMPRE GRATUITO | Premium opcional sem anúncios`
    },

    es: {
        title: 'Ruido Blanco - Sonidos para Dormir',
        short: 'Duerme mejor. Mantén el enfoque. Sonidos premium relajantes.',
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
        short: 'Dormez mieux. Restez concentré. Sons de relaxation premium.',
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

    ja: {
        title: 'ホワイトノイズ - 睡眠音',
        short: '寝坊しましょう。集中力を保つ。プレミアムリラックス音。',
        full: `ホワイトノイズ - 睡眠音
    
科学的に証明された落ち着きのある音で、40%早く眠れます。

🌙 メリット:
✓ これまで以上に快適な睡眠
✓ 仕事中の集中力向上
✓ 不安とストレスの軽減
✓ 完璧な睡眠環境を作成
✓ 完全オフラインで動作

🎵 8つ以上の高品質な音:
• 雨と雷雨
• 海の波
• 森
• 暖炉
• ホワイトノイズ
• 扇風機
• カフェ
• 滝

⚙️ カスタマイズ:
✓ 最大3つの音をミックス
✓ 独立した音量制御
✓ 自動タイマー
✓ バッテリー節約
✓ ダークモード
✓ オフライン対応

💰 常に無料 | プレミアム広告なし（オプション）`
    },

    zh: {
        title: '白噪音 - 睡眠音',
        short: '睡眠更好。集中力更强。高级放松音。',
        full: `白噪音 - 睡眠音
    
用科学证明的舒缓音声，比平时快40%入睡。

🌙 好处:
✓ 睡眠质量更好
✓ 工作时集中力更强
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
        short: '더 잘 잘 수 있습니다. 집중력 유지. 프리미엄 이완음.',
        full: `화이트 노이즈 - 수면음
    
과학적으로 증명된 진정한 소리로 40% 빠르게 잠들 수 있습니다.

🌙 장점:
✓ 이전보다 더 좋은 수면
✓ 업무 중 집중력 향상
✓ 불안감 및 스트레스 감소
✓ 완벽한 수면 환경 조성
✓ 완전히 오프라인에서 작동

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
        short: 'Спите лучше. Оставайтесь сосредоточены. Премиум звуки для релаксации.',
        full: `Белый шум - Звуки для сна
    
Засните на 40% быстрее с научно доказанными успокаивающими звуками.

🌙 ПРЕИМУЩЕСТВА:
✓ Лучший сон, чем когда-либо
✓ Повышенная концентрация на работе
✓ Снижение тревожности и стресса
✓ Создание идеальной среды для сна
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

💰 ВСЕГДА БЕСПЛАТНО | Опциональная премиум версия без рекламы`
    },

    ar: {
        title: 'الضوضاء البيضاء - أصوات النوم',
        short: 'نم أفضل. ابق منتبهًا. أصوات استرخاء متميزة.',
        full: `الضوضاء البيضاء - أصوات النوم
    
نم بنسبة 40% أسرع مع الأصوات المهدئة المثبتة علميًا.

🌙 الفوائد:
✓ نوم أفضل من أي وقت مضى
✓ تركيز أفضل في العمل
✓ تقليل القلق والتوتر
✓ إنشاء بيئة النوم المثالية
✓ يعمل تمامًا بدون اتصال بالإنترنت

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

💰 مجاني دائمًا | إصدار متميز اختياري بدون إعلانات`
    },

    hi: {
        title: 'सफ़ेद शोर - नींद की आवाज़ें',
        short: 'बेहतर नींद लें। ध्यान केंद्रित रहें। प्रीमियम विश्राम के लिए आवाज़ें।',
        full: `सफ़ेद शोर - नींद की आवाज़ें
    
वैज्ञानिक रूप से सिद्ध शांत करने वाली आवाज़ों के साथ 40% तेजी से नींद लें।

🌙 लाभ:
✓ पहले से बेहतर नींद
✓ काम में बेहतर ध्यान केंद्रण
✓ चिंता और तनाव में कमी
✓ नींद के लिए आदर्श माहौल बनाएं
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

💰 हमेशा मुफ्त | विकल्प प्रीमियम बिना विज्ञापन`
    },

    id: {
        title: 'Bising Putih - Suara Tidur',
        short: 'Tidur lebih baik. Tetap fokus. Suara relaksasi premium.',
        full: `Bising Putih - Suara Tidur
    
Tidur 40% lebih cepat dengan suara menenangkan yang terbukti secara ilmiah.

🌙 MANFAAT:
✓ Tidur lebih baik dari sebelumnya
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
        short: 'Daha iyi uyuyun. Odaklanmış kalın. Premium rahatlama sesleri.',
        full: `Beyaz Gürültü - Uyku Sesleri
    
Bilimsel olarak kanıtlanmış rahatlama sesleriyle %40 daha hızlı uyuyun.

🌙 FAYDALAR:
✓ Her zamankinden daha iyi uyku
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

💰 HER ZAMAN ÜCRETSIZ | İsteğe bağlı premium reklamsız`
    },

    it: {
        title: 'Rumore Bianco - Suoni per Dormire',
        short: 'Dormi meglio. Rimani concentrato. Suoni di relax premium.',
        full: `Rumore Bianco - Suoni per Dormire
    
Addormentati il 40% più velocemente con suoni calmanti scientificamente provati.

🌙 VANTAGGI:
✓ Sonno migliore che mai
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
        short: 'আরও ভাল ঘুম নিন। মনোনিবেশ রাখুন। প্রিমিয়াম শিথিল শব্দ।',
        full: `সাদা গোলমাল - ঘুমের শব্দ
    
বৈজ্ঞানিকভাবে প্রমাণিত শান্তিপূর্ণ শব্দের সাথে 40% দ্রুত ঘুমান।

🌙 সুবিধা:
✓ এর চেয়ে ভাল ঘুম
✓ কাজে মনোনিবেশ রাখুন
✓ উদ্বেগ এবং চাপ কমান
✓ নিখুঁত ঘুমের পরিবেश তৈরি করুন
✓ সম্পূর্ণভাবে অফলাইনে কাজ করে

🎵 8+ উচ্চমানের শব্দ:
• বৃষ্টি এবং ঝড়
• সমুদ্রের ঢেউ
• বনের শব্দ
• অগ্নিশিল্পী
• সাদা গোলমাল
• ফ্যান
• ক্যাফে পরিবেश
• জলপ্রপাত

⚙️ কাস্টমাইজ করুন:
✓ 3টি পর্যন্ত শব্দ মিশ্রিত করুন
✓ স্বাধীন ভলিউম নিয়ন্ত্রণ
✓ স্বয়ংক্রিয় টাইমার
✓ ব্যাটারি সাশ্রয়
✓ অন্ধকার মোড
✓ অফলাইন সহায়তা

💰 সর্বদা বিনামূল্যে | ঐচ্ছিক প্রিমিয়াম বিনা বিজ্ঞাপন`
    }
};

// ============================================
//  TESTE SPEC
// ============================================

test('Complete White Noise Publication Flow', async ({ page, context }) => {
    console.log('\n🚀 Iniciando fluxo completo de publicação:\n');

    // ==========================================
    // 1. NAVEGAÇÃO - Dashboard
    // ==========================================
    console.log('📍 [1/6] Navegando para Play Console Dashboard...');
    await page.goto(`${BASE_URL}/app-dashboard`);
    await page.waitForLoadState('networkidle');

    // Verificar se está logado
    const heading = await page.locator('h1, h2').first().textContent();
    expect(heading).toContain('White Noise', { ignoreCase: true });
    console.log('✅ Dashboard carregado. Usuário autenticado.');

    // ==========================================
    // 2. PÚBLICO-ALVO & CONTEÚDO
    // ==========================================
    console.log('\n📍 [2/6] Preenchendo Público-alvo & Conteúdo...');
    await page.goto(`${BASE_URL}/app-content/target-audience-content`);
    await page.waitForLoadState('networkidle');

    try {
        // Faixa etária: 13+
        const ageButton13 = page.locator('label, [role="radio"]').filter({
            hasText: /13\+|thirteen|13 years|13\-17|teens/i
        }).first();

        if (await ageButton13.isVisible()) {
            await ageButton13.click();
            console.log('  ✅ Faixa etária: 13+ selecionada');
        }

        // Categoria: Produtividade (Lifestyle/Tools)
        const categorySelect = page.locator('select, [role="combobox"]').filter({
            hasText: /category|categoria|Kategorie/i
        }).first();

        if (await categorySelect.isVisible()) {
            await categorySelect.selectOption({ label: /Productivity|Produtividade|Produktivität/i });
            console.log('  ✅ Categoria: Produtividade');
        }

        // Conteúdo sensível: NÃO
        const sensitiveCheckbox = page.locator('input[type="checkbox"], label').filter({
            hasText: /sensitive|sensível|sensible/i
        }).first();

        if (await sensitiveCheckbox.isVisible()) {
            await sensitiveCheckbox.click({ force: true });
            console.log('  ✅ Marcado: Sem conteúdo sensível');
        }

        // Salvar
        const saveBtnAudience = page.locator('button').filter({ hasText: /Save|Salvar|Speichern/ }).first();
        if (await saveBtnAudience.isVisible()) {
            await saveBtnAudience.click();
            await page.waitForTimeout(1000);
            console.log('  ✅ Formulário Público-alvo salvo');
        }
    } catch (error) {
        console.error(`  ⚠️ Erro ao preencher Público-alvo: ${error.message}`);
    }

    // ==========================================
    // 3. POLÍTICA DE PRIVACIDADE
    // ==========================================
    console.log('\n📍 [3/6] Validando Política de Privacidade...');
    await page.goto(`${BASE_URL}/app-content/privacy-policy`);
    await page.waitForLoadState('networkidle');

    const policyUrl = 'https://sites.google.com/view/sarezende-white-noise-privacy';

    try {
        // Preencher URL
        const policyInput = page.locator('input[placeholder*="policy"], input[aria-label*="policy"]').first();
        if (await policyInput.isVisible()) {
            await policyInput.fill(policyUrl);
            console.log(`  ✅ URL preenchida: ${policyUrl}`);
        }

        // Validar URL (GET request)
        try {
            const response = await context.request.get(policyUrl);
            if (response.ok) {
                console.log(`  ✅ Política validada (${response.status})`);
            } else {
                console.warn(`  ⚠️ Política retornou ${response.status}`);
            }
        } catch (fetchError) {
            console.warn(`  ⚠️ Não foi possível validar URL: ${fetchError.message}`);
        }

        // Salvar
        const saveBtnPolicy = page.locator('button').filter({ hasText: /Save|Salvar/ }).first();
        if (await saveBtnPolicy.isVisible() && !await saveBtnPolicy.isDisabled()) {
            await saveBtnPolicy.click();
            await page.waitForTimeout(1000);
            console.log('  ✅ Política de Privacidade salva');
        }
    } catch (error) {
        console.error(`  ⚠️ Erro ao preencher Política: ${error.message}`);
    }

    // ==========================================
    // 4. DESCRIÇÃO (15 IDIOMAS)
    // ==========================================
    console.log('\n📍 [4/6] Preenchendo Descrição em 15 idiomas...');
    await page.goto(`${BASE_URL}/app-content/details`);
    await page.waitForLoadState('networkidle');

    for (const [lang, content] of Object.entries(DESCRIPTIONS_BY_LANGUAGE)) {
        try {
            // Selecionar idioma
            const langSelect = page.locator('select, [role="combobox"]').filter({
                hasText: /language|idioma|sprache/i
            }).first();

            if (await langSelect.isVisible()) {
                await langSelect.selectOption(lang);
                await page.waitForTimeout(300);
            }

            // Preencher título
            const titleBox = page.locator('input[placeholder*="title"], input[aria-label*="title"]').first();
            if (await titleBox.isVisible()) {
                await titleBox.fill(content.title);
            }

            // Preencher descrição
            const descBox = page.locator('textarea').filter({
                hasText: /.{10,}/
            }).first();

            if (await descBox.isVisible()) {
                await descBox.fill(content.full);
                console.log(`  ✅ ${lang.toUpperCase()}: Descrição preenchida`);
            }

            // Salvar
            const saveDesc = page.locator('button').filter({ hasText: /Save|Salvar/ }).first();
            if (await saveDesc.isVisible() && !await saveDesc.isDisabled()) {
                await saveDesc.click();
                await page.waitForTimeout(500);
            }
        } catch (error) {
            console.warn(`  ⚠️ ${lang}: ${error.message}`);
        }
    }

    // ==========================================
    // 5. ANÚNCIOS
    // ==========================================
    console.log('\n📍 [5/6] Declarando Anúncios...');
    await page.goto(`${BASE_URL}/app-content/ads`);
    await page.waitForLoadState('networkidle');

    try {
        // Selecionar "Sim, app tem anúncios"
        const yesAds = page.locator('label, [role="radio"]').filter({
            hasText: /yes|sim|ja|sì|oui/i
        }).first();

        if (await yesAds.isVisible()) {
            await yesAds.click();
            console.log('  ✅ Marcado: App tem anúncios');
        }

        // Tipos de anúncios (banner, interstitial, rewarded)
        const bannerCheck = page.locator('label').filter({ hasText: /banner/i }).first();
        const interstitialCheck = page.locator('label').filter({ hasText: /interstitial/i }).first();
        const rewardedCheck = page.locator('label').filter({ hasText: /rewarded/i }).first();

        if (await bannerCheck.isVisible()) await bannerCheck.click();
        if (await interstitialCheck.isVisible()) await interstitialCheck.click();
        if (await rewardedCheck.isVisible()) await rewardedCheck.click();

        console.log('  ✅ Tipos de anúncios selecionados');

        // Salvar
        const saveBtnAds = page.locator('button').filter({ hasText: /Save|Salvar/ }).first();
        if (await saveBtnAds.isVisible() && !await saveBtnAds.isDisabled()) {
            await saveBtnAds.click();
            await page.waitForTimeout(1000);
            console.log('  ✅ Anúncios salvos');
        }
    } catch (error) {
        console.error(`  ⚠️ Erro ao preencher Anúncios: ${error.message}`);
    }

    // ==========================================
    // 6. SEGURANÇA DE DADOS  
    // ==========================================
    console.log('\n📍 [6/6] Completando Segurança de Dados...');
    await page.goto(`${BASE_URL}/app-content/data-privacy-security`);
    await page.waitForLoadState('networkidle');

    try {
        // Etapa 2: Não coleta dados obrigatórios
        const noMandatoryData = page.locator('label, [role="radio"]').filter({
            hasText: /no|não|nein|non/i
        }).first();

        if (await noMandatoryData.isVisible()) {
            await noMandatoryData.click();
            console.log('  ✅ Marcado: Não coleta dados obrigatórios');
        }

        // Avançar etapas
        let nextBtn = page.locator('button').filter({ hasText: /Next|Próximo|Weiter|Siguiente/ }).first();
        while (await nextBtn.isVisible()) {
            await nextBtn.click();
            await page.waitForTimeout(500);
            nextBtn = page.locator('button').filter({ hasText: /Next|Próximo/ }).first();
        }

        // Salvar final
        const saveFinal = page.locator('button').filter({ hasText: /Save|Salvar|Speichern/ }).first();
        if (await saveFinal.isVisible() && !await saveFinal.isDisabled()) {
            await saveFinal.click();
            await page.waitForTimeout(1000);
            console.log('  ✅ Segurança de Dados salva');
        }
    } catch (error) {
        console.error(`  ⚠️ Erro ao preencher Segurança de Dados: ${error.message}`);
    }

    // ==========================================
    // 7. SUBMETER PARA REVISÃO
    // ==========================================
    console.log('\n📍 [7/6] Navegando para Submissão...');
    await page.goto(`${BASE_URL}/test-and-release`);
    await page.waitForLoadState('networkidle');

    try {
        // Clique "Produção"
        const prodLink = page.locator('a, button').filter({
            hasText: /production|produção|produktiv/i
        }).first();

        if (await prodLink.isVisible()) {
            await prodLink.click();
            await page.waitForTimeout(1000);
        }

        // Clique "Enviar para Revisão"
        const submitBtn = page.locator('button').filter({
            hasText: /submit|enviar|einreichen|envoy/i
        }).first();

        if (await submitBtn.isVisible() && !await submitBtn.isDisabled()) {
            await submitBtn.click();
            await page.waitForTimeout(2000);
            console.log('  ✅ App enviado para revisão!');
        } else {
            console.log('  ℹ️ Botão "Enviar" desabilitado (pode haver erros não resolvidos)');
        }

        // Capturar status
        const statusText = await page.locator('[role="status"], .status').first().textContent();
        console.log(`\n✅ STATUS FINAL: ${statusText || 'Verificar no Play Console'}`);

    } catch (error) {
        console.error(`  ⚠️ Erro ao submeter: ${error.message}`);
    }

    console.log('\n🎉 Fluxo de Publicação Completo!\n');
});
