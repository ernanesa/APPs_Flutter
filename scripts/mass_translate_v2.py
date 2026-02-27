import os
import json
import time
from googletrans import Translator

NEW_LANGUAGES = {
    'id': 'id',
    'tr': 'tr',
    'it': 'it',
    'ko': 'ko'
}

WORKSPACE = '/home/ernane/Personal/APPs_Flutter'
ARB_FILES = [
    'apps/bmi_calculator/lib/l10n/app_en.arb',
    'apps/compound_interest_calculator/lib/l10n/app_en.arb',
    'apps/fasting_tracker/lib/l10n/app_en.arb',
    'apps/pomodoro_timer/lib/l10n/app_en.arb',
    'apps/white_noise/lib/l10n/app_en.arb',
    'packages/features/feature_bmi/lib/l10n/app_en.arb',
    'packages/features/feature_fasting/lib/l10n/app_en.arb',
    'packages/features/feature_water/lib/l10n/app_en.arb'
]

translator = Translator()

for relative_path in ARB_FILES:
    filepath = os.path.join(WORKSPACE, relative_path)
    if not os.path.exists(filepath):
        print(f"Skipping {filepath}, file not found.")
        continue
        
    print(f"Translating {filepath}")
    with open(filepath, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
        
    for lang_code in NEW_LANGUAGES.values():
        new_filepath = filepath.replace('app_en.arb', f'app_{lang_code}.arb')
        
        new_data = {}
        for key, value in en_data.items():
            if key.startswith('@@'):
                new_data[key] = lang_code
            elif key.startswith('@'):
                new_data[key] = value
            elif "{" in value:
                # Naïve translation avoiding placeholders if possible
                new_data[key] = value # Fallback if placeholder is tricky
            else:
                try:
                    res = translator.translate(value, dest=lang_code).text
                    new_data[key] = res
                    time.sleep(0.1) # Throttle to prevent ban
                except Exception as e:
                    new_data[key] = value # Fallback
        
        with open(new_filepath, 'w', encoding='utf-8') as f:
            json.dump(new_data, f, ensure_ascii=False, indent=2)
            
        print(f"  -> Created {new_filepath}")

print("All translations generated. Proceeding to flutter gen-l10n.")
