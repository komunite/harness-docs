#!/usr/bin/env bash
# init.sh — yeni vardiya icin ortami hazirlar. Idempotent.
set -euo pipefail

echo "== Capstone init =="

# 1) Python virtualenv
if [[ ! -d .venv ]]; then
  python -m venv .venv
fi

# shellcheck disable=SC1091
. .venv/bin/activate
pip install -q -r requirements.txt

# 2) DB ve gecici dosya temizligi (yeni vardiya temiz baslar)
rm -f notes.db notes.db-journal
rm -f /tmp/debug-*.log

# 3) Hizli saglik kontrolu
python -m py_compile app.py otel_setup.py

echo
echo "OK. Sirayla okumak icin:"
echo "  cat AGENTS.md"
echo "  cat PROGRESS.md"
echo "  cat features.json"
echo
echo "Calistir: make test && make verify"
