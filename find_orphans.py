import os
import glob

def find_dart_files(root_dir):
    return glob.glob(os.path.join(root_dir, 'lib', '**', '*.dart'), recursive=True)

for app in ['bmi_calculator', 'compound_interest_calculator', 'fasting_tracker', 'pomodoro_timer', 'white_noise']:
    print(f"\n--- Checking {app} ---")
    app_dir = os.path.join('apps', app)
    all_files = find_dart_files(app_dir)
    
    # Read all contents to search imports
    file_contents = {}
    for f in all_files:
        with open(f, 'r', encoding='utf-8') as file:
            file_contents[f] = file.read()
            
    for f in all_files:
        if f.endswith('main.dart'):
            continue
            
        basename = os.path.basename(f)
        
        # Check if basename is imported in any OTHER file
        is_imported = False
        for other_f, content in file_contents.items():
            if f != other_f and basename in content:
                is_imported = True
                break
                
        if not is_imported:
            print(f"ORPHAN: {f}")

