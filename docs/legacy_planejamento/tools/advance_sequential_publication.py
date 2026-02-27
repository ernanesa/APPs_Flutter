#!/usr/bin/env python3
"""Advance sequential publication board one app/step at a time."""

from __future__ import annotations

import argparse
import csv
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SEQUENTIAL_BOARD = ROOT / "artifacts" / "publication_sequential_board.csv"

VALID_STEPS = ["QA_FULL", "DEVICE_FISICO", "READY_SUBMISSION", "SUBMETIDO"]


def load_rows() -> list[dict[str, str]]:
    if not SEQUENTIAL_BOARD.exists():
        raise FileNotFoundError(f"Sequential board not found: {SEQUENTIAL_BOARD}")
    rows = list(csv.DictReader(SEQUENTIAL_BOARD.open(encoding="utf-8")))
    rows.sort(key=lambda r: int(r["order"]))
    return rows


def save_rows(rows: list[dict[str, str]]) -> None:
    if not rows:
        return
    fieldnames = list(rows[0].keys())
    with SEQUENTIAL_BOARD.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def next_index(rows: list[dict[str, str]], idx: int) -> int | None:
    nxt = idx + 1
    return nxt if nxt < len(rows) else None


def advance(rows: list[dict[str, str]], app: str, to_step: str) -> tuple[list[dict[str, str]], str]:
    target_idx = None
    for i, row in enumerate(rows):
        if row["app_path"] == app:
            target_idx = i
            break
    if target_idx is None:
        raise ValueError(f"App not found in sequential board: {app}")

    row = rows[target_idx]
    if row["locked"].lower() == "true":
        raise ValueError(f"App is locked and cannot advance yet: {app}")
    if row["status"] != "IN_PROGRESS":
        raise ValueError(f"App is not IN_PROGRESS: {app}")

    if to_step == "QA_FULL":
        row["publishing_status"] = "done"
        row["qa_full_status"] = "in_progress"
        row["current_step"] = "QA_FULL"
    elif to_step == "DEVICE_FISICO":
        row["qa_full_status"] = "done"
        row["device_status"] = "in_progress"
        row["current_step"] = "DEVICE_FISICO"
    elif to_step == "READY_SUBMISSION":
        row["device_status"] = "done"
        row["submission_status"] = "ready_submission"
        row["current_step"] = "READY_SUBMISSION"
        row["status"] = "READY_SUBMISSION"
    elif to_step == "SUBMETIDO":
        row["publishing_status"] = "done"
        row["qa_full_status"] = "done"
        row["device_status"] = "done"
        row["submission_status"] = "done"
        row["current_step"] = "SUBMETIDO"
        row["status"] = "DONE"
        row["finished_at"] = date.today().isoformat()

        nxt = next_index(rows, target_idx)
        if nxt is not None:
            next_row = rows[nxt]
            if next_row["status"] == "WAITING":
                next_row["locked"] = "false"
                next_row["status"] = "IN_PROGRESS"
                next_row["current_step"] = "PUBLISHING"
                next_row["publishing_status"] = "in_progress"
                if not next_row["started_at"]:
                    next_row["started_at"] = date.today().isoformat()
    else:
        raise ValueError(f"Invalid step: {to_step}")

    rows[target_idx] = row
    return rows, row["current_step"]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--app", required=True, help="cluster/app")
    parser.add_argument("--to", required=True, choices=VALID_STEPS)
    args = parser.parse_args()

    rows = load_rows()
    rows, step = advance(rows, args.app, args.to)
    save_rows(rows)
    print(f"Advanced {args.app} to {step}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
