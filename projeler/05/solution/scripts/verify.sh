#!/usr/bin/env bash
# Uyumluluk shim'i. Eski cagrilar 'scripts/verify.sh'i bekliyor olabilir;
# bu sarmal three_layer_check.sh'i cagirir.
set -euo pipefail
exec bash "$(dirname "$0")/three_layer_check.sh"
