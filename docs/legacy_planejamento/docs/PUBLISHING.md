# 🚀 Publicação — Play Console (rápido, repetível, automatizável)

Este documento define o fluxo **pré-console → console → pós-publicação**.

## 1) Pré-console (bloqueantes)

Antes de abrir o Play Console, valide:
```bash
melos run qa
melos run check:store_assets
melos run validate:qa:full -- -AppName <app>
```

Obrigatórios por app (`apps/<cluster>/<app>/publishing/`):
- `store_assets/` com `icon_512.png` e `feature_graphic.png`
- `policies/privacy_policy.md` (e URL publicada 200 OK)
- `policies/app-ads.txt` (quando aplicável)
- `admob/ADMOB_IDS.md` (quando há monetização)

## 2) Build (AAB release)

```bash
cd apps/<cluster>/<app>
flutter build appbundle --release
```

Saída típica:
- `build/app/outputs/bundle/release/app-release.aab`

## 3) Play Console (manual, porém padronizado)

Checklist mínimo:
- criar release (produção ou faixa desejada)
- subir AAB
- preencher **release notes** (pelo menos no idioma padrão)
- completar/confirmar itens de “Integridade do app” quando solicitados
- garantir store listing com screenshots obrigatórias (phone/tablet)

## 4) Automação (Playwright) — quando fizer sentido

Playwright é útil para **tarefas repetitivas de UI** (ex.: upload, navegação, coleta de evidências),
mas há limitações reais:
- login/2FA pode exigir ação humana (1ª vez)
- mudanças de UI do Google quebram seletores
- automação não deve tentar burlar políticas/segurança

### Setup (workspace)
```bash
npm ci
```

### Sessão autenticada (1ª vez)
Use um script de auth que salva `storageState` para execuções futuras.

> Importante: “zero intervenção humana” só é realista após uma sessão válida estar salva.

### Execução (headless/headed)
```bash
npm test
```

## 4.1) Regra: Persistent Browser (Evita Re-login)

**OBRIGATÓRIO antes de qualquer automação Playwright:**

1. Execute task **"Launch Persistent Play Console Browser (CDP 9222)"**
   - Abre Chrome dedicado (porta 9222, profile isolado)
   - **Login manual UNA VEZ** (cookies/sessão persistem forever)

2. Automação conecta via `connectOverCDP('http://localhost:9222')`:
   - Reutiliza abas/sessão (nova aba se preciso)
   - **Nunca mais re-login** (mesmo após restarts)

**Fluxo:**
```
1. Launch Persistent Browser → Manual login (1x)
2. npm run play:auth → Salva storageState (opcional)
3. npm run play:publish:white_noise → Conecta & publica
```

**Vantagens:**
- Sessão imortal (profile dedicado)
- Reutiliza abas abertas
- Evita 2FA repetido
- Funciona com continue_publication.ts (já usa CDP)

**Troubleshoot:**
- Mata Chrome 9222: `taskkill /F /IM chrome.exe /T` (reinicia limpo)
- Profile corrompido: Delete `automation/play-console-profile/`

## 5) Pós-publicação (marcador no repo)

Quando o app estiver LIVE, crie:
- `apps/<cluster>/<app>/publishing/PUBLISHED_ON_PLAYSTORE.md`

Depois gere o status consolidado:
```bash
melos run gen:publication-status
```

