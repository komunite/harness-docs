#!/usr/bin/env bash
# scripts/verify.sh — features.json icindeki aktif feature'i dogrular ve durumunu gunceller.
#
# Davranis:
#   1) WIP=1 ihlali (birden fazla active) varsa hicbir is yapmadan erken cikar.
#   2) Hicbir feature active degilse bilgi mesaji verir ve sifir kodla cikar.
#   3) Aktif feature'in `verification` komutunu calistirir.
#   4) Komut sifir kodla biterse `state` -> `passing` ve `evidence` icine commit hash + tarih yazar.
#   5) Komut basarisiz olursa `state` `active` kalir ve script sifir-disi kodla cikar.
#
# Bagimliliklar: jq, git (commit hash icin opsiyonel), bash 4+.

set -euo pipefail

FEATURES_FILE="${FEATURES_FILE:-features.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "hata: jq bulunamadi (PATH'e ekleyin)" >&2
  exit 2
fi

if [ ! -f "$FEATURES_FILE" ]; then
  echo "hata: $FEATURES_FILE yok" >&2
  exit 2
fi

# JSON gecerli mi?
if ! jq empty "$FEATURES_FILE" 2>/dev/null; then
  echo "hata: $FEATURES_FILE gecersiz JSON" >&2
  exit 2
fi

# 1) WIP=1 invariant — ayni anda en fazla bir feature 'active' olabilir.
active_count=$(jq '[.[] | select(.state=="active")] | length' "$FEATURES_FILE")
if [ "$active_count" -gt 1 ]; then
  echo "hata: WIP=1 ihlali — $active_count adet active feature var" >&2
  jq -r '.[] | select(.state=="active") | "  " + .id + " — " + .behavior' "$FEATURES_FILE" >&2
  exit 3
fi

# 2) Aktif feature yoksa sessiz cik (basarili kabul).
if [ "$active_count" -eq 0 ]; then
  echo "bilgi: active feature yok — yapilacak dogrulama yok"
  jq -r 'group_by(.state) | map({state: .[0].state, count: length}) | .[] | "  " + .state + ": " + (.count|tostring)' "$FEATURES_FILE"
  exit 0
fi

# 3) Aktif feature'i oku.
active_id=$(jq -r '.[] | select(.state=="active") | .id' "$FEATURES_FILE")
verify_cmd=$(jq -r --arg id "$active_id" '.[] | select(.id==$id) | .verification' "$FEATURES_FILE")

echo "active feature: $active_id"
echo "dogrulama komutu: $verify_cmd"
echo "---"

# 4) Komutu calistir. Cikis kodunu yakala (set -e altinda dogrudan calistirinca abort eder).
set +e
bash -c "$verify_cmd"
rc=$?
set -e

echo "---"
echo "cikis kodu: $rc"

if [ "$rc" -ne 0 ]; then
  echo "sonuc: feature $active_id active kaliyor (dogrulama basarisiz)"
  exit "$rc"
fi

# 5) Basarili. state -> passing, evidence guncellenir.
commit_hash=$(git rev-parse --short HEAD 2>/dev/null || echo "no-git")
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
evidence="commit $commit_hash — verified at $timestamp via verify.sh"

tmp_file=$(mktemp)
trap 'rm -f "$tmp_file"' EXIT

jq --arg id "$active_id" --arg ev "$evidence" \
  'map(if .id == $id then .state = "passing" | .evidence = $ev else . end)' \
  "$FEATURES_FILE" > "$tmp_file"

mv "$tmp_file" "$FEATURES_FILE"
trap - EXIT

echo "sonuc: feature $active_id -> passing"
echo "evidence: $evidence"
