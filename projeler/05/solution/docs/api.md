# API

Notes API. Tum ucnoktalar `Authorization: Bearer <API_TOKEN>` ister.

## Endpoint'ler

- `POST /notes` — yeni not olustur. Govde: `{"title": str, "body": str}`.
  Yanit: 201 + Note.
- `GET /notes` — tum notlari listele. Yanit: 200 + Note[].
- `GET /notes/{nid}` — tek not. Yanit: 200 + Note, ya da 404.
- `GET /notes/search?q=...` — baslik VEYA govdede LIKE araması. Yanit:
  200 + Note[].
- `PUT /notes/{nid}` — notu guncelle. Yanit: 200 + Note. **Olmayan id
  icin 404.**
- `DELETE /notes/{nid}` — notu sil. Yanit: 204, ya da 404.

## Sozdizimi notlari

- `/notes/search` rotasi `/notes/{nid}` rotasindan **once** tanimlanir.
- Tum SQL parametrize: f-string birleştirme yasaktir.

## Davranis sozlesmesi

- PUT missing id → 404. Bu satir yalniz birim testle degil, e2e ile
  korunur (tests/test_e2e.py::test_put_missing_id_returns_404).
- DELETE missing id → 404. Aynı kural.
- Auth basarisiz → 401, govdede "missing or invalid token". Sızdırılmıs
  veri yok.
