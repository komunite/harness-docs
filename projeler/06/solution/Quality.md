# Quality Document — Capstone

Her modul icin bes boyut. En dusuk puanli modul "onceki vardiyada buraya gir" ile isaretli; bir sonraki vardiya kanitla baslar.

| Modul   | Dogrulama | Ajan-okunabilirlik | Test kararliligi | Mimari sinir | Konvansiyon |
| ------- | --------- | ------------------ | ---------------- | ------------ | ----------- |
| app     | A         | A                  | A                | A            | A           |
| db      | A         | B                  | A                | A            | B           |
| scripts | A         | A                  | B                | A            | A           |
| tests   | A         | A                  | A                | A            | B           |
| docs    | B         | B                  | B                | B            | C  &larr; Once buraya gir |

## Notlar

- **app**: Tum endpointler ve middleware kapsama girdi; OTel attribute'lari standart isimle.
- **db**: SQLite tek dosyada; ayri modul ayriligi B. Buyume halinde `db.py` olusur.
- **scripts**: `verify.sh` portu env'den okuyor; ama paralel calistirmada race riski var (B).
- **tests**: `assert True` yok; per-test izole DB; konvansiyon B cunku bazi yardimcilar `tests/utils.py`'ye cikabilir.
- **docs**: Runbook eksik bolumler iceriyor (or. OTel ciktisini hangi env'de filtreliyoruz). Konvansiyon C cunku bazi belgeler eski sablonla.

## Eylem

Sonraki vardiya: `docs/` icinde runbook'u tamamla, eski sablonu konvansiyona uydur. Hedef: hepsi B veya ustu.
