#!/usr/bin/env bash
set -euo pipefail
python3 -m pip install --upgrade pip
python3 -m pip install -r tools/requirements-golden.txt

echo "✅ Golden requirements installed"
