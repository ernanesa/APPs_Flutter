import re
import os
import glob

def reg_rep(path, patterns):
    if not os.path.exists(path): return
    with open(path, 'r', encoding='utf-8') as f:
        c = f.read()
    for p, r in patterns:
        c = re.sub(p, r, c)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(c)

# 1. pomodoro_timer
reg_rep('apps/pomodoro_timer/lib/main.dart', [
    (r"ConsentService\.gatherConsent\([\s\S]*?\);", "await ConsentService.gatherConsent();")
])

for f in glob.glob('apps/pomodoro_timer/lib/providers/*.dart'):
    with open(f, 'r') as fp:
        c = fp.read()
    if 'sharedPreferencesProvider' in c and 'core_logic' not in c:
        c = "import 'package:core_logic/core_logic.dart';\n" + c
        with open(f, 'w') as fp:
            fp.write(c)

# compound interest main
reg_rep('apps/compound_interest_calculator/lib/main.dart', [
    (r"      AdService\.showAppOpenAdIfAvailable\(\);\n    \}\n  \}", "  }")
])

# white noise main
reg_rep('apps/white_noise/lib/main.dart', [
    (r"      AdService\.showAppOpenAdIfAvailable\(\);\n    \}\n  \}", "  }"),
    (r"  \}\n\n  @override\n  Widget build", "  }\n\n  @override\n  Widget build") # Add missing bracket if needed? Actually wait, my replace before removed BOTH. Let's just fix the missing brace manually by appending it if we count them. Let's just do a clean replace.
])

# fasting tracker l10n
for f in glob.glob('apps/fasting_tracker/lib/**/*.dart', recursive=True):
    reg_rep(f, [
        (r"import 'package:flutter_gen/gen_l10n/app_localizations\.dart';", "import 'package:fasting_tracker/l10n/app_localizations.dart';")
    ])

