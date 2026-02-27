#!/usr/bin/env bash
set -euo pipefail

# Fast Android smoke runner (WSL-friendly).
# - Assumes an Android emulator/device is already running and visible to adb.exe.
# - Uses prebuilt debug APKs (build with tools/testing/build_all_debug_apks.ps1 or manual flutter build).
# - Forces locale/theme (and Pomodoro colorful variant) via SharedPreferences XML using `run-as`.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT_DIR="${OUT_DIR:-$ROOT_DIR/artifacts/android_matrix}"
ADB="${ADB:-/mnt/c/Users/Ernane/AppData/Local/Android/Sdk/platform-tools/adb.exe}"

LOCALES=(${LOCALES:-en pt ar})
THEMES=(${THEMES:-light dark})

mkdir -p "$OUT_DIR"

require() { command -v "$1" >/dev/null 2>&1; }
require python3

adb() { "$ADB" "$@"; }

wait_device() {
  adb wait-for-device
  for _ in $(seq 1 120); do
    if [[ "$(adb shell getprop sys.boot_completed | tr -d '\r')" == "1" ]]; then
      break
    fi
    sleep 1
  done
  # best-effort unlock
  adb shell input keyevent 82 >/dev/null 2>&1 || true
}

resolve_component() {
  local pkg="$1"
  adb shell cmd package resolve-activity --brief "$pkg" | tr -d '\r' | tail -n 1
}

write_prefs() {
  local pkg="$1"
  shift
  local xml="$1"
  # Ensure shared_prefs exists (some apps might not have created it yet).
  adb shell run-as "$pkg" /system/bin/mkdir shared_prefs >/dev/null 2>&1 || true
  # Use tee to avoid quoting issues with `sh -c` when called via adb.exe from WSL.
  printf "%s" "$xml" | adb shell run-as "$pkg" /system/bin/tee shared_prefs/FlutterSharedPreferences.xml >/dev/null
}

take_screenshot() {
  local out="$1"
  mkdir -p "$(dirname "$out")"
  adb exec-out screencap -p > "$out"
}

capture_perf() {
  local pkg="$1"
  local out_base="$2"
  adb shell dumpsys meminfo "$pkg" > "${out_base}.meminfo.txt"
  adb shell dumpsys gfxinfo "$pkg" > "${out_base}.gfxinfo.txt"
}

launch_measure() {
  local component="$1"
  adb shell am start -W -n "$component" | tr -d '\r'
}

apk_path() {
  local app_path="$1"
  local p="$ROOT_DIR/$app_path/build/app/outputs/flutter-apk/app-debug.apk"
  if [[ ! -f "$p" ]]; then
    echo "APK not found: $p (build first)" >&2
    return 1
  fi
  echo "$p"
}

install_apk() {
  local pkg="$1"
  local apk="$2"
  # adb.exe is Windows; pass a Windows path to be safe.
  local win_apk
  win_apk="$(wslpath -w "$apk")"
  if ! adb install -r -d "$win_apk" >/dev/null 2>&1; then
    # Signature mismatch is common when an older release build is already installed.
    adb uninstall "$pkg" >/dev/null 2>&1 || true
    adb install -r -d "$win_apk" >/dev/null
  fi
}

apps=(
  "bmi_calculator|apps/health/bmi_calculator|sa.rezende.bmi_calculator|selected_locale|app_theme_mode|default"
  "fasting_tracker|apps/health/fasting_tracker|sa.rezende.fasting_tracker|app_locale|app_theme_mode|default"
  "pomodoro_timer|apps/productivity/pomodoro_timer|sa.rezende.pomodoro_timer|selected_locale|app_theme_mode|default"
  "pomodoro_timer|apps/productivity/pomodoro_timer|sa.rezende.pomodoro_timer|selected_locale|app_theme_mode|colorful"
  "white_noise|apps/media/white_noise|sa.rezende.white_noise|app_locale|app_theme_mode|default"
  "compound_interest_calculator|apps/finance/compound_interest_calculator|sa.rezende.compound_interest_calculator|app_locale|app_theme_mode|default"
)

wait_device

for entry in "${apps[@]}"; do
  IFS="|" read -r app_id app_path pkg locale_key theme_key variant <<<"$entry"

  apk="$(apk_path "$app_path")"
  install_apk "$pkg" "$apk"
  component="$(resolve_component "$pkg")"

  echo "==> $app_id ($variant) installed -> $component"

  for loc in "${LOCALES[@]}"; do
    for theme in "${THEMES[@]}"; do
      adb shell am force-stop "$pkg" >/dev/null 2>&1 || true

      xml="$(python3 - <<PY
prefs = {
  f"flutter.$locale_key": "$loc",
  f"flutter.$theme_key": "$theme",
}
if "$app_id" == "pomodoro_timer":
  if "$variant" == "colorful":
    prefs["flutter.pomodoro_settings"] = "{\"colorfulMode\":true,\"darkMode\":false}"
  else:
    prefs["flutter.pomodoro_settings"] = "{\"colorfulMode\":false,\"darkMode\":false}"
def esc(s: str) -> str:
  return (s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;').replace('"', '&quot;'))
print("<?xml version='1.0' encoding='utf-8' standalone='yes' ?>")
print("<map>")
for k in sorted(prefs.keys()):
  print(f"  <string name='{esc(k)}'>{esc(prefs[k])}</string>")
print("</map>")
PY
)"

      write_prefs "$pkg" "$xml"
      measure="$(launch_measure "$component")"
      sleep 2

      base_dir="$OUT_DIR/current/$app_id"
      base_name="${loc}_${theme}_${variant}"
      png="$base_dir/$base_name.png"
      take_screenshot "$png"
      capture_perf "$pkg" "$base_dir/$base_name"
      printf "    OK %s %s %s %s | %s\n" "$app_id" "$variant" "$loc" "$theme" "$(echo "$measure" | rg '^TotalTime:' || true)"
    done
  done
done

echo "Done. Artifacts in: $OUT_DIR"
