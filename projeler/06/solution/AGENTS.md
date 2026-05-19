# AGENTS.md — Capstone Düzeneği (solution)

Bes aparat + gozlemlenebilirlik + temiz teslim, tek koşumda.

## Routing — hangi role gireceksin

- **Yeni davranis veya endpoint** -> `executor.md`
- **Mevcut isin bagimsiz dogrulanmasi** -> `verifier.md`
- **Mimari karar** -> Once `DECISIONS.md`, sonra kod.
- **Sprint anlasmasi gerekli iyilestirme** -> `sprint-contracts/<konu>.md` yaz, sonra executor.

## Siki kisitlar

- **WIP = 1.** Ayni anda yalniz bir `TODO` ozellik acik.
- **Test yoksa davranis degisikligi yok.** Once test, sonra implementasyon.
- **`assert True` yasak.** Bos test reject.
- **Yarim commit yok.** Oturum ya commit ya rollback ile biter.
- **Bayat artefakt yasak.** `/tmp/debug-*.log`, yorum icine alinmis kod, yarim TODO — oturum sonunda silinmis olmali.
- **OTel ciktisini sessize alma.** Console exporter trace'leri stdout'a yazar; bu bir bug degil, bir aparat.

## Definition of Done (DoD)

Bir ozellik "DONE" olmaz, eger:

- [ ] `make test` yesil.
- [ ] `make verify` yesil (e2e).
- [ ] `three_layer_check.sh` yesil (uc katman).
- [ ] `features.json` icinde ilgili kayit `DONE`.
- [ ] `PROGRESS.md` son durumu yansitiyor.
- [ ] Yeni karar varsa `DECISIONS.md`'ye eklenmis.
- [ ] OTel span'lari `verify.sh` cikti loglarinda gorunuyor (gozlemlenebilirligin canli kaniti).

## Dev / Testing / PR

### Dev

- `make dev` — uvicorn 8000'de reload modunda.
- `OTEL_SEMCONV_STABILITY_OPT_IN=gen_ai_latest_experimental` ile gen_ai semconv opt-in (opsiyonel).

### Testing

- `make test` — pytest birim + entegrasyon.
- `make verify` — gercek HTTP cagrilariyla e2e.
- `make check` — uc katman (statik + test + e2e).
- `make session-close` — bes boyutu (build/test/progress/artifact/startup) tek tek dogrular.

### PR

- Tek bir ozellik. Mesaj tek satir, ne degisti + neden.
- Kanit komutu yorum olarak. Örnek: "verify ile dogrulandi: `make check`".
- OTel etkileyen degisiklikte ornek span ciktisi PR aciklamasina eklenir.

## Oturum Cikis Kontrol Listesi (10 madde)

Tek bir kalem isaretlenmediyse oturum bitmez.

- [ ] 1. `make test` yesil.
- [ ] 2. `make verify` yesil.
- [ ] 3. `three_layer_check.sh` yesil.
- [ ] 4. `features.json` guncel — TODO/DONE durumu kanitlanmis.
- [ ] 5. `PROGRESS.md` son durumu yansitiyor (bugun tarihli).
- [ ] 6. `DECISIONS.md` yeni karar varsa eklendi.
- [ ] 7. `Quality.md` modul notlari guncel; "buradan baslayin" isareti var.
- [ ] 8. Debug log/temp dosya yok (`find . -name 'debug-*.log'` bos).
- [ ] 9. `make dev` mudahalesiz acilir (5 saniyede yanit).
- [ ] 10. `git status --porcelain` -> ya commit ya rollback. Yarim degisiklik yok.

`bash scripts/session_close.sh` 1, 2, 5, 8, 9'u otomatik dogrular. Geriye kalan dort madde insan/ajan gozuyle teyit edilir.

## Vardiya devir-teslim — alirken

1. `cat README.md`
2. `cat AGENTS.md` (bu dosya)
3. `cat PROGRESS.md` — son durum.
4. `cat DECISIONS.md` — hangi yola neden gidildi.
5. `cat Quality.md` — en dusuk puanli modul = baslangic noktasi.
6. `cat features.json | python -m json.tool`
7. `bash init.sh && make check` — devraldigin halin uc katman yesil oldugunu kanitla.
8. OTel ciktisini bir kere `make verify` ile gor — gozlemlenebilirlik aparati canli mi?

## Vardiya devir-teslim — birakirken

1. `make check` yesil.
2. `bash scripts/session_close.sh` — bes boyut yesil.
3. `Quality.md` notlari guncel; "buraya gir" isareti tasinmis olabilir.
4. `git status --porcelain` bos veya yalniz commit'lenecek hazirligi var.
5. Son commit mesaji: ne degisti + neden + kanit komutu.

## Beş aparat tek diyagramda

```
+----------------------------------------------------------+
|  Repo: AGENTS.md, DECISIONS.md, docs/, Quality.md        |
|    + Durum: init.sh, PROGRESS.md, features.json          |
|       + Runtime fb: make test, verify, three_layer_check |
|          + Oz-dogrulama: executor.md, verifier.md        |
|             + Gozlem: otel_setup.py + middleware spanlari|
|                + Temiz teslim: session_close + cleanup   |
+----------------------------------------------------------+
```

Bir tanesi cikarilirsa diger dordu sessizce sahteye doner.
