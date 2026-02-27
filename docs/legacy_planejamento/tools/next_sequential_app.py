#!/usr/bin/env python3
"""Show the current active app in sequential publication board."""

from __future__ import annotations

import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BOARD = ROOT / "artifacts" / "publication_sequential_board.csv"


def main() -> int:
    if not BOARD.exists():
        raise FileNotFoundError(f"Sequential board not found: {BOARD}")

    rows = list(csv.DictReader(BOARD.open(encoding="utf-8")))
    rows.sort(key=lambda r: int(r["order"]))

    current = next((r for r in rows if r["status"] == "IN_PROGRESS"), None)
    if current is None:
        print("No app currently IN_PROGRESS.")
        return 0

    app_name = current["app_path"].split("/")[-1]
    print(f"order={current['order']}")
    print(f"app_path={current['app_path']}")
    print(f"current_step={current['current_step']}")
    print("commands:")
    print("  melos run check:l10n")
    print("  melos run check:store_assets")
    print(f"  melos run validate:qa:full -- -AppName {app_name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
