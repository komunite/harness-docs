#!/usr/bin/env bash
# init.sh — starter ortam hazirligi. Tek seferlik.
set -euo pipefail

if [ ! -d ".venv" ]; then
  python -m venv .venv
fi

# shellcheck disable=SC1091
. .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "OK: starter ortami hazir. 'make test' ile dogrulayin."
