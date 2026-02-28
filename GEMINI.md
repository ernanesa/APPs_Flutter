# GEMINI.md - Antigravity Kit

> This file defines how the AI behaves in this workspace.

---

## CRITICAL: AGENT & SKILL PROTOCOL (START HERE)

> **MANDATORY:** You MUST read the appropriate agent file and its skills BEFORE performing any implementation. This is the highest priority rule.

### Global Dependencies Rule
- **Always use the most up-to-date versions of libraries and SDKs**: For any code implementation or update, ALWAYS resolve dependencies to their latest major/minor versions using `flutter pub upgrade --major-versions`, and handle any resulting breaking changes. Do not stick to older versions unless explicitly demanded by the user for compatibility reasons.

### Global Performance, Security & SDK Rule (Ouro)
- **Minimum SDK and Extreme Performance**: All Android applications MUST use `minSdk = 26` (Android 8.0) or higher, and `targetSdk = 35` (or latest). Legacy code (like Multidex) must be stripped.
- **Desempenho Extremo, Latência Mínima e Segurança Máxima**: Estas são exigências absolutas para QUALQUER linha de código escrita em todos os apps atuais e futuros. Todas as implementações devem buscar o mais alto nível de otimização possível, garantindo segurança total dos dados e latência computacional irrisória. Todos os nossos apps terão qualidade PREMIUM Absoluta.

### ⚡ EXTREME PARALLELIZATION (MANDATORY INSTRUCTION)
- **Parallel Everything**: ALL tasks (research, planning, file creation, code development, testing, compiling) MUST be executed in parallel whenever programmatically possible. Do not perform actions sequentially if they can be grouped.
- **Maximum Agent Force**: Utilize all available tools, subagents, and concurrent API calls simultaneously to maximize speed, agility, and efficiency. Single-threading your thoughts is forbidden unless strictly required by file lock dependencies.

### 📅 TEMPORAL CONTEXT RULE (MANDATORY INSTRUCTION)
- **Always Verify Current Date:** Before performing any research, proposing any SDK versions, or outlining any App Store/Play Store publication policies, you MUST check the current date provided in your system metadata context.
- **No Outdated Tech:** We are operating in the year **2026**. Never propose deprecated 2023/2024 solutions, APIs, or policy compliance checklists. Always ensure information is current relative to the present day.

### 🌌 DUAL-TRACK ARCHITECTURE (MANDATORY INSTRUCTION)
> **AI INSTRUCTION: CRITICAL PROTOCOL FOR ALL FUTURE DEVELOPMENTS**

This project uses a **Dual-Track Strategy**: every feature lives BOTH as a standalone Play Store app AND as a module inside a SuperApp. This is deliberate — both tracks are active and generate independent revenue.

```
apps/
├── <app_name>          ← Standalone app (published on Play Store individually)
└── super_<domain>_app  ← SuperApp Hub (aggregates feature packages)

packages/
├── core_ui             ← Shared design system
├── core_logic          ← Shared logic (AdService, ConsentService, gamification)
└── features/
    └── feature_<name>  ← Modular version consumed by the SuperApp
```

**When the user asks you to "create an app" or "add a feature", YOU MUST FOLLOW THIS FLOW:**

1. **Standalone First:** Build the feature as a complete standalone app in `apps/<feature_name>` with full AdMob, i18n (11 languages), gamification, and Play Store assets. This generates immediate revenue.
2. **Then Modularize:** Extract the core logic into `packages/features/feature_<name>` so it can be consumed by the SuperApp shell without code duplication.
3. **SuperApp Shells:** `apps/super_<domain>_app` is a thin hub that imports feature packages and provides unified navigation (GoRouter), premium paywalls, and cross-promotion.
4. **Shared Infrastructure:** ALL apps MUST use `core_logic` (AdService, ConsentService, streak/gamification providers) and `core_ui` (AppTheme, BaseCard, GlobalStreakBadge). Never reimplement these locally.
5. **Gamification Mandatory:** Every app MUST include: Streak Counter, Achievements/Badges, Daily Goals. Hook into `core_logic` providers. Utility without retention is forbidden.
6. **Cross-Promotion:** The SuperApp should surface related standalone apps (e.g., Pomodoro timer integrated with White Noise, BMI Calculator alongside Water Tracker).

**Current Published App Portfolio:**
- `bmi_calculator` ✅ PUBLISHED
- `pomodoro_timer` ✅ Ready to submit
- `fasting_tracker` 🟠 In progress
- `white_noise` 🟠 In progress
- `compound_interest_calculator` 🔴 Setup needed
- `water_tracker` 🔴 Development needed
- `super_health_app` 🔧 Hub (aggregates BMI, Water, Fasting features)
