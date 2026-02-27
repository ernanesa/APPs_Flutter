#!/usr/bin/env python3
"""Generate a sequential publication board from the current parallel board."""

from __future__ import annotations

import csv
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PARALLEL_BOARD = ROOT / "artifacts" / "publication_parallel_board.csv"
SEQUENTIAL_BOARD = ROOT / "artifacts" / "publication_sequential_board.csv"
SEQUENTIAL_RUNBOOK = ROOT / "artifacts" / "PUBLICATION_SEQUENTIAL_RUNBOOK.md"


def load_parallel_rows() -> list[dict[str, str]]:
    if not PARALLEL_BOARD.exists():
        raise FileNotFoundError(f"Parallel board not found: {PARALLEL_BOARD}")
    rows = list(csv.DictReader(PARALLEL_BOARD.open(encoding="utf-8")))
    rows.sort(key=lambda r: int(r["sequence"]))
    return rows


def generate_sequential_board(rows: list[dict[str, str]]) -> None:
    fieldnames = [
        "order",
        "app_path",
        "cluster",
        "wave",
        "current_step",
        "status",
        "locked",
        "l10n_status",
        "int_test_status",
        "publishing_status",
        "qa_full_status",
        "device_status",
        "submission_status",
        "started_at",
        "finished_at",
        "notes",
    ]

    with SEQUENTIAL_BOARD.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()

        for idx, row in enumerate(rows, 1):
            first = idx == 1
            writer.writerow(
                {
                    "order": idx,
                    "app_path": row["app_path"],
                    "cluster": row["cluster"],
                    "wave": row["wave"],
                    "current_step": "PUBLISHING" if first else "WAITING",
                    "status": "IN_PROGRESS" if first else "WAITING",
                    "locked": "false" if first else "true",
                    "l10n_status": row["l10n_status"],
                    "int_test_status": row["int_test_status"],
                    "publishing_status": "in_progress" if first else "pending",
                    "qa_full_status": "pending",
                    "device_status": "pending",
                    "submission_status": "pending",
                    "started_at": date.today().isoformat() if first else "",
                    "finished_at": "",
                    "notes": row.get("notes", ""),
                }
            )


def generate_runbook() -> None:
    content = """# PUBLICATION SEQUENTIAL RUNBOOK (37 apps)

## Modo de execução
- Estratégia: **sequencial** (1 app por vez).
- Board oficial: `artifacts/publication_sequential_board.csv`.
- Ordem de execução: coluna `order` (1 -> 37).

## Regras operacionais
1. Trabalhar somente no app com `status=IN_PROGRESS`.
2. Nenhum próximo app pode iniciar com `locked=true`.
3. Só desbloquear próximo app após `submission_status=done` no app atual.

## Etapas por app
1. `PUBLISHING` (assets finais + checklist)
2. `QA_FULL` (`melos run validate:qa:full -- -AppName <app>`)
3. `DEVICE_FISICO`
4. `READY_SUBMISSION`
5. `SUBMETIDO`

## Comandos úteis
```bash
melos run check:l10n
melos run check:store_assets
melos run validate:qa:full -- -AppName <app>
```

## Avanço de etapa (automatizado)
Use:
```bash
python3 tools/advance_sequential_publication.py --app <cluster/app> --to <STEP>
```

Valores de `<STEP>`:
- `QA_FULL`
- `DEVICE_FISICO`
- `READY_SUBMISSION`
- `SUBMETIDO`
"""
    SEQUENTIAL_RUNBOOK.write_text(content, encoding="utf-8")


def main() -> int:
    rows = load_parallel_rows()
    generate_sequential_board(rows)
    generate_runbook()
    print(f"Generated: {SEQUENTIAL_BOARD}")
    print(f"Generated: {SEQUENTIAL_RUNBOOK}")
    print(f"Rows: {len(rows)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
