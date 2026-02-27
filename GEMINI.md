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

### 🌌 SUPERAPP ARCHITECTURE RAG (MANDATORY INSTRUCTION)
> **AI INSTRUCTION: CRITICAL PROTOCOL FOR ALL FUTURE DEVELOPMENTS**

The legacy "152 Standalone Apps" strategy has been DEPRECATED in favor of the **Superapp Ecosystem**. Do NOT blindly follow legacy `.md` files in planning directories that suggest building micro-apps.

**When the user asks you to "create an app" or "add a feature", YOU MUST FOLLOW THIS FLOW:**
1. **Modules, not Apps:** Every functional utility (e.g., BMI Calculator, Pomodoro, Fasting, Mortgage) MUST be built as an isolated feature package inside `packages/features/<feature_name>`.
2. **The Shells (Superapps):** The `apps/` directory is reserved STRICTLY for Superapp Hubs (e.g., `apps/super_health_app`, `apps/super_finance_app`, `apps/super_productivity`).
3. **Integration:** You inject the feature packages into the Superapp shells. The Superapps provide the routing, premium paywalls, and tab bars to navigate between features.
4. **Gamification First:** Before writing business logic, ensure that the feature hooks into the universal Gamification patterns (Streaks, Badges, Fire/FOMO loops) defined in `core_logic`/`core_ui`. Utility without retention is strictly forbidden.
5. **Cross-Promotion:** Emphasize internal synergy (e.g., The Productivity Superapp should offer White Noise directly inside the Pomodoro timer).
