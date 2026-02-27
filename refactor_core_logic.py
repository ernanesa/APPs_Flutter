import os
import glob

def find_dart_files(root_dir):
    return glob.glob(os.path.join(root_dir, 'lib', '**', '*.dart'), recursive=True)

apps = ['bmi_calculator', 'compound_interest_calculator', 'fasting_tracker', 'pomodoro_timer', 'white_noise']

for app in apps:
    app_dir = os.path.join('apps', app)
    all_files = find_dart_files(app_dir)
    
    # Files to delete
    to_delete = [
        os.path.join(app_dir, 'lib', 'services', 'ad_service.dart'),
        os.path.join(app_dir, 'lib', 'services', 'consent_service.dart'),
        os.path.join(app_dir, 'lib', 'presentation', 'providers', 'shared_prefs_provider.dart'),
        os.path.join(app_dir, 'lib', 'providers', 'shared_prefs_provider.dart'),
    ]
    
    for df in to_delete:
        if os.path.exists(df):
            os.remove(df)
            print(f"Deleted local service: {df}")

    # Imports to replace
    bad_imports = [
        "import 'services/ad_service.dart';",
        "import '../services/ad_service.dart';",
        "import '../../services/ad_service.dart';",
        "import 'services/consent_service.dart';",
        "import '../services/consent_service.dart';",
        "import '../../services/consent_service.dart';",
        "import 'providers/shared_prefs_provider.dart';",
        "import '../providers/shared_prefs_provider.dart';",
        "import 'presentation/providers/shared_prefs_provider.dart';",
        "import '../presentation/providers/shared_prefs_provider.dart';",
        "import '../../presentation/providers/shared_prefs_provider.dart';"
    ]
    
    for f in all_files:
        if not os.path.exists(f):
            continue
            
        with open(f, 'r', encoding='utf-8') as file:
            content = file.read()
            
        original_content = content
        needs_core_logic = False
        
        for imp in bad_imports:
            if imp in content:
                needs_core_logic = True
                content = content.replace(imp, "") # Remove original
                
        if needs_core_logic:
            # We don't want to add duplicate imports
            if "import 'package:core_logic/core_logic.dart';" not in content:
                # Add after another import
                if "import 'package:flutter/material.dart';" in content:
                    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:core_logic/core_logic.dart';")
                elif "import 'package:flutter_riverpod/flutter_riverpod.dart';" in content:
                    content = content.replace("import 'package:flutter_riverpod/flutter_riverpod.dart';", "import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:core_logic/core_logic.dart';")
                else:
                    content = "import 'package:core_logic/core_logic.dart';\n" + content
                    
        # Formatting fixes (trim empty lines if we left any)
        if content != original_content:
            with open(f, 'w', encoding='utf-8') as file:
                file.write(content)
            print(f"Refactored: {f}")

