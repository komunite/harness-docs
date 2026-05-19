# Recipe — Verifier rolünü kurmak

Tamamlanma yargısını yapan ajandan denetleyen ajana taşımak.

## Hedef

Aynı oturumun bir özelliği "tamamlandı" diye işaretlemesini mekanik olarak engellemek; bu yargıyı bağımsız bir verifier'a ve üç katmanlı bir kapıya bağlamak.

## Önkoşullar

- `features.json` mevcut, en az bir kayıt `active` durumunda.
- `Makefile`'da `test` ve `check` hedefleri çalışıyor.
- Repoda `scripts/` klasörü ve `verify.sh`'nin iskeleti var.

## Adımlar

### 1. verifier.md'yi yerleştir

```bash
cp .skill/duzenek-yaratici/templates/verifier.md.template ./verifier.md
```

Dört bölümü gözden geçir:

- **Rol** — verifier kod yazmaz, davranış ölçer. Bu satırı silme.
- **Yetki** — okuyabilir, koşturabilir, yalnız raporu yazabilir. Kaynak kod yazma yetkisi yok.
- **Üç katman koşumu** — sıra zorunlu; düşen katmandan sonrası koşmaz.
- **Hata mesajı formatı** — ERROR / WHY / FIX üçlüsü.

### 2. AGENTS.md'ye DoD bloğunu ekle

`AGENTS.md`'nin "Sıkı kısıtlar" bölümünden hemen sonra şu blok durur:

```markdown
## Definition of Done

- Feature complete = uçtan uca davranış doğrulandı.
- Üç katman: 1) lint+type, 2) unit+integration, 3) e2e (gerçek HTTP/DB).
- Katman N başarısızken N+1'e geçme.
- Tamamlanma yargısı verifier'dan gelir, executor'dan değil.
- features.json içinde "passing" yazma yetkisi yalnız verifier'da.
```

Bu blok söz değil, mekaniktir. `verifier.md` ile birlikte sözleşmeyi tamamlar.

### 3. three_layer_check.sh — üç katman tek komut

```bash
cp .skill/duzenek-yaratici/scripts/three_layer_check.sh ./scripts/
chmod +x scripts/three_layer_check.sh
```

Script üç katmanı sırayla koşar; ilk başarısızlıkta `set -euo pipefail` ile durur. Lokal ve CI aynı komut.

Makefile'a hedef ekle:

```makefile
check:
	bash scripts/three_layer_check.sh
```

### 4. verify.sh — gerçek doğrulama

Şu anki `verify.sh` placeholder olabilir. Aktif feature'ın `verification` komutunu gerçek hale getir:

```bash
# scripts/verify.sh — F01: GET /health 200 doner
set -euo pipefail
. .venv/bin/activate
uvicorn app:app --port 8765 --log-level warning &
SERVER_PID=$!
trap "kill $SERVER_PID 2>/dev/null || true" EXIT
sleep 1

code=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8765/health)
[[ "$code" == "200" ]] || { echo "FAIL: /health $code"; exit 1; }
echo "E2E OK"
```

Gerçek HTTP, gerçek port, gerçek protokol — mock değil.

### 5. features.json'a verification path'i bağla

```json
{
  "id": "F01",
  "behavior": "GET /health 200 doner",
  "verification": "bash scripts/verify.sh",
  "state": "active",
  "depends_on": [],
  "evidence": null
}
```

Verifier scripti çalıştığında `state`'i `passing` yapacak ve `evidence`'a commit hash + log path yazacak.

### 6. Pass-state gating

`features.json` içinde "passing" yazma yetkisi sadece verifier'da. Ajanın bu alana doğrudan yazma yetkisini reddetmek için pre-commit hook:

```bash
# .git/hooks/pre-commit (veya pre-commit framework içinde)
if git diff --cached features.json | grep -q '"state": "passing"'; then
  if ! git diff --cached features.json | grep -q '"evidence": {'; then
    echo "REJECT: 'passing' icin 'evidence' alani dolu olmali."
    exit 1
  fi
fi
```

Mekanik kapı; kibarlık değil sözleşme.

### 7. İlk doğrulama koşumu

```bash
make check
```

Üç katman yeşilse F01 `passing`'e geçirilebilir. Verifier scripti otomatik olarak `state` ve `evidence`'ı günceller (bkz. `kutuphane/features-json.mdx` otomasyon bloğu).

## Kanıt

- `cat verifier.md` — dört bölüm tam.
- `grep "Definition of Done" AGENTS.md` — DoD bloğu yerinde.
- `make check` — yeşil; `three_layer_check.sh` üç katmanı sırayla geçiyor.
- `features.json` — `passing` durumundaki kayıt `evidence` ile birlikte gelmiş.

## Yaygın hatalar

- **Verifier kod yazıyor** — Rol ihlali. verifier.md'nin "Yapamazsın" listesini katı uygula. Refactor önerse bile reddet.
- **Three layer check katman atlıyor** — `set -euo pipefail` yoksa veya `||` ile yutuluyorsa sözleşme delik. Script'i pür tut.
- **features.json'a manuel `passing` yazılıyor** — Pre-commit hook devrede değilse mekanik kapı yok. Sadece dokümante kural yetmez.
- **e2e testi mock kullanıyor** — Üçüncü katman gerçek HTTP, gerçek DB. Mock kullanırsan katman 2'ye düşürürsün; isimlendirmeyi düzelt veya gerçek yapıyı kur.
