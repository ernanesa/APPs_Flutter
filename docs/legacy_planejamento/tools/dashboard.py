import os
from pathlib import Path

def analyze_factory():
    root = Path("apps")
    clusters = [d for d in root.iterdir() if d.is_dir()]
    
    total_apps = 0
    apps_with_tests = 0
    
    print("\n🏭 FLUTTER FACTORY HEALTH REPORT")
    print("=================================")
    
    for cluster in clusters:
        print(f"\n📦 Cluster: {cluster.name.upper()}")
        apps = [d for d in cluster.iterdir() if d.is_dir()]
        
        for app in apps:
            total_apps += 1
            test_dir = app / "test"
            
            has_visual = (test_dir / "visual").exists()
            has_func = (test_dir / "functional").exists()
            has_perf = (test_dir / "performance").exists()
            has_a11y = (test_dir / "a11y").exists()
            
            status = []
            if has_visual: status.append("👁️ Visual")
            if has_func: status.append("🧠 Logic")
            if has_perf: status.append("⚡ Perf")
            if has_a11y: status.append("♿ A11y")
            
            if len(status) == 4:
                apps_with_tests += 1
                icon = "✅"
            elif len(status) > 0:
                icon = "⚠️"
            else:
                icon = "❌"
                
            print(f"  {icon} {app.name:<25} | {', '.join(status) if status else 'No tests'}")

    print("\n📊 SUMMARY")
    print(f"Total Apps: {total_apps}")
    print(f"Beast Mode Ready: {apps_with_tests} ({int(apps_with_tests/total_apps*100)}%)")
    print("=================================\n")

if __name__ == "__main__":
    analyze_factory()
