# Guvenlik Kurallari

## Kimlik dogrulama

- Tum uclar `Bearer <token>` bekler. Token `API_TOKEN` ortam degiskeninden okunur.
- Yanlis veya eksik token icin `401` doner; mesaj kullaniciya hassas bilgi sizdirmaz.

## Girdi dogrulamasi

- Tum kullanici girisi pydantic ile sema dogrulamasindan gecer.
- Serbest metin alanlari (`title`, `body`) icin uzunluk siniri yoksa eklenmesi onerilir; ekleme `DECISIONS.md`'ye yazilir.

## SQL injection

- Sorgular parametreli yazilir. `?` placeholder zorunludur.
- String interpolation ile olusturulmus SQL ifadesi gorulurse:
  1. Hemen parametreli surume cevrilir.
  2. `DECISIONS.md`'ye duzeltme notu yazilir.
  3. Davranisi koruyan bir test eklenir (ornek: quote karakteri iceren sorgu 500 vermeden 200 doner).

## Loglama

- Sirlar (`API_TOKEN`, ham `Authorization` header'i) logda yer almaz.
- Hata mesajlari iz birakir ama stack trace istemciye gonderilmez.
