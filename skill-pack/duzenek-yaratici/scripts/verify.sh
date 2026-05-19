#!/usr/bin/env bash
# verify.sh — uctan uca davranis dogrulamasi.
# Aktif feature'in 'verification' komutunu kosar.
# Mock'lar minimum; gercek HTTP/DB/protokol.

set -euo pipefail

FEATURES="${FEATURES_FILE:-features.json}"

if [[ ! -f "$FEATURES" ]]; then
  echo "verify.sh: $FEATURES bulunamadi. Once init.sh kos."
  exit 1
fi

# Aktif feature'i bul. JSON array veya obje yapisina toleransli.
ACTIVE_ID=$(jq -r '
  if type == "array" then
    .[] | select(.state == "active") | .id
  elif type == "object" and (.features|type) == "array" then
    .features[] | select(.state == "active") | .id
  else empty end
' "$FEATURES" 2>/dev/null || true)

if [[ -z "$ACTIVE_ID" ]]; then
  echo "verify.sh: aktif feature yok. Scheduler bir sonrakini secmeli."
  echo "          features.json icinde state='active' kayit bekleniyor."
  exit 0
fi

CMD=$(jq -r --arg id "$ACTIVE_ID" '
  if type == "array" then
    .[] | select(.id == $id) | .verification
  elif type == "object" and (.features|type) == "array" then
    .features[] | select(.id == $id) | .verification
  else empty end
' "$FEATURES")

if [[ -z "$CMD" || "$CMD" == "null" ]]; then
  echo "verify.sh: $ACTIVE_ID icin verification komutu yok."
  exit 1
fi

mkdir -p artifacts
LOG="artifacts/${ACTIVE_ID}.log"

echo "==> $ACTIVE_ID dogrulanıyor: $CMD"
if bash -c "$CMD" > "$LOG" 2>&1; then
  COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "uncommitted")
  echo "PASS $ACTIVE_ID (log: $LOG)"

  # State + evidence guncelle (jq inplace yok; tmp file uzerinden).
  jq --arg id "$ACTIVE_ID" --arg c "$COMMIT" --arg l "$LOG" '
    if type == "array" then
      map(if .id == $id then .state = "passing" | .evidence = {commit: $c, log: $l} else . end)
    elif type == "object" and (.features|type) == "array" then
      .features |= map(if .id == $id then .state = "passing" | .evidence = {commit: $c, log: $l} else . end)
    else . end
  ' "$FEATURES" > "$FEATURES.tmp" && mv "$FEATURES.tmp" "$FEATURES"
else
  echo "FAIL $ACTIVE_ID — bkz: $LOG"
  exit 1
fi
