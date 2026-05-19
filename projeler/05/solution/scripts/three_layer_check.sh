#!/usr/bin/env bash
# three_layer_check.sh — yapan/denetleyen ayriminin somut kapisi.
# Verifier rolu bu scripti kosturur; executor "passing" demek icin bu
# cikisina bakar. Katman N basarisizken N+1'e gecilmez.
set -euo pipefail

# ----- yardimci: ERROR / WHY / FIX blogu yazip cik -----
fail() {
  local layer="$1"
  local what="$2"
  local why="$3"
  local fix="$4"
  echo ""
  echo "============================================================"
  echo "VERIFIER BLOCKED — Katman ${layer} duser"
  echo "------------------------------------------------------------"
  echo "ERROR: ${what}"
  echo "WHY:   ${why}"
  echo "FIX:   ${fix}"
  echo "============================================================"
  exit 1
}

# ----- Katman 1 — lint / sozdizimi -----
echo "--> Katman 1: lint / sozdizimi"
if command -v ruff >/dev/null 2>&1; then
  if ! ruff check . ; then
    fail "1" \
      "ruff check . FAIL" \
      "Sozdizimi ya da stil ihlali var; ruff cikti hatti yukarida." \
      "Yukaridaki ruff bulgularini giderin, scripti tekrar kosturun. Otomatik duzeltme icin: 'ruff check --fix .'"
  fi
else
  echo "    (ruff yok; python -m py_compile fallback)"
  if ! python -m py_compile app.py tests/*.py ; then
    fail "1" \
      "py_compile FAIL" \
      "En az bir Python dosyasi sozdizimi olarak gecersiz." \
      "Yukaridaki traceback'in gosterdigi dosya/satiri duzeltin, sonra tekrar kosturun."
  fi
fi
echo "OK: Katman 1"

# ----- Katman 2 — unit / integration -----
echo "--> Katman 2: unit / integration"
if ! pytest tests/test_smoke.py tests/test_search.py -q ; then
  fail "2" \
    "pytest unit/integration FAIL" \
    "En az bir birim/integration testi duser. Cikti hatti yukarida; ilk FAIL satirina bakin." \
    "Ilgili modulu duzeltin (kod), gerekiyorsa testi netlestirin (test). Sonra 'bash scripts/three_layer_check.sh' tekrar kosturun."
fi
echo "OK: Katman 2"

# ----- Katman 3 — e2e -----
echo "--> Katman 3: e2e"
if ! pytest tests/test_e2e.py -q ; then
  fail "3" \
    "pytest e2e FAIL" \
    "Uctan uca akis (create -> get -> put -> put-missing -> delete -> re-get) en az bir adimda kirildi. Birim testlerin gormedigi sinir hatasi burada gorulur." \
    "FAIL eden test adina bakin; HTTP status / govde beklentisi neyse onu uygulamada karsilayin. Ornegin PUT olmayan id icin 404 dondurmek: 'if cur.rowcount == 0: raise HTTPException(404)'."
fi
echo "OK: Katman 3"

echo ""
echo "============================================================"
echo "VERIFIER PASSING — uc katman da gecti"
echo "lint OK | unit OK | e2e OK"
echo "============================================================"
