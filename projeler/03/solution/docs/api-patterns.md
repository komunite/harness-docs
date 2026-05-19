# API Desenleri

Bu repo, FastAPI uzerinde minimal bir Notes API barindirir. Yeni endpoint eklerken asagidaki desenlere uy.

## Endpoint sozlesmesi

- Tum endpoint'ler `Depends(auth)` ile korunur. Bearer token zorunludur.
- Yaratma islemleri `status_code=201` doner; govde `Note` modelidir.
- Tekil okumalar kaynak bulunamadiginda `404` doner.
- Liste okumalari `list[Note]` doner; bos koleksiyon 200 ile bos liste demektir, 404 degil.

## Hata bicimi

- FastAPI'nin varsayilan `HTTPException` mekanizmasi kullanilir. Ozel hata zarflari uretme.
- Yetkilendirme hatalari: 401, "missing or invalid token".
- Dogrulama hatalari: Pydantic'in 422 cevabini tut, ezme.

## Yeni endpoint ekleme adimlari

1. `app.py` icine, mevcut endpoint'lerin alt kismina ekle.
2. `response_model` ve `dependencies=[Depends(auth)]` zorunlu.
3. `tests/` altina en az bir mutlu yol + bir hata yolu testi.
4. Yeni davranis `PROGRESS.md`'de "Devam ediyor" altinda gorunmedikce bitti sayilmaz.
