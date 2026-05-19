# DECISIONS

Geri donulemez ya da geri donmesi zor kararlarin gerekce loglari. Tarih sirasiyla.

## 2025-01 — Bearer token + SQLite

- API minimum bagimliliklarla kurulur: FastAPI + sqlite3 + pydantic.
- Token ortam degiskeninden okunur; rotasyon icin yapilandirma dosyasi yok.

## 2025-02 — Search parametreli sorguya cevrildi

- Eski hal: `f"...WHERE title LIKE '%{q}%'"`. SQL injection acigi.
- Yeni hal: `WHERE title LIKE ?` + `(f"%{q}%",)`. Davranis korundu, risk kapatildi.
- Geriye donus yasak; benzeri her sorgu ayni sablonu izler.

## 2025-03 — features.json primitif yapildi

- Eski hal: serbest formda `features.md` notlari. Durumlar belirsiz, makine okuyamiyor.
- Yeni hal: `features.json` — id, behavior, verification, state, depends_on, evidence alanlariyla.
- `state` artik elle yazilmaz; `scripts/verify.sh` dogrulama komutu sifir cikis kodu verince gunceller.

## 2025-03 — WIP=1 mekanik kilit

- `scripts/verify.sh` calismaya baslarken ayni anda birden fazla `active` feature gorurse erken cikar.
- Kural ajanin diskresyonunda degil; script tarafindan zorlanir.
