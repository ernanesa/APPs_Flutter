import os
import json
import urllib.request
import urllib.parse
import time
import re

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

def translate_text(text, target_lang):
    if not text.strip(): return text
    try:
        url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl={target_lang}&dt=t&q={urllib.parse.quote(text)}"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            result = json.loads(response.read().decode('utf-8'))
            return "".join([x[0] for x in result[0]])
    except Exception as e:
        print(f"Failed to translate '{text}': {e}")
        return text

def split_by_placeholders(text):
    return re.split(r'(\{[^\}]+\})', text)

for relative_path in ARB_FILES:
    filepath = os.path.join(WORKSPACE, relative_path)
    if not os.path.exists(filepath):
        continue
        
    print(f"Translating {relative_path}")
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
            else:
                if '{' in value:
                    parts = split_by_placeholders(value)
                    translated_parts = []
                    for part in parts:
                        if part.startswith('{') and part.endswith('}'):
                            translated_parts.append(part)
                        else:
                            translated_parts.append(translate_text(part, lang_code))
                    new_data[key] = "".join(translated_parts)
                else:
                    new_data[key] = translate_text(value, lang_code)
                    
        with open(new_filepath, 'w', encoding='utf-8') as f:
            json.dump(new_data, f, ensure_ascii=False, indent=2)
            
        print(f"  -> Created app_{lang_code}.arb")

print("All translations generated!")
