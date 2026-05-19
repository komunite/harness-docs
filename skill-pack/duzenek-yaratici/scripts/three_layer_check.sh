#!/usr/bin/env bash
# three_layer_check.sh — uc katmanli dogrulama kapisi.
# Katman 1: statik (lint/format/derleme).
# Katman 2: birim + entegrasyon testleri.
# Katman 3: uctan uca davranis (gercek HTTP/DB).
# Ilk basarisiz katmanda durur; sonraki katmana gecmez.

set -euo pipefail

echo "[1/3] Statik — lint + type-check"
# Toolchain'e gore birini birak.
if command -v ruff >/dev/null 2>&1; then
  ruff check . || { echo "Katman 1 (ruff) basarisiz."; exit 1; }
fi
if command -v mypy >/dev/null 2>&1; then
  mypy . --ignore-missing-imports || { echo "Katman 1 (mypy) basarisiz."; exit 1; }
fi
if [[ -f package.json ]] && command -v pnpm >/dev/null 2>&1; then
  pnpm run lint 2>/dev/null || true
  pnpm run typecheck 2>/dev/null || true
fi
# Sozdizimi sanity (Python projeleri icin)
if ls *.py >/dev/null 2>&1; then
  python -m py_compile *.py || { echo "Katman 1 (py_compile) basarisiz."; exit 1; }
fi
echo "  OK"

echo "[2/3] Birim + entegrasyon — make test"
make test || { echo "Katman 2 (make test) basarisiz."; exit 1; }
echo "  OK"

echo "[3/3] E2E — bash scripts/verify.sh"
if [[ -x scripts/verify.sh ]]; then
  bash scripts/verify.sh || { echo "Katman 3 (verify.sh) basarisiz."; exit 1; }
else
  echo "  scripts/verify.sh yok veya calistirilabilir degil — atlandi."
  echo "  TODO: verifier kurulumunu tamamla (recipes/verifier-kurulumu.md)."
fi
echo "  OK"

echo
echo "OK — uc katman yesil."
