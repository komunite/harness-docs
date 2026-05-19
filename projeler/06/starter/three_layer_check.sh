#!/usr/bin/env bash
# three_layer_check.sh — uc katmanli dogrulama kapisi.
# Katman 1: statik (lint/format niyeti — burada syntax check ile temsil).
# Katman 2: birim + entegrasyon testleri (pytest).
# Katman 3: uctan uca davranis (scripts/verify.sh — gercek HTTP cagirilari).
set -euo pipefail

echo "[1/3] Statik: python -m py_compile"
. .venv/bin/activate
python -m py_compile app.py otel_setup.py

echo "[2/3] Test: pytest"
pytest -q

echo "[3/3] E2E: scripts/verify.sh"
bash scripts/verify.sh

echo "OK — uc katman yesil."
