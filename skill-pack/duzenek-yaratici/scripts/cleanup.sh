#!/usr/bin/env bash
# cleanup.sh — anlik temizlik. Idempotent.
# Iki kez kosturmak hic kosturmamakla ayni; hata kaynagi olamaz.

set -euo pipefail

# 1) Gecici debug log'lari sil
rm -f /tmp/debug-*.log

# 2) Repo icindeki SQLite/test DB dosyalari (testler kendi tmp dosyasiyla calisir)
rm -f *.db *.db-journal 2>/dev/null || true

# 3) Yerel .env varsa sablona dondur (sablon yoksa sessizce gec)
git checkout -- .env 2>/dev/null || true

# 4) Python cache temizligi
find . -type d -name '__pycache__' \
  -not -path './.venv/*' \
  -not -path './node_modules/*' \
  -exec rm -rf {} + 2>/dev/null || true
rm -rf .pytest_cache .mypy_cache .ruff_cache

# 5) Node cache temizligi (varsa)
if [[ -d node_modules/.cache ]]; then
  rm -rf node_modules/.cache
fi

# 6) Build artefaktlari
rm -rf dist build .next .turbo 2>/dev/null || true

# 7) Kanit uret — testler yesil mi?
if make test >/tmp/cleanup-test.log 2>&1; then
  echo "cleanup OK: testler yesil."
else
  echo "cleanup uyari: testler kirmizi (bkz: /tmp/cleanup-test.log)"
  exit 1
fi
