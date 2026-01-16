---
applyTo: '**'
---
# **Plano de Arquitetura: Do App Simples ao SuperApp (Modular)**

Versão: 6.3 | Janeiro 2026 | **Factory Mode** + Clean Architecture + Melos Monorepo + Lições de publicação real + padrões de gamificação + workflow otimizado + otimização de performance + teste funcional de UI + workflow de assets + crop 9:16 obrigatório + validação i18n automatizada + traduções de Store Listing obrigatórias + **Política de Privacidade via Google Sites** + **Script de Validação Automatizada**

---

### **📋 Changelog v6.3**
- ✨ **NOVO:** Mapa de Rejeições Comuns (Top 10 causas e soluções)
- ✨ **NOVO:** Script PowerShell `validate_publication.ps1` para validação completa
- ✨ **NOVO:** Template HTML de Privacy Policy reutilizável
- ✨ **NOVO:** Verificação automática de aspect ratio em screenshots
- 🔧 **AUTOMAÇÃO:** Zero trabalho manual repetitivo na validação

### **📋 Changelog v6.2**
- ✨ **NOVO:** Política de Privacidade via Google Sites (workflow completo)
- ✨ **NOVO:** Padrão de nomenclatura URLs: `sarezende-<app>-privacy`
- ✨ **NOVO:** Verificação obrigatória de URL antes de publicação
- ✨ **NOVO:** Troubleshooting de rejeição por política inválida
- 🔧 **LIÇÃO BMI Calculator:** URL 404 = rejeição imediata do Google Play

### **📋 Changelog v6.1**
- ✨ **NOVO:** Templates para Health/Wellness Apps (FastingSession, MetabolicStage)
- ✨ **NOVO:** NotificationService pattern com flutter_local_notifications
- ✨ **NOVO:** Repository Pattern completo (interface + implementação)
- ✨ **NOVO:** Workflow de criação paralela por lotes
- ✨ **NOVO:** Entity patterns com estados baseados em tempo
- 🔧 **LIÇÃO:** `create_file` falha em arquivos existentes → usar `replace_string_in_file`
- 🔧 **LIÇÃO:** Criar i18n dos 11 idiomas simultaneamente para evitar dessincronização

### **📋 Changelog v6.0**
- ✨ **NOVO:** Clean Architecture obrigatória (Domain/Data/Presentation)
- ✨ **NOVO:** Configuração Melos para monorepo
- ✨ **NOVO:** Integration Tests para screenshots automatizados
- ✨ **NOVO:** Feature-first modularization patterns
- 🔧 **ATUALIZADO:** Estrutura de pastas com camadas Clean Architecture
- 🔧 **ATUALIZADO:** Stack tecnológica 2026

---

Para cumprir o requisito de criar apps individuais que depois serão agregados, NÃO podemos usar uma estrutura monolítica comum (lib/main.dart cheio de tudo).

Utilizaremos uma **Arquitetura Modular Baseada em Packages com Clean Architecture**.

## **1\. Estrutura de Pastas (O Segredo)**

Mesmo para o primeiro app simples, a estrutura deve ser pensada como um monorepo **com Clean Architecture**.

```
/root_project  
  /apps (ou diretório raiz para apps individuais)
     /bmi_calculator (sa.rezende.bmi_calculator)  
     /pomodoro_timer (sa.rezende.pomodoro_timer)
     /todo_app (sa.rezende.todo)  
     /super_app (sa.rezende.superapp)  
  /packages (Módulos Reutilizáveis)  
     /core_ui (Design System: Cores, Tipografia, Botões Padrão)  
     /core_logic (Auth, Gerenciamento de Estado Base, Networking)  
     /feature_ads (Lógica centralizada do AdMob - MUITO IMPORTANTE)  
     /feature_i18n (Traduções compartilhadas)
     /feature_privacy (Consentimento UE/EEA/UK via UMP + entrypoint de opções)
     /feature_gamification (Streaks, Achievements, Daily Goals)  
  /DadosPublicacao (Chaves, certificados, assets de loja por app)
     /<app_name>/keys/
     /<app_name>/store_assets/
     /<app_name>/policies/
     /<app_name>/play_console/ (backups das respostas: Data Safety, ads, notas)
  /tools (Scripts de validação)
     check_l10n.ps1
     check_store_assets.ps1
  melos.yaml (NOVO - Configuração do monorepo)
```

## **1.1. Clean Architecture por App (NOVO v6.0)**

Cada app deve seguir a estrutura de **3 camadas**:

```
/lib
  /domain (PURA - Dart puro, sem dependências externas)
    /entities        # Classes de domínio (BMIResult, TimerSession)
    /repositories    # Interfaces abstratas (abstract class IBMIRepository)
    /usecases        # Lógica de negócio (CalculateBMIUseCase)
  
  /data (ADAPTADORES - Implementações concretas)
    /repositories    # Implementações (BMIRepositoryImpl)
    /datasources     # SharedPreferences, APIs, etc.
    /models          # DTOs com toJson/fromJson
  
  /presentation (UI - Flutter-specific)
    /providers       # Riverpod providers
    /screens         # Telas completas
    /widgets         # Componentes reutilizáveis
    /state           # StateNotifiers se necessário
  
  /services          # Services cross-cutting (AdService, ConsentService)
  /l10n              # Arquivos .arb de tradução
  main.dart
```

### **Regras de Dependência (CRÍTICO)**
```
presentation → domain ✅
presentation → data ✅
data → domain ✅
domain → NADA (puro Dart) ✅
domain → data ❌ PROIBIDO
domain → presentation ❌ PROIBIDO
```

## **1.2. Configuração Melos (NOVO v6.0)**

Criar `melos.yaml` na raiz do workspace:

```yaml
name: superapp_workspace
repository: https://github.com/usuario/superapp

packages:
  - apps/*
  - packages/*

command:
  bootstrap:
    usePubspecOverrides: true

scripts:
  analyze:
    run: melos exec -- flutter analyze
    description: Run flutter analyze in all packages

  test:
    run: melos exec -- flutter test
    description: Run flutter test in all packages

  gen-l10n:
    run: melos exec -- flutter gen-l10n
    description: Generate localizations in all packages

  build:
    run: melos exec --scope="apps/*" -- flutter build appbundle --release
    description: Build release AAB for all apps

  clean:
    run: melos exec -- flutter clean
    description: Clean all packages
```

### **Comandos Melos**
```powershell
# Instalar Melos globalmente
dart pub global activate melos

# Bootstrap (pub get em todos os packages)
melos bootstrap

# Rodar análise em todos os packages
melos analyze

# Rodar testes em todos os packages
melos test
```

## **2\. Benefícios desta Estrutura**

1. **Uniformidade Visual:** Todos os apps consomem o pacote core\_ui. Se você mudar a cor primária no core\_ui, todos os apps atualizam. Isso garante a coesão visual exigida.  
2. **Lógica de Ads Centralizada:** O pacote feature\_ads controla os IDs dos blocos de anúncios. Você configura a lógica de "Native Ad" uma vez e replica em todos os apps.  
3. **Migração Zero:** Quando for criar o SuperApp, você apenas adiciona as dependências dos apps individuais (que estarão modularizados) dentro dele.
4. **Dados de Publicação Organizados:** Keystores, assets e políticas ficam versionados e organizados por app.
5. **Gamificação Reutilizável:** Streaks, Achievements, Daily Goals podem ser compartilhados entre apps.

## **3\. Stack Tecnológica Recomendada (2025-2026)**

| Categoria | Tecnologia | Justificativa |
|-----------|------------|---------------|
| **Gerência de Estado** | Riverpod 2.x | Mais testável e modular que Bloc |
| **Navegação** | GoRouter | Deep Linking essencial para SuperApp |
| **Banco Local** | SharedPreferences / Hive | Persistência simples e rápida |
| **Áudio** | audioplayers ^6.4.0 | Para ambient sounds e feedback sonoro |
| **Notificações** | flutter_local_notifications ^18.0.1 | Lembretes e alertas locais |
| **Ads** | google_mobile_ads 5.3+ | Banner, Interstitial, App Open |
| **Consent (UE/EEA/UK)** | UMP via google_mobile_ads | GDPR: consent-first + privacy options |
| **Build** | AGP 8.5.1+ | Compatibilidade 16KB page size |

## **4\. O Agente de IA e a Geração de Código**

Quando você solicitar à IA para criar um app, use este prompt de arquitetura:

```
Crie o app [NOME] dentro da estrutura modular.

1. Use o package core_ui para os widgets visuais (se existir).  
2. Implemente a lógica de negócio isolada (sem dependência direta da UI).  
3. Configure o AdMob usando o feature_ads (ou crie lib/services/ad_service.dart).
4. Configure ConsentService para GDPR (lib/services/consent_service.dart).
5. Namespace: sa.rezende.[nome].  
6. Crie os arquivos .arb para os 11 idiomas imediatamente.
7. Configure AGP 8.5.1+ no settings.gradle.
8. Remova pastas desnecessárias (/ios, /web, /linux, /macos, /windows).
9. Implemente features de engagement: Streak Counter, Achievements, Daily Goals.
10. Use multi_replace_string_in_file para editar múltiplos .arb simultaneamente.
```

## **5\. Cronograma de Execução (Beast Mode)**

### **Fase A: Fundação (1-2 Dias)**

* Configurar o Monorepo (Melos é recomendado para gerenciar os pacotes).  
* Criar packages/core\_ui (Tema, Cores, Componentes Básicos).  
* Criar packages/feature\_ads (Helper de AdMob).
* Criar packages/feature\_gamification (Streaks, Achievements).
* Configurar ambiente Android (Flutter SDK, Android SDK, Emulador com GPU).

### **Fase B: Fábrica de Apps (Contínuo)**

* Desenvolver App 1 (ex: BMI Calculator). Validar. Publicar.  
* Desenvolver App 2 (ex: Pomodoro Timer). Validar. Publicar.
* Desenvolver App 3 (ex: Todo App). Validar. Publicar.
* *Nota:* Graças à Fase A, cada novo app já nasce com design, ads e gamificação configurados.

### **Fase C: A Fusão (Futuro)**

* Criar o projeto super\_app.  
* Importar as lógicas dos Apps individuais como "Features".  
* Criar uma "Home" unificadora que navega para essas features.

## **6\. Ambiente de Desenvolvimento (NOVO)**

### **6.1. Configuração do Emulador Android**

Para desenvolvimento eficiente, configure o emulador com:

```
# AVD config.ini
hw.gpu.enabled=yes
hw.gpu.mode=host
hw.ramSize=4096
```

Comando de inicialização otimizado:
```powershell
emulator -avd <AVD_NAME> -gpu host -memory 4096
```

### **6.2. Troubleshooting de ADB (Emulador Offline)**

Se `adb devices` mostrar "offline":

```powershell
adb kill-server
adb start-server
adb devices
# Se persistir:
emulator -avd <AVD_NAME> -no-snapshot-load -gpu host
```

### **6.3. Captura de Screenshots Reais**

```powershell
# Rodar app no emulador
flutter run -d emulator-5554

# Capturar screenshot
adb exec-out screencap -p > screenshot.png
```

## **7\. Checklist Pré-Publicação**

- [ ] AGP 8.5.1+ configurado
- [ ] Target SDK 35
- [ ] IDs AdMob de produção
- [ ] ConsentService (GDPR) implementado
- [ ] Screenshots reais do app (mín. 2) com ratio 9:16
- [ ] Ícone 512x512 (REAL, nunca Canvas)
- [ ] Feature graphic 1024x500
- [ ] **Política de privacidade via Google Sites** (padrão: `sarezende-<app>-privacy`)
- [ ] **URL de política VERIFICADA (status 200)**
- [ ] 11 idiomas traduzidos (app + Store Listing)
- [ ] AAB gerado com `flutter build appbundle --release`

### **7.1. Verificação de URL da Política de Privacidade (NOVO v6.2)**

**⚠️ LIÇÃO BMI Calculator:** URL retornando 404 = rejeição imediata do Google Play.

```powershell
# Verificar antes de submeter
$url = "https://sites.google.com/view/sarezende-<app>-privacy"
try {
    $response = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing -TimeoutSec 10
    Write-Host "✅ URL OK (status $($response.StatusCode))"
} catch {
    Write-Host "❌ BLOQUEANTE: URL não acessível"
}
```

## **8\. Toolkit de Produtividade (RECOMENDADO)**

Para desenvolvimento mais rápido e com menos erros, padronize o workflow com:

1. **VS Code Tasks:** usar `.vscode/tasks.json` para rodar `pub get`, `gen-l10n`, `analyze`, `test`, `build aab` por app.
2. **Guardrails (scripts):**
   - `tools/check_l10n.ps1` (garante que todos os `.arb` tenham as mesmas chaves)
   - `tools/check_store_assets.ps1` (valida dimensões mínimas dos assets da Play Store)

Padrão recomendado: **antes de qualquer release**, rodar `Flutter: Validate (l10n+analyze+test)` e `Assets: Check Store Assets`.

## **9\. Features de Engagement Obrigatórias**

Todo app deve incluir pelo menos:

| Feature | Descrição | Impacto |
|---------|-----------|---------|
| **Streak Counter** | Dias consecutivos de uso | ⭐⭐⭐⭐⭐ Alto |
| **Achievements** | Badges desbloqueáveis | ⭐⭐⭐⭐⭐ Alto |
| **Daily Goals** | Meta diária configurável | ⭐⭐⭐⭐ Médio-Alto |
| **Custom Themes** | Personalização visual | ⭐⭐⭐⭐ Médio-Alto |

### **9.1. Estrutura de Models para Gamificação**

```
/lib/models/
  streak_data.dart      # currentStreak, bestStreak, lastActiveDate
  achievement.dart      # id, titleKey, descriptionKey, category, requirement
  daily_goal.dart       # targetSessions, completedSessions, date
  app_theme.dart        # primaryColor, secondaryColor, name
```

### **9.2. Estrutura de Providers**

```
/lib/providers/
  streak_provider.dart       # StateNotifier<StreakData>
  achievements_provider.dart # StateNotifier<List<Achievement>>
  daily_goal_provider.dart   # StateNotifier<DailyGoal>
  theme_provider.dart        # StateNotifier<AppThemeType>
```

## **10\. Padrões de Edição i18n (Eficiência Máxima)**

### **10.1. Regra dos 11 Idiomas**
Ao adicionar nova string:
1. Adicionar chave em `app_en.arb` (template)
2. **IMEDIATAMENTE** adicionar nos outros 10 arquivos .arb
3. Usar `multi_replace_string_in_file` para edição em lote
4. Executar `flutter gen-l10n`

### **10.2. Organização de Chaves por Seção**
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

## **11\. Checklist de Integração de Features (CRÍTICO)**

**LIÇÃO APRENDIDA:** Criar models/providers/widgets NÃO é suficiente. É preciso INTEGRAR na UI principal.

### **11.1. Após criar qualquer feature de gamificação, verificar:**

- [ ] **main.dart:** Theme provider conectado ao MaterialApp (`ColorScheme.fromSeed(seedColor: selectedTheme.primaryColor)`)
- [ ] **timer_screen/home_screen:** StreakBadge no AppBar.leading
- [ ] **timer_screen/home_screen:** Achievements icon no AppBar.actions
- [ ] **timer_screen/home_screen:** DailyGoalProgress visível na tela principal
- [ ] **timer_screen/home_screen:** MotivationalQuote widget integrado
- [ ] **settings_screen:** ThemeSelector adicionado
- [ ] **settings_screen:** AmbientSoundSelector adicionado (se aplicável)
- [ ] **settings_screen:** DailyGoalSetter adicionado
- [ ] **settings_screen:** Link para AchievementsScreen adicionado
- [ ] **Callbacks:** `_onSessionComplete` ou equivalente chama `streakProvider.recordActivity()`, `dailyGoalProvider.incrementCompletedSessions()`, `achievementsProvider.checkAndUnlock()`

### **11.2. Template de Integração no main.dart**
```dart
// OBRIGATÓRIO: Conectar theme provider
final selectedTheme = ref.watch(selectedThemeProvider);
return MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: selectedTheme.primaryColor),
    useMaterial3: true,
  ),
  // ...
);
```

## **12\. Template de Strings i18n para Gamificação**

Ao implementar gamificação, adicionar TODAS estas chaves nos 11 arquivos .arb:

```
# STREAKS (4 chaves)
streakDays, currentStreak, bestStreak, days

# ACHIEVEMENTS (25+ chaves)
achievements, achievementUnlocked, achievementsProgress, notUnlockedYet, unlockedOn, close
categorySession, categoryStreak, categoryTime, categorySpecial
achievementFirstSession, achievementFirstSessionDesc (x14 achievements = 28 chaves)

# AMBIENT SOUNDS (9 chaves)
ambientSounds, soundSilence, soundRain, soundForest, soundOcean, soundCafe, soundFireplace, soundWhiteNoise, soundThunder

# THEMES (9 chaves)
colorTheme, themeTomato, themeOcean, themeForest, themeLavender, themeSunset, themeMidnight, themeRose, themeMint

# DAILY GOALS (6 chaves)
dailyGoal, dailyGoalTarget, goalReached, sessionsProgress, sessionsPerDay, focusTimeToday

# QUOTES (31 chaves)
newQuote, quote1Text, quote1Author ... quote15Text, quote15Author
```

**Total aproximado: ~80 chaves de gamificação por idioma**

## **13\. Ambiente Windows - Flutter Path (CRÍTICO)**

### **13.1. Problema Comum**
O comando `flutter` pode não estar no PATH do sistema Windows. Sintoma:
```
flutter: The term 'flutter' is not recognized as a name of a cmdlet...
```

### **13.2. Solução**
Usar caminho completo ou configurar PATH:
```powershell
# Opção 1: Caminho completo (recomendado para scripts)
C:\dev\flutter\bin\flutter gen-l10n

# Opção 2: Adicionar ao PATH da sessão
$env:Path = "C:\dev\flutter\bin;" + $env:Path
flutter gen-l10n
```

### **13.3. Configuração Permanente**
Adicionar `C:\dev\flutter\bin` às variáveis de ambiente do sistema.

---

## **14. Otimização de Performance para Produção (NOVO v5.2)**

### **14.1. Configuração Obrigatória de gradle.properties**

```properties
# Performance de build
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
org.gradle.caching=true
org.gradle.parallel=true
org.gradle.configuration-cache=true

# Otimizações Android
android.useAndroidX=true
android.enableJetifier=true
android.enableR8.fullMode=true

# Desabilitar features não usadas
android.defaults.buildfeatures.buildconfig=false
android.defaults.buildfeatures.aidl=false
android.defaults.buildfeatures.renderscript=false
android.defaults.buildfeatures.resvalues=false
android.defaults.buildfeatures.shaders=false
```

### **14.2. ProGuard Rules Agressivo**

```proguard
# Otimização máxima
-optimizationpasses 7
-allowaccessmodification
-repackageclasses ''

# Remover logs em produção
-assumenosideeffects class android.util.Log { *; }

# Remover null checks do Kotlin
-assumenosideeffects class kotlin.jvm.internal.Intrinsics { *; }

# Manter Flutter e AdMob
-keep class io.flutter.** { *; }
-keep class com.google.android.gms.ads.** { *; }
```

### **14.3. Logger Utility (Zero Logs em Produção)**

Criar `lib/utils/logger.dart`:

```dart
import 'package:flutter/foundation.dart';

void logDebug(String message) {
  if (kDebugMode) debugPrint(message);
}
```

**Regra:** Substituir TODOS os `debugPrint()` por `logDebug()` - será completamente removido em release via tree-shaking.

### **14.4. Resultados Esperados**

| Otimização | Impacto |
|------------|---------|
| R8 full mode | ~15-20% menor |
| 7 passes ProGuard | Código mais compacto |
| Remove logs | Zero debug output |
| Tree-shake icons | Até **99%** redução de fontes |

---

## **15. Assinatura de Produção (NOVO v5.2)**

### **15.1. Estrutura de Chaves**

```
/DadosPublicacao/<app_name>/keys/
  upload-keystore.jks     # Keystore de upload
  key.properties.example  # Template (SEM senhas)
```

### **15.2. Gerar Keystore**

```powershell
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### **15.3. Configurar key.properties**

Criar `android/key.properties` (NÃO commitar!):

```properties
storePassword=<senha>
keyPassword=<senha>
keyAlias=upload
storeFile=C:/Users/Ernane/Personal/APPs_Flutter/DadosPublicacao/<app>/keys/upload-keystore.jks
```

### **15.4. Adicionar ao .gitignore**

```gitignore
**/android/key.properties
**/*.jks
```

---

**Fim do Planejamento v5.3.** Mantenha o foco. Codifique uma feature, termine, valide, commite. Não deixe pontas soltas.

---

## **16. Teste Funcional de UI via ADB (NOVO v5.3)**

**Lição Pomodoro Timer:** Antes de publicar, testar TODAS as funcionalidades via automação ADB.

### **16.1. Comandos Essenciais**

```powershell
# Capturar hierarquia de UI
adb shell uiautomator dump /sdcard/ui.xml
adb shell cat /sdcard/ui.xml

# Clicar em elemento (centro dos bounds)
adb shell input tap <x> <y>

# Scroll vertical
adb shell input swipe 540 1500 540 600 300

# Screenshot
adb exec-out screencap -p > screenshot.png
```

### **16.2. Checklist de Testes Funcionais**

- [ ] Home Screen: Layout, elementos visíveis
- [ ] Controles principais: todos os botões respondem
- [ ] Settings: scroll, toggles, sliders
- [ ] Navegação: todas as telas acessíveis
- [ ] Achievements: dialog abre/fecha
- [ ] Theme Change: cor muda corretamente
- [ ] i18n: textos traduzidos visíveis
- [ ] Ads: banner carregando

---

## **17. Estrutura de Testes Unitários (NOVO v5.3)**

### **17.1. Mínimo de Testes por App**

| Tipo de App | Testes Mínimos | Cobertura |
|-------------|----------------|-----------|
| Calculadora | 10 | Core logic |
| Timer/Pomodoro | 19 | Timer + Gamificação |
| Todo/Lista | 15 | CRUD + Persistência |

### **17.2. Categorias Obrigatórias**

```
/test/
  unit_test.dart      # Lógica de negócio
  widget_test.dart    # Widgets isolados (opcional)
```

---

## **18. Fast Lane de Publicação (NOVO v5.3)**

### **18.1. Comando Único**

```powershell
Set-Location -Path "C:\Users\Ernane\Personal\APPs_Flutter\<app>";
C:\dev\flutter\bin\flutter clean;
C:\dev\flutter\bin\flutter pub get;
C:\dev\flutter\bin\flutter gen-l10n;
C:\dev\flutter\bin\flutter analyze;
C:\dev\flutter\bin\flutter test;
C:\dev\flutter\bin\flutter build appbundle --release
```

### **18.2. Verificação Pós-Build**

```powershell
$aab = "build\app\outputs\bundle\release\app-release.aab"
if (Test-Path $aab) {
    Write-Host "✅ AAB: $([math]::Round((Get-Item $aab).Length / 1MB, 2)) MB"
}
```

---

## **19. Métricas de Qualidade (NOVO v5.3)**

| Métrica | Critério | Ferramenta |
|---------|----------|------------|
| Analyze Issues | 0 | `flutter analyze` |
| Tests Passed | 100% | `flutter test` |
| AAB Size | < 30 MB | PowerShell |
| i18n Keys | Sincronizados | `check_l10n.ps1` |
| UI Tests | Todas as telas | ADB uiautomator |
| Screenshot Ratio | 9:16 exato | PowerShell |

## **19.1. Validação Automatizada de i18n (NOVO v5.5)**

```powershell
# Validar sincronização de chaves i18n
pwsh -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Ernane\Personal\APPs_Flutter\tools\check_l10n.ps1" -AppPath "C:\Users\Ernane\Personal\APPs_Flutter\<app>"

# Output esperado:
# Template keys: 148
# OK: all ARB files match template keys.
```

## **19.2. Validação de Aspect Ratio de Screenshots (NOVO v5.5)**

```powershell
# Verificar se todos os screenshots são 9:16
Get-ChildItem "DadosPublicacao\<app>\store_assets\screenshots\*.png" | ForEach-Object {
    Add-Type -AssemblyName System.Drawing
    $img = [System.Drawing.Image]::FromFile($_.FullName)
    $ratio = [math]::Round($img.Width / $img.Height, 4)
    $expected = [math]::Round(9/16, 4)  # 0.5625
    $status = if ($ratio -eq $expected) { "✅" } else { "❌ ($ratio)" }
    Write-Host "$($_.Name): $($img.Width)x$($img.Height) $status"
    $img.Dispose()
}
```
---

## **20. Workflow de Assets para Publicação (NOVO v5.4)**

**Lição Crítica:** NUNCA gerar ícones via Canvas/HTML. Usar SEMPRE o ícone real do app.

### **20.1. Ícone 512x512 (OBRIGATÓRIO usar ícone real)**

```powershell
# Upscale do ícone real de 192x192 para 512x512
Add-Type -AssemblyName System.Drawing
$appPath = "C:\Users\Ernane\Personal\APPs_Flutter\<app_name>"
$sourcePath = "$appPath\android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"
$destPath = "C:\Users\Ernane\Personal\APPs_Flutter\DadosPublicacao\<app_name>\store_assets\icon_512.png"

$sourceImage = [System.Drawing.Image]::FromFile($sourcePath)
$bitmap = New-Object System.Drawing.Bitmap(512, 512)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$graphics.DrawImage($sourceImage, 0, 0, 512, 512)
$bitmap.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose(); $bitmap.Dispose(); $sourceImage.Dispose()
```

### **20.2. Workflow de Screenshots (8 telas)**

1. **Comentar AdBannerWidget** antes de tirar screenshots
2. **Mudar idioma do emulador** para inglês:
   ```powershell
   C:\dev\android-sdk\platform-tools\adb.exe shell "setprop persist.sys.locale en-US; setprop ctl.restart zygote"
   Start-Sleep -Seconds 30  # Aguardar reinício
   ```
3. **Capturar screenshots** reais via ADB:
   ```powershell
   C:\dev\android-sdk\platform-tools\adb.exe exec-out screencap -p > screenshot.png
   ```
4. **Descomentar AdBannerWidget** após capturar

### **20.3. Estrutura de Assets**

```
DadosPublicacao/<app>/store_assets/
├── icon_512.png           # Ícone REAL upscaled
├── feature_graphic.png    # 1024x500
└── screenshots/
    ├── 01_home.png
    └── ... (até 08_extra.png)
```

**INSTRUÇÃO OBRIGATÓRIA:**
O ícone padrão do Flutter **DEVE** ser substituído por um novo ícone condizente com o app. Não é permitido publicar apps com o ícone genérico do Flutter. O ícone deve representar visualmente o propósito do app e ser entregue em todas as dimensões exigidas pela Play Store.


## **21. Versão do Documento**

| Versão | Data | Mudanças |
|--------|------|----------|
| 6.3 | Janeiro 2026 | Mapa de Rejeições Comuns, Script de Validação Pré-Submissão, Template HTML de Privacy Policy |
| 6.2 | Janeiro 2026 | Política de Privacidade via Google Sites, Verificação de URL obrigatória, Lição BMI Calculator |
| 6.1 | Janeiro 2026 | Templates Health Apps, NotificationService, Repository Pattern, Lições Fasting Tracker |
| 6.0 | Janeiro 2026 | Factory Mode, Clean Architecture obrigatória, Melos monorepo, Integration Tests |
| 5.6 | Janeiro 2026 | Traduções Store Listing obrigatórias |
| 5.5 | Janeiro 2026 | Crop 9:16 obrigatório, validação i18n automatizada, workflow swap-and-remove |
| 5.4 | Janeiro 2026 | Workflow de Assets, regra do ícone real |
| 5.3 | Janeiro 2026 | Teste funcional UI, Fast Lane, Métricas |
| 5.2 | Janeiro 2026 | Otimização R8, ProGuard, Assinatura |
| 5.1 | Janeiro 2026 | Gamificação, Templates i18n |
| 5.0 | Dezembro 2025 | Estrutura modular inicial |

---

## **22. Integration Tests para Screenshots (NOVO v6.0)**

### **22.1. Configuração**

Adicionar ao `pubspec.yaml`:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

### **22.2. Estrutura de Arquivos**

```
/integration_test
  screenshot_test.dart     # Teste principal de captura
/test_driver
  integration_test.dart    # Driver padrão
```

### **22.3. Template de Screenshot Test**

```dart
// integration_test/screenshot_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:seu_app/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Capture Play Store screenshots', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Screenshot 1: Home
    await binding.takeScreenshot('01_home');

    // Screenshot 2: Em uso
    await tester.tap(find.byKey(Key('primaryButton')));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('02_in_use');

    // Screenshot 3: Settings
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('03_settings');

    // Screenshot 4: Achievements
    await tester.tap(find.byIcon(Icons.emoji_events));
    await tester.pumpAndSettle();
    await binding.takeScreenshot('04_achievements');
  });
}
```

### **22.4. Driver File**

```dart
// test_driver/integration_test.dart
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();
```

### **22.5. Comando de Execução**

```powershell
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart -d emulator-5554
```

---

## **23. Sub-agentes para Tarefas Paralelas (NOVO v6.0)**

### **23.1. Quando Usar Sub-agentes**

| Tarefa | Paralela? | Delegável? |
|--------|-----------|------------|
| Tradução de 11 .arb | Sim | ✅ Sub-agente |
| Captura de screenshots | Sim | ✅ Sub-agente |
| Tradução Store Listing | Sim | ✅ Sub-agente |
| Análise de código | Não | ❌ Agente principal |
| Edição de lógica | Não | ❌ Agente principal |

### **23.2. Template de Delegação**

```
runSubagent(
  description: "Traduzir i18n",
  prompt: "Traduza as seguintes chaves para os idiomas: de, es, fr, zh, ru, ja, ar, hi, bn.
           Chaves: [lista de chaves e valores em inglês]
           Retorne um JSON com as traduções organizadas por idioma."
)
```

---

## **24. Produtividade Máxima (NOVO v6.2)**

### **24.1. Checklist de Ícone Obrigatório (CRÍTICO)**

**⚠️ O ícone padrão do Flutter DEVE ser substituído antes de qualquer build de release.**

| # | Etapa | Comando/Ação |
|---|-------|--------------|
| 1 | Criar ícone personalizado | Design no Figma/Canva |
| 2 | Exportar em densidades Android | 48x48 (mdpi) até 192x192 (xxxhdpi) |
| 3 | Substituir ic_launcher.png | Copiar para mipmap-* |
| 4 | Criar versão round | ic_launcher_round.png |
| 5 | Upscale para Play Store | Script PowerShell 512x512 |
| 6 | Validar | Verificar que NÃO é cubo azul |

### **24.2. Edição em Lote de i18n**

Para editar múltiplos arquivos .arb simultaneamente:

```
# Use multi_replace_string_in_file com array de operações
# Isso é 11x mais rápido que editar arquivo por arquivo
multi_replace_string_in_file({
  explanation: "Adicionar nova chave em todos os 11 idiomas",
  replacements: [
    { filePath: "app_en.arb", oldString: "...", newString: "..." },
    { filePath: "app_pt.arb", oldString: "...", newString: "..." },
    // ... outros 9 idiomas
  ]
})
```

### **24.3. Organização de Chaves por Categoria**

```json
{
  "@@locale": "en",
  "_GENERAL": "=== GENERAL ===",
  "appTitle": "...",
  "_CONTROLS": "=== CONTROLS ===",
  "start": "...",
  "_ACHIEVEMENTS": "=== ACHIEVEMENTS ===",
  "achievementFirst": "...",
  "_SETTINGS": "=== SETTINGS ===",
  "settings": "..."
}
```

### **24.4. Fast Lane Completo**

```powershell
# Validar + Build em um comando
Set-Location "<app_path>";
flutter clean; flutter pub get; flutter gen-l10n; flutter analyze; flutter test; flutter build appbundle --release
```

---

---

## **25. Mapa de Rejeições Comuns do Google Play (NOVO v6.3)**

### **25.1. Top 10 Causas de Rejeição e Soluções**

| # | Rejeição | Causa | Solução Rápida |
|---|----------|-------|----------------|
| 1 | Política de Privacidade inválida | URL 404 ou inacessível | Usar Google Sites + verificar com PowerShell |
| 2 | Ícone não carrega | Ícone gerado via Canvas | Usar ícone real de mipmap-xxxhdpi upscaled |
| 3 | Screenshots rejeitados | Aspect ratio incorreto | Crop para 9:16 (1080x1920) |
| 4 | Data Safety incompleto | Campos obrigatórios faltando | Declarar AdMob/Analytics se usados |
| 5 | ID de Publicidade não declarado | Usa AdMob sem declarar | Marcar "Sim" em Declaração de Ads |
| 6 | Classificação de conteúdo ausente | IARC não preenchido | Completar questionário IARC |
| 7 | Target SDK muito baixo | targetSdkVersion < 35 | Atualizar para SDK 35 |
| 8 | AAB muito grande | > 150MB | Ativar minifyEnabled + shrinkResources |
| 9 | Título muito longo | > 30 caracteres | Encurtar título do app |
| 10 | Descrição curta muito longa | > 80 caracteres | Resumir descrição |

### **25.2. Script de Validação Completa Pré-Submissão**

Salvar em `tools/validate_publication.ps1`:

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$AppName
)

$baseDir = "C:\Users\Ernane\Personal\APPs_Flutter"
$appDir = "$baseDir\$AppName"
$pubDir = "$baseDir\DadosPublicacao\$AppName"
$errors = @()
$warnings = @()

Write-Host "`n🔍 Validando $AppName para publicação...`n" -ForegroundColor Cyan

# 1. Verificar AAB existe
Write-Host "1. Verificando AAB..." -NoNewline
if (Test-Path "$pubDir\app-release.aab") {
    $size = [math]::Round((Get-Item "$pubDir\app-release.aab").Length / 1MB, 2)
    Write-Host " ✅ ($size MB)" -ForegroundColor Green
    if ($size -gt 150) { $warnings += "⚠️ AAB > 150MB - pode ser rejeitado" }
} else { 
    Write-Host " ❌" -ForegroundColor Red
    $errors += "AAB não encontrado" 
}

# 2. Verificar ícone 512x512
Write-Host "2. Verificando ícone 512x512..." -NoNewline
if (Test-Path "$pubDir\store_assets\icon_512.png") {
    Write-Host " ✅" -ForegroundColor Green
} else {
    Write-Host " ❌" -ForegroundColor Red
    $errors += "Ícone 512x512 não encontrado"
}

# 3. Verificar screenshots (mínimo 2)
Write-Host "3. Verificando screenshots..." -NoNewline
$screenshots = Get-ChildItem "$pubDir\store_assets\screenshots\*.png" -ErrorAction SilentlyContinue
if ($screenshots.Count -ge 2) {
    Write-Host " ✅ ($($screenshots.Count) encontrados)" -ForegroundColor Green
} else {
    Write-Host " ❌ ($($screenshots.Count)/2 mínimo)" -ForegroundColor Red
    $errors += "Mínimo 2 screenshots necessários"
}

# 4. Verificar política de privacidade URL
Write-Host "4. Verificando política de privacidade URL..." -NoNewline
$privacyUrl = "https://sites.google.com/view/sarezende-$($AppName.Replace('_','-'))-privacy"
try {
    $response = Invoke-WebRequest -Uri $privacyUrl -Method Head -TimeoutSec 10 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host " ✅" -ForegroundColor Green
    } else {
        Write-Host " ❌ (status $($response.StatusCode))" -ForegroundColor Red
        $errors += "Política de privacidade retornou status $($response.StatusCode)"
    }
} catch {
    Write-Host " ❌" -ForegroundColor Red
    $errors += "Política de privacidade inacessível: $privacyUrl"
}

# 5. Verificar i18n (11 idiomas)
Write-Host "5. Verificando traduções i18n..." -NoNewline
$arbFiles = Get-ChildItem "$appDir\lib\l10n\app_*.arb" -ErrorAction SilentlyContinue
if ($arbFiles.Count -ge 11) {
    Write-Host " ✅ ($($arbFiles.Count) idiomas)" -ForegroundColor Green
} else {
    Write-Host " ⚠️ ($($arbFiles.Count)/11 idiomas)" -ForegroundColor Yellow
    $warnings += "Apenas $($arbFiles.Count) idiomas configurados (recomendado: 11)"
}

# Resultado final
Write-Host "`n" + "="*50
if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "✅ APROVADO: Pronto para publicação!" -ForegroundColor Green
} elseif ($errors.Count -eq 0) {
    Write-Host "⚠️ APROVADO COM AVISOS:" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
} else {
    Write-Host "❌ BLOQUEADO: Corrija os erros antes de submeter:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  ❌ $_" -ForegroundColor Red }
    if ($warnings.Count -gt 0) {
        Write-Host "`n  Avisos:" -ForegroundColor Yellow
        $warnings | ForEach-Object { Write-Host "  $_" -ForegroundColor Yellow }
    }
}
```

### **25.3. Uso do Script**

```powershell
# Validar app antes de publicar
pwsh -File "C:\Users\Ernane\Personal\APPs_Flutter\tools\validate_publication.ps1" -AppName "bmi_calculator"
```

---

**Fim do Documento v6.3.** Factory Mode ativado. Clean Architecture + Melos + Validação Automatizada = Zero Rejeições.
