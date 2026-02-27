# 📘 PLAYBOOK — Padrão Obrigatório (Monorepo Flutter)

Este documento define o **padrão único** para todos os apps do monorepo: arquitetura, settings, i18n, tema, ads e gates de qualidade.

## Objetivos (ordem de prioridade)
1. **Zero retrabalho no Play Console** (publicação previsível)
2. **Zero regressão** nos apps em produção
3. **Velocidade com padrão** (paralelizar sem virar caos)

## 1) Estrutura do monorepo

```
apps/<cluster>/<app>/                # apps finais
apps_non_production/...              # apps fora de produção
packages/core/...                    # código compartilhado (design system, etc.)
packages/features/...                # features compartilhadas (settings, ads, etc.)
tools/                               # scripts de QA/automação
automation/                          # Playwright (RPA) quando aplicável
artifacts/                           # outputs gerados (logs, goldens, relatórios)
```

Regras:
- Apps **não importam outros apps**. Apenas packages em `packages/`.
- Qualquer padrão global deve estar documentado aqui (e não espalhado em vários arquivos).

## 2) Arquitetura (Clean vs Simple)

### Padrão preferido (Clean Architecture)
```
lib/
  domain/         # Dart puro (entities, usecases, interfaces)
  data/           # implementações, DTOs, datasources
  presentation/   # UI, providers, widgets
  services/       # cross-cutting (Ads/Consent/Tracking)
```

### Exceção (apps pequenos)
Apps muito pequenos podem usar estrutura simples, mas **devem** manter:
- separação mínima de “UI vs regra” (sem regra de negócio em widget)
- providers/testes para lógica crítica

## 3) Settings (idioma + tema) — padrão único

Obrigatório:
- persistência de **Locale** (ou “usar sistema”)
- persistência de **ThemeMode** (system/light/dark)

Recomendação:
- centralizar via `packages/features/settings` (um único padrão para todos os apps)

## 4) i18n — 15 idiomas (mínimo)

Todos os apps devem ter `lib/l10n/app_*.arb` com o mesmo conjunto de chaves.

Idiomas (15):
`en, zh, hi, es, fr, ar, bn, pt, ru, ja, de, ko, id, it, tr`

Comandos:
```bash
melos run gen:l10n
melos run check:l10n
```

Regra crítica:
- Se um provider carrega algo assíncrono (storage/network), UI **tem** que ter estado de `loading` visível e contrastante.

## 5) Tema — light/dark/system sempre

Obrigatório:
- `ThemeMode.system`
- `ThemeMode.light`
- `ThemeMode.dark`

Opcional por app:
- modo “colorful” como variante própria (não substitui light/dark)

## 6) Ads + Consent (UX + Receita + Monetização)

### Princípios Obrigatórios
1. Ads **não podem quebrar o fluxo** (UX first)
2. Consentimento (UMP/GDPR) **antes** de inicializar ads
3. Debug sempre com **test IDs** (nunca hardcode de production IDs)
4. Interstitial/AppOpen com **cooldown** e breakpoint natural (não durante core task)
5. **Kill switch** (desligar ads sem release quando necessário)

### Estrutura por App
```
apps/<cluster>/<app>/publishing/
  admob/
    ADMOB_IDS.md      # IDs por região (USA, EU, resto do mundo)
  policies/
    app-ads.txt       # Regras de ads (se necessário)
    privacy_policy.md # URL + snapshot de privacidade
```

### Monetização: Estratégia CPM

| Mercado  | CPM Típico | Estratégia                                       |
| -------- | ---------- | ------------------------------------------------ |
| 🇺🇸 USA    | $15-50     | **PRIORIDADE** — enfatizar benefits em descrição |
| 🇨🇦 Canada | $12-35     | PRIORIDADE — mesmo público linguístico que USA   |
| 🇬🇧 GB     | $10-30     | Alto valor — versão EN com tone europeu          |
| 🇩🇪 DE     | $8-25      | Alto — qualidade/eficiência                      |
| 🇫🇷 FR     | $8-20      | Médio-alto — lifestyle                           |
| 🇧🇷 BR     | $2-8       | Médio volume — baixo CPM                         |
| 🇮🇳 IN     | $0.5-3     | Alto volume — CPM muito baixo                    |

**Ação:** Na publicação Play Console, usar Playwright para preencher descrições otimizadas por idioma (ver `docs/PLAYSTORE_PUBLICATION_STRATEGY.md`)

## 7) Store Assets (Play Store) — obrigatório para publicar

Estrutura:
```
apps/<cluster>/<app>/publishing/store_assets/
  icon_512.png                 # 512x512
  feature_graphic.png          # 1024x500 (ou feature_1024x500.png)
  screenshots/                 # recomendado (phone/tablet)
```

Validação automática:
```bash
melos run check:store_assets
```

## 8) Gates de Qualidade (Definition of Done)

Antes de marcar “pronto para publicação”:
```bash
melos run qa
melos run check:store_assets
melos run validate:qa:full -- -AppName <app>
```

Marcadores de publicação (por app):
- `publishing/CHECKLIST_CONCLUIDO.md` → pronto para subir no Play Console
- `publishing/PUBLISHED_ON_PLAYSTORE.md` → publicado (marco final)

