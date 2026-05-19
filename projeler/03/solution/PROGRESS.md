# Proje Ilerleme

## Su anki durum

- Son commit: `feat: notes search endpoint iskeleti` (hash: `c0ffee1`)
- Test: smoke testleri yesil (2/2). Search testleri skip ile bekletiliyor (0 calisti, 2 skip).
- Lint: temiz.
- Calisan endpoint sayisi: POST /notes, GET /notes/id, GET /notes, GET /notes/search (kismi).

## Tamamlandi

- [x] Notes API iskeleti (POST, GET tekil, GET liste)
- [x] Bearer token auth
- [x] sqlite3 baglanti yardimcisi `conn()`
- [x] Smoke testleri (auth, create+read)
- [x] `GET /notes/search` endpoint iskeleti, mutlu yol manuel test edildi

## Devam ediyor

- [ ] `GET /notes/search` (yaklasik yuzde doksan tamam — iki acik madde)
  - Sorgu string interpolation ile kurulmus; `docs/security.md` ile celisik. SQL injection riski var.
  - Bos `q` parametresi tum kayitlari donduruyor; reddedilmesi gerekir (test mevcut, skip ile bekletiliyor).

## Bilinen sorunlar

- `tests/test_search.py::test_search_returns_matching_notes` skip; once SQL injection kapatilmali.
- `tests/test_search.py::test_search_empty_query_rejected` skip; bos `q` icin 400 doner hale gelmeli.
- `q` icindeki LIKE jokerleri (`%`, `_`) escape edilmiyor. Davranisin urunsel beklentisi belirsiz.

## Siradaki adimlar

1. `search_notes` icinde parametrize edilmis sorguya gec: `c.execute("... LIKE ?", (f"%{q}%",))`.
2. Bos `q` icin `HTTPException(400, "q must not be empty")` ekle.
3. `tests/test_search.py` icindeki iki `@pytest.mark.skip` decorator'unu kaldir; `make test` yesil olmali.
4. LIKE jokerleri konusunda urun kararini al, `DECISIONS.md`'ye yaz, gerekirse escape ekle.
5. `feat: search — guvenli sorgu + bos q reddi` commit'i; bu PROGRESS.md'yi de guncelle.

## Acik sorular

- Bos `q` icin 400 mu 422 mi? Su an plan 400; FastAPI'nin Pydantic dogrulamasi 422 verir, ayrim acik degil.
- LIKE jokerleri kullanici girdisinden gecirilmeli mi yoksa escape mi edilmeli? Karar bekliyor.
