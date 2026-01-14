# BMI Calculator - Dados de Publicação

## Informações do App

| Campo | Valor |
|-------|-------|
| **Nome do App** | BMI Calculator |
| **Package Name** | sa.rezende.bmi_calculator |
| **Versão** | 1.0.0+1 |
| **Target SDK** | 35 (Android 15) |
| **Min SDK** | 21 (Android 5.0) |
| **Formato** | Android App Bundle (.aab) |

---

## Configuração AdMob

### App ID
```
ca-app-pub-9691622617864549~7285917043
```

### Ad Units (Produção)

| Formato | Nome | ID |
|---------|------|-----|
| Banner | BMI Banner | `ca-app-pub-9691622617864549/5123837659` |
| Interstitial | BMI Interstitial | `ca-app-pub-9691622617864549/7287816621` |
| App Open | BMI App Open | `ca-app-pub-9691622617864549/5938225872` |

### Estratégia de Monetização
- **Banner:** Exibido na tela da calculadora
- **Interstitial:** Mostrado a cada 3 cálculos salvos
- **App Open:** Mostrado quando app volta ao foreground (não na 1ª abertura)

---

## Checklist de Publicação

### ✅ Requisitos Técnicos Concluídos
- [x] AGP atualizado para 8.5.1
- [x] Compatibilidade 16KB page size
- [x] IDs de AdMob de produção configurados
- [x] minifyEnabled true + shrinkResources true
- [x] ProGuard rules configuradas
- [x] Linting configurado
- [x] 11 idiomas implementados

### ⏳ Pendentes (Ação do Usuário)
- [ ] Gerar keystore de produção
- [ ] Build release (.aab)
- [ ] Screenshots do app
- [ ] Feature graphic
- [ ] Upload para Play Console
- [ ] Preencher Data Safety form
- [ ] Publicar app-ads.txt no site

---

## Comandos para Publicação

### 1. Gerar Keystore (executar uma vez)
```bash
keytool -genkey -v -keystore ~/bmi-upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Criar key.properties (android/key.properties)
```properties
storePassword=<sua_senha>
keyPassword=<sua_senha>
keyAlias=upload
storeFile=/home/ernane/bmi-upload-keystore.jks
```

### 3. Build Release
```bash
cd /home/ernane/Sources/APPs_Flutter/bmi_calculator
flutter build appbundle --release
```

### 4. Localização do AAB
```
build/app/outputs/bundle/release/app-release.aab
```

---

## Textos para a Play Store

### Título (30 caracteres)
```
BMI Calculator - Health
```

### Descrição Curta (80 caracteres)
```
Calculate your Body Mass Index quickly and track your health evolution over time.
```

### Descrição Completa (4000 caracteres)
```
📊 BMI CALCULATOR - Your Complete Health Companion

Calculate your Body Mass Index (BMI) in seconds and track your health journey with our beautiful, easy-to-use app.

✨ KEY FEATURES:

• 🧮 INSTANT CALCULATION
  Enter your weight and height to get your BMI instantly. Supports both kg/cm and automatic unit detection.

• 📈 EVOLUTION TRACKING
  Keep a complete history of your measurements. Watch your progress with beautiful interactive charts.

• 🌍 11 LANGUAGES
  Available in English, Portuguese, Spanish, Chinese, Hindi, Arabic, Bengali, Russian, Japanese, German, and French.

• 🎨 BEAUTIFUL DESIGN
  Modern Material 3 design with dark mode support. Adapts to your device's theme.

• 📱 WORKS OFFLINE
  No internet required. All your data stays on your device.

• 🔒 PRIVACY FOCUSED
  Your health data never leaves your device. We don't collect personal information.

📋 BMI CATEGORIES:
• Underweight: < 18.5
• Normal: 18.5 - 24.9
• Overweight: 25.0 - 29.9
• Obesity Class I: 30.0 - 34.9
• Obesity Class II: 35.0 - 39.9
• Obesity Class III: > 40.0

💡 Why track your BMI?
Body Mass Index is a useful screening tool to identify potential weight problems in adults. Regular tracking helps you stay motivated and aware of your health status.

🏥 Note: BMI is a general indicator. For personalized health advice, always consult a healthcare professional.

Download now and start your journey to a healthier you! 💪
```

---

## Arquivos Necessários

| Arquivo | Localização | Status |
|---------|-------------|--------|
| Keystore | ~/bmi-upload-keystore.jks | ⏳ Gerar |
| key.properties | android/key.properties | ⏳ Criar |
| Icon 512x512 | DadosPublicacao/bmi_calculator/store_assets/ | ⏳ Exportar |
| Feature Graphic | DadosPublicacao/bmi_calculator/store_assets/ | ⏳ Criar |
| Screenshots | DadosPublicacao/bmi_calculator/store_assets/screenshots/ | ⏳ Capturar |
| Privacy Policy | DadosPublicacao/bmi_calculator/policies/privacy_policy.md | ✅ Criado |
| AdMob IDs | DadosPublicacao/bmi_calculator/admob/admob_ids.json | ✅ Criado |

---

## Data Safety (Google Play Console)

### Respostas para o formulário:

| Pergunta | Resposta |
|----------|----------|
| O app coleta dados do usuário? | Sim |
| Quais dados são coletados? | Informações de saúde (peso, altura) - armazenadas localmente |
| Os dados são compartilhados? | Não diretamente, mas anúncios podem coletar IDs de publicidade |
| Os dados são criptografados? | Sim (armazenamento local) |
| Usuários podem solicitar exclusão? | Sim (deletar histórico no app) |

---

## Contatos

- **Desenvolvedor:** Ernane Rezende
- **Email:** ernane@rezende.dev
- **Website:** https://rezende.dev
- **Privacy Policy URL:** https://rezende.dev/apps/bmi-calculator/privacy

---

*Documento gerado em: 13 de Janeiro de 2026*
