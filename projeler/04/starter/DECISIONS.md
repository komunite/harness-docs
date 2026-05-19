# DECISIONS

Geri donulemez ya da geri donmesi zor kararlarin gerekce loglari. Tarih sirasiyla.

## 2025-01 — Bearer token + SQLite

- API minimum bagimliliklarla kurulur: FastAPI + sqlite3 + pydantic.
- Token ortam degiskeninden okunur; rotasyon icin yapilandirma dosyasi yok.

## 2025-02 — Search parametreli sorguya cevrildi

- Eski hal: `f"...WHERE title LIKE '%{q}%'"`. SQL injection acigi.
- Yeni hal: `WHERE title LIKE ?` + `(f"%{q}%",)`. Davranis korundu, risk kapatildi.
- Geriye donus yasak; benzeri her sorgu ayni sablonu izler.
