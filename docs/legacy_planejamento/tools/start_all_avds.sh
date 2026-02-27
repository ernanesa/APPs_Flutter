#!/bin/bash
# Script para iniciar todos os AVDs em paralelo no Linux

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Encontrar emulador
if [ -z "$ANDROID_HOME" ]; then
    # Tenta caminhos comuns
    if [ -d ~/Android/Sdk ]; then
        export ANDROID_HOME=~/Android/Sdk
    elif [ -d ~/android-sdk ]; then
        export ANDROID_HOME=~/android-sdk
    else
        echo -e "${RED}❌ ANDROID_HOME não configurado e SDK não encontrado${NC}"
        exit 1
    fi
fi

EMULATOR="$ANDROID_HOME/emulator/emulator"

if [ ! -f "$EMULATOR" ]; then
    echo -e "${RED}❌ Emulador não encontrado em: $EMULATOR${NC}"
    exit 1
fi

echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Iniciando todos os AVDs em paralelo  ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""

# Array de AVDs a iniciar
AVDS=("Phone_API24" "Phone_API35" "Tablet_API35")

# Iniciar cada AVD em um processo separado
PIDs=()
for avd in "${AVDS[@]}"; do
    echo -e "${YELLOW}▶ Iniciando $avd...${NC}"

    # Iniciar emulador em background
    "$EMULATOR" -avd "$avd" \
        -gpu host \
        -memory 4096 \
        -no-snapshot-save \
        -no-boot-anim \
        -accel on \
        -cores 4 \
        2>&1 | sed "s/^/[$avd] /" &

    PIDs+=($!)
    sleep 2  # Pequeno delay entre inicializações
    echo -e "${GREEN}✓ Processo de $avd iniciado (PID: ${PIDs[-1]})${NC}"
done

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Aguardando que os emuladores estejam prontos...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Aguardar que os emuladores apareçam no ADB
ADB="$ANDROID_HOME/platform-tools/adb"
MAX_WAIT=120  # 2 minutos máximo
ELAPSED=0

while [ $ELAPSED -lt $MAX_WAIT ]; do
    DEVICES=$("$ADB" devices 2>/dev/null | grep -E "emulator-[0-9]+" | wc -l)

    if [ "$DEVICES" -eq "${#AVDS[@]}" ]; then
        echo -e "${GREEN}✓ Todos os ${#AVDS[@]} emuladores estão prontos!${NC}"
        break
    fi

    echo -n "."
    sleep 2
    ELAPSED=$((ELAPSED + 2))
done

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Status dos dispositivos conectados:${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
"$ADB" devices

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ Todos os AVDs foram iniciados com sucesso!${NC}"
echo -e "${GREEN}✓ Você pode agora rodar os testes.${NC}"
echo ""
echo -e "${YELLOW}Dica: Para matar todos os emuladores depois:${NC}"
echo -e "${YELLOW}  killall emulator${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
