#!/usr/bin/env python3
"""Generate completion ranking and 'quase prontos' artifacts from current repo state."""

from __future__ import annotations

import csv
from collections import defaultdict
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import List

ROOT = Path(__file__).resolve().parents[1]
APPS_ROOT = ROOT / "apps"
RANKED_MD = ROOT / "APPS_RANKED_BY_COMPLETION.md"
QUASE_MD = ROOT / "artifacts" / "APPS_QUASE_PRONTOS.md"
QUASE_CSV = ROOT / "artifacts" / "apps_quase_prontos.csv"
BOARD_CSV = ROOT / "artifacts" / "publication_parallel_board.csv"
SEQUENTIAL_BOARD_CSV = ROOT / "artifacts" / "publication_sequential_board.csv"


@dataclass
class AppStatus:
    app_path: str
    cluster: str
    app_name: str
    has_pubspec: bool
    has_main: bool
    has_l10n: bool
    arb_count: int
    has_15_langs: bool
    has_tests: bool
    has_integration_test: bool
    has_publishing: bool
    has_android: bool
    percentage: int


def round_half_up(value: float) -> int:
    return int(value + 0.5)


def analyze_apps() -> List[AppStatus]:
    statuses: List[AppStatus] = []

    for cluster_dir in sorted(APPS_ROOT.iterdir()):
        if not cluster_dir.is_dir():
            continue

        for app_dir in sorted(cluster_dir.iterdir()):
            if not app_dir.is_dir():
                continue

            has_pubspec = (app_dir / "pubspec.yaml").exists()
            has_main = (app_dir / "lib" / "main.dart").exists()
            has_l10n = (app_dir / "l10n.yaml").exists()

            l10n_dir = app_dir / "lib" / "l10n"
            arb_count = len(list(l10n_dir.glob("*.arb"))) if l10n_dir.is_dir() else 0
            has_15_langs = arb_count >= 15

            has_tests = (app_dir / "test").is_dir()
            has_integration_test = (app_dir / "integration_test").is_dir()
            has_publishing = (app_dir / "publishing").is_dir()
            has_android = (app_dir / "android").is_dir()

            completed = sum(
                [
                    has_pubspec,
                    has_main,
                    has_l10n,
                    has_15_langs,
                    has_tests,
                    has_integration_test,
                    has_publishing,
                    has_android,
                ]
            )
            percentage = round_half_up((completed / 8) * 100)

            statuses.append(
                AppStatus(
                    app_path=f"{cluster_dir.name}/{app_dir.name}",
                    cluster=cluster_dir.name,
                    app_name=app_dir.name,
                    has_pubspec=has_pubspec,
                    has_main=has_main,
                    has_l10n=has_l10n,
                    arb_count=arb_count,
                    has_15_langs=has_15_langs,
                    has_tests=has_tests,
                    has_integration_test=has_integration_test,
                    has_publishing=has_publishing,
                    has_android=has_android,
                    percentage=percentage,
                )
            )

    statuses.sort(key=lambda s: (-s.percentage, s.app_path))
    return statuses


def bool_mark(value: bool) -> str:
    return "✅" if value else "❌"


def lang_mark(status: AppStatus) -> str:
    if status.has_15_langs:
        return "✅"
    if status.arb_count > 0:
        return f"⚠️ {status.arb_count}"
    return "❌"


def status_icon(percentage: int) -> str:
    if percentage == 100:
        return "✅"
    if percentage >= 75:
        return "🟢"
    if percentage >= 25:
        return "🟡"
    if percentage >= 1:
        return "🟠"
    return "⚪"


def build_ranking_md(statuses: List[AppStatus]) -> str:
    total = len(statuses)
    complete = sum(s.percentage == 100 for s in statuses)
    quasi = sum(75 <= s.percentage <= 99 for s in statuses)
    progress = sum(25 <= s.percentage <= 74 for s in statuses)
    started = sum(1 <= s.percentage <= 24 for s in statuses)
    not_started = sum(s.percentage == 0 for s in statuses)

    lines: List[str] = []
    lines.append("# Apps Ranqueados por Percentual de Completude")
    lines.append("")
    lines.append(f"**Data:** {date.today().isoformat()}")
    lines.append(f"**Total de Apps:** {total}")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## Resumo Executivo")
    lines.append("")
    lines.append("| Status | Quantidade | % do Total |")
    lines.append("|--------|------------|------------|")
    lines.append(f"| ✅ Completos (100%) | {complete} | {complete/total*100:.1f}% |")
    lines.append(f"| 🟢 Quase Prontos (75-99%) | {quasi} | {quasi/total*100:.1f}% |")
    lines.append(f"| 🟡 Em Progresso (25-74%) | {progress} | {progress/total*100:.1f}% |")
    lines.append(f"| 🟠 Iniciados (1-24%) | {started} | {started/total*100:.1f}% |")
    lines.append(f"| ⚪ Não Iniciados (0%) | {not_started} | {not_started/total*100:.1f}% |")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## Lista Completa (Ordenada por Completude)")
    lines.append("")
    lines.append("| # | App | Cluster | % | pubspec | main | l10n | 15 langs | tests | int_test | publishing | android |")
    lines.append("|---|-----|---------|---|:-------:|:----:|:----:|:--------:|:-----:|:--------:|:----------:|:-------:|")

    for idx, s in enumerate(statuses, 1):
        icon = status_icon(s.percentage)
        app = s.app_path.replace("/", "\\")
        lines.append(
            f"| {idx} | {icon} {app} | {s.cluster} | **{s.percentage}%** | "
            f"{bool_mark(s.has_pubspec)} | {bool_mark(s.has_main)} | {bool_mark(s.has_l10n)} | "
            f"{lang_mark(s)} | {bool_mark(s.has_tests)} | {bool_mark(s.has_integration_test)} | "
            f"{bool_mark(s.has_publishing)} | {bool_mark(s.has_android)} |"
        )

    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## Top 10 por Cluster")
    lines.append("")

    by_cluster: dict[str, List[AppStatus]] = defaultdict(list)
    for s in statuses:
        by_cluster[s.cluster].append(s)

    for cluster in sorted(by_cluster.keys()):
        lines.append(f"### {cluster.upper()}")
        lines.append("")
        cluster_apps = sorted(by_cluster[cluster], key=lambda s: (-s.percentage, s.app_name))
        for i, s in enumerate(cluster_apps[:10], 1):
            icon = status_icon(s.percentage)
            app = s.app_path.replace("/", "\\")
            lines.append(f"{i}. {icon} **{app}** - {s.percentage}%")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def build_quase_csv(statuses: List[AppStatus]) -> List[AppStatus]:
    quasi = [s for s in statuses if 75 <= s.percentage <= 99]
    with QUASE_CSV.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "app_path",
                "cluster",
                "percent",
                "15_langs_present",
                "missing_arbs",
                "publishing_ready",
                "android_ready",
                "notes",
            ],
        )
        writer.writeheader()

        for s in quasi:
            missing_arbs = max(0, 15 - s.arb_count)
            notes: List[str] = []
            if s.has_15_langs:
                notes.append("15 langs OK")
            else:
                notes.append(f"only {s.arb_count} ARB files (need 15)")
            if not s.has_integration_test:
                notes.append("int_test missing")
            if not s.has_publishing:
                notes.append("publishing not ready")

            writer.writerow(
                {
                    "app_path": s.app_path,
                    "cluster": s.cluster,
                    "percent": s.percentage,
                    "15_langs_present": "yes" if s.has_15_langs else "no",
                    "missing_arbs": missing_arbs,
                    "publishing_ready": "true" if s.has_publishing else "false",
                    "android_ready": "true" if s.has_android else "false",
                    "notes": "; ".join(notes),
                }
            )

    return quasi


def build_quase_md(quasi: List[AppStatus]) -> str:
    lines: List[str] = []
    lines.append("# Lista: Apps Quase Prontos (75–99%)")
    lines.append("")
    lines.append(f"**Gerado:** {date.today().isoformat()}")
    lines.append("")

    if not quasi:
        lines.append("> Snapshot atual: **nenhum app** está na faixa 75–99%.")
        lines.append("")
        if SEQUENTIAL_BOARD_CSV.exists():
            lines.append("> Para execução sequencial, use: `artifacts/publication_sequential_board.csv`.")
        elif BOARD_CSV.exists():
            lines.append("> Para execução paralela de publicação da onda planejada, use: `artifacts/publication_parallel_board.csv`.")
        lines.append("")
        return "\n".join(lines).rstrip() + "\n"

    lines.append("> Use esta checklist para atribuir responsáveis e acompanhar ações prioritárias (ex.: completar ARB, rodar int_tests, publicar).")
    lines.append("")

    for s in quasi:
        parts: List[str] = []
        parts.append(f"`{s.app_path}` — {s.percentage}%")
        if s.has_15_langs:
            parts.append("**15 langs OK**")
        else:
            parts.append(f"**{s.arb_count} ARB (miss {max(0, 15-s.arb_count)})**")
        if not s.has_integration_test:
            parts.append("int_test: ❌")
        parts.append(f"publishing: {'✅' if s.has_publishing else '❌'}")
        parts.append(f"android: {'✅' if s.has_android else '❌'}")
        lines.append("- [ ] " + " — ".join(parts))

    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("Próximo passo recomendado: mover os apps para o board operacional e executar os gates por onda.")
    lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    statuses = analyze_apps()
    RANKED_MD.write_text(build_ranking_md(statuses), encoding="utf-8")
    quasi = build_quase_csv(statuses)
    QUASE_MD.write_text(build_quase_md(quasi), encoding="utf-8")

    print(f"Generated: {RANKED_MD}")
    print(f"Generated: {QUASE_CSV}")
    print(f"Generated: {QUASE_MD}")
    print(f"Total apps: {len(statuses)}")
    print(f"Quase prontos (75-99): {len(quasi)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
