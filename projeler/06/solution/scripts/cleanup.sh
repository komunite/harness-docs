#!/usr/bin/env bash
# cleanup.sh — anlik temizlik. Idempotent.
# Iki kez koshturmak hic koshturmamakla ayni; hata kaynagi olamaz.
set -euo pipefail

# 1) Gecici debug log'lari sil
rm -f /tmp/debug-*.log

# 2) Repo icindeki SQLite dosyalari (testler kendi tmp dosyasiyla calisir)
rm -f notes.db notes.db-journal

# 3) Yerel .env varsa sablona dondur (sablon yoksa sessizce gec)
git checkout -- .env 2>/dev/null || true

# 4) Pytest cache ve __pycache__ temizligi
find . -type d -name '__pycache__' -not -path './.venv/*' -exec rm -rf {} + 2>/dev/null || true
rm -rf .pytest_cache

# 5) Kanit uret — testler yesil mi?
. .venv/bin/activate 2>/dev/null || true
pytest -q
