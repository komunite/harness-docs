#!/usr/bin/env bash
# Starter: tek katmanli dogrulama. Yalniz pytest kosar.
# Solution'da yerini scripts/three_layer_check.sh alir.
set -euo pipefail

echo "--> pytest"
pytest -q

echo "OK: tests passed (executor self-report)"
