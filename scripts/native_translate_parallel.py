import os
import json
import urllib.request
import urllib.parse
import re
from concurrent.futures import ThreadPoolExecutor, as_completed

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

def split_by_placeholders(text):
    return re.split(r'(\{[^\}]+\})', text)

def translate_single_text(text, target_lang):
    if not text.strip(): return text
    try:
        url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl={target_lang}&dt=t&q={urllib.parse.quote(text)}"
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=10) as response:
            result = json.loads(response.read().decode('utf-8'))
            return "".join([x[0] for x in result[0]])
    except Exception as e:
        return text

def process_translation_job(filepath, lang_code, en_data):
    new_filepath = filepath.replace('app_en.arb', f'app_{lang_code}.arb')
    new_data = {}
    
    # Pre-calculate what to translate
    to_translate = []
    
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
                        translated_parts.append(translate_single_text(part, lang_code))
                new_data[key] = "".join(translated_parts)
            else:
                new_data[key] = translate_single_text(value, lang_code)
                
    with open(new_filepath, 'w', encoding='utf-8') as f:
        json.dump(new_data, f, ensure_ascii=False, indent=2)
        
    return f"Created {new_filepath}"

def main():
    jobs = []
    with ThreadPoolExecutor(max_workers=30) as executor:
        for relative_path in ARB_FILES:
            filepath = os.path.join(WORKSPACE, relative_path)
            if not os.path.exists(filepath):
                continue
            with open(filepath, 'r', encoding='utf-8') as f:
                en_data = json.load(f)
            for lang_code in NEW_LANGUAGES.values():
                jobs.append(executor.submit(process_translation_job, filepath, lang_code, en_data))
                
        for future in as_completed(jobs):
            try:
                print(future.result())
            except Exception as e:
                print(f"Job failed: {e}")
                
if __name__ == '__main__':
    main()
