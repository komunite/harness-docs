# AGENTS.md — Capstone Düzeneği (starter)

Bu repo, beş aparatın tamamını barındıran bir capstone harness'tır.
Onceki vardiya OTel eklemeye basladi ama bitirmedi; ilk gorevin onu tamamlamak.

## Routing

- **Yeni davranıs / endpoint** -> `executor.md` rolu ile gir.
- **Mevcut isin dogrulanmasi** -> `verifier.md` rolu ile gir.
- **Mimari karar** -> Once `DECISIONS.md`'yi guncelle, sonra kodu.

## Sıkı kısıtlar

- **WIP = 1.** Ayni anda birden fazla `TODO` ozelligi acmazsin.
- **Test yoksa davranis degisikligi yok.** Once test, sonra implementasyon.
- **`assert True` yasak.** Bos test reject edilir.
- **`/tmp/debug-*.log` veya repo icindeki gecici dosyalar oturum sonunda silinir.**
- **Yarim commit yok.** Oturum ya commit ya rollback ile biter.

## Definition of Done (DoD)

Bir ozellik "DONE" olmaz, eger:

- [ ] `make test` yesil.
- [ ] `make verify` yesil (e2e).
- [ ] `three_layer_check.sh` yesil (uc katman).
- [ ] `features.json` icinde ilgili kayit `DONE` durumunda.
- [ ] `PROGRESS.md` son durumu yansitiyor.
- [ ] Yeni karar varsa `DECISIONS.md`'ye eklenmis.

## Dev / Testing / PR

- **Dev:** `make dev`. Sunucu 8000'de.
- **Testing:** `make test` (birim) -> `make verify` (e2e) -> `make check` (uc katman).
- **PR:** Tek bir ozellik. Mesaj: ne degisti + neden. Kanit komutu mutlaka yorum olarak iliştirilir.

## Vardiya devir-teslim

### Alirken

1. `cat PROGRESS.md` — neyin yapildi, neyin sirada.
2. `cat DECISIONS.md` — hangi yola neden gidildi.
3. `cat features.json | python -m json.tool` — ne `TODO`, ne `DONE`.
4. `bash init.sh && make test` — devraldigin halin yesil oldugunu kanitla.

### Birakirken

1. `make check` yesil.
2. `PROGRESS.md` guncel.
3. Yeni karar varsa `DECISIONS.md` guncel.
4. `git status --porcelain` -> commit ya da rollback. Yarim degisiklik yok.
