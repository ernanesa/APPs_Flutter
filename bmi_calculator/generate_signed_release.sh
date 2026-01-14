#!/bin/bash

# ============================================================================
# SCRIPT DE GERAÇÃO DE KEYSTORE E BUILD ASSINADO
# ============================================================================
# 
# Este script gera uma keystore de produção e faz o build do App Bundle
# assinado e pronto para upload no Google Play Console.
#
# Uso: bash generate_signed_release.sh
# ============================================================================

set -e  # Interromper em caso de erro

echo "🔐 GERAÇÃO DE KEYSTORE E BUILD ASSINADO"
echo "========================================"
echo ""

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Diretórios
APP_DIR="/home/ernane/Sources/APPs_Flutter/bmi_calculator"
KEYS_DIR="$HOME/.android-keys"
KEYSTORE_FILE="$KEYS_DIR/bmi-calculator-release.jks"
KEY_PROPERTIES="$APP_DIR/android/key.properties"

# Informações da Keystore (EDITAR CONFORME NECESSÁRIO)
KEY_ALIAS="bmi-calculator"
KEY_VALIDITY=10000  # 27+ anos
KEY_SIZE=2048
KEY_ALG="RSA"

# ============================================================================
# PASSO 1: Criar diretório para keys (se não existir)
# ============================================================================

echo -e "${YELLOW}[1/5]${NC} Verificando diretório de keys..."
if [ ! -d "$KEYS_DIR" ]; then
    mkdir -p "$KEYS_DIR"
    chmod 700 "$KEYS_DIR"
    echo -e "${GREEN}✓${NC} Diretório criado: $KEYS_DIR"
else
    echo -e "${GREEN}✓${NC} Diretório já existe"
fi

# ============================================================================
# PASSO 2: Gerar Keystore (se não existir)
# ============================================================================

if [ -f "$KEYSTORE_FILE" ]; then
    echo -e "${YELLOW}[2/5]${NC} Keystore já existe em: $KEYSTORE_FILE"
    read -p "Deseja sobrescrever? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Usando keystore existente..."
    else
        rm -f "$KEYSTORE_FILE"
        echo "Keystore removida. Gerando nova..."
        
        echo -e "${YELLOW}[2/5]${NC} Gerando keystore de produção..."
        echo ""
        echo "⚠️  IMPORTANTE: Guarde estas senhas em local SEGURO!"
        echo "    Se perder, NUNCA poderá atualizar o app na Play Store!"
        echo ""
        
        keytool -genkey -v \
            -keystore "$KEYSTORE_FILE" \
            -alias "$KEY_ALIAS" \
            -keyalg "$KEY_ALG" \
            -keysize "$KEY_SIZE" \
            -validity "$KEY_VALIDITY" \
            -storetype JKS
        
        echo -e "${GREEN}✓${NC} Keystore gerada com sucesso!"
    fi
else
    echo -e "${YELLOW}[2/5]${NC} Gerando keystore de produção..."
    echo ""
    echo "⚠️  IMPORTANTE: Guarde estas senhas em local SEGURO!"
    echo "    Se perder, NUNCA poderá atualizar o app na Play Store!"
    echo ""
    
    keytool -genkey -v \
        -keystore "$KEYSTORE_FILE" \
        -alias "$KEY_ALIAS" \
        -keyalg "$KEY_ALG" \
        -keysize "$KEY_SIZE" \
        -validity "$KEY_VALIDITY" \
        -storetype JKS
    
    echo -e "${GREEN}✓${NC} Keystore gerada com sucesso!"
fi

# ============================================================================
# PASSO 3: Criar arquivo key.properties
# ============================================================================

echo -e "${YELLOW}[3/5]${NC} Criando arquivo key.properties..."

read -sp "Digite a senha da keystore: " STORE_PASSWORD
echo ""
read -sp "Digite a senha da key (pode ser a mesma): " KEY_PASSWORD
echo ""

cat > "$KEY_PROPERTIES" <<EOF
storePassword=$STORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=$KEYSTORE_FILE
EOF

chmod 600 "$KEY_PROPERTIES"
echo -e "${GREEN}✓${NC} Arquivo key.properties criado em: $KEY_PROPERTIES"

# ============================================================================
# PASSO 4: Limpar build anterior e atualizar dependências
# ============================================================================

echo -e "${YELLOW}[4/5]${NC} Limpando build anterior..."
cd "$APP_DIR"
flutter clean
flutter pub get
flutter gen-l10n
echo -e "${GREEN}✓${NC} Projeto limpo e pronto"

# ============================================================================
# PASSO 5: Build do App Bundle assinado
# ============================================================================

echo -e "${YELLOW}[5/5]${NC} Gerando App Bundle assinado..."
echo ""
flutter build appbundle --release

AAB_FILE="$APP_DIR/build/app/outputs/bundle/release/app-release.aab"

if [ -f "$AAB_FILE" ]; then
    AAB_SIZE=$(du -h "$AAB_FILE" | cut -f1)
    echo ""
    echo -e "${GREEN}✅ BUILD CONCLUÍDO COM SUCESSO!${NC}"
    echo "=================================="
    echo ""
    echo "📦 App Bundle: $AAB_FILE"
    echo "📏 Tamanho: $AAB_SIZE"
    echo ""
    
    # Copiar para pasta de publicação
    PUBLISH_DIR="/home/ernane/Sources/APPs_Flutter/DadosPublicacao/bmi_calculator"
    cp "$AAB_FILE" "$PUBLISH_DIR/app-release-SIGNED.aab"
    echo -e "${GREEN}✓${NC} Cópia criada em: $PUBLISH_DIR/app-release-SIGNED.aab"
    echo ""
    
    echo "🚀 PRÓXIMOS PASSOS:"
    echo "==================="
    echo "1. Upload do arquivo no Play Console"
    echo "2. Preencher formulários usando: PLAY_CONSOLE_FORMULARIO.md"
    echo "3. Submeter para revisão"
    echo ""
    echo "⚠️  BACKUP DA KEYSTORE:"
    echo "   Faça backup do arquivo: $KEYSTORE_FILE"
    echo "   E do arquivo: $KEY_PROPERTIES"
    echo "   Guarde em local SEGURO (cloud, pendrive criptografado, etc)"
    echo ""
else
    echo -e "${RED}❌ ERRO: Build falhou!${NC}"
    exit 1
fi
