import os
import re

directories_to_scan = ['apps', 'packages/features']

# Delete local locale providers
for d in directories_to_scan:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f == 'locale_provider.dart':
                path = os.path.join(root, f)
                print(f"Limpando provedor de idioma local: {path}")
                os.remove(path)

# Regex to fix main.dart and any other file using the wrong theme properties
for d in directories_to_scan:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f.endswith('.dart'):
                path = os.path.join(root, f)
                with open(path, 'r', encoding='utf-8') as file:
                    content = file.read()
                
                new_content = content
                
                # Remove local locale provider imports
                new_content = re.sub(r"import\s+['\"].*?locale_provider\.dart['\"];", "", new_content)
                
                # Fix themeState properties
                new_content = new_content.replace('selectedTheme.primaryColor', 'selectedTheme.seedColor')
                new_content = new_content.replace('themeProvider).primaryColor', 'themeProvider).seedColor')
                
                # In main.dart, ensure we are using ConsumerWidget if it's the root app
                if f == 'main.dart' and 'class SuperHealthApp extends StatelessWidget' in new_content:
                    new_content = new_content.replace('class SuperHealthApp extends StatelessWidget', 'class SuperHealthApp extends ConsumerWidget')
                    new_content = new_content.replace('Widget build(BuildContext context) {', 'Widget build(BuildContext context, WidgetRef ref) {\n    final themeState = ref.watch(themeProvider);\n    final locale = ref.watch(localeProvider);')
                    
                    new_content = new_content.replace(
                        'theme: AppTheme.lightTheme(Colors.deepPurple),', 
                        'themeMode: themeState.mode,\n      theme: AppTheme.lightTheme(themeState.seedColor),\n      darkTheme: AppTheme.darkTheme(themeState.seedColor),\n      locale: locale,'
                    )

                if new_content != content:
                    with open(path, 'w', encoding='utf-8') as file:
                        file.write(new_content)
                    print(f"Atualizado: {path}")

print("Integração Global concluída.")
