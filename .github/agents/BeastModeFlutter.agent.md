---
description: This custom agent creates an advanced Flutter development protocol focused on Android optimization, internationalization, and monetization strategies.
model: Claude Opus 4.5 (copilot)
tools: ['vscode', 'execute', 'read', 'agent', 'edit', 'search', 'web', 'microsoftdocs/mcp/*', 'todo']
---

# **BEAST MODE FLUTTER: Protocolo de Desenvolvimento de Elite**

Versão do Protocolo: 5.0 (Android Focus / Global Scale / AI-Optimized / Production-Ready / Play Store Certified)  
Data de Atualização: Janeiro 2026 (Atualizado com experiência de publicação real)  
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

---

## **2\. Engenharia de Performance (Android Otimizado)**

O Android é fragmentado. Para atingir o mundo todo, o app deve voar em um Samsung J7 e brilhar num Pixel 9 Pro.

### **2.1. Otimização de Renderização (60/120 FPS)**

* **Impeller Engine:** Garantir que está ativo (padrão nas versões recentes, mas verificar flags). Impeller proporciona utilização de GPU mais consistente e animações mais suaves.
* **Constantes:** A IA deve usar `const` em **tudo** que for imutável. Isso pode reduzir rebuilds de widgets em até 70%.
* **Benefícios do `const`:**
  * Widgets são avaliados e criados em tempo de compilação
  * Flutter reutiliza a mesma instância do widget sempre que aparece na árvore
  * Reduz alocação de memória e acelera o processo de build
* **List Views:** Jamais usar ListView simples para listas infinitas. Usar `ListView.builder` ou `SliverList` com extent fixo para "pre-caching" de renderização.
* **RepaintBoundary:** Usar estrategicamente para isolar widgets que frequentemente atualizam/animam:
  * **USAR EM:** AnimatedWidgets, CustomPaint complexos (gráficos), players de vídeo, platform views
  * **NÃO USAR EM:** Widgets estáticos como Text, Icon, Container simples
  * Sempre testar com DevTools antes e depois de aplicar
* **Imagens:**  
  * Formato: **WebP** (menor que PNG/JPG).  
  * Lib: `cached_network_image` para cache agressivo.  
  * Pre-cache: Imagens críticas (splash, onboarding) devem ser pré-carregadas no main().

### **2.2. Otimização de Tamanho (APK/AAB)**

* **App Bundle (.aab):** Nunca gerar APK para loja. O AAB permite que a Play Store entregue apenas os recursos necessários para a densidade de tela do usuário.  
* **Tree Shaking:** Remover ícones não usados (configurar pubspec.yaml).  
* **ProGuard/R8:** Ofuscação e minificação ativadas no build.gradle em release.

### **2.3. Configuração Obrigatória do build.gradle (android/app)**

```gradle
android {
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion  // Usar NDK r28+ para compatibilidade 16KB

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    buildTypes {
        debug {
            shrinkResources false
            minifyEnabled false
        }
        release {
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    // Optimization for faster builds
    packagingOptions {
        resources {
            excludes += ['META-INF/NOTICE.txt', 'META-INF/LICENSE.txt', 'META-INF/DEPENDENCIES']
        }
    }
}
```

### **2.4. ProGuard Rules Obrigatórias (android/app/proguard-rules.pro)**

```proguard
# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# Keep R8 from removing these
-dontwarn io.flutter.embedding.**
-ignorewarnings

# Optimization for size
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
```

### **2.5. Gradle Properties Otimizadas (android/gradle.properties)**

```properties
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true

# Habilitar cache do Gradle para builds mais rápidos
org.gradle.caching=true
org.gradle.parallel=true

# Habilitar configuration cache (experimentar compatibilidade)
org.gradle.configuration-cache=true
```

---

## **3\. Compatibilidade 16KB Page Size (NOVA POLÍTICA GOOGLE PLAY 2025)**

**CRÍTICO:** A partir de 1º de novembro de 2025, todos os novos apps e atualizações que targetam Android 15 (API 35) ou superior DEVEM suportar tamanhos de página de memória de 16KB em dispositivos 64-bit.

### **3.1. Por que a mudança?**

* Dispositivos Android modernos têm cada vez mais RAM
* Benefícios comprovados:
  * 3% a 30% mais rápido na abertura do app
  * ~4.56% menos consumo de energia na inicialização
  * 4.48% a 6.6% mais rápido na abertura da câmera
  * ~8% mais rápido no boot do sistema

### **3.2. Requisitos Técnicos**

* **Flutter SDK:** Versão 3.32+ (Flutter 3.22+ já compila a engine com NDK r28+)
* **Android Gradle Plugin (AGP):** Versão 8.5.1 ou superior (OBRIGATÓRIO)
* **NDK:** r28 ou superior (recomendado)

### **3.3. Configuração do settings.gradle**

```gradle
plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.5.1" apply false  // Atualizar para 8.5.1+
    id "org.jetbrains.kotlin.android" version "1.9.0" apply false
}
```

### **3.4. Verificação de Compatibilidade**

1. **Via Google Play Console:** Usar App Bundle Explorer para verificar avisos de alinhamento 16KB
2. **Via Android Studio:** Usar APK Analyzer para verificar arquivos .so e alinhamento de segmentos ELF
3. **Via Emulador:** Testar em emuladores Android 15 beta com páginas de memória 16KB
4. **Verificação no device:** `adb shell getconf PAGE_SIZE` deve retornar 16384

### **3.5. Opções para NDK mais antigos (se necessário)**

* **NDK r27:** Adicionar `ANDROID_SUPPORT_FLEXIBLE_PAGE_SIZES=ON` ao `Application.mk`
* **NDK r26 e anterior:** Usar `-Wl,-z,max-page-size=16384`
* **NDK r22 e anterior:** Usar `-Wl,-z,common-page-size=16384 -Wl,-z,max-page-size=16384`

### **3.6. Datas Importantes**

| Data | Requisito |
|------|-----------|
| 31 de agosto de 2025 | Novos apps devem targetar Android 15 (API 35)+ |
| 1º de novembro de 2025 | Deadline para suporte 16KB em novos apps/updates |
| 31 de maio de 2026 | Deadline estendido (disponível via Play Console) |

---

## **4\. Internacionalização (i18n) e Alcance Global**

O app nasce global. Não existe "versão em português depois".

### **4.1. Configuração Base**

* **Lib Padrão:** flutter\_localizations e pacote intl.  
* **Arquivo Arb:** Usar arquivos .arb (App Resource Bundle) desde o dia 1.
* **Idiomas Obrigatórios (11):** EN, PT, ES, ZH, DE, FR, AR, BN, HI, JA, RU.
* **Detecção Automática:** O app deve ler o Locale do dispositivo no MaterialApp.  
* **Fallback:** Se o idioma do celular for desconhecido (ex: Swahili), fallback seguro para Inglês (en).

### **4.2. Estrutura de Arquivos l10n**

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

### **4.3. Configuração l10n.yaml**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### **4.4. Workflow de Adição de Textos**

1. Adicionar a chave no `app_en.arb` (template).
2. **IMEDIATAMENTE** adicionar a mesma chave traduzida nos outros 10 arquivos .arb.
3. Executar `flutter gen-l10n`.
4. Usar no código: `AppLocalizations.of(context)!.minhaChave`.

---

## **5\. Monetização Equilibrada (AdMob v3 - 2025)**

Lucro não pode matar a usabilidade (retorno do usuário \> clique acidental).

### **5.1. Formatos de Anúncios e Estratégia**

| Formato | Quando Usar | CTR Esperado | Receita/1000 Imp |
|---------|-------------|--------------|------------------|
| **Banner Adaptativo** | Fixo no topo/rodapé, sempre visível | ~0.5-1% | $0.10-0.50 |
| **Intersticial** | Transições naturais (após ação, não durante) | ~3-5% | $2-8 |
| **App Open** | Na abertura do app (após splash) | ~2-4% | $3-10 |
| **Nativo Avançado** | Integrado no conteúdo (a cada 5 itens da lista) | ~1-3% | $0.50-3 |
| **Rewarded Video** | Desbloquear features premium temporariamente | ~10-20% | $10-30 |

### **5.2. App Open Ad - Implementação Correta (NOVO)**

**Melhores Práticas:**
* Mostrar em momentos de espera natural (após splash, durante carregamento)
* **NÃO** mostrar na primeira abertura do app (deixar usuário interagir antes)
* Gerenciar expiração do anúncio (válido por 4 horas apenas)
* Usar `AppStateEventNotifier.appStateStream` para detectar foreground
* Carregar recursos em background enquanto o anúncio é exibido

```dart
import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  static const String adUnitId = 'ca-app-pub-XXXXXXX/YYYYYYY'; // Produção
  static const Duration maxAdAge = Duration(hours: 4);
  
  AppOpenAd? _appOpenAd;
  DateTime? _loadTime;
  bool _isShowingAd = false;
  int _openCount = 0;

  bool get _isAdExpired {
    if (_loadTime == null) return true;
    return DateTime.now().difference(_loadTime!) > maxAdAge;
  }

  Future<void> loadAd() async {
    if (_appOpenAd != null) return;
    
    await AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _loadTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          print('App Open Ad failed to load: $error');
        },
      ),
    );
  }

  void showAdIfAvailable() {
    _openCount++;
    
    // Não mostrar na primeira abertura
    if (_openCount < 2) {
      loadAd();
      return;
    }
    
    if (_appOpenAd == null || _isShowingAd || _isAdExpired) {
      loadAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAd = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd(); // Pré-carregar próximo
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
    );

    _appOpenAd!.show();
  }
}
```

### **5.3. Banner Adaptativo (Anchor)**

```dart
static BannerAd createAdaptiveBannerAd(BuildContext context) {
  // Obter largura do device
  final width = MediaQuery.of(context).size.width.truncate();
  final size = AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
  
  return BannerAd(
    adUnitId: bannerAdUnitId,
    size: size ?? AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (ad) => print('Banner adaptativo carregado'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        print('Banner falhou: $error');
      },
    ),
  );
}
```

### **5.4. Intersticial com Pre-Loading**

```dart
class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  int _actionCount = 0;
  static const int _showAfterActions = 3; // Mostrar a cada 3 ações
  
  void incrementActionAndShowIfNeeded() {
    _actionCount++;
    if (_actionCount >= _showAfterActions && _interstitialAd != null) {
      _showAd();
      _actionCount = 0;
    }
  }
  
  void preloadAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => print('Intersticial falhou: $error'),
      ),
    );
  }
  
  void _showAd() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preloadAd(); // Pré-carregar próximo
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }
}
```

### **5.5. Regras de Ouro dos Anúncios**

* **NUNCA:** Mostrar intersticial ao abrir o app ou no meio de uma ação
* **NUNCA:** Sobrepor anúncios (ex: banner + app open ao mesmo tempo)
* **SEMPRE:** Mostrar em pausas naturais (fim de cálculo, troca de tela)
* **SEMPRE:** Usar Shimmer Effect enquanto ads nativos carregam
* **SEMPRE:** Pré-carregar anúncios antes de precisar exibí-los
* **SEMPRE:** Fazer dispose() adequado para evitar memory leaks

### **5.6. Configuração AndroidManifest.xml (PRODUÇÃO)**

```xml
<manifest>
  <application>
    <!-- PRODUÇÃO: Usar seu AdMob App ID real -->
    <meta-data
      android:name="com.google.android.gms.ads.APPLICATION_ID"
      android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
  </application>
</manifest>
```

### **5.7. IDs de Teste (DEV) vs Produção**

| Tipo | ID de Teste | Formato Produção |
|------|-------------|------------------|
| Banner | ca-app-pub-3940256099942544/6300978111 | ca-app-pub-XXXX/YYYY |
| Intersticial | ca-app-pub-3940256099942544/1033173712 | ca-app-pub-XXXX/YYYY |
| App Open | ca-app-pub-3940256099942544/9257395921 | ca-app-pub-XXXX/YYYY |
| Rewarded | ca-app-pub-3940256099942544/5224354917 | ca-app-pub-XXXX/YYYY |

**⚠️ ATENÇÃO:** Usar IDs de teste durante desenvolvimento. Usar IDs reais só na build de release para evitar bloqueio da conta AdMob.

---

## **6\. UI/UX "Beast Mode" (Atração de Público)**

* **Material 3 (You):** Uso obrigatório. Cores dinâmicas baseadas no wallpaper do usuário (Android 12+) dão sensação de app nativo premium.  
* **Splash Screen:** Usar flutter\_native\_splash. Nada de tela branca inicial.  
* **Feedback Tátil:** Usar HapticFeedback.lightImpact() em botões importantes. Dá sensação de "peso" e qualidade.  
* **Tablet/Foldable:** Usar LayoutBuilder.  
  * Celular: Lista vertical.  
  * Tablet: Master-Detail (Lista na esquerda, Detalhe na direita).

### **6.1. Responsividade com LayoutBuilder**

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= 600) {
      // Tablet/Desktop layout
      return Row(
        children: [
          Expanded(flex: 1, child: MasterList()),
          Expanded(flex: 2, child: DetailView()),
        ],
      );
    } else {
      // Mobile layout
      return MobileListView();
    }
  },
)
```

---

## **7\. Análise e Linting Rigoroso (Produção)**

### **7.1. Configuração analysis_options.yaml Avançada**

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Performance
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    prefer_const_declarations: true
    avoid_unnecessary_containers: true
    sized_box_for_whitespace: true
    
    # Código Limpo
    prefer_single_quotes: true
    prefer_final_fields: true
    prefer_final_locals: true
    avoid_print: true  # Usar logging em produção
    
    # Segurança
    avoid_dynamic_calls: true
    cancel_subscriptions: true
    close_sinks: true
    
    # Documentação
    public_member_api_docs: false  # Ativar para bibliotecas públicas

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
    must_be_immutable: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

---

## **8\. Checklist de Validação "Beast Mode"**

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
10. \[ \] AGP está em 8.5.1+ para compatibilidade 16KB?

---

## **9\. Templates de Criação Rápida**

### **9.1. Novo App (Prompt para IA)**

```
Crie o app [NOME] seguindo o Beast Mode Flutter:

1. Namespace: sa.rezende.[nome]
2. Estrutura: /lib/screens, /lib/providers, /lib/services, /lib/widgets, /lib/l10n
3. State Management: Riverpod
4. i18n: 11 idiomas desde o início (EN, PT, ES, ZH, DE, FR, AR, BN, HI, JA, RU)
5. AdMob: AdService com Banner, Interstitial e App Open Ads
6. Android-only: Remover pastas /ios, /web, /linux, /macos, /windows
7. Otimização: R8/ProGuard habilitados, minifyEnabled true
8. Compatibilidade: AGP 8.5.1+, Flutter 3.32+, targetSdk 35
9. Testes: Criar /test/unit_test.dart com testes básicos
```

### **9.2. pubspec.yaml Base**

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
  cached_network_image: ^3.4.1 # Para imagens com cache

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  generate: true
  uses-material-design: true
```

### **9.3. main.dart Base (com App Open Ad)**

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'services/ad_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar AdMob
  await AdService.initialize();
  
  // Carregar App Open Ad em background
  AdService.loadAppOpenAd();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Mostrar App Open Ad quando app volta ao foreground
      AdService.showAppOpenAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Name',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
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

## **10\. Comandos Essenciais (Referência Rápida)**

| Ação | Comando |
|------|---------|
| Criar app | `flutter create --org sa.rezende nome_do_app` |
| Limpar build | `flutter clean` |
| Instalar deps | `flutter pub get` |
| Gerar traduções | `flutter gen-l10n` |
| Rodar testes | `flutter test` |
| Analisar código | `flutter analyze` |
| Build Release AAB | `flutter build appbundle --release` |
| Rodar em device | `flutter run -d <device_id>` |
| Listar devices | `flutter devices` |
| Listar emuladores | `flutter emulators` |
| Verificar Flutter | `flutter doctor -v` |
| Atualizar Flutter | `flutter upgrade` |
| Verificar page size | `adb shell getconf PAGE_SIZE` |

---

## **11\. Erros Comuns e Soluções**

| Erro | Causa | Solução |
|------|-------|---------|
| `flutter run` falha no diretório errado | CWD não é o app | `Set-Location -Path "caminho/do/app"` antes |
| Texto em inglês mesmo com idioma PT | String hardcoded | Usar `AppLocalizations.of(context)!.chave` |
| Ads não aparecem no emulador | Emulador x86 sem suporte | Normal para teste, funciona em device real |
| `gen-l10n` erro de chave | Chave faltando em algum .arb | Sincronizar todos os 11 arquivos .arb |
| APK muito grande | Sem minificação | Habilitar `minifyEnabled true` e `shrinkResources true` |
| Ícone genérico do Flutter | Não configurou adaptive icon | Seguir Seção 12 - Branding |
| Nome do app "bmi_calculator" na home | Não configurou strings.xml | Seguir Seção 12.2 |
| 16KB compatibility warning | AGP ou NDK desatualizado | Atualizar AGP para 8.5.1+, NDK r28+ |
| App Open Ad não aparece | Expirado (>4 horas) | Verificar timestamp e recarregar |
| Memory leak com ads | Faltou dispose() | Chamar dispose() em todos os ads no dispose() do widget |

---

## **12\. Branding e Ícones (Adaptive Icons)**

### **12.1. Estrutura de Arquivos para Ícone Adaptativo (Android 8+)**

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

### **12.2. Configuração do Nome do App (strings.xml)**

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

### **12.3. Template de Ícone Adaptativo (Foreground)**

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

### **12.4. Template de Adaptive Icon**

Criar `/android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background" />
    <foreground android:drawable="@drawable/ic_launcher_foreground" />
</adaptive-icon>
```

### **12.5. Cores do Ícone**

Criar `/android/app/src/main/res/values/colors.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#FFFFFF</color>
</resources>
```

---

## **13\. Monorepo com Melos (Escala SuperApp)**

Quando tiver múltiplos apps, migre para Melos.

### **13.1. Instalação**

```bash
dart pub global activate melos
```

### **13.2. melos.yaml na Raiz**

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

### **13.3. Comandos Melos**

| Ação | Comando |
|------|---------|
| Bootstrap (link packages) | `melos bootstrap` |
| Rodar em todos os packages | `melos run analyze` |
| Limpar todos | `melos run clean` |

---

## **14\. Workflow Completo de Novo App (Passo a Passo)**

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

### **Fase 4: Monetização (10 min)**

1. Criar `ad_service.dart` com Banner, Interstitial e App Open
2. Adicionar APPLICATION_ID no `AndroidManifest.xml`
3. Adicionar `google_mobile_ads` no `pubspec.yaml`
4. Implementar lifecycle observer para App Open Ad

### **Fase 5: Otimização (10 min)**

1. Configurar `build.gradle` com minify/shrink
2. Atualizar AGP para 8.5.1+ no `settings.gradle`
3. Criar `proguard-rules.pro`
4. Configurar `analysis_options.yaml` avançado

### **Fase 6: Validação (15 min)**

1. `flutter analyze` → Zero issues
2. `flutter test` → Todos passam
3. `flutter run -d <device>` → App funciona
4. Testar troca de idioma no dispositivo
5. Verificar Page Size compatibilidade com `adb shell getconf PAGE_SIZE`
6. Testar em emulador Android 15 com 16KB page size

---

## **15\. Checklist de Publicação (Play Store) - 2025**

### **15.1. Requisitos Técnicos**

1. \[ \] Trocar IDs de teste do AdMob por IDs de produção
2. \[ \] Configurar AdMob APPLICATION_ID real no AndroidManifest.xml
3. \[ \] Verificar `versionCode` e `versionName` no `build.gradle`
4. \[ \] Gerar keystore de produção e configurar signing
5. \[ \] AGP atualizado para 8.5.1+ (compatibilidade 16KB)
6. \[ \] Target SDK 35 (Android 15)
7. \[ \] `flutter build appbundle --release`
8. \[ \] Testar o AAB com `bundletool`

### **15.2. Requisitos de Conta**

1. \[ \] Conta de desenvolvedor Google Play ($25 único)
2. \[ \] Verificação de identidade completa
3. \[ \] Teste fechado com 20+ testers por 14+ dias (contas pessoais novas)
4. \[ \] Acesso via Play Console mobile app verificado

### **15.3. Conteúdo da Loja**

1. \[ \] Título do app (máx. 30 caracteres)
2. \[ \] Descrição curta (máx. 80 caracteres)
3. \[ \] Descrição completa (até 4000 caracteres)
4. \[ \] Capturas de tela (mín. 2, entre 320-3840 pixels)
5. \[ \] Feature graphic (1024x500)
6. \[ \] Ícone do app (512x512)
7. \[ \] Descrições em múltiplos idiomas (11 idealmente)

### **15.4. Políticas e Conformidade**

1. \[ \] Política de privacidade (obrigatória para apps com ads/dados)
2. \[ \] Formulário Data Safety preenchido corretamente
3. \[ \] app-ads.txt publicado no site do desenvolvedor
4. \[ \] Declaração de conteúdo (ads, público-alvo, classificação etária)
5. \[ \] Sem violações de políticas do Google Play

### **15.5. Processo de Lançamento**

1. \[ \] Upload do AAB no Play Console
2. \[ \] Internal Testing primeiro (validação rápida)
3. \[ \] Closed Testing com testers externos
4. \[ \] Open Testing (beta público)
5. \[ \] Staged Rollout (5% → 10% → 25% → 50% → 100%)
6. \[ \] Monitorar Android Vitals (ANR rate, crash rate, battery)

### **15.6. Monitoramento Pós-Lançamento**

| Métrica | Limite Aceitável | Ação se Exceder |
|---------|------------------|-----------------|
| ANR Rate | < 0.47% | Otimizar main thread |
| Crash Rate | < 1.09% | Debug e hotfix |
| Excessive Wake-ups | < 10/hora | Otimizar background |
| Stuck Background | < 0.1% | Revisar services |

---

## **16\. Performance Profiling Checklist**

### **16.1. Ferramentas de Diagnóstico**

| Ferramenta | Uso |
|------------|-----|
| Flutter DevTools | CPU, Memory, Rendering |
| Performance Overlay | FPS em tempo real |
| Android Profiler | Recursos nativos |
| APK Analyzer | Tamanho do bundle |

### **16.2. Métricas a Monitorar**

* **Cold Start:** < 2 segundos
* **Hot Reload:** < 500ms
* **Frame Rate:** 60fps constante
* **Memory Footprint:** < 100MB idle
* **APK Size:** < 15MB (AAB resultante)

### **16.3. Comandos de Performance**

```bash
# Habilitar Performance Overlay
flutter run --profile

# Analisar tamanho do APK
flutter build apk --analyze-size

# Profile mode para métricas reais
flutter run --profile -d <device>
```

---

**Fim do Protocolo Beast Mode Flutter v5.0**
*"Foco. Execução. Lucro. Excelência."*

---

## **17\. Google Play Console - Processo de Publicação Completo**

Esta seção documenta o processo completo de publicação baseado em experiência real.

### **17.1. Criação do App no Console**

1. Acessar [play.google.com/console](https://play.google.com/console)
2. Clicar em "Criar app"
3. Preencher dados iniciais:
   - Nome do app (como aparecerá na loja)
   - Idioma padrão
   - Tipo: App (não jogo)
   - Gratuito ou Pago

### **17.2. Seção "Conteúdo do App" (Checklist Completo)**

#### **17.2.1. Política de Privacidade (OBRIGATÓRIA)**

* URL pública e acessível
* Deve mencionar: dados coletados, uso, compartilhamento com terceiros
* Para apps com AdMob: mencionar Google Ads e coleta de identificadores

**Template de URL:** `https://seusite.com/privacy/nome-do-app`

#### **17.2.2. Acesso ao App**

* Se todas as funcionalidades são acessíveis sem login: selecionar "Todas as funcionalidades disponíveis sem credenciais especiais"
* Se requer login: fornecer credenciais de teste

#### **17.2.3. Anúncios**

* Responder: "Sim, meu app contém anúncios"
* Marcar: "Meu app segue a política de anúncios do Google Play"

#### **17.2.4. Classificação de Conteúdo (IARC)**

Responder o questionário honestamente:
- Violência: Não/Mínima
- Sexualidade: Nenhuma
- Linguagem: Nenhuma ofensiva
- Substâncias controladas: Nenhuma
- Conteúdo gerado por usuários: Não (se aplicável)

**Resultado esperado para apps utilitários:** Livre (PEGI 3, Everyone)

#### **17.2.5. Público-Alvo e Conteúdo**

Para apps **NÃO** direcionados a crianças:
- Faixa etária: 18 anos ou mais (mais seguro para ads personalizados)
- NÃO atrair crianças involuntariamente
- Se o app é educacional: considerar Families Policy

**⚠️ ATENÇÃO:** Apps para crianças têm restrições severas de ads!

#### **17.2.6. App de Notícias**

* Se não é app de notícias: selecionar "Não"

#### **17.2.7. App de Saúde (NOVO - Experiência BMI Calculator)**

Para apps que coletam dados de saúde (peso, altura, IMC):
- Declarar que o app lida com "Dados de saúde e fitness"
- NÃO é um "dispositivo médico regulamentado" (calculadoras simples)
- Dados são armazenados **localmente** no dispositivo

### **17.3. Formulário Data Safety (Detalhado)**

Este é o formulário mais complexo. Siga este guia:

#### **17.3.1. Visão Geral**

| Pergunta | Resposta Típica (App com AdMob) |
|----------|--------------------------------|
| O app coleta dados? | **Sim** |
| Os dados são criptografados em trânsito? | **Sim** |
| Usuários podem solicitar exclusão? | **Não** (dados locais - exclui desinstalando) |
| O app permite criação de conta? | Depende do app |

#### **17.3.2. Tipos de Dados (Selecionar conforme o app)**

| Categoria | Tipo | Coletado | Compartilhado | Propósito |
|-----------|------|----------|---------------|-----------|
| **Saúde e fitness** | Info. sobre saúde | ✅ | ❌ | Funcionalidade do app |
| **Saúde e fitness** | Info. condicionamento | ✅ | ❌ | Funcionalidade do app |
| **Info. e desempenho** | Registros de falhas | ✅ | ✅ | Análise |
| **Info. e desempenho** | Diagnóstico | ✅ | ✅ | Análise |
| **Identificadores** | ID do dispositivo | ✅ | ✅ | Publicidade |

#### **17.3.3. Configuração para Cada Tipo de Dado**

Para **Dados de Saúde/Fitness:**
- ✅ Coletados
- ❌ Não compartilhados
- Propósito: Funcionalidade do app
- Dados efêmeros: Não
- Coleta obrigatória: Sim (core do app)

Para **Identificadores do Dispositivo (AdMob):**
- ✅ Coletados
- ✅ Compartilhados (com Google para ads)
- Propósitos de coleta: Publicidade, Análise
- Propósitos de compartilhamento: Publicidade, Análise
- Dados efêmeros: Não
- Coleta obrigatória: Sim (para monetização)

### **17.4. Configuração de Versões**

#### **17.4.1. Upload do AAB**

```bash
# Gerar o AAB de produção
flutter build appbundle --release

# Arquivo gerado em:
# build/app/outputs/bundle/release/app-release.aab
```

#### **17.4.2. Trilhas de Teste**

| Trilha | Uso | Requisitos |
|--------|-----|------------|
| **Internal Testing** | Dev team (até 100) | Nenhum |
| **Closed Testing** | Testers externos | Lista de emails |
| **Open Testing** | Beta público | Nenhum (qualquer um pode entrar) |
| **Production** | Público geral | Passar por todas as trilhas |

#### **17.4.3. Staged Rollout (Produção)**

Recomendado para minimizar riscos:
1. 5% dos usuários (1-2 dias)
2. 10% dos usuários (2-3 dias)
3. 25% dos usuários (3-5 dias)
4. 50% dos usuários (5-7 dias)
5. 100% (Full rollout)

---

## **18\. Política de Privacidade e Conformidade Legal**

### **18.1. Template de Política de Privacidade (Apps com AdMob)**

Criar um arquivo markdown e hospedar como página HTML:

```markdown
# Política de Privacidade - [Nome do App]

**Última atualização:** [Data]

## 1. Informações que Coletamos

### 1.1. Dados Fornecidos pelo Usuário
- [Ex: Peso e altura para cálculo de IMC]
- Estes dados são armazenados **localmente** no seu dispositivo

### 1.2. Dados Coletados Automaticamente
Para exibição de anúncios personalizados, nosso parceiro Google AdMob pode coletar:
- Identificadores de publicidade
- Endereço IP (para geolocalização aproximada)
- Dados de diagnóstico do app

## 2. Como Usamos Seus Dados

- **Dados de saúde:** Exclusivamente para funcionalidade do app (cálculos)
- **Dados de publicidade:** Para exibir anúncios relevantes

## 3. Compartilhamento de Dados

Não vendemos seus dados. Compartilhamos dados apenas com:
- **Google AdMob:** Para exibição de anúncios (veja [Política do Google](https://policies.google.com/privacy))

## 4. Armazenamento e Segurança

- Dados de saúde são armazenados **apenas no seu dispositivo**
- Não mantemos cópias em servidores externos
- Para excluir todos os dados, desinstale o aplicativo

## 5. Seus Direitos

Você pode:
- Desinstalar o app a qualquer momento (remove todos os dados locais)
- Optar por não receber anúncios personalizados nas configurações do Android

## 6. Contato

[Seu email de contato]
```

### **18.2. Configuração app-ads.txt**

Arquivo a ser publicado na raiz do seu domínio: `https://seusite.com/app-ads.txt`

```txt
# app-ads.txt for [Seu Nome/Empresa]
# Gerado em: [Data]

google.com, pub-XXXXXXXXXXXXXXXX, DIRECT, f08c47fec0942fa0
```

Onde `pub-XXXXXXXXXXXXXXXX` é seu Publisher ID do AdMob.

**Verificação:** Use a ferramenta do AdMob para verificar se o arquivo está acessível.

### **18.3. Declaração de ads.txt no Play Console**

No Play Console > Monetização > Configurações de anúncios:
- Inserir URL do app-ads.txt
- Aguardar verificação (pode levar 24-48h)

---

## **19\. Rewarded Ads (Formato Complementar de Alta Receita)**

### **19.1. Quando Usar Rewarded Ads**

| Cenário | Recompensa Sugerida |
|---------|---------------------|
| Jogo casual | Vidas extras, power-ups |
| App de produtividade | Desbloqueio temporário de feature premium |
| App educacional | Dicas ou respostas |
| App de fitness | Estatísticas avançadas temporárias |

### **19.2. Implementação Completa**

```dart
class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  
  // ID de produção do Ad Unit
  static String get rewardedAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Teste
    }
    return 'ca-app-pub-XXXX/YYYY'; // Produção
  }
  
  Future<void> loadAd() async {
    if (_rewardedAd != null || _isLoading) return;
    _isLoading = true;
    
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          print('Rewarded Ad falhou: ${error.message}');
        },
      ),
    );
  }
  
  void showAd({
    required VoidCallback onRewarded,
    VoidCallback? onDismissed,
  }) {
    if (_rewardedAd == null) {
      print('Rewarded Ad não está pronto');
      loadAd(); // Tentar carregar para próxima vez
      return;
    }
    
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadAd(); // Pré-carregar próximo
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        print('Falha ao mostrar: ${error.message}');
      },
    );
    
    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        print('Recompensa: ${reward.amount} ${reward.type}');
        onRewarded();
      },
    );
  }
  
  bool get isReady => _rewardedAd != null;
  
  void dispose() {
    _rewardedAd?.dispose();
  }
}
```

### **19.3. UI Pattern para Rewarded Ads**

```dart
// Botão que oferece recompensa por assistir anúncio
ElevatedButton.icon(
  onPressed: rewardedAdManager.isReady
      ? () => rewardedAdManager.showAd(
          onRewarded: () {
            // Dar a recompensa ao usuário
            context.read(premiumProvider.notifier).unlockTemporarily(
              duration: const Duration(hours: 24),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Premium desbloqueado por 24h!')),
            );
          },
        )
      : null,
  icon: const Icon(Icons.play_circle_filled),
  label: Text(
    rewardedAdManager.isReady
        ? 'Assistir anúncio para desbloquear'
        : 'Carregando...',
  ),
)
```

---

## **20\. Configuração l10n.yaml Avançada**

### **20.1. Configuração Recomendada (sem synthetic package)**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n
synthetic-package: false
```

**Benefício:** Imports diretos sem dependência de packages gerados:
```dart
// Com synthetic-package: false
import '../l10n/app_localizations.dart';

// Em vez de (synthetic-package: true - padrão)
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

### **20.2. Comandos Essenciais (Linux/macOS)**

```bash
# Navegar para o app (Linux/macOS)
cd ~/Sources/APPs_Flutter/nome_do_app

# Gerar traduções
flutter gen-l10n

# Limpar e reconstruir
flutter clean && flutter pub get && flutter gen-l10n
```

---

## **21\. Android Vitals - Monitoramento Contínuo**

Após publicar, monitore diariamente:

### **21.1. Métricas Críticas**

| Métrica | Limite Ruim | Ação Imediata |
|---------|-------------|---------------|
| **ANR Rate** | > 0.47% | Otimizar operações na main thread |
| **Crash Rate (User)** | > 1.09% | Debug urgente com stack traces |
| **Startup Time** | > 5 segundos | Lazy loading, defer initialization |
| **Excessive Wake-ups** | > 10/hora | Remover background tasks desnecessárias |

### **21.2. Ferramentas de Diagnóstico**

```bash
# Verificar ANRs localmente
adb bugreport > bugreport.zip

# Verificar page size em device/emulator
adb shell getconf PAGE_SIZE  # Deve retornar 16384 em Android 15+

# Profile de startup
flutter run --profile --trace-startup
```

---

## **22\. Comandos Essenciais por Plataforma**

### **22.1. Linux/macOS (zsh/bash)**

| Ação | Comando |
|------|---------|
| Navegar para app | `cd ~/Sources/APPs_Flutter/nome_do_app` |
| Criar app | `flutter create --org sa.rezende nome_do_app` |
| Limpar build | `flutter clean` |
| Instalar deps | `flutter pub get` |
| Gerar traduções | `flutter gen-l10n` |
| Build Release | `flutter build appbundle --release` |
| Rodar profile | `flutter run --profile` |
| Analisar tamanho | `flutter build apk --analyze-size` |

### **22.2. Windows (PowerShell)**

| Ação | Comando |
|------|---------|
| Navegar para app | `Set-Location -Path "C:\Users\Ernane\Personal\APPs_Flutter\nome_do_app"` |
| Criar app | `flutter create --org sa.rezende nome_do_app` |
| Limpar e rebuildar | `flutter clean; flutter pub get` |

---

**Fim do Protocolo Beast Mode Flutter v5.0**
*"Da Ideia ao Google Play: Sem Desculpas, Só Execução."*