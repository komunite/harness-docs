# Solution — Yapan/Denetleyen Ayrımı + Uc Katmanlı Doğrulama

Starter ile aynı kod tabanı; iki yapısal fark:

1. **Rol ayrımı.** `executor.md` yanına `verifier.md` eklenmiştir. Verifier
   kod yazmaz; yalnız doğrulamayı dısarıdan kosar ve raporlar.
2. **Uc katmanlı kapı.** `scripts/three_layer_check.sh` sırayla **lint →
   unit → e2e** koşar. Katman N başarısızken N+1'e gecilmez.

Ek olarak starter'daki `PUT /notes/{nid}` defekti giderilmiştir: olmayan
bir `nid` icin endpoint artık `404` doner. Bu duzeltmeyi yakalayan kanıt
verifier rolunun urettiği `tests/test_e2e.py` icindeki uctan uca akıstır;
birim test paketi yalnız happy path baktıgı icin defekti gormezdi.

## Calistirma

```
make setup
bash scripts/three_layer_check.sh
```

Bekleneni: lint OK → unit OK → e2e OK. Herhangi bir katman duşerse script
**ERROR / WHY / FIX** formatında ajan-okunur bir mesaj basar ve durur.

## Dosya haritası

- `app.py` — duzeltilmis Notes API.
- `executor.md` — yapan rolun sozleşmesi.
- `verifier.md` — denetleyen rolun sozleşmesi (read-only, uc katman koşar).
- `AGENTS.md` — Definition of Done bloku icerir; tamamlanma yargısı dışsal.
- `scripts/three_layer_check.sh` — lint → unit → e2e sıralı kapı.
- `scripts/verify.sh` — uyumluluk icin `three_layer_check.sh` cagrisi.
- `tests/test_smoke.py` — birim/happy path testleri.
- `tests/test_search.py` — arama edge case'leri.
- `tests/test_e2e.py` — uctan uca akış; **PUT-missing-id 404 testi burada**.
- `features.json` — her madde icin dışsal `passes` alanı.
- `PROGRESS.md` — her satır verifier imzası ister.
- `DECISIONS.md` — rol ayrımı + uc katman kapı kararı kayıt altında.

## Dersle bağlantı

[Ders 09](../../../dersler/09-ajanlar-neden-erken-zafer-ilan-eder) "yapan
kendine bakmaz" tezini koyar; [Ders 10](../../../dersler/10-uctan-uca-test-neden-sonuclari-degistirir)
uctan uca testin neden mimari olarak gerekli olduğunu acıklar. Bu klasor
o iki dersin saha uygulamasıdır.
