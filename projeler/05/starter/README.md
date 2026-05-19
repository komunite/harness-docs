# Starter — Tek Rol, Kendi Onaylar

Bu klasorde tek bir rol vardir: **executor**. Ajan kodu yazar, testleri
kendi koşturur ve "tamamlandi" raporunu **kendisi** verir. Sistematik bir
doğrulayici yoktur; uctan uca davranış kontrolu yoktur; tamamlanma yargisi
ajanin ic sesinden ibarettir.

Bu kurulum dersin tezini somutlaştirmak icindir: ajanlar sistematik olarak
fazla guvenlidir. Kendi cıktısına bakan ajan, insan gözlemcinin "yetersiz"
diyeceği durumlarda bile pozitif rapor üretir. Birim testler yeşildir;
kod yazılmıştır; "bitti" denmiştir — ama bir sınır hatası dosyanın icinde
sessizce oturmaktadır.

Aynı kod tabanı `../solution/` altında yapan/denetleyen ayrımı ve uc
katmanlı doğrulama kapısı ile yeniden duzenlenmiştir. İki klasorun farkı
[Ders 09 — Erken Zafer İlanı](../../../dersler/09-ajanlar-neden-erken-zafer-ilan-eder)
ve [Ders 10 — Uctan Uca Test](../../../dersler/10-uctan-uca-test-neden-sonuclari-degistirir)
derslerinin saha kanıtıdır.

## Calistirma

```
make setup
make test
```

Tum birim testler yeşil cıkar. Bu **yeterli** gorunur — ama yeterli
degildir. Asagıdaki "Buldugun zaman" bolumune bak.

## Bu klasordeki rol modeli

- `executor.md` — tek rol tanımı. Ajan kodu yazar, testleri koşturur,
  kendi raporunu duzenler.
- `AGENTS.md` — kısıtlar var; ancak "Definition of Done" bloku yok.
  Tamamlanma yargısı ajanin kendi sozudur.
- `tests/test_smoke.py` — yalnız happy path. Sınır hatalarını gormez.
- `scripts/verify.sh` — tek katmanlı; sadece pytest koşturur.

## Buldugun zaman

`PUT /notes/{nid}` endpoint'i bulunmayan bir `nid` icin **404 yerine 200**
doner ve govdesinde bos `id` ile bir `Note` uretir. Bu defekt:

- Birim testlerden gecer (happy path yazilmiştir, missing-id senaryosu
  yazilmamiştir).
- Lint'ten gecer (sozdizimi temizdir).
- Ajanin **kendi gozune** carpmaz; cunku ajan kendi yazdığı koda kendi
  yazdığı testle bakar.

Bu davranısı starter'da **bilerek bırakıyoruz.** Solution'da hem hata
giderilmiştir hem de hatayı yakalayacak bir **verifier** rolu ve uc
katmanlı doğrulama scripti vardır.
