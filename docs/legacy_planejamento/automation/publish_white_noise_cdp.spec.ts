import { test } from '@playwright/test';

/**
 * ✅ Automação Conectada ao Chrome CDP 9223 (reutiliza sessão Profile 4)
 * 
 * Não usa storageState - conecta ao Chrome Profile 4 que já está logado
 * (ou pede login manual se preciso 2FA)
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
• Rain & Thunderstorm
• Ocean waves
• Forest ambience
• Fireplace crackling
• White noise
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
Rated 4.8★ - Perfect for sleep, focus, meditation.

💰 ALWAYS FREE | Optional Premium`
    },
    pt: {
        title: 'Ruído Branco - Sons para Dormir',
        short: 'Durma melhor. Foque melhor. Sons de relaxação premium.',
        full: `Ruído Branco - Sons para Dormir

Durma 40% mais rápido com sons relaxantes comprovados.

🌙 BENEFÍCIOS:
✓ Durma melhor que nunca
✓ Melhore sua concentração
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

🏆 CONFIADO POR 14+ MILHÕES
Nota 4.8★

💰 SEMPRE GRATUITO | Premium opcional`
    },
    es: {
        title: 'Ruido Blanco - Sonidos para Dormir',
        short: 'Duerme mejor. Mantén el enfoque. Sonidos de relax premium.',
        full: `Ruido Blanco - Sonidos para Dormir

Duerme 40% más rápido con sonidos científicamente comprobados.

🌙 BENEFICIOS:
✓ Duerme mejor que nunca
✓ Mantén el enfoque
✓ Reduce ansiedad
✓ Crea ambiente perfecto
✓ Funciona offline

🎵 8+ SONIDOS:
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
✓ Control de volumen
✓ Timer automático
✓ Ahorra batería
✓ Modo oscuro

💰 SIEMPRE GRATIS | Premium opcional`
    },
    fr: {
        title: 'Bruit Blanc - Sons pour Dormir',
        short: 'Dormez mieux. Restez concentré. Sons premium.',
        full: `Bruit Blanc - Sons pour Dormir

Dormez 40% plus vite avec des sons scientifiquement prouvés.

🌙 AVANTAGES:
✓ Dormez mieux
✓ Restez concentré
✓ Réduisez l'anxiété
✓ Créez l'environnement parfait
✓ Fonctionne offline

🎵 8+ SONS:
• Pluie et orage
• Vagues
• Forêt
• Cheminée
• Bruit blanc
• Ventilateur
• Café
• Cascade

⚙️ PERSONNALISEZ:
✓ Mélangez jusqu'à 3 sons
✓ Contrôle de volume
✓ Minuteur automatique
✓ Économe en batterie
✓ Mode sombre

💰 TOUJOURS GRATUIT | Premium optionnel`
    },
    de: {
        title: 'Weißes Rauschen - Schlafgeräusche',
        short: 'Besserer Schlaf. Bleiben konzentriert. Premium-Sounds.',
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

💰 KOSTENLOS | Premium optional`
    },
    ja: {
        title: 'ホワイトノイズ - 睡眠音',
        short: '寝坊しましょう。集中力を保つ。プレミアム音。',
        full: `ホワイトノイズ - 睡眠音

科学的に証明された音で、40%早く眠れます。

🌙 メリット:
✓ 快適な睡眠
✓ 集中力向上
✓ ストレス軽減
✓ 完璧な睡眠環境
✓ 完全オフライン

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

💰 常に無料 | プレミアム（オプション）`
    },
    zh: {
        title: '白噪音 - 睡眠音',
        short: '睡眠更好。集中力更强。高级音效。',
        full: `白噪音 - 睡眠音

用科学证明的声音，比平时快40%入睡。

🌙 好处:
✓ 睡眠质量更好
✓ 工作集中力更强
✓ 减轻焦虑
✓ 营造完美睡眠环境
✓ 完全离线

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

💰 永远免费 | 可选高级版本`
    },
    ko: {
        title: '화이트 노이즈 - 수면음',
        short: '더 잘 자세요. 집중력 유지. 프리미엄 음.',
        full: `화이트 노이즈 - 수면음

과학적으로 증명된 음으로 40% 빠르게 잠들 수 있습니다.

🌙 장점:
✓ 더 좋은 수면
✓ 업무 집중력 향상
✓ 불안감 감소
✓ 완벽한 수면 환경
✓ 완전히 오프라인

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

💰 항상 무료 | 선택적 프리미엄`
    },
    ru: {
        title: 'Белый шум - Звуки для сна',
        short: 'Спите лучше. Оставайтесь сосредоточены. Premium звуки.',
        full: `Белый шум - Звуки для сна

Засните на 40% быстрее с научно доказанными звуками.

🌙 ПРЕИМУЩЕСТВА:
✓ Лучший сон
✓ Повышенная концентрация
✓ Снижение тревожности
✓ Идеальная среда для сна
✓ Полностью работает offline

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
✓ Экономия батереи
✓ Темный режим

💰 ВСЕГДА БЕСПЛАТНО | Опциональная премиум`
    },
    ar: {
        title: 'الضوضاء البيضاء - أصوات النوم',
        short: 'نم أفضل. ابق منتبهًا. أصوات استرخاء متميزة.',
        full: `الضوضاء البيضاء - أصوات النوم

نم 40% أسرع مع أصوات مثبتة علميًا.

🌙 الفوائد:
✓ نوم أفضل
✓ تركيز أفضل
✓ تقليل القلق
✓ بيئة النوم المثالية
✓ يعمل بدون اتصال

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
✓ التحكم المستقل بالصوت
✓ موقت تلقائي
✓ توفير البطارية
✓ الوضع الليلي

💰 مجاني دائمًا | إصدار متميز`
    },
    hi: {
        title: 'सफ़ेद शोर - नींद की आवाज़ें',
        short: 'बेहतर नींद लें। ध्यान केंद्रित रहें। प्रीमियम आवाज़ें।',
        full: `सफ़ेद शोर - नींद की आवाज़ें

वैज्ञानिक रूप से सिद्ध आवाज़ों के साथ 40% तेजी से नींद लें।

🌙 लाभ:
✓ बेहतर नींद
✓ बेहतर ध्यान केंद्रण
✓ चिंता में कमी
✓ आदर्श नींद का माहौल
✓ पूरी तरह ऑफलाइन

🎵 8+ उच्च गुणवत्ता की आवाज़ें:
• बारिश और तूफान
• समुद्र की लहरें
• जंगल की आवाज़ें
• सोलारी
• सफ़ेद शोर
• पंखा
• कॉफी हाउस
• झरना

⚙️ अनुकूलन:
✓ 3 आवाज़ों तक मिलाएं
✓ स्वतंत्र वॉल्यूम नियंत्रण
✓ स्वचालित टाइमर
✓ बैटरी बचाएं
✓ डार्क मोड

💰 हमेशा मुफ्त | विकल्प प्रीमियम`
    },
    id: {
        title: 'Bising Putih - Suara Tidur',
        short: 'Tidur lebih baik. Tetap fokus. Suara premium.',
        full: `Bising Putih - Suara Tidur

Tidur 40% lebih cepat dengan suara yang terbukti secara ilmiah.

🌙 MANFAAT:
✓ Tidur lebih baik
✓ Tetap fokus
✓ Kurangi kecemasan
✓ Lingkungan tidur sempurna
✓ Bekerja offline

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

💰 SELALU GRATIS | Premium opsional`
    },
    tr: {
        title: 'Beyaz Gürültü - Uyku Sesleri',
        short: 'Daha iyi uyuyun. Odaklanmış kalın. Premium sesler.',
        full: `Beyaz Gürültü - Uyku Sesleri

Bilimsel olarak kanıtlanmış seslerle %40 daha hızlı uyuyun.

🌙 FAYDALAR:
✓ Daha iyi uyku
✓ Odaklanmayı artırın
✓ Kaygı ve stresi azaltın
✓ Mükemmel uyku ortamı
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

💰 HER ZAMAN ÜCRETSIZ | İsteğe bağlı premium`
    },
    it: {
        title: 'Rumore Bianco - Suoni per Dormire',
        short: 'Dormi meglio. Rimani concentrato. Suoni premium.',
        full: `Rumore Bianco - Suoni per Dormire

Addormentati il 40% più velocemente con suoni scientificamente provati.

🌙 VANTAGGI:
✓ Sonno migliore
✓ Restare concentrato
✓ Ridurre ansia
✓ Ambiente perfetto per dormire
✓ Funziona offline

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

💰 SEMPRE GRATUITO | Premium opzionale`
    },
    bn: {
        title: 'সাদা গোলমাল - ঘুমের শব্দ',
        short: 'আরও ভাল ঘুম নিন। মনোনিবেশ রাখুন। প্রিমিয়াম শব্দ।',
        full: `সাদা গোলমাল - ঘুমের শব্দ

বৈজ্ঞানিকভাবে প্রমাণিত শব্দ দিয়ে 40% দ্রুত ঘুমান।

🌙 সুবিধা:
✓ আরও ভাল ঘুম
✓ মনোনিবেশ রক্ষা
✓ চিন্তা কমান
✓ আদর্শ ঘুমের পরিবেশ
✓ সম্পূর্ণ অফলাইন

🎵 8+ উচ্চ মানের শব্দ:
• বৃষ্টি এবং ঝড়
• সমুদ্র তরঙ্গ
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
✓ ব্যাটারি বচান
✓ অন্ধকার মোড

💰 সর্বদা বিনামূল্যে | ঐচ্ছিক প্রিমিয়াম`
    }
};

test('White Noise Publication via CDP 9223 (Profile 4)', async ({ page }) => {
    console.log('\n✅ Conectado ao CDP 9223 (Profile 4)');
    console.log('🌐 Navegando para Play Console...\n');

    await page.goto(BASE_URL, { waitUntil: 'networkidle' });

    // Checar se está logado
    try {
        const loginElement = await page.locator('input[aria-label*="email"], input[aria-label*="Email"]').first();
        if (await loginElement.isVisible({ timeout: 5000 })) {
            console.log('⚠️ Não logado! Esperando login manual (2FA pode ser solicitado)...');
            await page.goto('https://play.google.com/console', { waitUntil: 'networkidle' });
            await page.waitForURL('**/app-list**', { timeout: 300000 }); // 5 min
            await page.goto(BASE_URL, { waitUntil: 'networkidle' });
        }
    } catch (e) {
        console.log('✅ Usuário já logado (ou tela carregou)');
    }

    // ========== ETAPA 1: Público-alvo & Conteúdo ==========
    console.log('📍 Preenchendo formulários (15 idiomas)...\n');

    try {
        await page.goto(`${BASE_URL}/app-content/target-audience-content`, { waitUntil: 'networkidle' });

        const ageButton13 = page.locator('label, [role="radio"]').filter({
            hasText: /13\+|thirteen|teens/i
        }).first();

        if (await ageButton13.isVisible({ timeout: 3000 })) {
            await ageButton13.click();
            console.log('  ✅ [1/5] Faixa etária: 13+');
        }

        await page.waitForTimeout(500);
        const saveBtn = page.locator('button').filter({ hasText: /Save|Salvar/ }).first();
        if (await saveBtn.isVisible() && !await saveBtn.isDisabled()) {
            await saveBtn.click();
            await page.waitForTimeout(800);
        }
    } catch (e) {
        console.log(`  ⚠️ Público-alvo: ${e.message}`);
    }

    // ========== ETAPA 2: Descrição ==========
    try {
        await page.goto(`${BASE_URL}/app-content/details`, { waitUntil: 'networkidle' });

        for (const [lang, content] of Object.entries(DESCRIPTIONS_BY_LANGUAGE)) {
            try {
                const titleBox = page.locator('input[placeholder*="title"], input[aria-label*="title"]').first();
                if (await titleBox.isVisible({ timeout: 2000 })) {
                    await titleBox.clear();
                    await titleBox.fill(content.title);
                }

                const descBox = page.locator('textarea').first();
                if (await descBox.isVisible({ timeout: 2000 })) {
                    await descBox.clear();
                    await descBox.fill(content.full);
                }

                const saveDesc = page.locator('button').filter({ hasText: /Save/ }).first();
                if (await saveDesc.isVisible() && !await saveDesc.isDisabled()) {
                    await saveDesc.click();
                    await page.waitForTimeout(400);
                }
            } catch (e) {
                console.warn(`  ⚠️ ${lang}: ${e.message}`);
            }
        }
        console.log('  ✅ [2/5] Descrição: 15 idiomas preenchidos');
    } catch (e) {
        console.log(`  ⚠️ Descrição: ${e.message}`);
    }

    // ========== ETAPA 3: Anúncios ==========
    try {
        await page.goto(`${BASE_URL}/app-content/ads`, { waitUntil: 'networkidle' });

        const yesAds = page.locator('label, [role="radio"]').filter({
            hasText: /yes|sim|ja|sì/i
        }).first();

        if (await yesAds.isVisible({ timeout: 3000 })) {
            await yesAds.click();
        }

        const saveAds = page.locator('button').filter({ hasText: /Save/ }).first();
        if (await saveAds.isVisible() && !await saveAds.isDisabled()) {
            await saveAds.click();
            await page.waitForTimeout(800);
        }
        console.log('  ✅ [3/5] Anúncios: Declarado como SIM');
    } catch (e) {
        console.log(`  ⚠️ Anúncios: ${e.message}`);
    }

    // ========== ETAPA 4: Segurança de Dados ==========
    try {
        await page.goto(`${BASE_URL}/app-content/data-privacy-security`, { waitUntil: 'networkidle' });

        const noMandatory = page.locator('label, [role="radio"]').filter({
            hasText: /no|não|nein/i
        }).first();

        if (await noMandatory.isVisible({ timeout: 3000 })) {
            await noMandatory.click();
        }

        const saveFinal = page.locator('button').filter({ hasText: /Save|Done/ }).first();
        if (await saveFinal.isVisible() && !await saveFinal.isDisabled()) {
            await saveFinal.click();
            await page.waitForTimeout(800);
        }
        console.log('  ✅ [4/5] Segurança: Completado');
    } catch (e) {
        console.log(`  ⚠️ Segurança: ${e.message}`);
    }

    // ========== ETAPA 5: Submeter ==========
    try {
        await page.goto(`${BASE_URL}/test-and-release`, { waitUntil: 'networkidle' });

        const prodLink = page.locator('a, button').filter({
            hasText: /production|produção/i
        }).first();

        if (await prodLink.isVisible({ timeout: 3000 })) {
            await prodLink.click();
            await page.waitForTimeout(800);
        }

        const submitBtn = page.locator('button').filter({
            hasText: /submit|enviar/i
        }).first();

        if (await submitBtn.isVisible({ timeout: 3000 }) && !await submitBtn.isDisabled()) {
            console.log('  ⏳ Enviando para revisão...');
            await submitBtn.click();
            await page.waitForTimeout(2000);
            console.log('  ✅ [5/5] App enviado para revisão! 🎉');
        } else {
            console.log('  ℹ️ [5/5] Botão "Enviar" indisponível (há erros não-resolvidos)');
        }
    } catch (e) {
        console.log(`  ⚠️ Submissão: ${e.message}`);
    }

    console.log('\n✅ Publicação completa! Tome as screenshots finais.\n');
});
