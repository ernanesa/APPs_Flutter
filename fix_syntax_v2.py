import os
import re

def fix_file(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()

    new_lines = []
    changed = False
    for line in lines:
        # Remove problematic imports
        if re.search(r"import '.*app_theme\.dart';", line):
            changed = True
            continue
        if re.search(r"import '.*locale_provider\.dart';", line):
            changed = True
            continue
        if "package:fasting_tracker/l10n/app_localizations.dart" in line:
            changed = True
            continue
        if "../l10n/app_localizations.dart" in line:
            changed = True
            continue
        
        # Replace l10n initialization
        if "final l10n = AppLocalizations.of(context)!;" in line:
            new_lines.append("    // l10n removed\n")
            changed = True
            continue
        
        # Replace l10n.something with "something"
        # We need to handle cases like Text(l10n.appTitle) -> Text("appTitle")
        # and l10n.notificationGoalReachedTitle -> "notificationGoalReachedTitle"
        new_line = re.sub(r"l10n\.(\w+)", r'"\1"', line)
        if new_line != line:
            changed = True
            line = new_line
            
        new_lines.append(line)

    if changed:
        with open(file_path, 'w') as f:
            f.writelines(new_lines)
        print(f"Fixed {file_path}")

def main():
    targets = [
        "packages/features",
        "apps/super_health_app"
    ]
    for target in targets:
        for root, dirs, files in os.walk(target):
            for file in files:
                if file.endswith(".dart"):
                    fix_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
