# API Patterns

Ne zaman oku: `app.py` içindeki endpoint'leri değiştirirken veya yeni endpoint eklerken. Sadece kod stili veya validation kuralı için buraya bak; auth ile ilgili kararlar `security.md`'de, persistence kuralları `database-rules.md`'dedir.

## Sıkı kısıtlar

- Her endpoint `Depends(auth)` ile korunur. İstisna açık karar gerektirir ve `AGENTS.md`'deki sıkı kısıtlar bölümünde gerekçelendirilir.
- Her endpoint `response_model` belirtir. Tipsiz dönüş kabul edilmez.
- Status kodları aşağıdaki tabloya uyar; özel durumlar bu dokümana eklenir.

## URI ve kaynak isimlendirme

- Kaynak isimleri çoğul: `/notes`, ileride `/users`, `/sessions`.
- Path parametreleri kısa ve okunabilir: `nid` (note id), `uid` (user id). Karışıklık riski varsa açık isim tercih edilir.
- Endpoint URI'leri küçük harf, tire yok, alt çizgi yok. Yalın kelime kullanılır.

## Status kodları

| Durum | Kod |
| --- | --- |
| Başarılı POST (kaynak yaratıldı) | 201 |
| Başarılı GET | 200 |
| Yetkisiz erişim (token yok veya geçersiz) | 401 |
| Bulunamayan kaynak | 404 |
| Validation hatası | 422 |
| Beklenmedik sunucu hatası | 500 |

403 ve 401 ayrımı şu an yapılmaz; ayrım gerekirse bu tabloya eklenir.

## Response gövdesi

- Tekil kaynak için JSON objesi.
- Liste için JSON dizisi; "envelope" sarmalayıcı kullanılmaz.
- Hata gövdesi FastAPI'nin standart formatına bırakılır: `detail` alanı içerir, ek alan eklenmez.

## Validation

- Pydantic `BaseModel` ile tanımlanır. Şu an `Note` modeli `title` ve `body` taşır; ikisi de zorunlu string.
- Ek kural eklemek için `Field(min_length=...)` gibi Pydantic v2 araçları kullanılır.
- Custom validator gerekiyorsa `@field_validator` kullanılır; v1 stilini karıştırma.
- Validation hatası gövdesi Pydantic tarafından üretilir; override yok.

## Pagination, filtering, search

- Şu an üçü de yok.
- Eklendiğinde: pagination cursor-based olur, offset-based değil. Cursor alanı response gövdesine `next` olarak eklenir.
- Filtering query parametreleri ile gelir: `?title=foo`. Filtre eklenince bu doküman güncellenir.
- Search ayrı bir tartışma; eklenirse bu dokümana bir alt bölüm açılır.

## Tipsel ve dekoratör deseni

Yeni endpoint eklerken aşağıdaki desen takip edilir. Mevcut `create_note` referans olarak kullanılır: `response_model`, `status_code`, `dependencies` üçü de açıkça belirtilir; SQL parametreli yazılır; `with conn() as c` deyimi commit'i taşır. Persistence ile ilgili detay için `database-rules.md`'ye bak.

## Bu dosyanın kapsamı

API yüzeyi ile ilgili konvansiyonlar. Şu konular **bu dosyada değil**:

- DB transaction kuralları → `database-rules.md`
- Auth dependency mekaniği → `security.md`
- Modül içi dosya düzeni → `src/api/ARCHITECTURE.md`
