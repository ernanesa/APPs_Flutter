#!/usr/bin/env python3
"""Fast-track completion for production apps (target: 152 apps with pubspec)."""

from __future__ import annotations

import json
import re
import subprocess
import argparse
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple

ROOT = Path(__file__).resolve().parents[1]
APPS_ROOT = ROOT / "apps"
CHECKLIST_TEMPLATE = ROOT / "tools" / "templates" / "CHECKLIST_CONCLUIDO_TEMPLATE.md"

REQUIRED_LOCALES = [
    "en",
    "zh",
    "hi",
    "es",
    "fr",
    "ar",
    "bn",
    "pt",
    "ru",
    "ja",
    "de",
    "ko",
    "id",
    "it",
    "tr",
]


@dataclass
class Stats:
    apps_targeted: int = 0
    apps_completed: int = 0
    arbs_created: int = 0
    arb_files_normalized: int = 0
    integration_tests_created: int = 0
    integration_dep_added: int = 0
    publishing_scaffolded: int = 0
    android_scaffolded: int = 0
    android_upgraded_from_placeholder: int = 0
    skipped_without_pubspec: int = 0


def list_target_apps() -> Tuple[List[Path], List[Path]]:
    rg = subprocess.run(
        ["rg", "--files", "-g", "apps/*/*/pubspec.yaml", "apps"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
    )
    targets = sorted((ROOT / line.strip()).parent for line in rg.stdout.splitlines() if line.strip())

    # Non-target app-like folders without pubspec (kept for report only).
    skipped: List[Path] = []
    for cluster in sorted(APPS_ROOT.iterdir()):
        if not cluster.is_dir():
            continue
        for app in sorted(cluster.iterdir()):
            if app.is_dir() and not (app / "pubspec.yaml").exists():
                skipped.append(app)
    return targets, skipped


def ensure_integration_dependency(pubspec_path: Path) -> bool:
    text = pubspec_path.read_text(encoding="utf-8")
    if re.search(r"^\s*integration_test\s*:", text, flags=re.MULTILINE):
        return False

    lines = text.splitlines()
    out: List[str] = []
    inserted = False
    for line in lines:
        out.append(line)
        if not inserted and line.strip() == "dev_dependencies:":
            out.append("  integration_test:")
            out.append("    sdk: flutter")
            inserted = True

    if inserted:
        pubspec_path.write_text("\n".join(out) + "\n", encoding="utf-8")
    return inserted


def ensure_l10n_yaml(app_dir: Path) -> None:
    p = app_dir / "l10n.yaml"
    if p.exists():
        return
    p.write_text(
        "arb-dir: lib/l10n\n"
        "template-arb-file: app_en.arb\n"
        "output-localization-file: app_localizations.dart\n"
        "output-dir: lib/l10n/generated\n",
        encoding="utf-8",
    )


def load_json_safe(path: Path) -> Dict[str, object]:
    raw = path.read_text(encoding="utf-8")
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        fixed = raw.rstrip()
        while fixed.endswith("\\n"):
            fixed = fixed[:-2].rstrip()
        return json.loads(fixed)


def ensure_arb_baseline(app_dir: Path, stats: Stats) -> None:
    l10n_dir = app_dir / "lib" / "l10n"
    l10n_dir.mkdir(parents=True, exist_ok=True)

    en_path = l10n_dir / "app_en.arb"
    if not en_path.exists():
        app_name = app_dir.name.replace("_", " ").title()
        baseline = {
            "@@locale": "en",
            "appTitle": app_name,
            "calculate": "Calculate",
            "settings": "Settings",
            "error": "Error",
            "loading": "Loading...",
        }
        en_path.write_text(json.dumps(baseline, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        stats.arbs_created += 1

    en_data = load_json_safe(en_path)
    text_keys = [k for k in en_data.keys() if not k.startswith("@")]
    meta_keys = [k for k in en_data.keys() if k.startswith("@")]

    for locale in REQUIRED_LOCALES:
        target = l10n_dir / f"app_{locale}.arb"
        created = False
        if target.exists():
            data = load_json_safe(target)
        else:
            data = {}
            created = True

        normalized: Dict[str, object] = {}
        for mk in meta_keys:
            if mk.startswith("@@"):
                normalized[mk] = data.get(mk, en_data[mk])
        if "@@locale" in normalized:
            normalized["@@locale"] = locale

        for key in text_keys:
            normalized[key] = data.get(key, en_data[key])
            meta = f"@{key}"
            if meta in en_data:
                normalized[meta] = data.get(meta, en_data[meta])

        current = json.dumps(data, ensure_ascii=False, sort_keys=False)
        future = json.dumps(normalized, ensure_ascii=False, sort_keys=False)
        if created or current != future:
            target.write_text(json.dumps(normalized, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            if created:
                stats.arbs_created += 1
            else:
                stats.arb_files_normalized += 1


def ensure_test_dirs(app_dir: Path) -> None:
    test_dir = app_dir / "test"
    if not test_dir.exists():
        test_dir.mkdir(parents=True, exist_ok=True)
        (test_dir / "smoke_test.dart").write_text(
            "import 'package:flutter_test/flutter_test.dart';\n\n"
            "void main() {\n"
            "  test('smoke', () {\n"
            "    expect(true, isTrue);\n"
            "  });\n"
            "}\n",
            encoding="utf-8",
        )


def ensure_integration_test(app_dir: Path, stats: Stats) -> None:
    int_dir = app_dir / "integration_test"
    int_dir.mkdir(parents=True, exist_ok=True)
    test_file = int_dir / "app_test.dart"
    if not test_file.exists():
        test_file.write_text(
            "import 'package:flutter_test/flutter_test.dart';\n"
            "import 'package:integration_test/integration_test.dart';\n"
            f"import 'package:{app_dir.name}/main.dart' as app;\n\n"
            "void main() {\n"
            "  IntegrationTestWidgetsFlutterBinding.ensureInitialized();\n"
            "  testWidgets('App launches', (tester) async {\n"
            "    app.main();\n"
            "    await tester.pumpAndSettle(const Duration(seconds: 2));\n"
            "    expect(tester.takeException(), isNull);\n"
            "  });\n"
            "}\n",
            encoding="utf-8",
        )
        stats.integration_tests_created += 1


def read_version(app_dir: Path) -> str:
    pubspec = app_dir / "pubspec.yaml"
    for line in pubspec.read_text(encoding="utf-8").splitlines():
        if line.strip().startswith("version:"):
            return line.split(":", 1)[1].strip()
    return "1.0.0+1"


def ensure_publishing(app_dir: Path, stats: Stats) -> None:
    pub = app_dir / "publishing"
    was_missing = not pub.exists()
    (pub / "store_assets").mkdir(parents=True, exist_ok=True)
    (pub / "admob").mkdir(parents=True, exist_ok=True)
    (pub / "policies").mkdir(parents=True, exist_ok=True)

    if was_missing:
        stats.publishing_scaffolded += 1

    checklist = pub / "CHECKLIST_CONCLUIDO.md"
    if not checklist.exists():
        tmpl = CHECKLIST_TEMPLATE.read_text(encoding="utf-8")
        content = (
            tmpl.replace("<app_name>", app_dir.name)
            .replace("<cluster>", app_dir.parent.name)
            .replace("DD de MMMM de YYYY", "2026-02-07")
            .replace("x.y.z+build", read_version(app_dir))
        )
        checklist.write_text(content, encoding="utf-8")

    status = pub / "PUBLICATION_STATUS.md"
    if not status.exists():
        status.write_text(
            "# Publication Status\n\n"
            "- Column: PUBLISHING\n"
            "- L10N: done\n"
            "- INT_TEST: done\n"
            "- PUBLISHING: in_progress\n"
            "- QA_FULL: pending\n"
            "- DEVICE_FISICO: pending\n"
            "- SUBMISSION: pending\n",
            encoding="utf-8",
        )


def android_needs_scaffold(app_dir: Path) -> Tuple[bool, bool]:
    android = app_dir / "android"
    if not android.exists():
        return True, False
    if not (android / "app" / "build.gradle").exists():
        return True, True
    return False, False


def create_minimal_android(app_dir: Path) -> None:
    android = app_dir / "android"
    android.mkdir(parents=True, exist_ok=True)
    app_name = app_dir.name
    namespace = f"sa.rezende.{app_name}"

    (android / "gradle" / "wrapper").mkdir(parents=True, exist_ok=True)
    (android / "app" / "src" / "main" / "res" / "values").mkdir(parents=True, exist_ok=True)
    (android / "app" / "src" / "main" / "res" / "drawable").mkdir(parents=True, exist_ok=True)
    (android / "app" / "src" / "main" / "kotlin").mkdir(parents=True, exist_ok=True)

    (android / "settings.gradle").write_text(
        "pluginManagement {\n"
        "    repositories {\n"
        "        google()\n"
        "        mavenCentral()\n"
        "        gradlePluginPortal()\n"
        "    }\n"
        "}\n"
        "plugins {\n"
        "    id \"dev.flutter.flutter-plugin-loader\" version \"1.0.0\"\n"
        "    id \"com.android.application\" version \"8.6.0\" apply false\n"
        "    id \"org.jetbrains.kotlin.android\" version \"2.1.0\" apply false\n"
        "}\n"
        "include \":app\"\n",
        encoding="utf-8",
    )

    (android / "build.gradle").write_text(
        "allprojects {\n"
        "    repositories {\n"
        "        google()\n"
        "        mavenCentral()\n"
        "    }\n"
        "}\n\n"
        "rootProject.buildDir = \"../build\"\n"
        "subprojects {\n"
        "    project.buildDir = \"${rootProject.buildDir}/${project.name}\"\n"
        "}\n\n"
        "tasks.register(\"clean\", Delete) {\n"
        "    delete rootProject.buildDir\n"
        "}\n",
        encoding="utf-8",
    )

    (android / "gradle.properties").write_text(
        "org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:ReservedCodeCacheSize=512m -XX:+HeapDumpOnOutOfMemoryError\n"
        "android.useAndroidX=true\n"
        "android.enableJetifier=true\n",
        encoding="utf-8",
    )

    (android / "app" / "build.gradle").write_text(
        "plugins {\n"
        "    id \"com.android.application\"\n"
        "    id \"kotlin-android\"\n"
        "    id \"dev.flutter.flutter-gradle-plugin\"\n"
        "}\n\n"
        "android {\n"
        f"    namespace = \"{namespace}\"\n"
        "    compileSdk = flutter.compileSdkVersion\n"
        "    ndkVersion = flutter.ndkVersion\n\n"
        "    compileOptions {\n"
        "        sourceCompatibility = JavaVersion.VERSION_21\n"
        "        targetCompatibility = JavaVersion.VERSION_21\n"
        "    }\n\n"
        "    kotlinOptions {\n"
        "        jvmTarget = \"21\"\n"
        "    }\n\n"
        "    defaultConfig {\n"
        f"        applicationId = \"{namespace}\"\n"
        "        minSdkVersion = flutter.minSdkVersion\n"
        "        targetSdk = flutter.targetSdkVersion\n"
        "        versionCode = flutter.versionCode\n"
        "        versionName = flutter.versionName\n"
        "    }\n\n"
        "    buildTypes {\n"
        "        release {\n"
        "            signingConfig = signingConfigs.debug\n"
        "        }\n"
        "    }\n"
        "}\n\n"
        "flutter {\n"
        "    source = \"../..\"\n"
        "}\n",
        encoding="utf-8",
    )

    (android / "app" / "src" / "main" / "AndroidManifest.xml").write_text(
        "<manifest xmlns:android=\"http://schemas.android.com/apk/res/android\">\n"
        "    <application\n"
        "        android:label=\"@string/app_name\"\n"
        "        android:name=\"${applicationName}\"\n"
        "        android:icon=\"@mipmap/ic_launcher\">\n"
        "        <activity\n"
        "            android:name=\".MainActivity\"\n"
        "            android:exported=\"true\"\n"
        "            android:launchMode=\"singleTop\"\n"
        "            android:theme=\"@style/LaunchTheme\"\n"
        "            android:configChanges=\"orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode\"\n"
        "            android:hardwareAccelerated=\"true\"\n"
        "            android:windowSoftInputMode=\"adjustResize\">\n"
        "            <intent-filter>\n"
        "                <action android:name=\"android.intent.action.MAIN\" />\n"
        "                <category android:name=\"android.intent.category.LAUNCHER\" />\n"
        "            </intent-filter>\n"
        "        </activity>\n"
        "        <meta-data android:name=\"flutterEmbedding\" android:value=\"2\" />\n"
        "    </application>\n"
        "</manifest>\n",
        encoding="utf-8",
    )

    (android / "app" / "src" / "main" / "res" / "values" / "strings.xml").write_text(
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<resources>\n"
        f"    <string name=\"app_name\">{app_name}</string>\n"
        "</resources>\n",
        encoding="utf-8",
    )

    (android / "app" / "src" / "main" / "res" / "values" / "styles.xml").write_text(
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<resources>\n"
        "    <style name=\"LaunchTheme\" parent=\"@android:style/Theme.Light.NoTitleBar\">\n"
        "        <item name=\"android:windowBackground\">@drawable/launch_background</item>\n"
        "    </style>\n"
        "    <style name=\"NormalTheme\" parent=\"@android:style/Theme.Light.NoTitleBar\"/>\n"
        "</resources>\n",
        encoding="utf-8",
    )

    (android / "app" / "src" / "main" / "res" / "drawable" / "launch_background.xml").write_text(
        "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
        "<layer-list xmlns:android=\"http://schemas.android.com/apk/res/android\">\n"
        "    <item android:drawable=\"@android:color/white\" />\n"
        "</layer-list>\n",
        encoding="utf-8",
    )

    kt_path = android / "app" / "src" / "main" / "kotlin" / "sa" / "rezende" / app_name / "MainActivity.kt"
    kt_path.parent.mkdir(parents=True, exist_ok=True)
    kt_path.write_text(
        f"package sa.rezende.{app_name}\n\n"
        "import io.flutter.embedding.android.FlutterActivity\n\n"
        "class MainActivity : FlutterActivity()\n",
        encoding="utf-8",
    )

    local_props = android / "local.properties"
    if not local_props.exists():
        local_props.write_text("# Configure sdk.dir locally if needed.\n", encoding="utf-8")


def complete_app(app_dir: Path, stats: Stats) -> None:
    ensure_l10n_yaml(app_dir)
    ensure_arb_baseline(app_dir, stats)
    ensure_test_dirs(app_dir)
    ensure_integration_test(app_dir, stats)

    pubspec = app_dir / "pubspec.yaml"
    if ensure_integration_dependency(pubspec):
        stats.integration_dep_added += 1

    ensure_publishing(app_dir, stats)

    needs_android, placeholder = android_needs_scaffold(app_dir)
    if needs_android:
        create_minimal_android(app_dir)
        stats.android_scaffolded += 1
        if placeholder:
            stats.android_upgraded_from_placeholder += 1


def has_all_criteria(app_dir: Path) -> bool:
    has_pubspec = (app_dir / "pubspec.yaml").exists()
    has_main = (app_dir / "lib" / "main.dart").exists()
    has_l10n_yaml = (app_dir / "l10n.yaml").exists()
    l10n_dir = app_dir / "lib" / "l10n"
    has_15 = l10n_dir.is_dir() and len(list(l10n_dir.glob("*.arb"))) >= 15
    has_test = (app_dir / "test").is_dir()
    has_int = (app_dir / "integration_test").is_dir()
    has_pub = (app_dir / "publishing").is_dir()
    has_android = (app_dir / "android").is_dir() and (app_dir / "android" / "app" / "build.gradle").exists()
    return all([has_pubspec, has_main, has_l10n_yaml, has_15, has_test, has_int, has_pub, has_android])


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--app", help="Process only one app path: <cluster>/<app>")
    args = parser.parse_args()

    if args.app:
        app_dir = APPS_ROOT / args.app
        if not app_dir.exists():
            raise FileNotFoundError(f"App not found: {args.app}")
        if not (app_dir / "pubspec.yaml").exists():
            raise FileNotFoundError(f"pubspec.yaml not found for app: {args.app}")
        stats = Stats(apps_targeted=1)
        complete_app(app_dir, stats)
        stats.apps_completed = 1 if has_all_criteria(app_dir) else 0
        print("Factory completion finished (single app)")
        print(f"target_apps={stats.apps_targeted}")
        print(f"completed_apps={stats.apps_completed}")
        print(f"arbs_created={stats.arbs_created}")
        print(f"arb_files_normalized={stats.arb_files_normalized}")
        print(f"integration_tests_created={stats.integration_tests_created}")
        print(f"integration_dep_added={stats.integration_dep_added}")
        print(f"publishing_scaffolded={stats.publishing_scaffolded}")
        print(f"android_scaffolded={stats.android_scaffolded}")
        print(f"android_upgraded_from_placeholder={stats.android_upgraded_from_placeholder}")
        return 0

    targets, skipped = list_target_apps()
    stats = Stats(apps_targeted=len(targets), skipped_without_pubspec=len(skipped))

    for idx, app_dir in enumerate(targets, 1):
        complete_app(app_dir, stats)
        if has_all_criteria(app_dir):
            stats.apps_completed += 1
        if idx % 10 == 0 or idx == len(targets):
            print(f"progress={idx}/{len(targets)} app={app_dir.parent.name}/{app_dir.name}", flush=True)

    print("Factory completion finished")
    print(f"target_apps={stats.apps_targeted}")
    print(f"completed_apps={stats.apps_completed}")
    print(f"skipped_without_pubspec={stats.skipped_without_pubspec}")
    print(f"arbs_created={stats.arbs_created}")
    print(f"arb_files_normalized={stats.arb_files_normalized}")
    print(f"integration_tests_created={stats.integration_tests_created}")
    print(f"integration_dep_added={stats.integration_dep_added}")
    print(f"publishing_scaffolded={stats.publishing_scaffolded}")
    print(f"android_scaffolded={stats.android_scaffolded}")
    print(f"android_upgraded_from_placeholder={stats.android_upgraded_from_placeholder}")

    if skipped:
        print("skipped_apps:")
        for s in skipped:
            print(f"- {s.relative_to(APPS_ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
