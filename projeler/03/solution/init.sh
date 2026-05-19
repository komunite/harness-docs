#!/usr/bin/env bash
# init.sh — vardiya alimi (clock-in)
# Idempotent: birden fazla kez calistirilabilir, yan etkisi yoktur.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

echo "==> vardiya alimi basliyor"
echo "==> kok dizin: $ROOT"

# 1) Bagimliliklar — make setup zaten idempotent (pip install).
echo ""
echo "==> make setup"
make setup

# 2) Test durumu — yarim is testleri skip ile beklendigi icin || true.
#    Smoke testleri yesil olmalidir; degilse asagidaki cikti orneklerini incele.
echo ""
echo "==> make test (yarim is icin || true)"
make test || true

# 3) Vardiya defteri — ekrana bas, sonraki ajan ne yapacagini bilsin.
echo ""
echo "================ PROGRESS.md ================"
cat PROGRESS.md
echo "============================================="

# 4) Sonraki adimlar — PROGRESS.md icindeki listeden ilk maddeyi vurgula.
echo ""
echo "==> Onerilen sonraki adim:"
echo "    PROGRESS.md 'Siradaki adimlar' listesinin 1 numarali maddesinden devam et."
echo "    Belirsiz nokta varsa DECISIONS.md son uc kaydi oku; cevabi yine oraya yaz."
echo ""
echo "==> vardiya alindi. AGENTS.md icindeki 'Vardiya alimi (clock-in)' rutinini takip et."
