# ✅ QA Factory — Validação de Qualidade (Pronto para Play Console)

Este documento descreve **como validar** um app (local e CI) antes de publicação.

> Regra #1: emulador ajuda, mas **device físico encontra bugs que o emulador não vê**.

## 1) Quick Start (local)

### Checar ambiente
```bash
pwsh tools/check_environment.ps1
```

### Quality gate rápido (workspace)
```bash
melos run qa
```

### Pipeline completo (por app)
```bash
melos run validate:qa:full -- -AppName <nome_do_app>
```

## 2) O que o pipeline valida

- **Arquitetura (best-effort):** estrutura mínima (Clean ou Simple aceitável)
- **Unit/Widget tests:** `flutter test`
- **Golden tests (visual):** geração + comparação (quando configurado)
- **Perf smoke (best-effort):** baseline rápido (quando possível)
- **Security scan (best-effort):** MobSF (quando configurado)
- **Self-heal:** diagnóstico de falhas via `tools/self_heal_runner.py`

## 3) Golden tests (visual)

Fluxo recomendado:
```bash
# gerar screenshots atuais
melos run generate:goldens -- -AppName <app>

# comparar (baseline vs current)
melos run golden:test -- -AppName <app>
```

Artefatos (padrão):
- `artifacts/goldens/<app>/baseline/`
- `artifacts/goldens/<app>/current/`
- `artifacts/goldens/<app>/diffs/`

## 4) i18n (15 idiomas)

Obrigatório:
```bash
melos run gen:l10n
melos run check:l10n
```

Recomendação prática:
- sempre revisar pelo menos **1 idioma RTL** (árabe) em device real
- sempre revisar **font scale alto** (acessibilidade) em device real

## 5) Testes em device físico (obrigatório antes de publicar)

Quando o pipeline passar, rode os testes de uso real:
- cenários (usar o app de verdade: calcular/salvar/mudar settings/kill & restart)
- screenshots + logcat

Plano mestre (manual + automatizável):
- `docs/MASTER_TEST_PLAN.md`

Scripts úteis (ver `tools/`):
- `tools/test_apps_COMPLETE.ps1`
- `tools/test_physical_device_comprehensive.ps1`

## 6) CI (GitHub Actions)

Workflow: `.github/workflows/qa-pipeline.yml`

O CI deve, no mínimo:
- `melos bootstrap`
- `melos run qa`
- `melos run check:store_assets`
- (opcional) `melos run validate:qa:full` em apps-alvo

## 7) Limitações (realidade vs objetivo)

- Perf/Security/Device Farm exigem setup e credenciais; automatizamos o máximo possível, mas **não dá para “inventar” device farm** sem infraestrutura.
- “100% cobertura” deve ser tratada como **meta**, mas com gates realistas (ex.: cobertura mínima por pacote e testes obrigatórios por fluxo crítico).
