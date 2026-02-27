#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

APPS_LIST="/tmp/factory_apps_152.txt"
LOG="artifacts/factory_completion_sequential.log"
DONE="artifacts/factory_completion_done.txt"
FAIL="artifacts/factory_completion_failed.txt"

rg --files -g 'apps/*/*/pubspec.yaml' apps \
  | sed 's#^apps/##;s#/pubspec.yaml$##' \
  | sort > "$APPS_LIST"

: > "$LOG"
: > "$DONE"
: > "$FAIL"

TOTAL=$(wc -l < "$APPS_LIST" | tr -d ' ')
IDX=0

while IFS= read -r app; do
  IDX=$((IDX+1))
  echo "[$IDX/$TOTAL] $app" | tee -a "$LOG"

  if timeout 35s python3 tools/factory_complete_all_apps.py --app "$app" >> "$LOG" 2>&1; then
    echo "$app" >> "$DONE"
  else
    echo "$app" >> "$FAIL"
    echo "  -> timeout/failure" | tee -a "$LOG"
  fi

done < "$APPS_LIST"

DONE_COUNT=$(wc -l < "$DONE" | tr -d ' ')
FAIL_COUNT=$(wc -l < "$FAIL" | tr -d ' ')

echo "done=$DONE_COUNT failed=$FAIL_COUNT total=$TOTAL" | tee -a "$LOG"
