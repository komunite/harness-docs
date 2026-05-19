# AGENTS.md

Bu dosya bir router'dır. Yığını, sıkı kısıtları ve doğrulama komutlarını
ozetler; gerisi kodun kendisinden okunur.

## Sıkı kısıtlar

- Tum `/notes` endpoint'leri `Authorization: Bearer <API_TOKEN>` ister.
- SQL parametrize edilir; f-string ile SQL birleştirilmez.
- `app.py` baseline'ı korunur; imza değiştirmek gerekirse `DECISIONS.md`'ye
  gerekce yazılır.

## Doğrulama komutu

- Birim testler: `make test`

> Not: Bu starter'da **Definition of Done** bloku yoktur. Tamamlanma yargısı
> executor'in `make test` cıktısına bakıp verdigi sozdur. Solution
> klasorundeki `AGENTS.md` bu yargıyı dışsal bir verifier'a devreder ve uc
> katmanlı kapı tanımlar.

## Dev Environment Tips

- Python 3.11+ zorunludur.
- Kurulum: `make setup`.
- Yerel sunucu: `make dev`.
- Token: varsayılan `dev-token`. `API_TOKEN` ile uzerine yazılır.
- Veritabanı: `DB_PATH` ile SQLite dosyası secilir.

## Testing Instructions

- `make test` — `pytest -q` koşar.
- Test dosyası `fastapi.testclient.TestClient` kullanır; canlı sunucu
  gerektirmez.
- Yeni endpoint icin happy path testi eklenir.

## PR Instructions

- PR başlığı kısa, emir kipi.
- Aciklama: ne değişti, neden, doğrulama cıktısı.
- Bağımlılık eklendiyse `requirements.txt` aynı PR'da guncellenir.
