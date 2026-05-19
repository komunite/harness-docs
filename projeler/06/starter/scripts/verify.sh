#!/usr/bin/env bash
# verify.sh — uctan uca davranis dogrulamasi.
# Sunucuyu arka planda kaldirir, gercek HTTP cagrilariyla
# auth/CRUD/search akisini test eder, sonra temiz biter.
set -euo pipefail

PORT="${PORT:-8765}"
TOKEN="${API_TOKEN:-dev-token}"
DB_FILE="$(mktemp -t notes-verify-XXXXXX.db)"

cleanup() {
  if [[ -n "${SERVER_PID:-}" ]]; then
    kill "$SERVER_PID" 2>/dev/null || true
    wait "$SERVER_PID" 2>/dev/null || true
  fi
  rm -f "$DB_FILE"
}
trap cleanup EXIT

# shellcheck disable=SC1091
. .venv/bin/activate

export DB_PATH="$DB_FILE"
export API_TOKEN="$TOKEN"

uvicorn app:app --port "$PORT" --log-level warning >/tmp/verify-server.log 2>&1 &
SERVER_PID=$!

# Sunucu hazir mi diye bekle. Saglik kontrolu yerine /notes 401 testi yeterli.
for _ in $(seq 1 30); do
  if curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:${PORT}/notes" \
       | grep -q "401"; then
    break
  fi
  sleep 0.2
done

H="Authorization: Bearer ${TOKEN}"
BASE="http://127.0.0.1:${PORT}"

# 1) Auth eksikse 401
code=$(curl -s -o /dev/null -w "%{http_code}" "${BASE}/notes")
[[ "$code" == "401" ]] || { echo "FAIL: auth check, got $code"; exit 1; }

# 2) Note yarat
nid=$(curl -s -H "$H" -H "Content-Type: application/json" \
  -d '{"title":"e2e","body":"hello"}' "${BASE}/notes" \
  | python -c "import sys,json;print(json.load(sys.stdin)['id'])")
[[ -n "$nid" ]] || { echo "FAIL: create"; exit 1; }

# 3) Note oku
title=$(curl -s -H "$H" "${BASE}/notes/${nid}" \
  | python -c "import sys,json;print(json.load(sys.stdin)['title'])")
[[ "$title" == "e2e" ]] || { echo "FAIL: get"; exit 1; }

# 4) Search
hits=$(curl -s -H "$H" "${BASE}/notes/search?q=e2" \
  | python -c "import sys,json;print(len(json.load(sys.stdin)))")
[[ "$hits" -ge 1 ]] || { echo "FAIL: search"; exit 1; }

# 5) PUT 404
code=$(curl -s -o /dev/null -w "%{http_code}" -X PUT -H "$H" \
  -H "Content-Type: application/json" \
  -d '{"title":"x","body":"y"}' "${BASE}/notes/999999")
[[ "$code" == "404" ]] || { echo "FAIL: put 404, got $code"; exit 1; }

# 6) Delete
code=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE -H "$H" "${BASE}/notes/${nid}")
[[ "$code" == "204" ]] || { echo "FAIL: delete, got $code"; exit 1; }

echo "E2E OK"
