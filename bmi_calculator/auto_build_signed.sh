#!/bin/bash

# ============================================================================
# SCRIPT AUTOMATIZADO DE BUILD ASSINADO (SEM INTERAÇÃO)
# ============================================================================

set -e

echo "🔐 GERAÇÃO AUTOMÁTICA DE KEYSTORE E BUILD ASSINADO"
echo "===================================================="

# Configurações
APP_DIR="/home/ernane/Sources/APPs_Flutter/bmi_calculator"
KEYS_DIR="$HOME/.android-keys"
KEYSTORE_FILE="$KEYS_DIR/bmi-calculator-release.jks"
KEY_PROPERTIES="$APP_DIR/android/key.properties"
KEY_ALIAS="bmi-calculator"

# Senhas automáticas (MUDE DEPOIS PARA ALGO SEGURO!)
STORE_PASSWORD="BMIcalc2026@Secure!"
KEY_PASSWORD="BMIcalc2026@Secure!"

# Cores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Criar diretório de keys
mkdir -p "$KEYS_DIR"
chmod 700 "$KEYS_DIR"

# Verificar se keystore já existe
if [ -f "$KEYSTORE_FILE" ]; then
    echo -e "${GREEN}✓${NC} Usando keystore existente"
else
    echo -e "${YELLOW}[1/4]${NC} Gerando keystore com dados automáticos..."
    
    # Gerar keystore com dados pré-configurados
    keytool -genkey -v \
        -keystore "$KEYSTORE_FILE" \
        -alias "$KEY_ALIAS" \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -storetype JKS \
        -storepass "$STORE_PASSWORD" \
        -keypass "$KEY_PASSWORD" \
        -dname "CN=Ernane Rezende, OU=Development, O=sa.rezende, L=Brasil, ST=Brasil, C=BR"
    
    echo -e "${GREEN}✓${NC} Keystore criada!"
fi

# Criar key.properties
echo -e "${YELLOW}[2/4]${NC} Criando key.properties..."
cat > "$KEY_PROPERTIES" <<EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE_FILE
EOF

chmod 600 "$KEY_PROPERTIES"
echo -e "${GREEN}✓${NC} Arquivo key.properties criado"

# Limpar e preparar
echo -e "${YELLOW}[3/4]${NC} Limpando projeto..."
cd "$APP_DIR"
flutter clean > /dev/null 2>&1
flutter pub get > /dev/null 2>&1
flutter gen-l10n > /dev/null 2>&1
echo -e "${GREEN}✓${NC} Projeto preparado"

# Build
echo -e "${YELLOW}[4/4]${NC} Gerando App Bundle ASSINADO..."
flutter build appbundle --release

AAB_FILE="$APP_DIR/build/app/outputs/bundle/release/app-release.aab"

if [ -f "$AAB_FILE" ]; then
    AAB_SIZE=$(du -h "$AAB_FILE" | cut -f1)
    
    # Copiar para pasta de publicação
    PUBLISH_DIR="/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator"
    cp "$AAB_FILE" "$PUBLISH_DIR/app-release-SIGNED.aab"
    
    echo ""
    echo -e "${GREEN}✅ BUILD ASSINADO CONCLUÍDO!${NC}"
    echo "=============================="
    echo ""
    echo "📦 App Bundle: $PUBLISH_DIR/app-release-SIGNED.aab"
    echo "📏 Tamanho: $AAB_SIZE"
    echo ""
    echo "🔑 CREDENCIAIS DA KEYSTORE:"
    echo "   Localização: $KEYSTORE_FILE"
    echo "   Alias: $KEY_ALIAS"
    echo "   Senha Store: $STORE_PASSWORD"
    echo "   Senha Key: $KEY_PASSWORD"
    echo ""
    echo "⚠️  FAÇA BACKUP DA KEYSTORE EM LOCAL SEGURO!"
    echo ""
    echo "🚀 Pronto para upload no Play Console!"
else
    echo "❌ ERRO: Build falhou!"
    exit 1
fi
