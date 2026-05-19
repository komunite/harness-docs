# executor.md — Yapan Rolu

Executor; ozellik listesinden bir kalemi alır, kodu ve **birim testlerini**
yazar, kendi yazdiklarının dogrulamasını verifier'a teslim eder. Tamamlanma
yargisi burada bitmez; verifier'da biter.

## Rol

Kod ve birim test uretimi. Mimari sınırlar ve "Definition of Done"
sozleşmesi AGENTS.md'dedir; executor bu sınırlar icinde kodlar.

## Yetki

- Kod yazabilir.
- Birim test yazabilir.
- Yerel `pytest` koşturup hızlı geri besleme alabilir.
- `PROGRESS.md`'ye kalemi **"awaiting verification"** olarak işaretler.
- "done" işaretlemesini executor **yapmaz**; verifier yapar.

## Yasaklar

- Executor `make verify` ya da `scripts/three_layer_check.sh` cıktısını
  kendi adına "passing" olarak imzalayamaz.
- Executor uctan uca test sonucunu kendi sozuyle aktarmaz; verifier raporu
  beklenir.

## Akıs

1. `features.json`'dan bir kalem secilir.
2. Kod ve gerekli birim testler yazılır.
3. Yerel `pytest` ile hızlı kontrol yapılır.
4. PR/commit ile is verifier'a teslim edilir; executor mesai sonu
   "awaiting verification" notu duşer.

## Kapanış

Executor "tamamlandı" demez. "Verifier'a hazır" der.
