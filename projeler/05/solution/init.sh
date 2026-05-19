#!/usr/bin/env bash
# init.sh — solution ortam hazirligi. Tek seferlik.
set -euo pipefail

if [ ! -d ".venv" ]; then
  python -m venv .venv
fi

# shellcheck disable=SC1091
. .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install ruff || echo "ruff opsiyonel; py_compile fallback aktif"

chmod +x scripts/three_layer_check.sh scripts/verify.sh || true

echo "OK: solution ortami hazir."
echo "Tam dogrulama: 'bash scripts/three_layer_check.sh' veya 'make verify'."
