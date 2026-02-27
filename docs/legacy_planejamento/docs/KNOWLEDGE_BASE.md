# 🧠 Knowledge Base — Blockers, Aprendizados e Prevenções

Objetivo: sempre que um problema aparecer e for resolvido, **registrar**:
- o que aconteceu (sintoma)
- causa raiz
- correção aplicada
- prevenção (checklist/automação)

Formato sugerido (copie e cole):
```md
## YYYY-MM-DD — <título curto>

**Sintoma:** ...
**Impacto:** ...
**Causa raiz:** ...
**Correção:** ...
**Prevenção/Automação:** ...
**Evidências/Links:** ...
```

---

## 2026-02-05 — Emulador passou; device físico encontrou 2 bugs bloqueantes

**Sintoma:** testes automatizados e emulador “ok”, mas em device físico:
- gráfico de evolução vazio (BMI)
- tela “branca/travada” (Pomodoro)

**Impacto:** risco alto de publicação com bug em produção.

**Causa raiz (padrão):**
- providers que carregam storage async, mas retornam estado padrão antes do load completar (sem `AsyncNotifier`/loading state)
- loading state sem contraste pode parecer “app congelado”

**Correção (padrão):**
- usar `AsyncNotifier` para dados persistidos
- UI obrigatória com `when(data/loading/error)` e loading visível/contrastante

**Prevenção/Automação:**
- gate obrigatório: testar em **device físico** antes de publicar
- adicionar checklist de “loading state visível” em review

---

## 2026-02-04 — Blocker ao criar AVDs (System Images ausentes)

**Sintoma:** Android SDK instalado, mas `sdkmanager` sem system images; não dá para criar AVD.

**Impacto:** sem emuladores → sem testes UI automatizados localmente.

**Causa raiz:** falta de download de system images (rede bloqueada/instável).

**Correção:**
- baixar system images via `sdkmanager` (quando houver rede)
- alternativa imediata: testar em **device físico**

**Prevenção/Automação:**
- `tools/check_environment.ps1` deve sinalizar system images ausentes
- documentar lista mínima de AVDs (API antiga + atual; phone + tablet)

