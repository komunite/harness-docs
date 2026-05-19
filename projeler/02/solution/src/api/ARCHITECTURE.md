# src/api — ARCHITECTURE

Bu modül henüz fiziksel olarak ayrı bir dizinde değildir; mevcut tüm endpoint kodu repo kökündeki `app.py` içindedir. Bu dosya, modül *zaten ayrılmış olsaydı* nasıl görüneceğini ve hangi sınırların korunacağını yazar; refactor başladığında bu dosya yol haritası olarak kullanılır.

## Niyet

API katmanı tek bir sorumluluk taşır: HTTP isteklerini kabul edip Pydantic modelleriyle doğrulamak, persistence katmanına yönlendirmek, response'u şekillendirmek. İş kuralı API katmanında durmaz; bir gün domain katmanı eklendiğinde bu sınır netleşir.

## Bağımlılıklar

- API katmanı FastAPI ve Pydantic'e bağlıdır.
- API katmanı persistence için `conn()` fonksiyonunu kullanır; SQLite import'u sadece persistence yardımcılarında olur. API endpoint kodu doğrudan `sqlite3` import etmez.
- Auth, `Depends(auth)` ile her endpoint'e enjekte edilir; ayrıntı `docs/security.md`.

## Dosya düzeni — hedef

```
src/api/
├── ARCHITECTURE.md     # bu dosya
├── __init__.py
├── routes.py           # FastAPI dekoratörleri ve handler'lar
├── models.py           # Pydantic modelleri
└── dependencies.py     # auth ve diğer Depends fonksiyonları
```

Mevcut durumda hepsi `app.py` içinde tek dosyada toplanmıştır; refactor sırasında bu üç dosyaya bölünür.

## Sınırlar

- Endpoint dosyası iş kuralı barındırmaz; sadece request mapping ve response shaping.
- Pydantic modelleri persistence şemasıyla aynı olmak zorunda değildir; bir gün ayrılırlar.
- Auth dependency'si API katmanında durur ama uygulama kuralı (token kaynağı, rotation politikası) `docs/security.md`'dedir.

## Neden hâlâ tek dosya

Üç endpoint için üç dosya bölmek prematüredir. Eşik: endpoint sayısı beşi geçtiğinde veya farklı resource grupları belirginleştiğinde bölme zamanı gelir. Bölme kararı bu dosyada commit edilir.

## Referanslar

- Endpoint konvansiyonu: `docs/api-patterns.md`
- DB kuralları: `docs/database-rules.md`
- Auth ve secret: `docs/security.md`
