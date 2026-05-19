# Starter — Cok Oturumlu Sureklilik (Yarim Birakilmis Vardiya)

Bu klasor, vardiyasini eksik teslim etmis bir takimi temsil eder. Bir onceki oturumda `GET /notes/search?q=...` endpoint'i eklenmeye baslandi ama bitirilemedi. Iki sorun acik:

- Sorgu string interpolation ile kurulmus; SQL injection riski var (`docs/security.md` ile celisik).
- Bos `q` parametresi tum kayitlari donduruyor; testler bunu reddetmeli ama henuz reddetmiyor.

`tests/test_search.py` icindeki iki test `@pytest.mark.skip` ile bekletiliyor. `make test` yesil, ama is bitmis degil.

Asil sorun kodda degil, repoda eksik olan seylerde:

- `PROGRESS.md` yok. Yeni acilan bir oturum "nerede kaldigimi" repodan okuyamaz.
- `DECISIONS.md` yok. Bir hafta sonra "search icin neden FTS5 degil LIKE?" diye soracak bir ajan, gerekceyi bulamayacagi icin tersini onerebilir.
- `AGENTS.md` icinde vardiya alimi/teslimi rutini yazili degil. Oturum baslangici ve bitisi sozsuz.
- `init.sh` yok. Soguk baslangic her seferinde sifirdan kesif demek.

## Gorev

Bu starter'in uzerine `solution/` klasorundeki sureklilik artefaktlarini ekleyin. Kodu duzeltmek **bu projenin amaci degil**; amaci, devir teslimi yapilabilir hale getirmek. Bug'i bir sonraki oturuma birakacak sekilde belgelemek esas hedeftir.

## Calistirma

```bash
make setup
make test   # yesil: yarim is testleri skip ile gizlendigi icin
```

## Sonraki oturuma birakilan acik sorular

- Search icin LIKE yeterli mi, yoksa FTS5'e gecmek mi gerekir? (Karari `DECISIONS.md`'de gerekceli yaz.)
- Bos `q` parametresi 400 mu, 422 mi donmeli? FastAPI varsayilani 422; ama urunsel beklenti 400 olabilir.
- `q` icinde `%` ve `_` karakterleri (LIKE jokerleri) escape edilmeli mi?

Bu sorularin hepsi bir sonraki vardiyada cevaplanmali. Repodan okunabilir olmayan her cevap, oturum aralarinda kaybolur.
