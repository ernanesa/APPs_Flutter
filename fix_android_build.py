import os

def fix_gradle(path):
    if not os.path.exists(path): return
    with open(path, 'r') as f: content = f.read()
    
    # 1. Habilitar compileOptions Java 8
    if 'compileOptions {' not in content:
        content = content.replace('android {', 'android {\n    compileOptions {\n        coreLibraryDesugaringEnabled true\n        sourceCompatibility JavaVersion.VERSION_1_8\n        targetCompatibility JavaVersion.VERSION_1_8\n    }')
    
    # 2. Adicionar dependência de desugaring
    if 'dependencies {' in content and 'coreLibraryDesugaring' not in content:
        content = content.replace('dependencies {', 'dependencies {\n    coreLibraryDesugaring "com.android.tools:desugar_jdk_libs:2.0.3"')
        
    with open(path, 'w') as f: f.write(content)

# Aplicar em todos os apps
for root, dirs, files in os.walk('apps'):
    if 'build.gradle' in files and 'app' in root:
        fix_gradle(os.path.join(root, 'build.gradle'))

print("Gradle fix aplicado.")
