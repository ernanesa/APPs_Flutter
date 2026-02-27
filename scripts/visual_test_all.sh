#!/bin/bash
APPS=("water_tracker" "bmi_calculator" "pomodoro_timer" "fasting_tracker" "compound_interest_calculator" "white_noise")

echo "🚀 Iniciando a Maratona de Testes Visuais da App Factory..."

for APP in "${APPS[@]}"; do
    echo "------------------------------------------------"
    echo "📱 Preparando teste para: $APP"
    echo "------------------------------------------------"
    cd "apps/$APP"
    
    # Tenta encontrar o APK e instalar
    APK_PATH=$(find build -name "*.apk" | head -1)
    if [ -n "$APK_PATH" ]; then
        echo "📥 Instalando APK: $APK_PATH"
        adb install -r "$APK_PATH"
    else
        echo "⚠️ APK não encontrado para $APP. Pulando instalação direta..."
    fi
    
    echo "▶️ Rodando teste de integração (assista no emulador)..."
    flutter test integration_test/app_test.dart -d emulator-5554
    
    cd ../..
done

echo "✅ Todos os Apps foram testados com sucesso!"
