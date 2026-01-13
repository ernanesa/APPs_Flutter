---
description: This custom agent creates an advanced Flutter development protocol focused on Android optimization, internationalization, and monetization strategies.
model: Claude Opus 4.5 (copilot)
tools: ['vscode', 'execute', 'read', 'edit', 'search', 'web', 'agent', 'copilot-container-tools/*', 'io.github.chromedevtools/chrome-devtools-mcp/*', 'io.github.upstash/context7/*', 'playwright/*', 'microsoftdocs/mcp/*', 'upstash/context7/*', 'todo']
---

# **BEAST MODE FLUTTER: Protocolo de Desenvolvimento de Elite**

Versão do Protocolo: 3.0 (Android Focus / Global Scale / AI-Optimized)  
Namespace Base: sa.rezende.\<nome\_do\_app\>  
Filosofia: "Código Limpo, Performance Brutal, Lucro Inteligente."

---

## **0\. Regras de Ouro para a IA (LEIA PRIMEIRO)**

Estas regras são **OBRIGATÓRIAS** para garantir desenvolvimento ágil e sem erros.

### **0.1. Navegação de Diretório (CRÍTICO)**
* **SEMPRE** usar `Set-Location` ou `cd` para o diretório do app ANTES de executar comandos Flutter.
* Padrão: `Set-Location -Path "C:\Users\Ernane\Personal\APPs_Flutter\<nome_do_app>"; flutter <comando>`
* **NUNCA** executar `flutter run` da raiz do monorepo.

### **0.2. Arquitetura Modular (Referência: Arquitetura do SuperApp.instructions.md)**
* Todo novo app deve seguir a estrutura de monorepo com packages compartilhados.
* Estrutura obrigatória:
  ```
  /root_project
    /apps/<nome_do_app>
    /packages/core_ui (quando existir)
    /packages/feature_ads (quando existir)
  ```
* Se os packages ainda não existirem, crie o app de forma **modular internamente** (separar `/lib/services`, `/lib/providers`, `/lib/screens`, `/lib/widgets`, `/lib/l10n`).

### **0.3. Geração de Código (Pós-Edição)**
* **APÓS editar qualquer arquivo `.arb`:** Executar `flutter gen-l10n`.
* **APÓS adicionar dependências:** Executar `flutter pub get`.
* **APÓS mudanças estruturais:** Executar `flutter clean && flutter pub get`.

### **0.4. i18n - Zero Strings Hardcoded**
* **JAMAIS** escrever texto em português ou inglês diretamente no código Dart.
* **SEMPRE** usar `AppLocalizations.of(context)!.chaveDoTexto`.
* **REGRA DOS 11 IDIOMAS:** Ao adicionar uma nova chave, adicionar em TODOS os arquivos .arb simultaneamente (EN, PT, ES, ZH, DE, FR, AR, BN, HI, JA, RU).
* Use `multi_replace_string_in_file` para editar múltiplos .arb de uma vez.

### **0.5. Android-Only (Limpeza Obrigatória)**
* **REMOVER** pastas: `/ios`, `/web`, `/linux`, `/macos`, `/windows` no momento da criação.
* **MANTER APENAS:** `/android`, `/lib`, `/test`, `/l10n`.
* Isso reduz tamanho do projeto e evita erros de build cruzado.

### **0.6. Testes desde o Dia 1**
* Criar `/test/unit_test.dart` com testes básicos de lógica de negócio.
* Executar `flutter test` antes de considerar qualquer task completa.

---

## **1\. O "Zen Mode" de Desenvolvimento (Mentalidade Burke Holland)**

Não perca tempo com distrações. O ambiente de desenvolvimento deve ser uma extensão do seu pensamento.

### **1.1. Regras de Ouro da Interface (VS Code)**

* **Sem Sidebars:** A árvore de arquivos só aparece quando solicitada (Ctrl+B ou atalho customizado).  
* **Foco no Código:** O editor ocupa 95% da tela.  
* **Teclado \> Mouse:** Se você usar o mouse, está perdendo tempo. Aprenda os atalhos de navegação e edição em bloco.  
* **Feedback Imediato:** Linting estrito (flutter\_lints ou very\_good\_analysis) ativado. O erro deve brilhar na hora, não no compile.

### **1.2. O Ciclo de Feedback (The Loop)**

1. **Planejamento Micro:** Nunca comece a codar sem definir a *Task*. (Ex: "Criar Widget de Card de Anúncio Nativo").  
2. **Execução:** Codificar focado até a task estar 100%.  
3. **Validação:** Teste no emulador Android (Pixel com Play Store) e Tablet (simulado).  
4. **Commit:** Mensagens semânticas (feat:, fix:, perf:).

## **2\. Engenharia de Performance (Android Otimizado)**

O Android é fragmentado. Para atingir o mundo todo, o app deve voar em um Samsung J7 e brilhar num Pixel 9 Pro.

### **2.1. Otimização de Renderização (60/120 FPS)**

* **Impeller Engine:** Garantir que está ativo (padrão nas versões recentes, mas verificar flags).  
* **Constantes:** A IA deve usar const em **tudo** que for imutável. Isso reduz o trabalho do Garbage Collector (GC).  
* **List Views:** Jamais usar ListView simples para listas infinitas. Usar ListView.builder ou SliverList com extent fixo quando possível para "pre-caching" de renderização.  
* **Imagens:**  
  * Formato: **WebP** (menor que PNG/JPG).  
  * Lib: cached\_network\_image para cache agressivo.  
  * Pre-cache: Imagens críticas (splash, onboarding) devem ser pré-carregadas no main().

### **2.2. Otimização de Tamanho (APK/AAB)**

* **App Bundle (.aab):** Nunca gerar APK para loja. O AAB permite que a Play Store entregue apenas os recursos necessários para a densidade de tela do usuário.  
* **Tree Shaking:** Remover ícones não usados (configurar pubspec.yaml).  
* **ProGuard/R8:** Ofuscação e minificação ativadas no build.gradle em release.

### **2.3. Configuração Obrigatória do build.gradle (android/app)**

```gradle
android {
    buildTypes {
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    // Para debug em emulador x86, não filtrar ABI
    // Para release, otimizar apenas para ARM
}
```

### **2.4. ProGuard Rules Obrigatórias (android/app/proguard-rules.pro)**

```proguard
# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Google Mobile Ads (AdMob)
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Gson (se usar)
-keepattributes Signature
-keepattributes *Annotation*
```

## **3\. Internacionalização (i18n) e Alcance Global**

O app nasce global. Não existe "versão em português depois".

### **3.1. Configuração Base**

* **Lib Padrão:** flutter\_localizations e pacote intl.  
* **Arquivo Arb:** Usar arquivos .arb (App Resource Bundle) desde o dia 1.
* **Idiomas Obrigatórios (11):** EN, PT, ES, ZH, DE, FR, AR, BN, HI, JA, RU.
* **Detecção Automática:** O app deve ler o Locale do dispositivo no MaterialApp.  
* **Fallback:** Se o idioma do celular for desconhecido (ex: Swahili), fallback seguro para Inglês (en).

### **3.2. Estrutura de Arquivos l10n**

```
/lib/l10n/
  app_en.arb (template)
  app_pt.arb
  app_es.arb
  app_zh.arb
  app_de.arb
  app_fr.arb
  app_ar.arb
  app_bn.arb
  app_hi.arb
  app_ja.arb
  app_ru.arb
/l10n.yaml
```

### **3.3. Configuração l10n.yaml**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### **3.4. Workflow de Adição de Textos**

1. Adicionar a chave no `app_en.arb` (template).
2. **IMEDIATAMENTE** adicionar a mesma chave traduzida nos outros 10 arquivos .arb.
3. Executar `flutter gen-l10n`.
4. Usar no código: `AppLocalizations.of(context)!.minhaChave`.

## **4\. Monetização Equilibrada (AdMob v2)**

Lucro não pode matar a usabilidade (retorno do usuário \> clique acidental).

### **4.1. Estratégia de Ads**

* **Banner Adaptativo (Anchor):** No rodapé ou topo, fixo. Não use banners de tamanho fixo (320x50), use AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize.  
* **Nativo Avançado (Native Advanced):** O "Beast Mode" dos Ads.  
  * Integre o anúncio DENTRO do conteúdo (ex: a cada 5 itens de uma lista).  
  * Estilize o anúncio para parecer parte do app (mesma fonte, cores, bordas), mantendo a tag "Anúncio" visível por regras do Google.  
  * Isso aumenta o CTR sem irritar o usuário (Banner Blindness).  
* **Interstitials (Tela Cheia):**  
  * **NUNCA:** Ao abrir o app ou no meio de uma ação (clicar num botão).  
  * **SEMPRE:** Em pausas naturais (fim de uma fase, após salvar uma nota, troca de contexto pesada).  
* **Rewarded Video:** Para desbloquear features premium temporariamente. Alta aceitação.

### **4.2. Implementação Técnica**

* **Pre-loading:** Carregar o anúncio no initState da tela anterior para exibição instantânea.  
* **Shimmer Effect:** Enquanto o Ad Nativo carrega, mostre um esqueleto (shimmer) do tamanho exato do Ad para evitar "layout shift" (pulo de tela).

### **4.3. Padrão Singleton para AdService (OBRIGATÓRIO)**

Criar `/lib/services/ad_service.dart`:

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  // IDs de TESTE (trocar por produção antes de publicar)
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  BannerAd createBannerAd({required AdSize size}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Banner loaded'),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    );
  }

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => print('Interstitial failed: $error'),
      ),
    );
  }

  void showInterstitial() {
    _interstitialAd?.show();
    _interstitialAd = null;
    loadInterstitial(); // Pré-carrega o próximo
  }
}
```

### **4.4. Configuração AndroidManifest.xml**

```xml
<manifest>
  <application>
    <meta-data
      android:name="com.google.android.gms.ads.APPLICATION_ID"
      android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
  </application>
</manifest>
```

## **5\. UI/UX "Beast Mode" (Atração de Público)**

* **Material 3 (You):** Uso obrigatório. Cores dinâmicas baseadas no wallpaper do usuário (Android 12+) dão sensação de app nativo premium.  
* **Splash Screen:** Usar flutter\_native\_splash. Nada de tela branca inicial.  
* **Feedback Tátil:** Usar HapticFeedback.lightImpact() em botões importantes. Dá sensação de "peso" e qualidade.  
* **Tablet/Foldable:** Usar LayoutBuilder.  
  * Celular: Lista vertical.  
  * Tablet: Master-Detail (Lista na esquerda, Detalhe na direita).

## **6\. Checklist de Validação "Beast Mode"**

Antes de dar uma task como "Concluída", verifique:

1. \[ \] O app abre em menos de 2s (Cold start)?  
2. \[ \] Funciona offline? (Tratamento de erro amigável).  
3. \[ \] Roda a 60fps no scroll? (Abra o DevTools \> Performance Overlay).  
4. \[ \] O anúncio não cobre botões de navegação?  
5. \[ \] Se eu mudar o idioma do celular para Inglês, o app muda tudo?  
6. \[ \] O pacote está como sa.rezende.\<app\>?
7. \[ \] Todos os 11 arquivos .arb estão sincronizados?
8. \[ \] `flutter test` passa sem erros?
9. \[ \] `flutter analyze` retorna zero issues?

---

## **7\. Templates de Criação Rápida**

### **7.1. Novo App (Prompt para IA)**

```
Crie o app [NOME] seguindo o Beast Mode Flutter:

1. Namespace: sa.rezende.[nome]
2. Estrutura: /lib/screens, /lib/providers, /lib/services, /lib/widgets, /lib/l10n
3. State Management: Riverpod
4. i18n: 11 idiomas desde o início (EN, PT, ES, ZH, DE, FR, AR, BN, HI, JA, RU)
5. AdMob: AdService singleton com Banner e Interstitial
6. Android-only: Remover pastas /ios, /web, /linux, /macos, /windows
7. Otimização: R8/ProGuard habilitados, minifyEnabled true
8. Testes: Criar /test/unit_test.dart com testes básicos
```

### **7.2. pubspec.yaml Base**

```yaml
name: nome_do_app
description: Descrição do app.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.6.0

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: any
  flutter_riverpod: ^2.6.1
  shared_preferences: ^2.3.5
  google_mobile_ads: ^5.3.0
  fl_chart: ^0.70.2 # Se precisar de gráficos

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  generate: true
  uses-material-design: true
```

### **7.3. main.dart Base**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService().initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Name',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
```

---

## **8\. Comandos Essenciais (Referência Rápida)**

| Ação | Comando |
|------|---------|
| Criar app | `flutter create --org sa.rezende nome_do_app` |
| Limpar build | `flutter clean` |
| Instalar deps | `flutter pub get` |
| Gerar traduções | `flutter gen-l10n` |
| Rodar testes | `flutter test` |
| Analisar código | `flutter analyze` |
| Build Release | `flutter build appbundle --release` |
| Rodar em device | `flutter run -d <device_id>` |
| Listar devices | `flutter devices` |
| Listar emuladores | `flutter emulators` |

---

## **9\. Erros Comuns e Soluções**

| Erro | Causa | Solução |
|------|-------|---------|
| `flutter run` falha no diretório errado | CWD não é o app | `Set-Location -Path "caminho/do/app"` antes |
| Texto em inglês mesmo com idioma PT | String hardcoded | Usar `AppLocalizations.of(context)!.chave` |
| Ads não aparecem no emulador | Emulador x86 sem suporte | Normal para teste, funciona em device real |
| `gen-l10n` erro de chave | Chave faltando em algum .arb | Sincronizar todos os 11 arquivos .arb |
| APK muito grande | Sem minificação | Habilitar `minifyEnabled true` e `shrinkResources true` |
| Ícone genérico do Flutter | Não configurou adaptive icon | Seguir Seção 10 - Branding |
| Nome do app "bmi_calculator" na home | Não configurou strings.xml | Seguir Seção 10.2 |

---

## **10\. Branding e Ícones (Adaptive Icons)**

### **10.1. Estrutura de Arquivos para Ícone Adaptativo (Android 8+)**

```
/android/app/src/main/res/
  /drawable/
    ic_launcher_foreground.xml  (ícone vetorial SVG-like)
  /mipmap-anydpi-v26/
    ic_launcher.xml             (referência ao adaptive icon)
    ic_launcher_round.xml       (versão redonda)
  /values/
    colors.xml                  (cor de fundo do ícone)
    strings.xml                 (nome do app)
```

### **10.2. Configuração do Nome do App (strings.xml)**

Criar `/android/app/src/main/res/values/strings.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">App Name</string>
</resources>
```

Atualizar `AndroidManifest.xml`:
```xml
<application
    android:label="@string/app_name"
    android:icon="@mipmap/ic_launcher"
    android:roundIcon="@mipmap/ic_launcher_round">
```

### **10.3. Template de Ícone Adaptativo (Foreground)**

Criar `/android/app/src/main/res/drawable/ic_launcher_foreground.xml`:

```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <group android:translateX="18" android:translateY="18">
        <!-- SEU ÍCONE AQUI (72x72 área segura) -->
    </group>
</vector>
```

### **10.4. Template de Adaptive Icon**

Criar `/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
```

### **10.5. Cores do Ícone**

Criar `/android/app/src/main/res/values/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>
```

---

## **11\. Monorepo com Melos (Escala SuperApp)**

Quando tiver múltiplos apps, migre para Melos.

### **11.1. Instalação**

```bash
dart pub global activate melos
```

### **11.2. melos.yaml na Raiz**

```yaml
name: rezende_apps
packages:
  - apps/*
  - packages/*

scripts:
  analyze:
    run: flutter analyze
    exec:
      concurrency: 1
  test:
    run: flutter test
    exec:
      concurrency: 1
  clean:
    run: flutter clean
    exec:
      concurrency: 5
  gen-l10n:
    run: flutter gen-l10n
    exec:
      concurrency: 1
```

### **11.3. Comandos Melos**

| Ação | Comando |
|------|---------|
| Bootstrap (link packages) | `melos bootstrap` |
| Rodar em todos os packages | `melos run analyze` |
| Limpar todos | `melos run clean` |

---

## **12\. Workflow Completo de Novo App (Passo a Passo)**

### **Fase 1: Criação (5 min)**

```powershell
# 1. Navegar para raiz
Set-Location -Path "C:\Users\Ernane\Personal\APPs_Flutter"

# 2. Criar app
flutter create --org sa.rezende nome_do_app

# 3. Entrar no app
Set-Location -Path ".\nome_do_app"

# 4. Remover plataformas desnecessárias
Remove-Item -Recurse -Force ios, web, linux, macos, windows
```

### **Fase 2: Estruturação (10 min)**

1. Criar pastas: `/lib/screens`, `/lib/providers`, `/lib/services`, `/lib/widgets`, `/lib/l10n`
2. Criar `l10n.yaml` na raiz
3. Criar os 11 arquivos `.arb`
4. Configurar `pubspec.yaml` (adicionar `generate: true`)
5. Executar `flutter pub get && flutter gen-l10n`

### **Fase 3: Branding (5 min)**

1. Criar `strings.xml` com nome do app
2. Criar `colors.xml` com cor de fundo do ícone
3. Criar `ic_launcher_foreground.xml` com ícone vetorial
4. Criar `ic_launcher.xml` e `ic_launcher_round.xml`
5. Atualizar `AndroidManifest.xml`

### **Fase 4: Monetização (5 min)**

1. Criar `ad_service.dart`
2. Adicionar APPLICATION_ID no `AndroidManifest.xml`
3. Adicionar `google_mobile_ads` no `pubspec.yaml`

### **Fase 5: Otimização (5 min)**

1. Configurar `build.gradle` com minify/shrink
2. Criar `proguard-rules.pro`

### **Fase 6: Validação (10 min)**

1. `flutter analyze` → Zero issues
2. `flutter test` → Todos passam
3. `flutter run -d <device>` → App funciona
4. Testar troca de idioma no dispositivo

---

## **13\. Checklist de Publicação (Play Store)**

Antes de submeter para a Play Store:

1. \[ \] Trocar IDs de teste do AdMob por IDs de produção
2. \[ \] Verificar `versionCode` e `versionName` no `build.gradle`
3. \[ \] Gerar keystore e configurar signing
4. \[ \] `flutter build appbundle --release`
5. \[ \] Testar o AAB com `bundletool`
6. \[ \] Screenshots em 11 idiomas (opcional, mas recomendado)
7. \[ \] Descrição da loja em múltiplos idiomas
8. \[ \] Política de privacidade (obrigatória para apps com ads)

---

**Fim do Protocolo Beast Mode Flutter v3.1**
*"Foco. Execução. Lucro."*