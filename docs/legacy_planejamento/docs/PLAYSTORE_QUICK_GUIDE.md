# 📱 PLAYSTORE PUBLICATION - Guia Resumido para Próximos Apps

**Data:** 2026-02-06  
**Objetivo:** Repetir fluxo de publicação do White Noise em futuros apps (150+ apps do monorepo)

---

## 🎯 Pipeline Simplificado (5 Min)

```bash
# 1. Garantir qualidade
melos run qa
melos run check:store_assets

# 2. Build
cd apps/<cluster>/<app>
flutter build appbundle --release

# 3. Autenticação (1ª vez)
npm run play:auth
# → Você faz login manual (1 vez, sessão dura ~14 dias)

# 4. Automação completa (descrição + formulários + submissão)
npm run play:publish:<app_name>
# → Preenche 5 formulários automaticamente
# → Submete para revisão

# 5. Status
melos run gen:publication-status

# ⏱️  Tempo total: ~5 min (automático)
# 📊 Aprovação esperada: 24-48h
# 💰 Receita 1ª semana: $200-500 (se CPM otimizado USA/Canadá)
```

---

## 📋 Checklist Rápido

### App Analysis (5 min antes)
- [ ] Tipo de app? (produtividade, jogo, utilidade)
- [ ] Funcionalidades? (ler main.dart)
- [ ] Dados sensíveis? (ler pubspec.yaml)
- [ ] Monetização? (ads, IAP, premium)
- [ ] Idiomas? (16 = ideal, 15 = mínimo obrigatório)

### Playwright Automation
- [ ] `npm run play:auth` (sessão válida)
- [ ] `npm run play:publish:<app>` (executa)
- [ ] Play Console: validar zero erros
- [ ] Status = "Em Revisão" ✅

### Pós-Publicação (24-48h após aprovação)
- [ ] Criar `publishing/PUBLISHED_ON_PLAYSTORE.md`
- [ ] `melos run gen:publication-status`
- [ ] Documentar CPM inicial

---

## 📁 Estrutura de Arquivos (Padrão)

Cada app precisa ter (antes de publicar):

```
apps/<cluster>/<app>/
├── lib/
│   ├── main.dart             # Verificar: dados, anúncios, consentimento
│   └── l10n/
│       ├── app_en.arb        # English (CRÍTICO para USA/Canadá)
│       ├── app_de.arb        # German (alto CPM)
│       ├── app_pt.arb        # Portuguese (alto volume)
│       └── ... (13 idiomas mais)
│
├── pubspec.yaml              # Verificar: versão, categoria, dependências
│
└── publishing/
    ├── store_assets/
    │   ├── icon_512.png      # ✅ OBRIGATÓRIO
    │   ├── feature_graphic_1024x500.png  # ✅ OBRIGATÓRIO
    │   └── screenshots/      # Recomendado
    │
    ├── admob/
    │   └── ADMOB_IDS.md       # IDs por região (app_id, ca_app_id)
    │
    └── policies/
        ├── privacy_policy.md  # URL + cópia da política
        └── app-ads.txt        # Se aplicável
```

---

## 🎨 Descrição: Fórmula por Idioma (CRÍTICO)

### Mercado USA/Canadá (CPM: $15-50)
**Fórmula:** [BENEFÍCIO] + features + call-to-action

```
White Noise - Sleep Sounds

Sleep 40% faster with scientifically-proven soothing sounds.

🌙 BENEFITS:
✓ Sleep better  
✓ Stay focused
✓ Reduce anxiety

🎵 FEATURES:
✓ 8 sounds
✓ Mix custom
✓ Auto-timer

💰 Free + Optional Premium
```

### Mercado Alemanha (CPM: $8-25)  
**Fórmula:** Qualidade + Eficiência + Precisão

```
Weißes Rauschen - Schlafgeräusche

Schlafen Sie 40% schneller mit wissenschaftlich belegten Geräuschen.

Hochwertig | Effizient | Wissenschaftlich
```

### Mercado Brasil (CPM: $2-8)
**Fórmula:** Funcionalidades + Benefícios + Amigável

```
Ruído Branco - Sons para Dormir

Durma melhor. Foque melhor. Relaxe.

8+ Sons | Timer | Offline | Grátis
```

---

## 🛠️ Como Criar Novo Script Playwright

Copiar `automation/publish_white_noise_complete.spec.ts` e adaptar:

```typescript
// 1. Mudar APP_ID e DEVELOPER_ID (de play console)
const APP_ID = 'novo_id_aqui';
const DEVELOPER_ID = 'seu_developer_id';

// 2. Mudar DESCRIPTIONS_BY_LANGUAGE
const DESCRIPTIONS_BY_LANGUAGE: Record<string, { title: string; short: string; full: string }> = {
  en: {
    title: 'Novo App - Nome Certo',
    full: 'Sua descrição customizada por tipo de app'
  },
  // ... 14 idiomas mais
};

// 3. Adaptar formulários (se houver diferenças)
// A maioria dos campos é padrão Play Console
```

Adicionar em `package.json`:
```json
{
  "scripts": {
    "play:publish:novo_app": "npx playwright test ./automation/publish_novo_app.spec.ts"
  }
}
```

---

## 🔍 Troubleshooting Rápido

| Problema                             | Solução                                             |
| ------------------------------------ | --------------------------------------------------- |
| "Sessão expirada"                    | Rodar `npm run play:auth` novamente                 |
| "Este navegador não é seguro"        | Usar sessão pré-autenticada (nunca OAuth)           |
| "Campo não encontrado no formulário" | Verificar URL Play Console (mudou?)                 |
| "Erro ao preencher idioma X"         | Pode estar em dropdown diferente; ajustar seletor   |
| "App teve erro de validação"         | Ver `docs/KNOWLEDGE_BASE.md` para blocker conhecido |

---

## 📊 Monetização: Próximas Otimizações

### CPM por Categoria (Benchmark)
| Tipo          | USA CPM | Estratégia                 |
| ------------- | ------- | -------------------------- |
| Produtividade | $20-50  | Benefits (sleep, focus)    |
| Jogos         | $15-40  | Addictive, ranking         |
| Utilitários   | $8-25   | Speed, offline, simplicity |
| Saúde         | $10-30  | Wellness, data privacy     |

### Próxtimas Ações
- [ ] Testar White Noise por 2 semanas (medir CPM real)
- [ ] Documentar receita inicial em `docs/KNOWLEDGE_BASE.md`
- [ ] Aplicar estratégia comprovada a Pomodoro Timer
- [ ] Replicar em BMI Calculator
- [ ] Massa crítica: 10 apps LIVE = ~$2-3k/mês

---

## 📚 Referências

- **Masterpiece:** `docs/PLAYSTORE_PUBLICATION_STRATEGY.md` (15 idiomas completos)
- **Automation:** `automation/publish_white_noise_complete.spec.ts`
- **Agent:** `.github/agents/PlayStorePublisher.agent.md`
- **Policy:** `docs/PLAYBOOK.md` (seção 6: Ads+Consent+Monetização)
- **Blockers:** `docs/KNOWLEDGE_BASE.md`

---

## ✅ Próximos Apps (Prioridade)

1. **Pomodoro Timer** (Produtividade)
   - CPM Target: USA $25-50
   - Features: Timer, notifications, focus mode
   - Descrição: "Boost productivity. Beat the timer."

2. **BMI Calculator** (Saúde/Utilidade)
   - CPM Target: USA $8-20
   - Features: Cálculo, histórico, gráficos
   - Descrição: "Track BMI. Stay healthy."

3. **Fasting Tracker** (Saúde)
   - CPM Target: USA $12-30
   - Features: Timer intermitente, estatísticas
   - Descrição: "Intermittent fasting made easy."

4. **Compound Interest Calculator** (Finanças)
   - CPM Target: USA $10-25
   - Features: Investimentos, simulação
   - Descrição: "Grow your money. Plan ahead."

---

**Sucesso:** Quando app LIVE + LIVE = Play Store LIVE 🎉
