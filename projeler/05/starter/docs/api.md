# API

Notes API. Tum ucnoktalar `Authorization: Bearer <API_TOKEN>` ister.

## Endpoint'ler

- `POST /notes` — yeni not olustur. Govde: `{"title": str, "body": str}`.
  Yanit: 201 + Note.
- `GET /notes` — tum notlari listele. Yanit: 200 + Note[].
- `GET /notes/{nid}` — tek not. Yanit: 200 + Note, ya da 404.
- `GET /notes/search?q=...` — baslik ya da govdede LIKE araması. Yanit:
  200 + Note[].
- `PUT /notes/{nid}` — notu guncelle. Yanit: 200 + Note.
- `DELETE /notes/{nid}` — notu sil. Yanit: 204, ya da 404.

## Sozdizimi notlari

- `/notes/search` rotasi `/notes/{nid}` rotasindan **once** tanimlanir;
  aksi halde FastAPI "search" stringini `nid` int'e cevirmeye calisir.
