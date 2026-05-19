# PROGRESS

Bu dosya iki oturum arasinda durum tasimak icindir. Ajan her oturum sonunda
asagidaki alanlari gunceller; sonraki oturum okuyarak kaldigi yerden devam eder.

## Mevcut odak

- Notes API'nin canonical uclari `app.py` icinde tamamlandi.
- `/notes/search` ucu parametreli sorguya cevrildi; ilgili testler `tests/test_search.py` icinde aktif.
- Ozellik listesi `features.json` icinde primitif olarak tutuluyor.
- `scripts/verify.sh` aktif ozelligi calistirip durumunu yazar.

## Son oturum kararlari

- Search testleri `pytest.skip` ile gecistirilmedi; gercek testlerle dogrulandi.
- F02 (search) `passing` olarak isaretlendi; kanit `features.json` icindeki `evidence` alaninda.

## Sonraki oturuma not

- Yeni feature aktive edilmeden once VCR kontrolu yapilir (bkz. `AGENTS.md`).
- WIP=1: ayni anda yalniz tek bir `active` feature olmali.
- `make verify` yesil olmadan durum elle `passing`'e yazilmaz.
