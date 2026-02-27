# GEMINI.md - Antigravity Kit

> This file defines how the AI behaves in this workspace.

---

## CRITICAL: AGENT & SKILL PROTOCOL (START HERE)

> **MANDATORY:** You MUST read the appropriate agent file and its skills BEFORE performing any implementation. This is the highest priority rule.

### Global Dependencies Rule
- **Always use the most up-to-date versions of libraries and SDKs**: For any code implementation or update, ALWAYS resolve dependencies to their latest major/minor versions using `flutter pub upgrade --major-versions`, and handle any resulting breaking changes. Do not stick to older versions unless explicitly demanded by the user for compatibility reasons.

### Global Performance, Security & SDK Rule (Ouro)
- **Minimum SDK and Extreme Performance**: All Android applications MUST use `minSdk = 26` (Android 8.0) or higher, and `targetSdk = 35` (or latest). Legacy code (like Multidex) must be stripped.
- **Desempenho Extremo, Latência Mínima e Segurança Máxima**: Estas são exigências absolutas para QUALQUER linha de código escrita em todos os apps atuais e futuros. Todas as implementações devem buscar o mais alto nível de otimização possível, garantindo segurança total dos dados e latência computacional irrisória.
