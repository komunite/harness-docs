#!/usr/bin/env bash
# init.sh — oturum acilisinda calistir.
# Amac: ajanin "ben simdi neredeyim" sorusunu insan turuna sormadan yanitlamasi.

set -euo pipefail

echo "=== AGENTS.md ==="
[ -f AGENTS.md ] && head -n 40 AGENTS.md || echo "(yok)"

echo
echo "=== PROGRESS.md ==="
[ -f PROGRESS.md ] && cat PROGRESS.md || echo "(yok)"

echo
echo "=== DECISIONS.md (son 30 satir) ==="
[ -f DECISIONS.md ] && tail -n 30 DECISIONS.md || echo "(yok)"

echo
echo "=== features.md ==="
[ -f features.md ] && cat features.md || echo "(yok)"

echo
echo "=== git status ==="
git status --short 2>/dev/null || echo "(git repo degil)"
