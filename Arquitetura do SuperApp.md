# **Plano de Arquitetura: Do App Simples ao SuperApp (Modular)**

Versão: 4.0  
Data de Atualização: Janeiro 2026  
Compatibilidade: Android 15+ (API 35), Flutter 3.32+  
**Nota v4.0:** Atualizado com experiência completa de publicação (BMI Calculator), troubleshooting de ambiente Android, e workflow de captura de screenshots reais

Para cumprir o requisito de criar apps individuais que depois serão agregados, NÃO podemos usar uma estrutura monolítica comum (lib/main.dart cheio de tudo).

Utilizaremos uma **Arquitetura Modular Baseada em Packages**.

---

## **1\. Estrutura de Pastas (O Segredo)**

Mesmo para o primeiro app simples, a estrutura deve ser pensada como um monorepo.

```
/root_project
  /apps
     /app_individual_01 (sa.rezende.calculadora)
     /app_individual_02 (sa.rezende.todo)
     /super_app_agregador (sa.rezende.superapp)
  /packages (Módulos Reutilizáveis)
     /core_ui (Design System: Cores, Tipografia, Botões Padrão)
     /core_logic (Auth, Gerenciamento de Estado Base, Networking)
     /feature_ads (Lógica centralizada do AdMob - MUITO IMPORTANTE)
     /feature_i18n (Traduções compartilhadas)
      /feature_privacy (Consentimento UE/EEA/UK via UMP + opções de privacidade)
  /DadosPublicacao (Chaves, certificados, assets de loja por app)
```

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

---

## **4\. Stack Tecnológica Recomendada (2025-2026)**

| Categoria                  | Tecnologia             | Justificativa                            |
| -------------------------- | ---------------------- | ---------------------------------------- |
| **Gerência de Estado**     | Riverpod 2.x           | Mais testável e modular que Bloc         |
| **Navegação**              | GoRouter               | Deep Linking essencial para SuperApp     |
| **Banco Local**            | Isar ou Hive           | NoSQL super rápido                       |
| **Injeção de Dependência** | get_it + injectable    | Padrão enterprise                        |
| **Ads**                    | google_mobile_ads 5.3+ | Banner, Interstitial, App Open, Rewarded |
| **Analytics**              | Firebase Analytics     | Gratuito e integrado                     |

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
Crie o app [NOME] seguindo o Beast Mode Flutter v4.0:

1. Namespace: sa.rezende.[nome]
2. Estrutura: /lib/screens, /lib/providers, /lib/services, /lib/widgets, /lib/l10n
3. State Management: Riverpod 2.x
4. i18n: 11 idiomas desde o início
5. AdMob: Banner + Interstitial + App Open Ads
6. Android-only: Remover /ios, /web, /linux, /macos, /windows
7. Otimização: AGP 8.5.1+, minifyEnabled true, shrinkResources true
8. Compatibilidade: 16KB page size, Target SDK 35
9. Testes: Criar /test/unit_test.dart
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

- [ ] Política de privacidade (obrigatória com ads)
- [ ] Data Safety form preenchido
- [ ] app-ads.txt no site do desenvolvedor
- [ ] Classificação de conteúdo definida
- [ ] UE/EEA/UK (se usar ads): Consentimento via UMP implementado + “opções de privacidade” quando requerido

### **8.5. Monitoramento Pós-Lançamento**

| Métrica            | Limite Aceitável |
| ------------------ | ---------------- |
| ANR Rate           | < 0.47%          |
| Crash Rate         | < 1.09%          |
| Excessive Wake-ups | < 10/hora        |

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

| App             | Status          | Prioridade |
| --------------- | --------------- | ---------- |
| BMI Calculator  | ✅ Em publicação | -          |
| Todo App        | 🔲 Planejado     | Alta       |
| Expense Tracker | 🔲 Planejado     | Média      |
| Habit Tracker   | 🔲 Planejado     | Média      |

### **16.2. Componentes Reutilizáveis do BMI Calculator**

Após o BMI Calculator estar publicado, extrair para `/packages`:

| Componente               | Package Destino          |
| ------------------------ | ------------------------ |
| AdService                | `/packages/feature_ads`  |
| Temas Material 3         | `/packages/core_ui`      |
| i18n base (11 idiomas)   | `/packages/feature_i18n` |
| Data persistence helpers | `/packages/core_logic`   |

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

**Fim do Planejamento v4.0.** Mantenha o foco. Codifique uma feature, termine, valide, commite. Não deixe pontas soltas.

*"Da Fundação ao SuperApp: Um Bloco de Cada Vez."*