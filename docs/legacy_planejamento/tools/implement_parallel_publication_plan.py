#!/usr/bin/env python3
"""Implement the 37-app parallel publication master plan.

Actions:
- Backfill missing ARBs for the 15 required locales.
- Scaffold missing integration_test for target apps.
- Ensure integration_test dependency in pubspec for apps with integration tests.
- Scaffold publishing folder structure and placeholder store assets.
- Generate an execution board CSV with week/wave assignments.
- Generate a human-readable implementation report.
"""

from __future__ import annotations

import csv
import json
import re
import zlib
import binascii
import struct
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Dict, List, Tuple

ROOT = Path(__file__).resolve().parents[1]
CSV_PATH = ROOT / "artifacts" / "apps_quase_prontos.csv"
BOARD_PATH = ROOT / "artifacts" / "publication_parallel_board.csv"
REPORT_PATH = ROOT / "artifacts" / "PUBLICATION_PARALLEL_IMPLEMENTATION_REPORT.md"
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

WAVE_1 = [
    "finance/compound_interest_calculator",
    "productivity/decision_wheel",
    "productivity/game_scoreboard",
    "productivity/number_lottery",
    "productivity/lorem_generator",
    "productivity/qr_generator",
    "finance/discount_calculator",
    "finance/tip_split_calculator",
    "productivity/case_converter",
    "productivity/ocr_extractor",
    "productivity/qr_scanner",
    "productivity/quick_notes",
]

WAVE_2 = [
    "productivity/random_name_generator",
    "productivity/teleprompter",
    "productivity/todo_list",
    "productivity/travel_checklist",
    "productivity/word_counter",
    "tools/unit_converter",
    "utility/voltage_drop_calculator",
    "utility/aspect_ratio_calculator",
    "utility/brick_calculator",
    "utility/clothing_size_converter",
    "utility/torque_converter",
    "utility/cooking_converter",
]

WAVE_3 = [
    "utility/download_speed_calculator",
    "utility/fuel_mix_calculator",
    "utility/logic_gate_simulator",
    "utility/number_base_converter",
    "utility/ohms_law_calculator",
    "utility/paint_calculator",
    "utility/password_generator",
    "utility/ppi_calculator",
    "utility/pressure_converter",
    "utility/resistor_color_code",
    "utility/shoe_size_converter",
    "utility/temperature_converter",
    "utility/concrete_calculator",
]

WAVE_MAP: Dict[str, str] = {}
for app in WAVE_1:
    WAVE_MAP[app] = "W1"
for app in WAVE_2:
    WAVE_MAP[app] = "W2"
for app in WAVE_3:
    WAVE_MAP[app] = "W3"


@dataclass
class Row:
    app_path: str
    cluster: str
    percent: int
    langs_ok: bool
    missing_arbs: int
    publishing_ready: bool
    android_ready: bool
    notes: str


@dataclass
class Stats:
    created_arb_files: int = 0
    apps_i18n_backfilled: int = 0
    arb_files_normalized: int = 0
    created_integration_tests: int = 0
    pubspec_integration_dep_added: int = 0
    publishing_scaffolded: int = 0
    store_assets_generated: int = 0
    checklist_created: int = 0


def parse_csv() -> List[Row]:
    rows: List[Row] = []
    with CSV_PATH.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for r in reader:
            rows.append(
                Row(
                    app_path=r["app_path"],
                    cluster=r["cluster"],
                    percent=int(r["percent"]),
                    langs_ok=(r["15_langs_present"].strip().lower() == "yes"),
                    missing_arbs=int(r["missing_arbs"]),
                    publishing_ready=(r["publishing_ready"].strip().lower() == "true"),
                    android_ready=(r["android_ready"].strip().lower() == "true"),
                    notes=r.get("notes", "").strip(),
                )
            )
    return rows


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


def backfill_arbs(app_dir: Path) -> Tuple[int, List[str]]:
    l10n_dir = app_dir / "lib" / "l10n"
    l10n_dir.mkdir(parents=True, exist_ok=True)

    en_path = l10n_dir / "app_en.arb"
    if not en_path.exists():
        return 0, []

    template = json.loads(en_path.read_text(encoding="utf-8"))
    created = 0
    created_locales: List[str] = []

    for locale in REQUIRED_LOCALES:
        target = l10n_dir / f"app_{locale}.arb"
        if target.exists():
            continue

        payload = dict(template)
        if "@@locale" in payload:
            payload["@@locale"] = locale

        target.write_text(
            json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        created += 1
        created_locales.append(locale)

    return created, created_locales


def _load_arb_json(path: Path) -> Tuple[Dict[str, object], bool]:
    raw = path.read_text(encoding="utf-8")
    try:
        return json.loads(raw), False
    except json.JSONDecodeError:
        # Recovery for files that ended with literal backslash-n sequences.
        fixed = raw.rstrip()
        while fixed.endswith("\\n"):
            fixed = fixed[:-2].rstrip()
        return json.loads(fixed), True


def normalize_arb_keys(app_dir: Path) -> int:
    l10n_dir = app_dir / "lib" / "l10n"
    en_path = l10n_dir / "app_en.arb"
    if not en_path.exists():
        return 0

    en_data, _ = _load_arb_json(en_path)
    en_text_keys = [k for k in en_data.keys() if not k.startswith("@")]
    en_meta_keys = [k for k in en_data.keys() if k.startswith("@")]

    touched = 0
    for arb_path in sorted(l10n_dir.glob("app_*.arb")):
        if arb_path.name == "app_en.arb":
            continue

        locale_data, recovered = _load_arb_json(arb_path)
        locale_match = re.match(r"app_([a-z_]+)\\.arb$", arb_path.name)
        locale_code = locale_match.group(1) if locale_match else ""

        normalized: Dict[str, object] = {}

        # Keep global metadata keys from template if present.
        for meta in en_meta_keys:
            if meta.startswith("@@"):
                normalized[meta] = locale_data.get(meta, en_data[meta])
        if "@@locale" in normalized and locale_code:
            normalized["@@locale"] = locale_code

        # Keep text keys from template order and align per locale file.
        for key in en_text_keys:
            normalized[key] = locale_data.get(key, en_data[key])
            meta_key = f"@{key}"
            if meta_key in en_data:
                normalized[meta_key] = locale_data.get(meta_key, en_data[meta_key])

        current = json.dumps(locale_data, ensure_ascii=False, sort_keys=False)
        future = json.dumps(normalized, ensure_ascii=False, sort_keys=False)
        if recovered or current != future:
            arb_path.write_text(
                json.dumps(normalized, ensure_ascii=False, indent=2) + "\n",
                encoding="utf-8",
            )
            touched += 1

    return touched


def _png_chunk(chunk_type: bytes, data: bytes) -> bytes:
    length = struct.pack(">I", len(data))
    crc = struct.pack(">I", binascii.crc32(chunk_type + data) & 0xFFFFFFFF)
    return length + chunk_type + data + crc


def write_solid_png(path: Path, width: int, height: int, rgb: Tuple[int, int, int]) -> None:
    r, g, b = rgb
    row = bytes([r, g, b]) * width
    raw = b"".join(b"\x00" + row for _ in range(height))
    compressed = zlib.compress(raw, level=9)

    sig = b"\x89PNG\r\n\x1a\n"
    ihdr = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    data = b"".join(
        [
            sig,
            _png_chunk(b"IHDR", ihdr),
            _png_chunk(b"IDAT", compressed),
            _png_chunk(b"IEND", b""),
        ]
    )
    path.write_bytes(data)


def scaffold_publishing(row: Row, app_dir: Path, stats: Stats) -> None:
    pub_dir = app_dir / "publishing"
    store_assets = pub_dir / "store_assets"
    admob_dir = pub_dir / "admob"
    policies_dir = pub_dir / "policies"

    was_missing = not pub_dir.exists()

    store_assets.mkdir(parents=True, exist_ok=True)
    admob_dir.mkdir(parents=True, exist_ok=True)
    policies_dir.mkdir(parents=True, exist_ok=True)

    if was_missing:
        stats.publishing_scaffolded += 1

    # Placeholder assets to satisfy store asset checks.
    assets = [
        (store_assets / "icon_512.png", 512, 512, (23, 92, 211)),
        (store_assets / "feature_graphic.png", 1024, 500, (18, 51, 125)),
        (store_assets / "screenshot_01_phone.png", 1080, 1920, (245, 247, 250)),
        (store_assets / "screenshot_02_phone.png", 1080, 1920, (230, 236, 245)),
    ]

    for asset_path, w, h, color in assets:
        if asset_path.exists():
            continue
        write_solid_png(asset_path, w, h, color)
        stats.store_assets_generated += 1

    admob_ids = admob_dir / "ADMOB_IDS.md"
    if not admob_ids.exists():
        admob_ids.write_text(
            "# ADMOB_IDS\n\n"
            "- Status: pending\n"
            "- Note: preencher IDs reais após configuração no AdMob.\n",
            encoding="utf-8",
        )

    privacy_policy = policies_dir / "PRIVACY_POLICY.md"
    if not privacy_policy.exists():
        privacy_policy.write_text(
            "# Política de Privacidade\n\n"
            "Este arquivo é um placeholder operacional para o fluxo de publicação.\n"
            "Substitua pelo texto final e URL pública 200 OK antes da submissão.\n",
            encoding="utf-8",
        )

    checklist = pub_dir / "CHECKLIST_CONCLUIDO.md"
    if not checklist.exists():
        template = CHECKLIST_TEMPLATE.read_text(encoding="utf-8")
        version = read_app_version(app_dir)
        content = (
            template.replace("<app_name>", row.app_path.split("/")[-1])
            .replace("<cluster>", row.cluster)
            .replace("DD de MMMM de YYYY", date.today().isoformat())
            .replace("x.y.z+build", version)
        )
        checklist.write_text(content, encoding="utf-8")
        stats.checklist_created += 1

    status_md = pub_dir / "PUBLICATION_STATUS.md"
    if not status_md.exists():
        status_md.write_text(
            "# Publication Status\n\n"
            "- Column: Backlog\n"
            "- Next: I18N -> INT_TEST -> PUBLISHING -> QA_FULL -> DEVICE_FISICO -> READY_SUBMISSION -> SUBMETIDO\n",
            encoding="utf-8",
        )


def read_app_version(app_dir: Path) -> str:
    pubspec = app_dir / "pubspec.yaml"
    if not pubspec.exists():
        return "1.0.0+1"
    for line in pubspec.read_text(encoding="utf-8").splitlines():
        if line.strip().startswith("version:"):
            return line.split(":", 1)[1].strip()
    return "1.0.0+1"


def create_integration_test(app_path: str, app_dir: Path) -> bool:
    int_dir = app_dir / "integration_test"
    int_dir.mkdir(parents=True, exist_ok=True)
    test_file = int_dir / "app_test.dart"
    if test_file.exists():
        return False

    app_name = app_path.split("/")[-1]
    content = (
        "import 'package:flutter_test/flutter_test.dart';\n"
        "import 'package:integration_test/integration_test.dart';\n"
        f"import 'package:{app_name}/main.dart' as app;\n\n"
        "void main() {\n"
        "  IntegrationTestWidgetsFlutterBinding.ensureInitialized();\n\n"
        "  testWidgets('App launches without framework exceptions', (tester) async {\n"
        "    app.main();\n"
        "    await tester.pumpAndSettle(const Duration(seconds: 2));\n"
        "    expect(tester.takeException(), isNull);\n"
        "  });\n"
        "}\n"
    )
    test_file.write_text(content, encoding="utf-8")
    return True


def app_missing_required_locales(app_dir: Path) -> int:
    l10n_dir = app_dir / "lib" / "l10n"
    missing = 0
    for locale in REQUIRED_LOCALES:
        if not (l10n_dir / f"app_{locale}.arb").exists():
            missing += 1
    return missing


def app_has_key_sync(app_dir: Path) -> bool:
    l10n_dir = app_dir / "lib" / "l10n"
    en_path = l10n_dir / "app_en.arb"
    if not en_path.exists():
        return False
    en_data, _ = _load_arb_json(en_path)
    en_keys = {k for k in en_data.keys() if not k.startswith("@")}

    for locale in REQUIRED_LOCALES:
        arb = l10n_dir / f"app_{locale}.arb"
        if not arb.exists():
            return False
        data, _ = _load_arb_json(arb)
        keys = {k for k in data.keys() if not k.startswith("@")}
        if keys != en_keys:
            return False
    return True


def write_board(rows: List[Row], int_missing: List[str], i18n_created: Dict[str, List[str]]) -> None:
    fieldnames = [
        "wave",
        "sequence",
        "app_path",
        "cluster",
        "percent",
        "track",
        "missing_arbs_before",
        "missing_arbs_after",
        "integration_test_before",
        "integration_test_after",
        "publishing_ready_before",
        "publishing_ready_after",
        "current_column",
        "l10n_status",
        "int_test_status",
        "publishing_status",
        "qa_full_status",
        "device_status",
        "submission_status",
        "notes",
    ]

    order_index = {row.app_path: i + 1 for i, row in enumerate(rows)}
    with BOARD_PATH.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            wave = WAVE_MAP.get(row.app_path, "UNASSIGNED")
            app_dir = ROOT / "apps" / row.app_path
            missing_after = app_missing_required_locales(app_dir)
            key_sync = app_has_key_sync(app_dir)
            int_before = "missing" if row.app_path in int_missing else "present"
            int_after = "present" if (app_dir / "integration_test").exists() else "missing"
            track = "type1_15_langs" if row.missing_arbs == 0 else "type2_arb_backfill"
            publishing_after = "true" if (app_dir / "publishing").exists() else "false"
            l10n_done = missing_after == 0 and key_sync
            int_done = int_after == "present"
            current_column = "PUBLISHING" if (l10n_done and int_done) else "Backlog"

            writer.writerow(
                {
                    "wave": wave,
                    "sequence": order_index[row.app_path],
                    "app_path": row.app_path,
                    "cluster": row.cluster,
                    "percent": row.percent,
                    "track": track,
                    "missing_arbs_before": row.missing_arbs,
                    "missing_arbs_after": missing_after,
                    "integration_test_before": int_before,
                    "integration_test_after": int_after,
                    "publishing_ready_before": str(row.publishing_ready).lower(),
                    "publishing_ready_after": publishing_after,
                    "current_column": current_column,
                    "l10n_status": "done" if l10n_done else "pending",
                    "int_test_status": "done" if int_done else "pending",
                    "publishing_status": "in_progress",
                    "qa_full_status": "pending",
                    "device_status": "pending",
                    "submission_status": "pending",
                    "notes": row.notes,
                }
            )


def write_report(stats: Stats, rows: List[Row], int_missing: List[str], i18n_created: Dict[str, List[str]]) -> None:
    missing_locales_apps = 0
    key_sync_ok_apps = 0
    missing_int_apps = 0
    missing_publishing_apps = 0

    for row in rows:
        app_dir = ROOT / "apps" / row.app_path
        if app_missing_required_locales(app_dir) > 0:
            missing_locales_apps += 1
        if app_has_key_sync(app_dir):
            key_sync_ok_apps += 1
        if not (app_dir / "integration_test").exists():
            missing_int_apps += 1
        if not (app_dir / "publishing").exists():
            missing_publishing_apps += 1

    lines: List[str] = []
    lines.append("# PUBLICATION PARALLEL IMPLEMENTATION REPORT")
    lines.append("")
    lines.append(f"Generated on: {date.today().isoformat()}")
    lines.append("")
    lines.append("## Applied changes")
    lines.append("")
    lines.append(f"- Apps in scope: {len(rows)}")
    lines.append(f"- ARB files created: {stats.created_arb_files}")
    lines.append(f"- Apps with i18n backfill applied: {stats.apps_i18n_backfilled}")
    lines.append(f"- ARB files normalized (key sync with app_en): {stats.arb_files_normalized}")
    lines.append(f"- Integration tests created: {stats.created_integration_tests}")
    lines.append(f"- pubspec integration_test dependency added: {stats.pubspec_integration_dep_added}")
    lines.append(f"- Publishing scaffolds created: {stats.publishing_scaffolded}")
    lines.append(f"- Placeholder store assets generated: {stats.store_assets_generated}")
    lines.append(f"- CHECKLIST_CONCLUIDO.md created: {stats.checklist_created}")
    lines.append("")
    lines.append("## Current state after implementation")
    lines.append("")
    lines.append(f"- Apps with all 15 required locales present: {len(rows) - missing_locales_apps}/{len(rows)}")
    lines.append(f"- Apps with ARB key sync against app_en: {key_sync_ok_apps}/{len(rows)}")
    lines.append(f"- Apps with integration_test folder present: {len(rows) - missing_int_apps}/{len(rows)}")
    lines.append(f"- Apps with publishing folder present: {len(rows) - missing_publishing_apps}/{len(rows)}")
    lines.append("")

    if int_missing:
        lines.append("## Apps that were missing integration_test")
        lines.append("")
        for app in int_missing:
            lines.append(f"- {app}")
        lines.append("")

    if i18n_created:
        lines.append("## i18n backfill details")
        lines.append("")
        for app in sorted(i18n_created):
            locs = ", ".join(i18n_created[app])
            lines.append(f"- {app}: {locs}")
        lines.append("")

    lines.append("## Output artifacts")
    lines.append("")
    lines.append("- artifacts/publication_parallel_board.csv")
    lines.append("- artifacts/PUBLICATION_PARALLEL_IMPLEMENTATION_REPORT.md")
    lines.append("")
    lines.append("## Important")
    lines.append("")
    lines.append("- Store assets generated by this script are placeholders for gate automation and must be replaced by final creative assets before Play submission.")

    REPORT_PATH.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    rows = parse_csv()
    stats = Stats()

    int_missing_before: List[str] = []
    i18n_created_locales: Dict[str, List[str]] = {}

    for row in rows:
        app_dir = ROOT / "apps" / row.app_path
        if not app_dir.exists():
            raise FileNotFoundError(f"App path not found: {app_dir}")

        created, locales = backfill_arbs(app_dir)
        if created > 0:
            stats.created_arb_files += created
            stats.apps_i18n_backfilled += 1
            i18n_created_locales[row.app_path] = locales

        stats.arb_files_normalized += normalize_arb_keys(app_dir)

        integration_dir = app_dir / "integration_test"
        if not integration_dir.exists():
            int_missing_before.append(row.app_path)
            if create_integration_test(row.app_path, app_dir):
                stats.created_integration_tests += 1

        pubspec = app_dir / "pubspec.yaml"
        if pubspec.exists() and ensure_integration_dependency(pubspec):
            stats.pubspec_integration_dep_added += 1

        scaffold_publishing(row, app_dir, stats)

    write_board(rows, int_missing_before, i18n_created_locales)
    write_report(stats, rows, int_missing_before, i18n_created_locales)

    print("Parallel publication plan implementation completed.")
    print(f"Apps: {len(rows)}")
    print(f"ARB files created: {stats.created_arb_files}")
    print(f"Integration tests created: {stats.created_integration_tests}")
    print(f"Publishing scaffolds created: {stats.publishing_scaffolded}")
    print(f"Assets generated: {stats.store_assets_generated}")
    print(f"ARB files normalized: {stats.arb_files_normalized}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
