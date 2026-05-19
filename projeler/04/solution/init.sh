#!/usr/bin/env bash
# init.sh — oturum acilisinda calistir.
# Amac: ajanin "ben simdi neredeyim" sorusunu insan turuna sormadan yanitlamasi.

set -euo pipefail

echo "=== AGENTS.md ==="
[ -f AGENTS.md ] && head -n 60 AGENTS.md || echo "(yok)"

echo
echo "=== PROGRESS.md ==="
[ -f PROGRESS.md ] && cat PROGRESS.md || echo "(yok)"

echo
echo "=== DECISIONS.md (son 30 satir) ==="
[ -f DECISIONS.md ] && tail -n 30 DECISIONS.md || echo "(yok)"

echo
echo "=== features.json — durum dagilimi ==="
if [ -f features.json ] && command -v jq >/dev/null 2>&1; then
  jq -r 'group_by(.state) | map({state: .[0].state, count: length}) | .[] | "\(.state): \(.count)"' features.json
  echo
  echo "Aktif feature:"
  jq -r '.[] | select(.state=="active") | "  \(.id) — \(.behavior)"' features.json
else
  echo "(features.json veya jq yok)"
fi

echo
echo "=== git status ==="
git status --short 2>/dev/null || echo "(git repo degil)"
