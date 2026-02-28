import os
import re

directories = ['apps', 'packages/features']

replacements = [
    (r'\.currentStreak', '.streak'),
    (r'currentStreak:', 'streak:'),
    (r'ref\.watch\(achievementsProvider\)', 'null'),
    (r'ref\.read\(achievementsProvider\.notifier\)', 'null'),
]

for d in directories:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                new_content = content
                for old, new in replacements:
                    new_content = re.sub(old, new, new_content)
                
                if new_content != content:
                    with open(path, 'w', encoding='utf-8') as file:
                        file.write(new_content)
                    print(f"Refatorado: {path}")

