---
applyTo: '**'
---
# **Plano de Arquitetura: Do App Simples ao SuperApp (Modular)**

Versão: 5.1 | Janeiro 2026 | Inclui lições de publicação real + padrões de gamificação + workflow otimizado

Para cumprir o requisito de criar apps individuais que depois serão agregados, NÃO podemos usar uma estrutura monolítica comum (lib/main.dart cheio de tudo).

Utilizaremos uma **Arquitetura Modular Baseada em Packages**.

## **1\. Estrutura de Pastas (O Segredo)**

Mesmo para o primeiro app simples, a estrutura deve ser pensada como um monorepo.

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
- [ ] Screenshots reais do app (mín. 2)
- [ ] Ícone 512x512
- [ ] Feature graphic 1024x500
- [ ] Política de privacidade hospedada
- [ ] 11 idiomas traduzidos
- [ ] AAB gerado com `flutter build appbundle --release`

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

**Fim do Planejamento v5.1.** Mantenha o foco. Codifique uma feature, termine, valide, commite. Não deixe pontas soltas.