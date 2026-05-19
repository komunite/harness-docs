#!/usr/bin/env bash
# session_close.sh — bes boyutu (build/test/progress/artifact/startup) tek tek
# dogrular ve oturum sonunda temiz state birakildigini kanitlar.
# Idempotent: iki kez kosturmak hic kosturmamakla ayni veya daha guvenli.

set -euo pipefail

PASS=0
FAIL=0

ok()   { echo "  [OK]   $1"; PASS=$((PASS+1)); }
fail() { echo "  [FAIL] $1"; FAIL=$((FAIL+1)); }

echo "== Session Close — bes boyut =="

# 1) BUILD
echo
echo "[1/5] Build"
if make setup >/tmp/sc-build.log 2>&1; then
  ok "make setup"
else
  fail "make setup (log: /tmp/sc-build.log)"
fi

# 2) TEST
echo
echo "[2/5] Test"
if make test >/tmp/sc-test.log 2>&1; then
  ok "make test"
else
  fail "make test (log: /tmp/sc-test.log)"
fi

# 3) PROGRESS — PROGRESS.md var, bos degil, bugun dokunulmus mu?
echo
echo "[3/5] Progress"
if [[ -s PROGRESS.md ]]; then
  today=$(date -u +%Y-%m-%d)
  # mtime'in bugun olup olmadigi (BSD ve GNU stat'a uyumlu)
  mtime_day=$(
    date -u -r PROGRESS.md +%Y-%m-%d 2>/dev/null \
    || date -u -d "@$(stat -c %Y PROGRESS.md 2>/dev/null)" +%Y-%m-%d 2>/dev/null \
    || echo "unknown"
  )
  if [[ "$mtime_day" == "$today" ]]; then
    ok "PROGRESS.md bugun guncel ($today)"
  else
    fail "PROGRESS.md son degisiklik $mtime_day, bugun degil"
  fi
else
  fail "PROGRESS.md bos veya yok"
fi

# 4) ARTIFACT — bayat debug dosyasi var mi?
echo
echo "[4/5] Artifact"
debug_count=$(find . -name 'debug-*.log' -not -path './.venv/*' -not -path './node_modules/*' 2>/dev/null | wc -l | tr -d ' ')
tmp_debug=$(find /tmp -maxdepth 1 -name 'debug-*.log' 2>/dev/null | wc -l | tr -d ' ')
if [[ "$debug_count" == "0" && "$tmp_debug" == "0" ]]; then
  ok "bayat artefakt yok"
else
  fail "debug-*.log bulundu (repo: $debug_count, /tmp: $tmp_debug)"
fi

# 5) STARTUP — make dev acilis denemesi (3 saniye)
echo
echo "[5/5] Startup"
if make dev >/tmp/sc-startup.log 2>&1 &
then
  SP=$!
  sleep 3
  if kill -0 "$SP" 2>/dev/null; then
    ok "make dev ayaga kalkti (PID $SP)"
    kill "$SP" 2>/dev/null || true
    wait "$SP" 2>/dev/null || true
  else
    fail "make dev ayaga kalkmadi (log: /tmp/sc-startup.log)"
  fi
else
  fail "make dev baslatilamadi (log: /tmp/sc-startup.log)"
fi

echo
echo "Toplam: PASS=$PASS  FAIL=$FAIL"
if [[ "$FAIL" -gt 0 ]]; then
  echo "Oturum kapanmadi. Bes boyutun hepsi yesil olana kadar yarim teslim yok."
  exit 1
fi
echo "Oturum temiz kapanabilir."
