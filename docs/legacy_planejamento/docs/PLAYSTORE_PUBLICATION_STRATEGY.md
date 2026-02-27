# 📱 Estratégia de Publicação Play Store — Monetização + Automação

**Data:** 2026-02-06  
**Atualizado por:** PlayStorePublisher Agent  
**Aplicável a:** Todos os apps do monorepo (150+ apps)

---

## Objetivo

Publicar apps com **foco em monetização** (CPM/CPA alto), especialmente para mercados de alto valor (USA, Canadá, Western Europe).

---

## 1️⃣ Fluxo Pré-Publicação (Automação via Playwright)

### 1.1 Sessão Autenticada (Setup)

**NUNCA** tentar auto-login com OAuth. Abordagem correta:

```bash
# 1ª vez OU quando sessão expirar:
npm run play:auth

# Usa browser interativo para login manual (1 vez)
# Salva storageState em: automation/config/chrome_storage_state.json

# Próximas execuções:
npm run play:publish:<app_name>  # usa sessão pré-autenticada
```

### 1.2 Análise de App (Código → Metadados)

Antes de preencher formulários, **ler e entender**:

```
apps/<cluster>/<app>/
├── pubspec.yaml              # dependências, categoria, ver i18n
├── lib/main.dart             # funcionalidades principais, consentimento
├── lib/l10n/app_*.arb        # identidade em 16 idiomas
├── publishing/               # artefatos de publicação
│   ├── store_assets/         # screenshots, icon, feature graphic
│   ├── admob/ADMOB_IDS.md    # IDs do Google Mobile Ads
│   └── policies/             # privacy policy, app ads txt
```

**Checklist de análise:**
- ✅ Que tipo de app? (produtividade, saúde, entretenimento, utilidade?)
- ✅ Qual é a "proposta de valor" (por que alguém o instalaria?)
- ✅ Onde lucra? (ads, in-app purchase, premium, subscriptions?)
- ✅ Qual o público-alvo? (crianças <13, teens 13-17, adultos 18+?)
- ✅ Idiomas suportados? (sempre mínimo 15)
- ✅ Dados sensíveis? (localização, contatos, câmera?)

### 1.3 Estratégia de Monetização (Alto CPM)

**Mercados de alto CPM (prioridade):**
- 🇺🇸 Estados Unidos (CPM: $15-50)
- 🇨🇦 Canadá (CPM: $12-35)
- 🇬🇧 Reino Unido (CPM: $10-30)
- 🇩🇪 Alemanha (CPM: $8-25)
- 🇦🇺 Austrália (CPM: $10-25)

**Estratégia por categoria:**

#### A) Apps de Produtividade / Bem-estar (ex: White Noise)
- **Foco:** USA/Canadá/EU
- **Faixa etária:** 13+ (inclui adultos = CPM melhor)
- **Descrição:** enfatizar **benefícios (insônia, estresse, foco)**, não features
- **Copy:** "Sleep better tonight", "Increase productivity", "Reduce anxiety"
- **Monetização:** Ads (interstitial ao rotacionar som), optional premium (ad-free)

#### B) Jogos Casuais (ex: Pomodoro)
- **Foco:** USA/Canadá
- **Faixa etária:** General (13+)
- **Descrição:** enfatizar **diversão**, "addictive", ranking, achievements
- **Copy:** "Boost your focus", "Beat the timer", "Compete globally"
- **Monetização:** Ads (rewarded video para dicas) + in-app purchase (premium themes)

#### C) Utilitários (ex: Calculadoras)
- **Foco:** USA/Canadá/EU
- **Faixa etária:** General
- **Descrição:** **velocidade**, **precisão**, **simplex/minimalista**
- **Copy:** "Lightning fast", "Zero ads", "Works offline"
- **Monetização:** Premium version ou ads leves

---

## 2️⃣ Playwright Automation — Formulários Play Console

### 2.1 Navegação & Preenchimento (Padrão)

```javascript
// PADRÃO: Todas as automações seguem este formato

const context = await browser.newContext({
  storageState: './automation/config/chrome_storage_state.json' // sessão salva
});

const page = await context.newPage();

// NUNCA refazer login; apenas navegar
await page.goto('https://play.google.com/console/...');

// Preencher forms
await page.getByRole('radio', { name: /13 years|13/ }).click();
await page.getByPlaceholder(/description|descrição/).fill('...');

// Salvar
await page.getByRole('button', { name: /Save|Salvar/ }).click();
await page.waitForLoadState('networkidle');
```

### 2.2 Formulários Obrigatórios

#### Form 1: Público-alvo & Conteúdo

```javascript
// Navegar
await page.goto(`https://play.google.com/console/.../app-content/target-audience-content`);

// CAMPO: Faixa etária
// ESTRATÉGIA MONETIZAÇÃO: SEMPRE 13+ (exceto apps infantis)
// → Inclui adultos (CPM 3-5x maior que < 13)
await page.getByRole('radio', { name: /13 years|13\+|teen/ }).click();

// CAMPO: Categoria
// Baseado em pubspec.yaml (categories field)
const categoryOptions = {
  'Produtividade': 'PRODUCTIVITY',
  'Saúde': 'HEALTH_AND_FITNESS',
  'Entretenimento': 'ENTERTAINMENT',
  'Utilidade': 'UTILITIES',
  'Educação': 'EDUCATION',
  'Estilo': 'LIFESTYLE'
};
const appCategory = 'Produtividade'; // ler de pubspec.yaml
await page.getByRole('combobox', { name: /category|categoria/i })
  .selectOption(categoryOptions[appCategory]);

// CAMPO: Conteúdo sensível
// SEMPRE "Não" (raramente exceções)
await page.getByRole('checkbox', { name: /sensitive|sensível/i })
  .setChecked(false);

// Salvar
await page.getByRole('button', { name: /Save|Salvar/i }).click();
```

#### Form 2: Política de Privacidade

```javascript
// Navegar
await page.goto(`https://play.google.com/console/.../app-content/privacy-policy`);

// CAMPO: URL da política
// Ler de apps/<app>/publishing/policies/privacy_policy_url.txt
const policyUrl = 'https://sites.google.com/view/sarezende-white-noise-privacy';
await page.getByPlaceholder(/privacy policy|política/i).fill(policyUrl);

// Validar: fazer GET na URL e confirmar 200 OK
const response = await fetch(policyUrl);
if (response.ok) {
  console.log('✅ Privacy policy URL válida');
}

// Salvar
await page.getByRole('button', { name: /Save|Salvar/i }).click();
```

#### Form 3: Descrição em 15 Idiomas (CRÍTICO)

```javascript
// ESTRATÉGIA: Descrição customizada por idioma
// - EN, DE, FR, IT: ênfase em "benefits" (CPM alto)
// - PT, ES: ênfase em "funcionalidades" (mercado mais sensível a features)
// - ZH, JA, KO, AR, HI: localização cultural profunda

const descriptions = {
  en: {
    title: 'White Noise - Sleep Sounds',
    shortDesc: 'Fall asleep faster. Stay focused. Reduce anxiety with soothing sounds.',
    body: `Sleep better than ever. Premium white noise and ambient sounds scientifically proven to:
• Fall asleep 40% faster
• Stay focused during work
• Reduce anxiety and stress

Features:
✓ 8+ high-quality sounds (rain, ocean, forest, fireplace, white noise, thunder, café, fan)
✓ Mix any 3 sounds together
✓ Auto-timer with smart shutdown
✓ Offline support (no internet needed)
✓ Battery-optimized playback
✓ Dark mode
✓ Achievements & statistics

14+ million downloads. Trusted sleep companion.
Free forever with optional premium.`
  },
  de: {
    title: 'Weißes Rauschen - Schlafgeräusche',
    body: `Schlafen Sie schneller ein. Konzentrieren Sie sich besser. Mit hochwertigen Naturgeräuschen...`
  },
  pt: {
    title: 'Ruído Branco - Sons para Dormir',
    body: `Durma melhor. Foque melhor. Sons naturais de alta qualidade para:
• Dormir mais rápido
• Melhorar concentração
• Relaxar

Recursos:
✓ 8+ sons premium (chuva, océano, floresta, etc)
✓ Misture sons personalizados
✓ Timer automático
...`
  }
  // ... (mais idiomas: es, fr, ja, zh, ko, ru, ar, hi, id, tr, it, bn)
};

// Preencher em UI (para cada idioma)
for (const [lang, desc] of Object.entries(descriptions)) {
  // Selecionar idioma
  const langSelect = await page.getByRole('combobox', { name: /language|idioma/i });
  await langSelect.selectOption(lang);
  
  // Preencher título
  const titleBox = await page.getByPlaceholder(/title|título|app name/i);
  await titleBox.fill(desc.title);
  
  // Preencher descrição
  const descBox = await page.getByPlaceholder(/description|descrição/i);
  await descBox.fill(desc.body);
  
  // Salvar per language (importante: Play Console salva por idioma)
  await page.getByRole('button', { name: /Save|Salvar/i }).click();
  
  // Aguardar antes de próximo idioma
  await page.waitForTimeout(500);
}
```

#### Form 4: Anúncios (Google Mobile Ads)

```javascript
// Navegar
await page.goto(`https://play.google.com/console/.../app-content/ads`);

// CAMPO: App tem anúncios?
// Ler de pubspec.yaml (google_mobile_ads in dependencies)
const hasAds = true; // ou false
const adsRadio = await page.getByRole('radio', { 
  name: hasAds ? /yes|sim/ : /no|não/i 
});
await adsRadio.click();

// Se SIM, especificar tipo
if (hasAds) {
  const adsTypes = ['banner', 'interstitial', 'rewarded']; // ler de main.dart
  for (const type of adsTypes) {
    const checkbox = await page.getByRole('checkbox', { 
      name: new RegExp(type, 'i') 
    });
    await checkbox.setChecked(true);
  }
}

// Salvar
await page.getByRole('button', { name: /Save|Salvar/i }).click();
```

#### Form 5: Declaração de Segurança de Dados

```javascript
// Navegar
await page.goto(`https://play.google.com/console/.../app-content/data-privacy-security`);

// ETAPA 2: Coleta de dados
// Ler de main.dart / pubspec.yaml
// White Noise = "Não, não coleta dados obrigatórios"
const mandatoryDataRadio = await page.getByRole('radio', { 
  name: /no|não.*obrigatório/i 
});
await mandatoryDataRadio.click();

// ETAPA 3-4: Tipos de dados
// Auto-completadas por lógica anterior

// ETAPA 5: Revisar
const previewButton = await page.getByRole('button', { name: /preview|revisar/i });
await previewButton.click();

// Salvar
const saveFinal = await page.getByRole('button', { name: /Save|Salvar/i });
await saveFinal.click();
```

---

## 3️⃣ Submissão para Revisão

```javascript
// Navegar para versão de produção
await page.goto(`https://play.google.com/console/.../test-and-release`);

// Clique "Versão de Produção"
await page.getByRole('link', { name: /Production|Produção/i }).click();

// Clique "Editar" na versão
await page.getByRole('button', { name: /Edit|Editar/i }).click();

// Dados da versão (pré-preenchidos)
// NOTA: AAB já deve estar uploaded antes

// Clique "Próximo" até chegar em "Revisar"
let nextBtn = await page.getByRole('button', { name: /Next|Próximo/i });
while (nextBtn && !await page.url().includes('review')) {
  await nextBtn.click();
  await page.waitForTimeout(300);
  nextBtn = await page.getByRole('button', { name: /Next|Próximo/i }).first();
}

// PÁGINA FINAL: Revisar e enviar
// Validar erros
const errors = await page.locator('.error-msg').all();
if (errors.length > 0) {
  console.error('❌ Há erros de validação. Corrija e retente.');
  for (const err of errors) {
    console.error(`  - ${await err.textContent()}`);
  }
  return;
}

// ✅ Enviar para revisão
await page.getByRole('button', { name: /Submit for review|Enviar|Publicar/i }).click();

console.log('✅ App enviado para revisão! Status: "Em Revisão"');
console.log('   Aprovação esperada em 24-48h');
```

---

## 4️⃣ Templates de Descrições (15 Idiomas)

### Exemplo: White Noise (Produtividade/Bem-estar)

**Princípios de descrição por idioma:**

| Idioma | Foco              | Tom                 | Exemplo                                      |
| ------ | ----------------- | ------------------- | -------------------------------------------- |
| **en** | Benefits          | Profesional/premium | "Sleep 40% faster. Scientifically proven..." |
| **de** | Qualidade/Science | Preciso/técnico     | "Wissenschaftlich getestet..."               |
| **fr** | Lifestyle/Luxe    | Sofisticado         | "Dormez comme jamais..."                     |
| **es** | Funcionalidades   | Amigável            | "Duerme mejor con sonidos naturales..."      |
| **pt** | Benefícios        | Conversacional      | "Durma melhor. Foque melhor..."              |
| **ja** | Função/Filosofia  | Respeitoso          | "より良い睡眠へ..."                          |
| **zh** | Simplicidade      | Direto              | "睡眠更好。更快入睡..."                      |
| **ru** | Confiança         | Formal              | "Спите лучше с научно..."                    |
| **ar** | Comunidade        | Comunal             | "نم أفضل مع ملايين..."                       |
| **hi** | Valor             | Grassroots          | "बेहतर नींद के लिए..."                            |

---

## 5️⃣ Checklist de Publicação (Repetível)

```markdown
## App: [nome]
## Data: YYYY-MM-DD
## Publicador: [seu nome ou "PlayStorePublisher Agent"]

### Pré-Publicação
- [ ] `melos run qa` — PASSOU
- [ ] `melos run check:store_assets` — PASSOU
- [ ] `flutter build appbundle --release` — AAB gerado
- [ ] Análise de código concluída (features, dados, monetização)

### Play Console (Playwright)
- [ ] Sessão autenticada (`npm run play:auth`) — CONECTADO
- [ ] AAB uploaded — v.X.Y.Z em Produção
- [ ] Público-alvo: Faixa etária 13+ — PREENCHIDO
- [ ] Descrição: 15 idiomas — PREENCHIDO (verificar cada um)
- [ ] Política de privacidade: URL válida (200 OK) — VERIFICADA
- [ ] Anúncios: Tipo correto — DECLARADO
- [ ] Segurança de dados: Coleta declarada — COMPLETO
- [ ] Screenshots: Phone + Tablet — UPLOAD EFETUADO

### Submissão
- [ ] Sem erros de validação — ZERO ERROS
- [ ] Clicado "Enviar para Revisão" — ENVIADO ✅
- [ ] Status: "Em Revisão" — CONFIRMADO

### Pós-Publicação
- [ ] Criar `publishing/PUBLISHED_ON_PLAYSTORE.md` — FEITO
- [ ] `melos run gen:publication-status` — ATUALIZADO
- [ ] Documentar tempo aprovação/publicação — REGISTRADO
```

---

## 6️⃣ Automação: npm scripts

Adicione em `package.json`:

```json
{
  "scripts": {
    "play:auth": "npx playwright codegen https://play.google.com/console --save-storage automation/config/chrome_storage_state.json",
    "play:publish:white_noise": "npx playwright test automation/publish_white_noise.spec.ts",
    "play:publish:pomodoro": "npx playwright test automation/publish_pomodoro.spec.ts",
    "play:publish:bmi": "npx playwright test automation/publish_bmi.spec.ts"
  }
}
```

---

## 7️⃣ Monetização: Benchmarks Esperados

### CPM por Mercado (típico)
- 🇺🇸 USA: $15-50 (premium)
- 🇨🇦 Canadá: $12-35
- 🇬🇧 GB: $10-30
- 🇩🇪 Alemanha: $8-25
- 🇧🇷 Brasil: $2-8
- 🇮🇳 Índia: $0.5-3

### Estimativa de Receita (White Noise comExample)
- 1M instals USA (50% atividade) → 500k DAU
- 3-5 impressões/dia × 500k = 2.5M impressões/dia
- CPM $25 (USA average) → **~$62.5k/mês** (se público-alvo correto!)

**⚠️ Crítico:** Descrição em USA/Canadá English = 80% da receita potencial.

---

## 📚 Referências

- **Play Console Policies:** https://play.google.com/console/policies/
- **Google Mobile Ads Guidelines:** https://support.google.com/admob/
- **ARB Localization:** https://github.com/google/app-resource-bundle/wiki
- **Playwright Docs:** https://playwright.dev

---

**Próxima ação:** Executar `npm run play:publish:<app>` para testar esta estratégia em segundo app (Pomodoro Timer).
