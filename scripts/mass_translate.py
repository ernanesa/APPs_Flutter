import os
import json
import glob
import sys
from deep_translator import GoogleTranslator

# The languages to add
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
    'packages/features/feature_fasting/lib/l10n/app_en.arb'
]

import re
def split_by_placeholders(text):
    return re.split(r'(\{[^\}]+\})', text)

for relative_path in ARB_FILES:
    filepath = os.path.join(WORKSPACE, relative_path)
    if not os.path.exists(filepath):
        print(f"Skipping {filepath}, file not found.")
        continue
        
    print(f"Translating {filepath}")
    with open(filepath, 'r', encoding='utf-8') as f:
        en_data = json.load(f)
        
    for lang_code, lang_name in NEW_LANGUAGES.items():
        new_filepath = filepath.replace('app_en.arb', f'app_{lang_code}.arb')
        
        new_data = {}
        translator = GoogleTranslator(source='en', target=lang_code)
        
        for key, value in en_data.items():
            if key.startswith('@@'):
                new_data[key] = lang_code
            elif key.startswith('@'):
                new_data[key] = value # Metadata stays the same
            else:
                # Text translation
                if '{' in value:
                    parts = split_by_placeholders(value)
                    translated_parts = []
                    for part in parts:
                        if part.startswith('{') and part.endswith('}'):
                            translated_parts.append(part)
                        elif part.strip() == '':
                            translated_parts.append(part)
                        else:
                            try:
                                translated_parts.append(translator.translate(part))
                            except Exception as e:
                                translated_parts.append(part) # Fallback
                    new_data[key] = "".join(translated_parts)
                else:
                    if value.strip() == '':
                        new_data[key] = value
                    else:
                        try:
                            new_data[key] = translator.translate(value)
                        except Exception as e:
                            print(f"Error translating {value}: {e}")
                            new_data[key] = value # Fallback
        
        with open(new_filepath, 'w', encoding='utf-8') as f:
            json.dump(new_data, f, ensure_ascii=False, indent=2)
            
        print(f"  -> Created {new_filepath}")

print("All translations generated. Proceeding to flutter gen-l10n.")
