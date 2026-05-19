# API Pattern Kurallari

Notes API icin sabit kurallar. Ajan bu kurallari degistirmeden uygular.

## Endpoint sozlesmesi

- Tum rotalar `Bearer` token ister; `auth` Depends ile baglanir.
- Yazma uclari (POST, PUT, DELETE) `201` veya `200` doner; hata `4xx` veya `5xx`.
- Listeleme uclari her zaman bir JSON dizisi doner. Bos durumda `[]`.
- Tekil kayit bulunamadiginda `404` doner; gizli kayit icin `404` tercih edilir, `403` degil.

## Sema kurallari

- Tum govde modelleri `pydantic.BaseModel` ile tanimlanir.
- `id` alani veritabaninda atanir; istemci POST gonderirken icermez, sunucu yanitta doldurur.
- Yeni alan eklerken `Optional` kullanma; varsayilan deger ver.

## Hata bicimi

- HTTPException mesajlari kisa ve teknik tutulur.
- 401 mesaji: `missing or invalid token`.
- 404 mesaji icin govde gerekmiyorsa bos birakilabilir.

## Arama uclari

- `q` parametresi bos veya yalnizca bosluk ise hemen `[]` donulur.
- Sorgu **mutlaka** parametreli (placeholder) yapilir; string interpolation yasaktir.
