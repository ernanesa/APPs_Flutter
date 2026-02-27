#!/usr/bin/env python3
"""Sync per-app publishing/PUBLICATION_STATUS.md from a publication board CSV."""

from __future__ import annotations

import argparse
import csv
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_BOARD = ROOT / "artifacts" / "publication_sequential_board.csv"
FALLBACK_BOARD = ROOT / "artifacts" / "publication_parallel_board.csv"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--board", help="Path to board csv (sequential or parallel)")
    args = parser.parse_args()

    board = (ROOT / args.board).resolve() if args.board else (DEFAULT_BOARD if DEFAULT_BOARD.exists() else FALLBACK_BOARD)

    if not board.exists():
        raise FileNotFoundError(f"Board file not found: {board}")

    rows = list(csv.DictReader(board.open(encoding="utf-8")))
    updated = 0

    for row in rows:
        app_path = row["app_path"]
        pub_status = ROOT / "apps" / app_path / "publishing" / "PUBLICATION_STATUS.md"
        pub_status.parent.mkdir(parents=True, exist_ok=True)

        # Compatible with both board schemas.
        column = row.get("current_column") or row.get("current_step", "UNKNOWN")
        l10n = row.get("l10n_status", "unknown")
        int_test = row.get("int_test_status", "unknown")
        publishing = row.get("publishing_status", "unknown")
        qa_full = row.get("qa_full_status", "unknown")
        device = row.get("device_status", "unknown")
        submission = row.get("submission_status", "unknown")

        try:
            board_ref = board.relative_to(ROOT).as_posix()
        except ValueError:
            board_ref = str(board)

        content = (
            "# Publication Status\n\n"
            f"- App: `{app_path}`\n"
            f"- Column: {column}\n"
            f"- L10N: {l10n}\n"
            f"- INT_TEST: {int_test}\n"
            f"- PUBLISHING: {publishing}\n"
            f"- QA_FULL: {qa_full}\n"
            f"- DEVICE_FISICO: {device}\n"
            f"- SUBMISSION: {submission}\n"
            f"- Next: mover conforme avanço no board central `{board_ref}`.\n"
        )

        prev = pub_status.read_text(encoding="utf-8") if pub_status.exists() else ""
        if prev != content:
            pub_status.write_text(content, encoding="utf-8")
            updated += 1

    print(f"Board used: {board}")
    print(f"Synced publication status files: {updated}/{len(rows)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
