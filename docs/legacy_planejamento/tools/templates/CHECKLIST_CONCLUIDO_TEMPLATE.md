# CHECKLIST_CONCLUIDO.md (Template)

**App:** <app_name>
**Cluster:** <cluster>
**Data:** DD de MMMM de YYYY
**Versão:** x.y.z+build

---

## Status do Checklist

### Requisitos Técnicos
- [ ] AGP atualizado para 8.6.0
- [ ] Kotlin atualizado para 2.1.0
- [ ] Target SDK 35
- [ ] minifyEnabled true + shrinkResources true
- [ ] ProGuard rules configuradas
- [ ] i18n (15 idiomas) implementado e validado (`melos run check:l10n`)
- [ ] Settings (idioma + tema) persistindo corretamente
- [ ] Ads: consentimento antes de inicializar (quando aplicável)

### Build
- [ ] App Bundle (.aab) gerado (ex.: `flutter build appbundle --release`)

### Documentação
- [ ] Política de privacidade (arquivo + URL 200 OK)
- [ ] IDs do AdMob documentados em `publishing/admob/ADMOB_IDS.md` (quando aplicável)
- [ ] `app-ads.txt` pronto e publicado (quando aplicável)
- [ ] Assets Play Store em `publishing/store_assets/` (ícone, feature graphic, screenshots)

### Próximos Passos
- [ ] Validar gates: `melos run qa` + `melos run check:store_assets` + `melos run validate:qa:full -- -AppName <app>`
- [ ] Upload AAB para Play Console e salvar rascunho
- [ ] Submeter para revisão
- [ ] Quando aprovado: criar `publishing/PUBLISHED_ON_PLAYSTORE.md` (template em `tools/templates/PUBLISHED_ON_PLAYSTORE_TEMPLATE.md`)

---

*Template gerado por tools/templates/CHECKLIST_CONCLUIDO_TEMPLATE.md*
