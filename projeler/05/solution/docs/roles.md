# Roles

Bu dosya `executor.md` ve `verifier.md`'ye giden bir indeks. Ozet:

- **executor** — yapan. Kod yazar, birim test yazar. Tamamlanma yargisi
  vermez. Bkz. [executor.md](../executor.md).
- **verifier** — denetleyen. Kod yazmaz. `scripts/three_layer_check.sh`
  kosturur, rapor yazar. Tamamlanma yargisini verir. Bkz.
  [verifier.md](../verifier.md).

## Neden iki rol?

Bir ogrenci kendi sinavini okumaz. Kalibrasyon yanliligi tek basina da
yetiyor — kendi cikti uzerinde ajan sistematik olarak fazla guvenli
puanliyor — ama yapisal ayrim daha guclu kararlar uretiyor. Bu projedeki
PUT-404 defekti tek rol modelinde "tamamlandi" damgasi yemisti; iki rol
modelinde verifier ilk e2e kosumunda yakaladi.

## Yetki sinir hatti

| Eylem                          | Executor | Verifier |
| ------------------------------ | :------: | :------: |
| Kod yazmak                     |   Evet   |  Hayir   |
| Birim test yazmak              |   Evet   |  Hayir   |
| E2E suit kosturmak             |   Evet*  |   Evet   |
| "passing" damgasi vurmak       |  Hayir   |   Evet   |
| ERROR/WHY/FIX yazmak           |   -      |   Evet   |
| PROGRESS.md "done" satiri      |  Hayir   |   Evet   |

`*` Executor e2e kosturabilir; ama sonucu "passing" diye imzalayamaz —
imza verifier'in.
