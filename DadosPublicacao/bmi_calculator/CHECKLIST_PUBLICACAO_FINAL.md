# ✅ CHECKLIST FINAL PARA PUBLICAÇÃO IMEDIATA

## 📦 STATUS DOS ARQUIVOS

### App Bundle
- ✅ **Arquivo**: `/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator/app-release.aab`
- ✅ **Tamanho**: 45 MB
- ✅ **Hash MD5**: `12434e8090074014cc906ec76b2819e4`
- ⚠️ **Status**: Gerado sem keystore (debug signing) - Google Play aceita para TESTE mas exigirá re-upload para produção

### Documentação Completa
- ✅ **Formulário Play Console**: `/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator/PLAY_CONSOLE_FORMULARIO.md`
- ✅ **Store Listings (11 idiomas)**: `/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator/store_assets/store_listings.md`
- ✅ **Política de Privacidade**: `/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator/policies/privacy_policy.md`
- ✅ **IDs do AdMob**: `/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator/admob/admob_ids.json`
- ✅ **app-ads.txt**: `/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator/admob/app-ads.txt`

---

## 🚀 PLANO DE AÇÃO IMEDIATA (3 ETAPAS)

### ETAPA 1: Upload Inicial (Internal Testing) - 10 minutos

1. **Acessar**: https://play.google.com/console/u/0/developers/4710261638140419429/app-list
2. **Criar Novo App**:
   - Nome: `BMI Calculator`
   - Idioma: English (US)
   - Tipo: App
   - Grátis: Sim
3. **Upload do AAB**:
   - Ir em "Internal Testing"
   - Fazer upload de: `app-release.aab` (45MB)
   - Criar release 1.0.0 (1)

**IMPORTANTE**: Internal Testing aceita debug signing temporariamente.

---

### ETAPA 2: Preencher Formulários - 15 minutos

Use o arquivo **PLAY_CONSOLE_FORMULARIO.md** e copie/cole na ordem exata:

#### 2.1 Store Listing
- Título: `BMI Calculator - Health`
- Descrição curta: `Calculate your Body Mass Index quickly and track your health evolution over time.`
- Descrição completa: *(Copiar do arquivo store_listings.md)*
- Email: `ernane@rezende.dev`
- **Política de Privacidade**: `https://rezende.dev/privacy-bmi` ⚠️ HOSPEDAR ANTES!

#### 2.2 Data Safety
- Coleta dados: `Sim` (Saúde/Fitness + IDs do dispositivo)
- Criptografado: `Sim`
- Deletável: `Sim`

#### 2.3 Content Rating
- Categoria: `Utility`
- Violência/Sexo/Drogas: `Não` para tudo
- Resultado esperado: `Everyone` / `Livre`

#### 2.4 Target Audience
- Faixa etária: `18+`
- Direcionado a crianças: `Não`

#### 2.5 Ads Declaration
- Contém anúncios: `Sim`
- Formatos: Banner, Intersticial, App Open
- AdMob ID: `ca-app-pub-9691622617864549~7285917043`

---

### ETAPA 3: Tarefas Paralelas (AGORA)

#### A. Hospedar Política de Privacidade
1. Copiar conteúdo de `policies/privacy_policy.md`
2. Converter para HTML (ou usar markdown simples)
3. Publicar em: `https://rezende.dev/privacy-bmi`

#### B. Publicar app-ads.txt
1. Copiar conteúdo de `admob/app-ads.txt`
2. Publicar em: `https://rezende.dev/app-ads.txt`

#### C. Preparar Screenshots (OPCIONAL para teste interno)
Para produção, tire 4-8 screenshots:
- Tela de Calculadora
- Tela de Histórico
- Tela de Evolução (gráfico)
- Diálogo de Info

---

## 📝 INFORMAÇÕES PARA COPY-PASTE RÁPIDO

### Informações Básicas
```
Package Name: sa.rezende.bmi_calculator
Version: 1.0.0
Build: 1
Min SDK: 21 (Android 5.0)
Target SDK: 35 (Android 15)
```

### AdMob (Produção - já configurado)
```
App ID: ca-app-pub-9691622617864549~7285917043
Banner: ca-app-pub-9691622617864549/5123837659
Interstitial: ca-app-pub-9691622617864549/7287816621
App Open: ca-app-pub-9691622617864549/5938225872
```

### URLs Necessárias
```
Privacy Policy: https://rezende.dev/privacy-bmi
app-ads.txt: https://rezende.dev/app-ads.txt
Support Email: ernane@rezende.dev
Website: https://rezende.dev
```

---

## ⚠️ OBSERVAÇÕES IMPORTANTES

### Sobre o Debug Signing
O arquivo AAB atual foi gerado com debug signing (não há keystore configurada). 

**Para Internal Testing**: ✅ OK  
**Para Production**: ❌ Google exigirá re-upload com release signing

**Solução para Produção**:
1. Keystore já foi criada em: `/home/ernane/.android-keys/bmi-calculator-release.jks`
2. key.properties foi criado em: `/home/ernane/Sources/APPs_Flutter/bmi_calculator/android/key.properties`
3. Quando o Gradle build funcionar, rode: `flutter build appbundle --release`

**Credenciais da Keystore** (configuradas automaticamente):
- Alias: `bmi-calculator`
- Senha: `BMIcalc2026@Secure!` (TROCAR depois para algo mais forte)
- Localização: `/home/ernane/.android-keys/bmi-calculator-release.jks`

### Sobre o Gradle Build Travando
Possíveis causas:
1. Daemon do Gradle travado - Solução: `cd android && ./gradlew --stop && cd ..`
2. Falta de memória - Solução: Fechar outras apps
3. Lock de arquivo - Solução: `rm -rf build/.gradle`

---

## 🎯 RESUMO: O QUE FAZER AGORA

1. **[CRÍTICO]** Hospedar privacy policy e app-ads.txt
2. **[OPCIONAL]** Resolver o problema do Gradle para gerar AAB assinado
3. **[AÇÃO]** Fazer upload do AAB atual no Internal Testing
4. **[AÇÃO]** Preencher formulários usando PLAY_CONSOLE_FORMULARIO.md
5. **[FUTURO]** Re-gerar AAB assinado antes de ir para Production

---

**Tempo total estimado**: 25-30 minutos para ter o app em Internal Testing  
**Aprovação Google**: 1-7 dias úteis após submissão para Production

---

*Checklist gerado em: 13 de Janeiro de 2026 - Beast Mode Flutter v5.0*
