# **Plano de Arquitetura: Do App Simples ao SuperApp (Modular)**

Versão: 6.5  
Data de Atualização: Janeiro 2026  
Compatibilidade: Android 15+ (API 35), Flutter 3.32+  
**Nota v6.6:** Tríade AdMob Sync (AdService + Manifest + ADMOB_IDS.md), guardrail de assets obrigatório (check_store_assets.ps1), app-ads.txt com validação antes do Console, regra de consistência visual do ícone
**Nota v6.5:** Crop 9:16 obrigatório (script PowerShell automatizado), validação i18n via check_l10n.ps1, traduções de Store Listing obrigatórias (template de delegação), workflow swap-and-remove, lição Fasting Tracker (validação completa antes de submeter = zero retrabalho)
**Nota v6.3:** Automação AdMob via Playwright MCP (4 min vs 15+ min), Template ADMOB_IDS.md para documentação de IDs, estrutura DadosPublicacao expandida com pasta admob/
**Nota v6.2:** Política de Privacidade via Google Sites (workflow completo), verificação obrigatória de URL antes de publicação, lição BMI Calculator (URL 404 = rejeição)
**Nota v6.0:** Clean Architecture obrigatória (Domain/Data/Presentation), Templates para Health/Wellness Apps, NotificationService, Repository Pattern completo, Entities com estados temporais
**Nota v5.4:** Workflow de assets para publicação, regra do ícone real, lições do Pomodoro Timer
**Nota v5.3:** Teste funcional de UI via ADB, estrutura de testes unitários, fast lane de publicação
**Nota v5.2:** Otimização de performance (R8 full mode, ProGuard 7 passes), assinatura de produção
**Nota v5.1:** Padrões de gamificação (Streaks, Achievements), templates de serviços reutilizáveis

Para cumprir o requisito de criar apps individuais que depois serão agregados, NÃO podemos usar uma estrutura monolítica comum (lib/main.dart cheio de tudo).

Utilizaremos uma **Arquitetura Modular Baseada em Packages**.

---

## **0.1 Quick Wins de Publicação (Sem Retrabalho)**

1. **Tríade AdMob Sync:** Atualize `AdService`, `AndroidManifest` e `ADMOB_IDS.md` no mesmo commit.
2. **Assets Guardrail:** Execute `tools/check_store_assets.ps1` antes do Play Console.
3. **Política e app-ads.txt:** URL pública com status 200 e `app-ads.txt` publicado.
4. **Ícone consistente:** O mesmo ícone do app em Android, Play Store e AdMob.

---

## **1\. Estrutura de Pastas (O Segredo)**

Mesmo para o primeiro app simples, a estrutura deve ser pensada como um monorepo.

```
/root_project
  /apps
     /bmi_calculator (sa.rezende.bmi_calculator)
     /pomodoro_timer (sa.rezende.pomodoro_timer)
     /todo_app (sa.rezende.todo)
     /super_app_agregador (sa.rezende.superapp)
  /packages (Módulos Reutilizáveis)
     /core_ui (Design System: Cores, Tipografia, Botões Padrão)
     /core_logic (Auth, Gerenciamento de Estado Base, Networking)
     /feature_ads (Lógica centralizada do AdMob - MUITO IMPORTANTE)
     /feature_i18n (Traduções compartilhadas)
     /feature_privacy (Consentimento UE/EEA/UK via UMP + opções de privacidade)
     /feature_gamification (Streaks, Achievements, Daily Goals - NOVO)
  /DadosPublicacao (Chaves, certificados, assets de loja por app)
  /tools (Scripts de validação: check_l10n.ps1, check_store_assets.ps1)
```

---

## **1.1. Clean Architecture por App (OBRIGATÓRIO v6.0)**

Cada app DEVE seguir a estrutura de **3 camadas**:

```
/lib
  /domain (PURA - Dart puro, sem dependências externas)
    /entities        # Classes de domínio (FastingSession, StreakData)
    /repositories    # Interfaces abstratas (abstract class IFastingRepository)
    /usecases        # Lógica de negócio (StartFastingUseCase) - OPCIONAL
  
  /data (ADAPTADORES - Implementações concretas)
    /repositories    # Implementações (FastingRepositoryImpl)
    /datasources     # SharedPreferences, APIs, etc.
    /models          # DTOs com toJson/fromJson
  
  /presentation (UI - Flutter-specific)
    /providers       # Riverpod providers
    /screens         # Telas completas
    /widgets         # Componentes reutilizáveis
  
  /services          # Services cross-cutting (AdService, ConsentService, NotificationService)
  /l10n              # Arquivos .arb de tradução
  main.dart
```

### **Regras de Dependência (CRÍTICO)**

```
presentation → domain ✅
presentation → data ✅ (via providers)
data → domain ✅
domain → NADA (puro Dart) ✅
domain → data ❌ PROIBIDO
domain → presentation ❌ PROIBIDO
```

### **Benefícios da Clean Architecture**

| Benefício        | Descrição                                    |
| ---------------- | -------------------------------------------- |
| Testabilidade    | Domain layer pode ser testado sem Flutter    |
| Manutenibilidade | Mudanças em uma camada não afetam outras     |
| Escalabilidade   | Fácil adicionar novos datasources            |
| Reusabilidade    | Entities podem ser compartilhadas entre apps |

---

## **2\. Requisitos Técnicos Obrigatórios (2025-2026)**

### **2.1. Política de 16KB Page Size (CRÍTICO)**

A partir de **1º de novembro de 2025**, todos os apps que targetam Android 15 (API 35)+ **DEVEM** suportar tamanhos de página de memória de 16KB.

| Requisito                       | Versão Mínima        |
| ------------------------------- | -------------------- |
| **Android Gradle Plugin (AGP)** | 8.5.1+ (OBRIGATÓRIO) |
| **NDK**                         | r28+ (recomendado)   |
| **Flutter SDK**                 | 3.32+                |
| **Target SDK**                  | 35 (Android 15)      |
| **Min SDK**                     | 21 (Android 5.0)     |

### **2.2. Configuração settings.gradle**

```gradle
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.5.1" apply false  // MÍNIMO 8.5.1
    id "org.jetbrains.kotlin.android" version "1.9.0" apply false
}
```

### **2.3. Configuração gradle.properties**

```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true

# Otimização de builds
org.gradle.caching=true
org.gradle.parallel=true
```

### **2.4. Datas Limites**

| Data       | Requisito                                      |
| ---------- | ---------------------------------------------- |
| 31/08/2025 | Novos apps devem targetar Android 15 (API 35)+ |
| 01/11/2025 | Suporte a 16KB page size obrigatório           |
| 31/05/2026 | Deadline estendido (via Play Console)          |

---

## **3\. Benefícios desta Estrutura**

1. **Uniformidade Visual:** Todos os apps consomem o pacote core_ui. Se você mudar a cor primária no core_ui, todos os apps atualizam. Isso garante a coesão visual exigida.
2. **Lógica de Ads Centralizada:** O pacote feature_ads controla os IDs dos blocos de anúncios. Você configura a lógica de "Native Ad" uma vez e replica em todos os apps.
3. **Migração Zero:** Quando for criar o SuperApp, você apenas adiciona as dependências dos apps individuais (que estarão modularizados) dentro dele.
4. **Conformidade Automática:** Atualizações de requisitos (como 16KB) são feitas uma vez nos packages compartilhados.
5. **Conformidade UE (Ads):** O fluxo UMP (consent-first) pode virar um package reutilizável e ser aplicado em todos os apps com AdMob.
6. **Gamificação Reutilizável:** Streaks, Achievements e Daily Goals podem ser compartilhados entre apps, aumentando engajamento com código mínimo.

---

## **4\. Stack Tecnológica Recomendada (Evergreen - 2026)**

**REGRA DE OURO (Evergreen Dependencies):** Todos os apps e packages devem operar SEMPRE com a versão mais atualizada possível do Flutter SDK, Dart SDK e packages do pub.dev. O ecossistema deve estar sempre na vanguarda para extrair máxima performance da engine.

| Categoria              | Tecnologia                | Justificativa                            |
| ---------------------- | ------------------------- | ---------------------------------------- |
| **Gerência de Estado** | Riverpod 2.x              | Mais testável e modular que Bloc         |
| **Navegação**          | GoRouter                  | Deep Linking essencial para SuperApp     |
| **Banco Local**        | SharedPreferences/Hive    | Persistência simples e rápida            |
| **Áudio**              | audioplayers ^6.4.0       | Para ambient sounds e feedback sonoro    |
| **Ads**                | google_mobile_ads 5.3+    | Banner, Interstitial, App Open, Rewarded |
| **Analytics**          | Firebase Analytics        | Gratuito e integrado                     |
| **Consent (GDPR)**     | UMP via google_mobile_ads | Consentimento consent-first              |

---

## **5\. Estratégia de Monetização (AdMob 2025)**

### **5.1. Formatos Recomendados por Tipo de App**

| Tipo de App              | Banner       | Interstitial     | App Open        | Rewarded          | Nativo           |
| ------------------------ | ------------ | ---------------- | --------------- | ----------------- | ---------------- |
| Utilitário (Calculadora) | ✅ Topo       | ✅ A cada 3 ações | ✅ No foreground | ❌                 | ❌                |
| Jogo Casual              | ✅ Rodapé     | ✅ Entre fases    | ✅               | ✅ Vidas/Power-ups | ❌                |
| App de Conteúdo          | ✅ Adaptativo | ❌                | ✅               | ❌                 | ✅ A cada 5 itens |
| Produtividade            | ✅            | ✅ Após salvar    | ✅               | ✅ Premium temp    | ❌                |

### **5.2. IDs de Teste (Desenvolvimento)**

```dart
// NUNCA use em produção - apenas desenvolvimento
static const testBannerId = 'ca-app-pub-3940256099942544/6300978111';
static const testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
static const testAppOpenId = 'ca-app-pub-3940256099942544/9257395921';
static const testRewardedId = 'ca-app-pub-3940256099942544/5224354917';
```

### **5.3. Melhores Práticas**

- **App Open Ad:** NÃO mostrar na primeira abertura do app
- **Interstitial:** Mostrar em pausas naturais, NUNCA no meio de uma ação
- **Rewarded:** Alta aceitação do usuário, melhor CPM
- **Pre-loading:** Sempre carregar o próximo anúncio após exibir o atual
- **Expiração:** App Open Ads expiram em 4 horas - gerenciar timestamp

---

## **6\. Internacionalização (i18n) - 11 Idiomas Obrigatórios**

Para maximizar alcance global, todo app deve nascer com 11 idiomas:

| Código | Idioma            | % Cobertura Mundial |
| ------ | ----------------- | ------------------- |
| en     | English           | 17%                 |
| zh     | 中文 (Chinese)    | 15%                 |
| hi     | हिन्दी (Hindi)       | 8%                  |
| es     | Español           | 7%                  |
| ar     | العربية (Arabic)  | 5%                  |
| bn     | বাংলা (Bengali)      | 4%                  |
| pt     | Português         | 3%                  |
| ru     | Русский (Russian) | 3%                  |
| ja     | 日本語 (Japanese) | 2%                  |
| de     | Deutsch (German)  | 2%                  |
| fr     | Français (French) | 2%                  |

**Total: ~68% da população mundial coberta**

### **6.1. Estrutura de Arquivos**

```
/lib/l10n/
  app_en.arb (template)
  app_pt.arb
  app_es.arb
  ... (11 arquivos)
/l10n.yaml
```

---

## **7\. O Agente de IA e a Geração de Código**

Quando você solicitar à IA para criar um app, use este prompt de arquitetura:

```
Crie o app [NOME] seguindo o Beast Mode Flutter v5.0:

1. Namespace: sa.rezende.[nome]
2. Estrutura: /lib/screens, /lib/providers, /lib/services, /lib/widgets, /lib/l10n, /lib/models
3. State Management: Riverpod 2.x
4. i18n: 11 idiomas desde o início (EN, PT, ES, ZH, DE, FR, AR, BN, HI, JA, RU)
5. AdMob: Banner + Interstitial + App Open Ads
6. Consent: ConsentService para GDPR/UMP
7. Android-only: Remover /ios, /web, /linux, /macos, /windows
8. Otimização: AGP 8.5.1+, minifyEnabled true, shrinkResources true
9. Compatibilidade: 16KB page size, Target SDK 35
10. Gamificação: Streak Counter, Achievements, Daily Goals
11. Testes: Criar /test/unit_test.dart
12. Usar multi_replace_string_in_file para editar múltiplos .arb simultaneamente
```

---

## **8\. Checklist de Publicação (Play Store 2025)**

### **8.1. Requisitos Técnicos**

- [ ] AGP atualizado para 8.5.1+
- [ ] Target SDK 35 (Android 15)
- [ ] 16KB page size compatibility verificada
- [ ] IDs de AdMob de produção configurados
- [ ] minifyEnabled true + shrinkResources true
- [ ] ProGuard rules configuradas
- [ ] Keystore de produção gerada
- [ ] App Bundle (.aab) gerado

### **8.2. Requisitos de Conta**

- [ ] Taxa de registro paga ($25)
- [ ] Verificação de identidade completa
- [ ] Teste fechado com 20+ testers por 14+ dias (contas novas)
- [ ] Play Console mobile app verificado

### **8.3. Conteúdo da Loja**

- [ ] Título (máx. 30 caracteres)
- [ ] Descrição curta (máx. 80 caracteres)
- [ ] Descrição completa (até 4000 caracteres)
- [ ] Screenshots (mín. 2 por tipo de device)
- [ ] Feature graphic (1024x500)
- [ ] Ícone (512x512)
- [ ] Descrições em 11 idiomas

### **8.4. Políticas e Conformidade**

- [ ] Política de privacidade via Google Sites (padrão: `sarezende-<app>-privacy`)
- [ ] **URL de política VERIFICADA (status 200)** - Lição BMI Calculator
- [ ] Data Safety form preenchido
- [ ] app-ads.txt no site do desenvolvedor
- [ ] Classificação de conteúdo definida
- [ ] UE/EEA/UK (se usar ads): Consentimento via UMP implementado + “opções de privacidade” quando requerido


### **8.4.1. Verificação de URL da Política (NOVO v6.2 - OBRIGATÓRIO)**

**LIÇÃO BMI Calculator:** URL 404 = rejeição imediata do Google Play.

```powershell
# Verificar antes de submeter ao Play Console
$url = "https://sites.google.com/view/sarezende-<app>-privacy"
try {
    $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -TimeoutSec 10
    Write-Host "URL OK (status $($response.StatusCode))"
} catch {
    Write-Host "BLOQUEANTE: URL não acessível - NÃO submeter"
}
```

### **8.5. Monitoramento Pós-Lançamento**

| Métrica            | Limite Aceitável |
| ------------------ | ---------------- |
| ANR Rate           | < 0.47%          |
| Crash Rate         | < 1.09%          |
| Excessive Wake-ups | < 10/hora        |

---

## **8.6. NOVO: Code Quality Workflow (ZERO ISSUES - White Noise)**

**LIÇÃO:** Seguir este processo mantém 0 warnings consistentemente.

### **Loop de Qualidade (Read → Fix → Verify)**

```powershell
# 1. SEMPRE ler antes de editar (evita 90% dos erros)
Read-File path/to/file.dart

# 2. Fazer edição com contexto preciso
Replace-String -OldString "exact match" -NewString "corrected code"

# 3. Validar imediatamente
flutter analyze

# 4. Se warnings aparecerem: READ → FIX → VERIFY (loop até 0 issues)
```

### **Checklist Pré-Commit**

```powershell
# Fast Lane de Validação
Set-Location "C:\path\to\app"
flutter clean
flutter pub get
flutter gen-l10n
flutter analyze     # DEVE retornar "No issues found!"
flutter test        # DEVE passar 100%
```

### **Erros Comuns e Fixes Imediatos**

| Erro             | Causa                      | Fix                                     |
| ---------------- | -------------------------- | --------------------------------------- |
| `Unused import`  | Import não usado no código | Remover linha do import                 |
| `Prefer const`   | Widget pode ser const      | Adicionar `const` antes do widget       |
| `Missing return` | Função sem return          | Adicionar `return` ou mudar para `void` |
| `Type mismatch`  | Tipo incorreto             | Verificar assinatura da função          |

### **Pattern: Multi-Replace para i18n**

**SEMPRE** editar os 11 arquivos .arb de uma vez usando `multi_replace_string_in_file`:

```dart
// Em vez de 11 operações sequenciais (lento)
replace_string_in_file(app_en.arb, ...)
replace_string_in_file(app_pt.arb, ...)
// ...

// Use 1 operação paralela (11x mais rápido)
multi_replace_string_in_file([
  {filePath: app_en.arb, oldString: ..., newString: ...},
  {filePath: app_pt.arb, oldString: ..., newString: ...},
  // ... outros 9 idiomas
])
```

**Resultado:** Código limpo, zero retrabalho, builds rápidos.

---

## **9\. Cronograma de Execução (Beast Mode)**

### **Fase A: Fundação (1-2 Dias)**

* Configurar o Monorepo (Melos recomendado)
* Criar packages/core_ui (Tema, Cores, Componentes)
* Criar packages/feature_ads (Helper de AdMob com App Open)
* Configurar AGP 8.5.1+ e gradle.properties otimizado

### **Fase B: Fábrica de Apps (Contínuo)**

* Desenvolver App 1 (ex: BMI Calculator). Validar. Publicar.
* Desenvolver App 2 (ex: Todo App). Validar. Publicar.
* *Nota:* O App 2 já nasce com design e ads do App 1 configurados.

### **Fase C: A Fusão (Futuro)**

* Criar projeto super_app
* Importar lógicas dos Apps 1 e 2 como "Features"
* Criar "Home" unificadora com navegação

---

## **10\. Estrutura DadosPublicacao**

Para cada app publicado, manter nesta pasta:

```
/DadosPublicacao
  /bmi_calculator
    /keys
      upload-keystore.jks
      key.properties
    /admob
      admob_ids.json
    /store_assets
      icon_512.png
      feature_graphic.png
      screenshots/
    /policies
      privacy_policy.md
    README.md (resumo do app)
  /app_02
    ...
```

---

## **11\. Experiência de Publicação Real (Case: BMI Calculator)**

Esta seção documenta o aprendizado prático do primeiro app publicado.

### **11.1. Cronograma Real de Publicação**

| Etapa                           | Tempo Estimado | Tempo Real  |
| ------------------------------- | -------------- | ----------- |
| Configuração inicial do Console | 30 min         | 45 min      |
| Preenchimento de metadados      | 1 hora         | 2 horas     |
| Data Safety form                | 30 min         | 1.5 horas   |
| Upload e testes internos        | 30 min         | 45 min      |
| **Total**                       | **2.5 horas**  | **5 horas** |

**Lição:** O processo leva mais tempo que o esperado. Planeje um dia inteiro para a primeira publicação.

### **11.2. Obstáculos Encontrados**

| Problema                        | Solução                                                             |
| ------------------------------- | ------------------------------------------------------------------- |
| Import de localizações falhando | Usar `synthetic-package: false` no l10n.yaml                        |
| AGP incompatível com 16KB       | Atualizar para 8.5.1+ no settings.gradle                            |
| App Open Ad não aparecia        | Implementar lógica de expiração (4h) e skip nas primeiras aberturas |
| Data Safety form complexo       | Seguir guia detalhado do BeastModeFlutter.agent.md                  |

### **11.3. Otimizações Aplicadas**

```
✅ IDs de produção do AdMob configurados
✅ App Open Ad com gestão de lifecycle
✅ Interstitial com pre-loading e contador de ações
✅ AGP 8.5.1 para compatibilidade 16KB
✅ ProGuard/R8 ativados
✅ analysis_options.yaml rigoroso
✅ 11 idiomas configurados desde o início
```

---

## **12\. Processo de Data Safety para Apps de Saúde**

Apps que coletam dados de saúde (peso, altura, IMC) requerem declarações específicas:

### **12.1. Tipos de Dados a Declarar**

| Categoria           | Dados             | Coletado | Compartilhado  |
| ------------------- | ----------------- | -------- | -------------- |
| **Saúde e fitness** | Peso, altura, IMC | ✅        | ❌ (local only) |
| **Identificadores** | Device ID (AdMob) | ✅        | ✅              |
| **Diagnóstico**     | Crash logs        | ✅        | ✅              |

### **12.2. Respostas Padrão para Apps Utilitários**

```yaml
Coleta de dados: Sim
Criptografia em trânsito: Sim  # AdMob usa HTTPS
Criação de conta: Não
Exclusão de dados: Não (dados locais - desinstalar remove)
Login externo: Não
```

### **12.3. Propósitos por Tipo de Dado**

| Tipo de Dado  | Propósito de Coleta   | Propósito de Compartilhamento |
| ------------- | --------------------- | ----------------------------- |
| Saúde/Fitness | Funcionalidade do app | N/A                           |
| Device ID     | Publicidade, Análise  | Publicidade                   |
| Crash logs    | Análise               | Análise                       |

---

## **13\. Estrutura de Políticas Obrigatórias**

### **13.1. Política de Privacidade**

Criar e hospedar em URL pública. Template mínimo:

```markdown
# Política de Privacidade - [App Name]

## Dados Coletados
- Dados de saúde (peso, altura): armazenados LOCALMENTE
- Identificadores de publicidade: coletados pelo Google AdMob

## Compartilhamento
- Dados de saúde: NÃO compartilhados
- Identificadores: compartilhados com Google para publicidade

## Exclusão
- Desinstale o app para remover todos os dados locais

## Contato
[seu@email.com]
```

### **13.2. app-ads.txt**

Publicar na raiz do domínio (`https://seusite.com/app-ads.txt`):

```
google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0
```

### **13.3. Estrutura de Arquivos Recomendada**

```
/DadosPublicacao
  /bmi_calculator
    /keys
      upload-keystore.jks
      key.properties
    /admob
      ad_unit_ids.json  # Banner, Interstitial, App Open IDs
    /store_assets
      icon_512.png
      feature_graphic_1024x500.png
      /screenshots
        phone_1.png
        phone_2.png
    /policies
      privacy_policy.md
      privacy_policy.html  # Versão hospedada
    /play_console
      data_safety_responses.md  # Backup das respostas
    README.md
```

---

## **14\. Configuração de l10n Moderna**

### **14.1. l10n.yaml Recomendado**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n
synthetic-package: false  # IMPORTANTE: evita problemas de import
```

### **14.2. Imports Corretos**

```dart
// Com synthetic-package: false (RECOMENDADO)
import '../l10n/app_localizations.dart';

// Com synthetic-package: true (padrão, pode causar problemas)
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

---

## **15\. AdService Completo (Template de Produção)**

### **15.1. Estrutura do AdService**

```dart
// lib/services/ad_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // === IDs de Produção ===
  static String get bannerAdUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/6300978111';
    return 'ca-app-pub-XXXX/YYYY'; // Produção
  }
  
  static String get interstitialAdUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/1033173712';
    return 'ca-app-pub-XXXX/YYYY'; // Produção
  }
  
  static String get appOpenAdUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/9257395921';
    return 'ca-app-pub-XXXX/YYYY'; // Produção
  }

  // === App Open Ad State ===
  static AppOpenAd? _appOpenAd;
  static DateTime? _appOpenLoadTime;
  static bool _isShowingAd = false;
  static int _appOpenCount = 0;
  static const Duration _maxAdAge = Duration(hours: 4);

  // === Interstitial State ===
  static InterstitialAd? _interstitialAd;
  static int _actionCount = 0;
  static const int _showAfterActions = 3;

  // === Initialize ===
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // === App Open Ad ===
  static Future<void> loadAppOpenAd() async {
    if (_appOpenAd != null) return;
    
    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          debugPrint('App Open Ad failed: $error');
        },
      ),
    );
  }

  static bool get _isAdExpired {
    if (_appOpenLoadTime == null) return true;
    return DateTime.now().difference(_appOpenLoadTime!) > _maxAdAge;
  }

  static void showAppOpenAdIfAvailable() {
    _appOpenCount++;
    
    // Skip first 2 opens for better UX
    if (_appOpenCount < 2) {
      loadAppOpenAd();
      return;
    }
    
    if (_appOpenAd == null || _isShowingAd || _isAdExpired) {
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
    );

    _appOpenAd!.show();
  }

  // === Interstitial ===
  static void preloadInterstitialAd() {
    if (_interstitialAd != null) return;
    
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => debugPrint('Interstitial failed: $error'),
      ),
    );
  }

  static void incrementActionAndShowIfNeeded() {
    _actionCount++;
    if (_actionCount >= _showAfterActions && _interstitialAd != null) {
      _showInterstitial();
      _actionCount = 0;
    }
  }

  static void _showInterstitial() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitialAd();
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }

  // === Cleanup ===
  static void dispose() {
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
  }
}
```

---

## **16\. Próximos Apps Planejados**

### **16.1. Pipeline de Desenvolvimento**

| App             | Status                 | Prioridade |
| --------------- | ---------------------- | ---------- |
| BMI Calculator  | ✅ Publicado            | -          |
| Pomodoro Timer  | ✅ Pronto para publicar | Alta       |
| Todo App        | 🔲 Planejado            | Média      |
| Expense Tracker | 🔲 Planejado            | Média      |
| Habit Tracker   | 🔲 Planejado            | Média      |

### **16.2. Componentes Reutilizáveis Extraídos**

Após o BMI Calculator e Pomodoro Timer, extrair para `/packages`:

| Componente             | Package Destino                  | Status |
| ---------------------- | -------------------------------- | ------ |
| AdService              | `/packages/feature_ads`          | 🔲      |
| ConsentService         | `/packages/feature_privacy`      | 🔲      |
| Temas Material 3       | `/packages/core_ui`              | 🔲      |
| i18n base (11 idiomas) | `/packages/feature_i18n`         | 🔲      |
| Streak/Achievements    | `/packages/feature_gamification` | 🔲      |
| AmbientSoundService    | `/packages/feature_audio`        | 🔲      |

---

## **NOVO: 16.3. Features de Gamificação Obrigatórias**

Todo app deve incluir features de engagement para aumentar retenção:

| Feature                 | Complexidade | Impacto | Prioridade        |
| ----------------------- | ------------ | ------- | ----------------- |
| **Streak Counter**      | Baixa        | ⭐⭐⭐⭐⭐   | Obrigatório       |
| **Achievements/Badges** | Média        | ⭐⭐⭐⭐⭐   | Obrigatório       |
| **Daily Goals**         | Baixa        | ⭐⭐⭐⭐    | Recomendado       |
| **Custom Themes**       | Média        | ⭐⭐⭐⭐    | Recomendado       |
| **Motivational Quotes** | Baixa        | ⭐⭐⭐     | Opcional          |
| **Ambient Sounds**      | Média        | ⭐⭐⭐     | Para apps de foco |

### **Estrutura de Models**

```
/lib/models/
  streak_data.dart      # currentStreak, bestStreak, lastActiveDate
  achievement.dart      # id, titleKey, descriptionKey, category, requirement
  daily_goal.dart       # targetSessions, completedSessions, date
  app_theme.dart        # primaryColor, secondaryColor, name
```

### **Estrutura de Providers**

```
/lib/providers/
  streak_provider.dart       # StateNotifier<StreakData>
  achievements_provider.dart # StateNotifier<List<Achievement>>
  daily_goal_provider.dart   # StateNotifier<DailyGoal>
  theme_provider.dart        # StateNotifier<AppThemeType>
```

---

## **CRÍTICO: 16.4. Checklist de Integração de Features na UI**

**LIÇÃO APRENDIDA (Pomodoro Timer):** Criar models, providers e widgets NÃO é suficiente. O erro mais comum é criar toda a infraestrutura mas esquecer de INTEGRAR na UI principal.

### **Pontos de Integração Obrigatórios:**

| Feature            | Onde Integrar                      | Como Integrar                                                 |
| ------------------ | ---------------------------------- | ------------------------------------------------------------- |
| **Theme dinâmico** | `main.dart`                        | `ref.watch(selectedThemeProvider)` → `ColorScheme.fromSeed()` |
| **Streak Badge**   | `AppBar.leading` da tela principal | Widget `StreakBadge()`                                        |
| **Achievements**   | `AppBar.actions`                   | `IconButton` → `AchievementsScreen`                           |
| **Daily Goal**     | Tela principal                     | Widget `DailyGoalProgress()`                                  |
| **Theme Selector** | `SettingsScreen`                   | Widget `ThemeSelector()`                                      |
| **Sound Selector** | `SettingsScreen`                   | Widget `AmbientSoundSelector()`                               |
| **Goal Setter**    | `SettingsScreen`                   | Widget `DailyGoalSetter()`                                    |
| **Quotes**         | Tela principal                     | Widget `MotivationalQuote()`                                  |

### **Template de Callback de Conclusão:**

```dart
void _onActionComplete() {
  // 1. Streak
  ref.read(streakProvider.notifier).recordActivity();
  
  // 2. Daily Goal
  ref.read(dailyGoalProvider.notifier).incrementCompletedSessions();
  
  // 3. Achievements
  final newAchievements = ref.read(achievementsProvider.notifier).checkAndUnlock(...);
  
  // 4. Feedback
  if (newAchievements.isNotEmpty) {
    _showAchievementDialog(newAchievements.first);
  }
}
```

---

## **16.5. Template de Strings i18n para Gamificação**

**Total: ~80 chaves por idioma**

| Categoria    | Qtd | Exemplos                                                                    |
| ------------ | --- | --------------------------------------------------------------------------- |
| Streaks      | 4   | `streakDays`, `currentStreak`, `bestStreak`, `days`                         |
| Achievements | 34  | `achievements`, `achievementFirstSession`, `achievementFirstSessionDesc`... |
| Sounds       | 9   | `ambientSounds`, `soundRain`, `soundForest`...                              |
| Themes       | 9   | `colorTheme`, `themeTomato`, `themeOcean`...                                |
| Daily Goals  | 6   | `dailyGoal`, `goalReached`, `sessionsProgress`...                           |
| Quotes       | 31  | `newQuote`, `quote1Text`, `quote1Author`... (x15)                           |

---

## **17\. Ambiente de Desenvolvimento Android (NOVO v4.0)**

Esta seção documenta a configuração correta do ambiente de desenvolvimento.

### **17.1. Estrutura de Diretórios Recomendada (Windows)**

```
C:\dev\
  flutter\           # Flutter SDK
  android-sdk\       # Android SDK
    platform-tools\  # ADB
    emulator\        # Emulador
    
C:\Users\<USER>\.android\
  avd\              # Configurações dos AVDs
```

### **17.2. Configuração de Path (PowerShell)**

```powershell
# Adicionar ao Profile do PowerShell ou executar antes de trabalhar
$env:Path = "C:\dev\flutter\bin;C:\dev\android-sdk\platform-tools;C:\dev\android-sdk\emulator;" + $env:Path
```

### **17.3. Otimização do Emulador Android**

**Configurar GPU no AVD (config.ini):**

```ini
# Localização: C:\Users\<USER>\.android\avd\<AVD_NAME>.avd\config.ini
hw.gpu.enabled=yes
hw.gpu.mode=host      # Usa GPU do computador (NVIDIA/AMD/Intel)
hw.ramSize=4096       # 4GB RAM para o emulador
```

**Comando de inicialização otimizado:**

```powershell
emulator -avd <AVD_NAME> -gpu host -memory 4096
```

### **17.4. Troubleshooting: Emulador "Offline" no ADB**

**Problema comum:** `adb devices` mostra `emulator-5554 offline`

**Soluções em ordem:**

```powershell
# 1. Reiniciar ADB server
adb kill-server
adb start-server
adb devices

# 2. Reconectar offline
adb reconnect offline

# 3. Cold boot do emulador (sem snapshot)
emulator -avd <AVD_NAME> -no-snapshot-load -gpu host

# 4. Wipe data completo (último recurso)
emulator -avd <AVD_NAME> -wipe-data
```

### **17.5. Workflow de Desenvolvimento**

```powershell
# 1. Verificar ambiente
flutter doctor -v
adb devices

# 2. Navegar para o app
Set-Location -Path "C:\Users\Ernane\Personal\APPs_Flutter\<app_name>"

# 3. Limpar e preparar
flutter clean
flutter pub get
flutter gen-l10n

# 4. Rodar no emulador
flutter run -d emulator-5554
```

---

## **18\. Captura de Screenshots para Play Store (NOVO v4.0)**

### **18.1. Por que Screenshots Reais?**

- Google Play valoriza screenshots autênticos
- Placeholders genéricos não representam o app
- Screenshots reais aumentam conversão de downloads

### **18.2. Dimensões Obrigatórias**

| Tipo       | Dimensão  | Mínimo        |
| ---------- | --------- | ------------- |
| Phone      | 1080x1920 | 2 screenshots |
| Tablet 7"  | 1200x1920 | Opcional      |
| Tablet 10" | 1600x2560 | Opcional      |

### **18.3. Workflow de Captura via ADB**

```powershell
# 1. Rodar app no emulador
flutter run -d emulator-5554

# 2. Navegar para a tela desejada no app

# 3. Capturar screenshot
adb exec-out screencap -p > screenshot.png

# 4. Ou salvar no device e puxar
adb shell screencap -p /sdcard/screen1.png
adb pull /sdcard/screen1.png ./store_assets/phone_1.png
```

### **18.4. Organização de Assets**

```
/DadosPublicacao/<app_name>/store_assets/
  icon_512.png           # 512x512 (obrigatório)
  feature_1024x500.png   # 1024x500 (obrigatório)
  phone_1.png            # Screenshot 1
  phone_2.png            # Screenshot 2
  tablet7_1.png          # Opcional
  tablet10_1.png         # Opcional
```

### **18.5. INSTRUÇÃO OBRIGATÓRIA: Substituição do Ícone Padrão**

**⚠️ CRÍTICO:** O ícone padrão do Flutter (cubo azul) **DEVE SER SUBSTITUÍDO** por um ícone condizente com o app antes de qualquer publicação. 

**Regras:**
1. **NUNCA** publicar um app com o ícone genérico do Flutter
2. **NUNCA** gerar ícones via Canvas/HTML - use sempre o ícone real do app
3. O ícone deve representar visualmente o propósito do app
4. O ícone deve ser entregue em TODAS as dimensões exigidas (mipmap-*)
5. O ícone 512x512 para a Play Store deve ser um upscale de alta qualidade do ícone real

**Script de Upscale (PowerShell):**
```powershell
Add-Type -AssemblyName System.Drawing
$sourcePath = "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"
$destPath = "..\DadosPublicacao\<app_name>\store_assets\icon_512.png"
$sourceImage = [System.Drawing.Image]::FromFile($sourcePath)
$bitmap = New-Object System.Drawing.Bitmap(512, 512)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.DrawImage($sourceImage, 0, 0, 512, 512)
$bitmap.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose(); $bitmap.Dispose(); $sourceImage.Dispose()
```

---

## **19\. Automação do Play Console (NOVO v4.0)**

### **19.1. Agente de Publicação**

Para automação do Google Play Console, criar um agente dedicado:

**Arquivo:** `.github/agents/publicacaoApp.agent.md`

### **19.2. Dados Necessários por App**

```json
{
  "appName": "BMI Calculator",
  "shortDescription": "Calculate your BMI quickly and accurately.",
  "fullDescription": "Full description up to 4000 chars...",
  "privacyPolicyUrl": "https://yoursite.com/privacy/bmi",
  "supportEmail": "support@yoursite.com",
  "category": "Health & Fitness"
}
```

### **19.3. Checklist de Upload Automatizado**

1. [ ] Assets com dimensões corretas verificados
2. [ ] Traduções para 12 idiomas preparadas
3. [ ] AAB gerado e assinado
4. [ ] Política de privacidade URL acessível
5. [ ] IDs de AdMob de produção no app

---

## **NOVO: 31. Templates para Health/Wellness Apps (v6.0)**

### **31.1. Entity com Estados Temporais (Fasting/Timer)**

```dart
// lib/domain/entities/fasting_session.dart
enum FastingState { idle, fasting, paused, completed }

enum MetabolicStage {
  fed,          // 0-4 horas
  earlyFasting, // 4-8 horas
  fatBurning,   // 8-12 horas
  ketosis,      // 12-18 horas
  deepKetosis,  // 18-24 horas
  autophagy,    // 24+ horas
}

class FastingSession {
  final String id;
  final DateTime? startTime;
  final DateTime? endTime;
  final Duration targetDuration;
  final FastingState state;
  final Duration? pausedDuration;

  Duration get elapsedDuration {
    if (startTime == null) return Duration.zero;
    final end = endTime ?? DateTime.now();
    final elapsed = end.difference(startTime!);
    return elapsed - (pausedDuration ?? Duration.zero);
  }

  double get progress => elapsedDuration.inSeconds / targetDuration.inSeconds;
  
  MetabolicStage get currentStage {
    final hours = elapsedDuration.inHours;
    if (hours < 4) return MetabolicStage.fed;
    if (hours < 8) return MetabolicStage.earlyFasting;
    if (hours < 12) return MetabolicStage.fatBurning;
    if (hours < 18) return MetabolicStage.ketosis;
    if (hours < 24) return MetabolicStage.deepKetosis;
    return MetabolicStage.autophagy;
  }
}
```

### **31.2. Entity de Informações de Saúde**

```dart
// lib/domain/entities/health_info.dart
class HealthInfo {
  final String titleKey;        // i18n key
  final String descriptionKey;  // i18n key
  final String icon;
  final int minHours;           // Quando começa
  final int maxHours;           // Quando termina
  final List<String> benefitKeys;  // Lista de benefícios (i18n)
  final String? warningKey;     // Aviso opcional
  final String? sourceUrl;      // Fonte científica
}
```

### **31.3. Repository Pattern Completo**

```dart
// lib/domain/repositories/i_fasting_repository.dart
abstract class IFastingRepository {
  Future<FastingSession?> getCurrentSession();
  Future<void> saveSession(FastingSession session);
  Future<List<FastingSession>> getHistory();
  Future<void> deleteSession(String id);
}

// lib/data/repositories/fasting_repository_impl.dart
class FastingRepositoryImpl implements IFastingRepository {
  final SharedPreferences _prefs;
  
  FastingRepositoryImpl(this._prefs);
  
  @override
  Future<FastingSession?> getCurrentSession() async {
    final json = _prefs.getString('current_session');
    if (json == null) return null;
    return FastingSessionModel.fromJson(jsonDecode(json)).toEntity();
  }
  
  @override
  Future<void> saveSession(FastingSession session) async {
    final model = FastingSessionModel.fromEntity(session);
    await _prefs.setString('current_session', jsonEncode(model.toJson()));
  }
}
```

### **31.4. NotificationService Template**

```dart
// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> scheduleFastingReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'fasting_reminders',
          'Fasting Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
```

### **31.5. Chaves i18n para Apps de Saúde (~50 chaves)**

| Categoria  | Chaves                                                                                                   |
| ---------- | -------------------------------------------------------------------------------------------------------- |
| Estados    | `stateIdle`, `stateFasting`, `statePaused`, `stateCompleted`                                             |
| Stages     | `stageFed`, `stageEarlyFasting`, `stageFatBurning`, `stageKetosis`, `stageDeepKetosis`, `stageAutophagy` |
| Benefícios | `benefitInsulinDrop`, `benefitFatBurning`, `benefitKetones`, `benefitAutophagy`, `benefitGrowthHormone`  |
| Ações      | `startFast`, `endFast`, `pauseFast`, `resumeFast`                                                        |
| Stats      | `totalFasts`, `longestFast`, `averageDuration`, `currentStreak`                                          |

---

## **NOVO: 32. Workflow de Criação Paralela (v6.0)**

### **32.1. Ordem de Criação Otimizada**

Para máxima eficiência, criar arquivos em lotes paralelos:

| Lote | Arquivos                             | Dependências        |
| ---- | ------------------------------------ | ------------------- |
| 1    | Domain Entities                      | Nenhuma             |
| 2    | Domain Repositories (interfaces)     | Entities            |
| 3    | Data Models                          | Entities            |
| 4    | Data Repositories (impl)             | Models + Interfaces |
| 5    | Presentation Providers               | Repositories        |
| 6    | Presentation Widgets                 | Providers           |
| 7    | Presentation Screens                 | Widgets + Providers |
| 8    | Services (Ad, Consent, Notification) | Independentes       |
| 9    | i18n (todos os 11 arquivos)          | Independentes       |

### **32.2. Template de Prompt para Criação Paralela**

```
Crie os seguintes arquivos em PARALELO (lote 1 - entities):
1. lib/domain/entities/fasting_session.dart
2. lib/domain/entities/streak_data.dart
3. lib/domain/entities/achievement.dart
4. lib/domain/entities/health_info.dart
5. lib/domain/entities/user_settings.dart
```

---

## **NOVO: 33. pubspec.yaml para Health Apps (v6.0)**

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  
  # State Management
  flutter_riverpod: ^2.6.1
  
  # Persistence
  shared_preferences: ^2.3.5
  
  # Notifications
  flutter_local_notifications: ^18.0.1
  timezone: ^0.10.0
  
  # Ads & Consent
  google_mobile_ads: ^5.3.0
  
  # UI
  fl_chart: ^0.70.2  # Para gráficos de progresso
```

---

**Fim do Planejamento v6.0.** Mantenha o foco. Codifique uma feature, termine, valide, commite. Não deixe pontas soltas.

*"Da Fundação ao SuperApp: Um Bloco de Cada Vez."*

---

## **NOVO: 21. Padrões de Edição i18n (Eficiência Máxima)**

### **21.1. Regra de Ouro: Edição em Lote**

Ao adicionar novas strings, **SEMPRE** usar `multi_replace_string_in_file` para editar todos os 11 arquivos .arb simultaneamente:

```
// Prompt eficiente:
"Adicione a chave 'achievementFirstSession' em todos os 11 arquivos .arb:
EN: 'First Session', PT: 'Primeira Sessão', ES: 'Primera Sesión', 
ZH: '首次会话', DE: 'Erste Sitzung', FR: 'Première Session',
AR: 'الجلسة الأولى', BN: 'প্রথম সেশন', HI: 'पहला सत्र',
JA: '最初のセッション', RU: 'Первая сессия'"
```

### **21.2. Organização de Chaves**

Organizar por categoria com comentários:

```json
{
  "@@locale": "en",
  "_GENERAL": "=== GENERAL ===",
  "appTitle": "App Name",
  
  "_ACHIEVEMENTS": "=== ACHIEVEMENTS ===",
  "achievementFirstSession": "First Session",
  
  "_STREAKS": "=== STREAKS ===",
  "currentStreak": "Current Streak"
}
```

### **21.3. Checklist Pós-Edição**

1. Verificar que todos os 11 .arb têm a nova chave
2. Executar `flutter gen-l10n`
3. Verificar imports no código (`AppLocalizations.of(context)!.chave`)

---

## **NOVO: 24. Otimização de Performance para Produção (v5.2)**

**Lição Pomodoro Timer:** Estas otimizações reduziram o AAB de ~30MB para 24MB com 99.4% de redução nas fontes.

### **24.1. gradle.properties Otimizado**

```properties
# Build performance
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
org.gradle.caching=true
org.gradle.parallel=true
org.gradle.configuration-cache=true

# R8 full mode (CRÍTICO)
android.enableR8.fullMode=true

# Desabilitar features não usadas
android.defaults.buildfeatures.buildconfig=false
android.defaults.buildfeatures.aidl=false
android.defaults.buildfeatures.renderscript=false
android.defaults.buildfeatures.resvalues=false
android.defaults.buildfeatures.shaders=false
```

### **24.2. build.gradle Otimizado (android/app)**

```gradle
android {
    defaultConfig {
        // APENAS idiomas usados
        resourceConfigurations += ['en', 'pt', 'es', 'zh', 'de', 'fr', 'ar', 'bn', 'hi', 'ja', 'ru']
    }
    
    buildFeatures {
        buildConfig = false
        aidl = false
        renderScript = false
        resValues = false
        shaders = false
    }
    
    packagingOptions {
        resources {
            excludes += ['META-INF/*.kotlin_module', 'kotlin/**', 'DebugProbesKt.bin']
        }
    }
}
```

### **24.3. ProGuard Rules Agressivo**

```proguard
# 7 passes de otimização
-optimizationpasses 7
-allowaccessmodification
-repackageclasses ''

# Remover logs em produção
-assumenosideeffects class android.util.Log { *; }

# Remover null checks do Kotlin
-assumenosideeffects class kotlin.jvm.internal.Intrinsics { *; }
```

### **24.4. Logger Utility**

**Criar:** `lib/utils/logger.dart`

```dart
import 'package:flutter/foundation.dart';

void logDebug(String message) {
  if (kDebugMode) debugPrint(message);
}
```

**Substituir** TODOS os `debugPrint()` por `logDebug()` para tree-shaking completo.

### **24.5. Resultados Esperados**

| Métrica    | Antes     | Depois         |
| ---------- | --------- | -------------- |
| AAB Size   | ~30MB     | ~24MB          |
| Icon Fonts | 1.6MB     | 10KB (99.4% ↓) |
| Debug Logs | Presentes | Removidos      |

---

## **NOVO: 25. Assinatura de Produção (v5.2)**

### **25.1. Estrutura de Chaves**

```
/DadosPublicacao/<app_name>/keys/
  upload-keystore.jks
  key.properties.example  # Template SEM senhas
```

### **25.2. Gerar Keystore**

```powershell
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### **25.3. Configurar key.properties**

Criar `android/key.properties`:

```properties
storePassword=<senha>
keyPassword=<senha>
keyAlias=upload
storeFile=C:/Users/Ernane/Personal/APPs_Flutter/DadosPublicacao/<app>/keys/upload-keystore.jks
```

### **25.4. Configurar build.gradle**

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### **25.5. .gitignore**

```gitignore
**/android/key.properties
**/*.jks
```

---

## **NOVO: 26. Testes Pré-Publicação (v5.2)**

### **26.1. Checklist Obrigatório**

```powershell
# 1. Análise estática
flutter analyze

# 2. Testes unitários
flutter test

# 3. Build release
flutter build appbundle --release

# 4. Verificar tamanho
$aab = "build\app\outputs\bundle\release\app-release.aab"
Write-Host "Tamanho: $([math]::Round((Get-Item $aab).Length / 1MB, 2)) MB"

# 5. Verificar assinatura
jarsigner -verify $aab
```

### **26.2. Critérios de Aprovação**

| Teste             | Critério                      |
| ----------------- | ----------------------------- |
| `flutter analyze` | 0 issues                      |
| `flutter test`    | 100% passed                   |
| AAB Size          | < 30MB                        |
| Assinatura        | jar verified                  |
| i18n              | Todas as chaves sincronizadas |

---

## **NOVO: 22. ConsentService Template (GDPR/UMP)**

### **22.1. Implementação Padrão**

```dart
// lib/services/consent_service.dart
class ConsentService {
  static bool _canRequestAds = false;
  static bool _isPrivacyOptionsRequired = false;
  
  static bool get canRequestAds => _canRequestAds;
  static bool get isPrivacyOptionsRequired => _isPrivacyOptionsRequired;
  
  static Future<void> gatherConsent({bool forceReset = false}) async {
    final params = ConsentRequestParameters();
    
    if (forceReset) ConsentInformation.instance.reset();
    
    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadAndShowConsentForm();
        }
        _updateCanRequestAds();
      },
      (error) => _canRequestAds = true, // Fallback
    );
  }
  
  static Future<void> showPrivacyOptions() async {
    ConsentForm.showPrivacyOptionsForm((error) {});
  }
}
```

### **22.2. Integração no main.dart**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Consent FIRST
  await ConsentService.gatherConsent();
  
  // 2. Ads ONLY if allowed
  if (ConsentService.canRequestAds) {
    await AdService.initialize();
  }
  
  runApp(const ProviderScope(child: MyApp()));
}
```

---

## **NOVO: 23. Checklist de Feature Completa**

Antes de considerar uma feature "pronta":

### **Código**
- [ ] Model com copyWith
- [ ] Provider com persistência (SharedPreferences)
- [ ] Widget(s) com `const` onde possível
- [ ] Integração na UI principal

### **i18n**
- [ ] Chaves em app_en.arb
- [ ] Traduzido nos 10 outros .arb
- [ ] `flutter gen-l10n` sem erros

### **Testes**
- [ ] Teste unitário da lógica
- [ ] `flutter test` passa
- [ ] `flutter analyze` sem warnings

### **UX**
- [ ] Funciona em modo claro/escuro
- [ ] Responsivo (celular/tablet)
- [ ] Estados de loading/empty/error tratados

---

## **20\. Toolkit de Produtividade (VS Code + Scripts)**

Para reduzir atrito e aumentar assertividade (menos “erros bobos” que travam build/publicação), padronize:

- **VS Code Tasks:** `.vscode/tasks.json` (inputs por app) para rodar `pub get`, `gen-l10n`, `analyze`, `test`, `build aab`.
- **Guardrails:**
  - `tools/check_l10n.ps1` para garantir que todos os `.arb` estão sincronizados com `app_en.arb`.
  - `tools/check_store_assets.ps1` para validar `icon_512.png`, `feature_1024x500.png` e mínimo de screenshots.

Workflow recomendado antes de release:
1) `Flutter: Validate (l10n+analyze+test)`
2) `Assets: Check Store Assets`

---

## **21\. Ambiente Windows - Troubleshooting (NOVO v5.1)**

### **21.1. Flutter não reconhecido no PATH**

**Sintoma:**
```
flutter: The term 'flutter' is not recognized as a name of a cmdlet...
```

**Solução - Usar caminho completo:**
```powershell
C:\dev\flutter\bin\flutter gen-l10n
C:\dev\flutter\bin\flutter analyze
C:\dev\flutter\bin\flutter test
C:\dev\flutter\bin\flutter build appbundle --release
```

### **21.2. Configuração Permanente de PATH**

Adicionar ao PATH do sistema:
- `C:\dev\flutter\bin`
- `C:\dev\android-sdk\platform-tools`
- `C:\dev\android-sdk\emulator`

### **21.3. Emulador Offline no ADB**

```powershell
adb kill-server
adb start-server
adb devices

# Se persistir:
emulator -avd <AVD_NAME> -no-snapshot-load -gpu host
```

### **21.4. Erro de Substituição em arquivos .arb**

**Causa:** Caracteres especiais, encoding ou formatação diferente.

**Solução:** Sempre ler o arquivo com `read_file` primeiro para ver o conteúdo exato antes de editar.

---

## **22\. Padrões de Eficiência para Desenvolvimento**

### **22.1. Edições Paralelas**
- Usar `create_file` em paralelo para criar múltiplos arquivos independentes
- Usar `multi_replace_string_in_file` para editar múltiplos .arb simultaneamente

### **22.2. Validação Contínua**
- Após cada bloco de edições .arb: `flutter gen-l10n`
- Após cada mudança de código: `flutter analyze`
- Antes de considerar completo: `flutter test`

### **22.3. Workflow Otimizado de i18n**

1. Adicionar strings em `app_en.arb` (template)
2. Editar os outros 10 .arb em lote
3. Executar `flutter gen-l10n`
4. Verificar com `flutter analyze`

---

## **14. Parallel Data Layer Creation Workflow (NOVO v7.0 - TESTADO)**

**LIÇÃO CRÍTICA (White Noise - Janeiro 2026):**
> Criar DTOs e repositórios em PARALELO reduziu tempo de **80-100min para 10min**  
> Taxa de sucesso: **100%** na primeira tentativa  
> Redução de erros: **58→0** em 10 minutos

### **14.1. Parallel DTO Creation (5-10 Entidades Simultaneamente)**

**Strategy Comprovada**: Criar todos os DTOs simultaneamente aceita erros iniciais (20-58 erros esperados), mas permite correção em lote.

**Métricas Reais (White Noise)**:
| Abordagem      | Tempo     | Taxa Sucesso | Resultado                   |
| -------------- | --------- | ------------ | --------------------------- |
| Sequencial     | 80-100min | 60-70%       | Cansativo, erros acumulados |
| Paralelo (5+5) | 10min     | 100%         | Rápido, erros previsíveis   |

**Template EntityDto (Copy-Paste Ready)**:
```dart
class EntityDto {
  final String id;
  final String name;
  final int value;
  
  const EntityDto({
    required this.id,
    required this.name,
    required this.value,
  });
  
  // Domain Entity → DTO (usado pelo Repository)
  factory EntityDto.fromEntity(Entity entity) {
    return EntityDto(
      id: entity.id,
      name: entity.name,
      value: entity.value,
    );
  }
  
  // DTO → Domain Entity (usado pelo Repository)
  Entity toEntity() {
    return Entity(
      id: id,
      name: name,
      value: value,
    );
  }
  
  // JSON serialization (para SharedPreferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'value': value,
  };
  
  factory EntityDto.fromJson(Map<String, dynamic> json) {
    return EntityDto(
      id: json['id'] as String,
      name: json['name'] as String,
      value: json['value'] as int,
    );
  }
}
```

**Expectativa de Erros (NORMAL e esperado)**:
```
Após criar 5 DTOs em paralelo:
├─ 20-58 erros esperados
├─ Maioria: imports faltando, nomes errados
├─ Corrigir via multi-replace (80-90% sucesso)
└─ Diagnóstico para 2-3 erros restantes
```

### **14.2. Flutter Analyze Exit Codes (CRÍTICO - Interpretação)**

**LIÇÃO WHITE NOISE:** Exit codes do `flutter analyze` indicam severidade:

| Exit Code | Significado                | Ação                                 |
| --------- | -------------------------- | ------------------------------------ |
| **0**     | Perfeito (zero issues)     | ✅ Prosseguir sem preocupação         |
| **1**     | Warnings (não-bloqueantes) | ⚠️ OK para continuar, corrigir depois |
| **2+**    | Errors (bloqueantes)       | ❌ CORRIGIR antes de prosseguir       |

**PowerShell Exit Code Check**:
```powershell
flutter analyze
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ PERFEITO: Zero issues"
} elseif ($LASTEXITCODE -eq 1) {
    Write-Host "⚠️ OK: Apenas warnings (não bloqueante)"
} else {
    Write-Host "❌ BLOQUEANTE: Errors devem ser corrigidos"
    exit 1
}
```

**Regra de Ouro**:
- Exit code 0 ou 1 → CONTINUAR
- Exit code 2+ → PARAR e corrigir

### **14.3. Efficient Debugging Strategy**

**Quando erros persistem após multi-replace (típico: 2-3 erros finais)**:

**Step 1: Identify Exact Error**
```powershell
flutter analyze
# Output: lib/data/repositories/sound_repository_impl.dart:23:30 - Expected '}'
```

**Step 2: Read Context Around Error**
```javascript
read_file("lib/data/repositories/sound_repository_impl.dart", offset=20, limit=30)
// Lê linhas 20-50 para diagnóstico
```

**Step 3: Identify Root Cause**
- Brace duplicado?
- Import faltando?
- Nome de classe errado?

**Step 4: Targeted Fix**
```javascript
replace_string_in_file({
  filePath: "sound_repository_impl.dart",
  oldString: "[exact text with error + context]",
  newString: "[corrected text]"
})
```

**Step 5: Validate**
```powershell
flutter analyze
# Exit code 0 ou 1 → Success!
```

### **14.4. Validation Checklist**

**Before considering Data Layer complete**:

- [ ] **Domain Purity**: Entities não dependem de nada (Dart puro)
- [ ] **DTO Completeness**: Cada entity tem seu DTO correspondente
- [ ] **Bidirectional Conversion**: toEntity() e fromEntity() funcionando
- [ ] **Repository Implementation**: Todas as interfaces implementadas
- [ ] **Dependency Injection**: LocalDataSource injetado via constructor
- [ ] **Flutter Analyze**: Exit code 0 ou 1 (warnings OK, errors NOT OK)
- [ ] **Compilation**: `flutter pub get` sem erros

**Comando de Validação Final**:
```powershell
flutter analyze
# Exit code 0: perfeito
# Exit code 1: warnings (OK para continuar)
# Exit code 2+: errors (BLOQUEANTE - corrigir antes de prosseguir)
```

---

## **NOVO: 27. Teste Funcional de UI via ADB (v5.3)**

**Lição Pomodoro Timer:** Antes de publicar, testar TODAS as funcionalidades via automação ADB.

### **27.1. Workflow de Teste**

```powershell
# 1. Capturar hierarquia de UI
adb shell uiautomator dump /sdcard/ui.xml
adb shell cat /sdcard/ui.xml

# 2. Clicar em elementos
adb shell input tap <x> <y>

# 3. Scroll
adb shell input swipe 540 1500 540 600 300

# 4. Screenshot
adb exec-out screencap -p > screenshot.png
```

### **27.2. Checklist de Testes Funcionais**

| Tela         | Testes                                          |
| ------------ | ----------------------------------------------- |
| Home         | Layout, timer display, daily goal, streak badge |
| Controls     | Start, Pause, Reset, Skip                       |
| Settings     | Scroll, toggles, theme selector                 |
| Achievements | Dialog, badges, categorias                      |
| Navigation   | AppBar buttons, back navigation                 |

---

## **NOVO: 28. Estrutura de Testes Unitários (v5.3)**

### **28.1. Mínimo de Testes**

| Tipo de App | Testes | Cobertura            |
| ----------- | ------ | -------------------- |
| Calculadora | 10     | Core logic           |
| Timer       | 19     | Timer + Gamification |
| Todo        | 15     | CRUD + Persistência  |

### **28.2. Template**

```dart
void main() {
  group('Core Logic', () {
    test('main function works', () {
      // Test core functionality
    });
  });
  
  group('Gamification', () {
    test('streak increments', () { ... });
    test('achievements unlock', () { ... });
    test('daily goal tracks', () { ... });
  });
}
```

---

## **NOVO: 29. Fast Lane de Publicação (v5.3)**

### **29.1. Comando Único**

```powershell
Set-Location -Path "C:\Users\Ernane\Personal\APPs_Flutter\<app>";
C:\dev\flutter\bin\flutter clean;
C:\dev\flutter\bin\flutter pub get;
C:\dev\flutter\bin\flutter gen-l10n;
C:\dev\flutter\bin\flutter analyze;
C:\dev\flutter\bin\flutter test;
C:\dev\flutter\bin\flutter build appbundle --release
```

### **29.2. Verificação**

```powershell
$aab = "build\app\outputs\bundle\release\app-release.aab"
Write-Host "✅ AAB: $([math]::Round((Get-Item $aab).Length / 1MB, 2)) MB"
```

---

## **NOVO: 30. Relatório de Qualidade Pré-Publicação (v5.3)**

Template para documentar qualidade antes de publicar:

```markdown
# Relatório de Qualidade - [App Name] v[version]

## Build
- ✅ flutter analyze: 0 issues
- ✅ flutter test: X/X passed
- ✅ AAB Size: XX.X MB
- ✅ Assinatura: válida

## i18n
- ✅ 11 idiomas
- ✅ XXX chaves sincronizadas

## Testes Funcionais (ADB)
- ✅ Home Screen
- ✅ Timer/Main Controls
- ✅ Settings
- ✅ Achievements
- ✅ Theme Change
- ✅ Navigation

## Features
- ✅ Streaks
- ✅ Daily Goals
- ✅ Achievements
- ✅ Themes
- ✅ Ads
```

---

## **NOVO: 32. Lições de Produtividade (v6.1)**

### **32.1. Delegação de Tradução via Sub-agente**

Quando traduzir para 11 idiomas, use este template para delegar ao sub-agente:

```
runSubagent("Traduzir i18n para 9 idiomas", """
Tarefa: Traduzir arquivo ARB de inglês para 9 idiomas.

Template (app_en.arb): [conteúdo completo]

Idiomas alvo:
- Bengali (bn), Alemão (de), Chinês (zh), Hindi (hi)
- Árabe (ar), Russo (ru), Japonês (ja), Espanhol (es), Francês (fr)

Regras:
1. Manter EXATAMENTE as mesmas chaves do template
2. Manter placeholders intactos ({count}, {hours}, {minutes})
3. Respeitar formato ICU plural para cada idioma
4. Retornar cada arquivo .arb completo e pronto para uso

Formato de retorno:
=== app_bn.arb ===
{ conteúdo JSON }
=== app_de.arb ===
{ conteúdo JSON }
... (para todos os 9 idiomas)
""")
```

### **32.2. Checklist de Ícone (CRÍTICO)**

| Etapa | Ação                                         | Status |
| ----- | -------------------------------------------- | ------ |
| 1     | Criar ícone personalizado para o app         | ⬜      |
| 2     | Exportar em todas as densidades (mipmap-*)   | ⬜      |
| 3     | Substituir ic_launcher.png padrão do Flutter | ⬜      |
| 4     | Gerar ic_launcher_round.png (Android 8+)     | ⬜      |
| 5     | Upscale para 512x512 (Play Store)            | ⬜      |
| 6     | Verificar que NÃO é o cubo azul do Flutter   | ⬜      |

### **32.3. Padrões de Edição em Lote**

Para máxima eficiência ao editar múltiplos arquivos:

```
# Usar multi_replace_string_in_file para editar 11 .arb simultaneamente
# Usar create_file em paralelo para criar múltiplos arquivos
# Usar runSubagent para tarefas paralelas de tradução/pesquisa
```

### **32.4. Organização de Chaves i18n por Categoria**

```json
{
  "@@locale": "en",
  
  "_GENERAL": "=== GENERAL ===",
  "appTitle": "App Name",
  
  "_CONTROLS": "=== CONTROLS ===",
  "start": "Start",
  
  "_ACHIEVEMENTS": "=== ACHIEVEMENTS ===",
  "achievementFirst": "First Achievement",
  
  "_SETTINGS": "=== SETTINGS ===",
  "settings": "Settings"
}
```

---

## **33. Automação AdMob via Playwright (NOVO v6.3)**

### **33.1. Workflow Automatizado**

O Playwright MCP permite automatizar completamente a criação de apps e ad units no console AdMob:

| Passo | Ação                       | Tempo | Automatizado |
| ----- | -------------------------- | ----- | ------------ |
| 1     | Navegar para AdMob Console | 10s   | ✅            |
| 2     | Verificar se app existe    | 20s   | ✅            |
| 3     | Criar novo app             | 30s   | ✅            |
| 4     | Criar Banner ad unit       | 40s   | ✅            |
| 5     | Criar Interstitial ad unit | 40s   | ✅            |
| 6     | Criar App Open ad unit     | 40s   | ✅            |
| 7     | Capturar IDs de produção   | 20s   | ✅            |
| 8     | Atualizar código fonte     | 60s   | ✅            |

**Total: ~4 minutos** vs 15+ minutos manualmente.

**LIÇÃO Fasting Tracker:** Automação AdMob reduz significativamente o tempo de configuração e elimina erros de digitação de IDs.

### **33.2. Template ADMOB_IDS.md**

Criar em `DadosPublicacao/<app_name>/admob/ADMOB_IDS.md`:

```markdown
# AdMob IDs de Produção - [Nome do App]

**Data de Criação:** [DD/MM/YYYY]
**Conta AdMob:** [email]

## IDs de Produção

| Tipo             | Nome no AdMob      | ID Completo            |
| ---------------- | ------------------ | ---------------------- |
| **App ID**       | [App Name]         | `ca-app-pub-XXXX~YYYY` |
| **Banner**       | [App]_Banner       | `ca-app-pub-XXXX/ZZZZ` |
| **Interstitial** | [App]_Interstitial | `ca-app-pub-XXXX/ZZZZ` |
| **App Open**     | [App]_AppOpen      | `ca-app-pub-XXXX/ZZZZ` |

## Arquivos Atualizados
- [x] lib/services/ad_service.dart
- [x] android/app/src/main/AndroidManifest.xml
```

### **33.3. Estrutura DadosPublicacao Expandida**

```
DadosPublicacao/<app_name>/
├── app-release.aab           # AAB assinado
├── CHECKLIST_CONCLUIDO.md
├── admob/                    # NOVO: Documentação AdMob
│   └── ADMOB_IDS.md          # IDs de produção documentados
├── keys/
│   ├── upload-keystore.jks
│   └── key.properties.example
├── policies/
│   └── privacy_policy.html
└── store_assets/
    ├── icon_512.png
    ├── feature_graphic.png
    └── screenshots/
```

---

## **34. Feature Graphic via Playwright Canvas (NOVO v6.3)**

### **34.1. Geração Automatizada**

```javascript
await page.setContent(`
  <div id="feature" style="
    width: 1024px; height: 500px;
    background: linear-gradient(135deg, #4CAF50 0%, #2E7D32 100%);
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    font-family: 'Segoe UI', Arial, sans-serif; color: white;">
    <div style="font-size: 72px; font-weight: bold;">App Name</div>
    <div style="font-size: 32px; opacity: 0.9;">Tagline here</div>
  </div>
`);
await page.locator('#feature').screenshot({ path: 'feature_graphic.png' });
```

### **34.2. Cores por Categoria**

| Categoria     | Gradiente           |
| ------------- | ------------------- |
| Saúde/Fitness | `#4CAF50 → #2E7D32` |
| Produtividade | `#E74C3C → #C0392B` |
| Finanças      | `#3498DB → #2980B9` |
| Utilidades    | `#34495E → #2C3E50` |
| Jogos         | `#9B59B6 → #8E44AD` |

---

## **35. Crop de Screenshots 9:16 (NOVO v6.5 - CRÍTICO)**

**LIÇÃO APRENDIDA (Fasting Tracker):** O Google Play Console REJEITA screenshots com aspect ratio diferente de 9:16 para phones.

### **35.1. Script de Crop Automatizado**

```powershell
# Crop para 9:16 (1080x1920) centralizado
Add-Type -AssemblyName System.Drawing
$inputPath = "DadosPublicacao\<app>\store_assets\screenshots\original.png"
$outputPath = "DadosPublicacao\<app>\store_assets\screenshots\cropped.png"

$original = [System.Drawing.Image]::FromFile($inputPath)
$targetRatio = 9.0 / 16.0
$currentRatio = $original.Width / $original.Height

if ($currentRatio -gt $targetRatio) {
    $newWidth = [int]($original.Height * $targetRatio)
    $cropX = [int](($original.Width - $newWidth) / 2)
    $cropRect = [System.Drawing.Rectangle]::new($cropX, 0, $newWidth, $original.Height)
} else {
    $newHeight = [int]($original.Width / $targetRatio)
    $cropY = [int](($original.Height - $newHeight) / 2)
    $cropRect = [System.Drawing.Rectangle]::new(0, $cropY, $original.Width, $newHeight)
}

$bitmap = New-Object System.Drawing.Bitmap($original)
$cropped = $bitmap.Clone($cropRect, $bitmap.PixelFormat)
$cropped.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$original.Dispose(); $bitmap.Dispose(); $cropped.Dispose()
```

### **35.2. Validação de Aspect Ratio**

```powershell
Get-ChildItem "DadosPublicacao\<app>\store_assets\screenshots\*.png" | ForEach-Object {
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    $ratio = [math]::Round($img.Width / $img.Height, 4)
    $expected = 0.5625  # 9/16
    $status = if ($ratio -eq $expected) { "✅" } else { "❌ ($ratio)" }
    Write-Host "$($_.Name): $status"
    $img.Dispose()
}
```

---

## **36. Traduções de Store Listing (NOVO v6.5 - OBRIGATÓRIO)**

**LIÇÃO:** O Play Console exige descrições traduzidas para cada idioma. Apenas i18n do código NÃO é suficiente.

### **36.1. Template JSON para Sub-agente**

```json
{
  "translations": {
    "en-US": {
      "title": "App Name",
      "shortDescription": "Short description up to 80 characters.",
      "fullDescription": "🎯 App Name\n\n📊 Features:\n• Feature 1\n• Feature 2"
    },
    "pt-BR": { "title": "...", "shortDescription": "...", "fullDescription": "..." },
    "de-DE": { "title": "...", "shortDescription": "...", "fullDescription": "..." }
  }
}
```

### **36.2. Prompt para Delegação**

```
runSubagent("Traduzir Store Listing", "Traduza para 10 idiomas (de, pt, es, fr, zh, ru, ja, ar, hi, bn):

Regras:
1. Respeitar limite de 30 chars para título
2. Respeitar limite de 80 chars para descrição curta
3. Adaptar culturalmente (não traduzir literalmente)
4. Manter keywords relevantes para ASO

Retorne JSON organizado por idioma.")
```

---

## **37. Validação i18n Automatizada (NOVO v6.5)**

### **37.1. Ferramenta check_l10n.ps1**

Criar em `tools/check_l10n.ps1` para validar sincronização de chaves entre todos os arquivos .arb.

### **37.2. Uso**

```powershell
pwsh -File tools\check_l10n.ps1 -AppPath .\fasting_tracker
# Output: ✅ OK: all ARB files match template keys.
```

---

**Fim do Planejamento v6.5.** Clean Architecture + Factory Mode + Automação AdMob + Validação Completa = Zero Retrabalho.

*"Da Fundação ao SuperApp: Um Bloco de Cada Vez. Agora com Arquitetura Limpa, Automação Total, AdMob em 4 Minutos e Validação Automatizada."*
