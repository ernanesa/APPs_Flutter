# Checklist Operacional de Publicação (1 página)

**Objetivo:** reduzir retrabalho e acelerar releases com validações obrigatórias.

## 1) Pré-Flight (ANTES do Console)
- [ ] `tools/check_l10n.ps1` OK
- [ ] `tools/check_store_assets.ps1` OK
- [ ] Política de privacidade URL **200**
- [ ] `app-ads.txt` publicado e acessível
- [ ] Ícone 512x512 real (Android → Play Store → AdMob)
- [ ] Feature graphic 1024x500
- [ ] Screenshots 9:16 (mín. 2)

## 2) AdMob (Tríade Sync)
- [ ] App criado no AdMob
- [ ] Banner / Interstitial / App Open criados
- [ ] IDs validados na lista de ad units
- [ ] Atualizado no mesmo commit:
  - [ ] `lib/services/ad_service.dart`
  - [ ] `android/app/src/main/AndroidManifest.xml`
  - [ ] `DadosPublicacao/<app>/admob/ADMOB_IDS.md`

## 3) Build & Qualidade
- [ ] `flutter gen-l10n`
- [ ] `flutter analyze` (0 issues)
- [ ] `flutter test` (100%)
- [ ] `flutter build appbundle --release`
- [ ] AAB copiado para `DadosPublicacao/<app>/`

## 4) Play Console (Metadados)
- [ ] Nome, descrição curta e completa (EN)
- [ ] Categoria e email de suporte
- [ ] Política de privacidade salva
- [ ] Data Safety preenchido
- [ ] Declaração de Ads = Sim
- [ ] Declaração de ID de publicidade

## 5) Assets no Console
- [ ] Ícone 512x512
- [ ] Feature graphic 1024x500
- [ ] Screenshots (mín. 2)

## 6) Release
- [ ] Upload AAB
- [ ] Notas da versão (EN)
- [ ] Países/regiões definidos
- [ ] Verificações automáticas concluídas
- [ ] Enviar para revisão
