# AGENTS.md — Yonlendirici

Bu dosya bir router'dir. Detayli kurallar `docs/` altinda yasar; burada yalnizca "hangi durumda nereye bakilacagi" yazar.

## Proje ozeti

- Minimal Notes API, FastAPI + sqlite3.
- Bearer token auth, tum endpoint'ler korumali.
- Test cercevesi: pytest. Calistirma: `make test`.

## Yonlendirme tablosu

| Durum | Nereye bak |
| --- | --- |
| Yeni endpoint ekliyorum | `docs/api-patterns.md` |
| SQL sorgusu yaziyorum | `docs/database-rules.md` |
| Auth, token, girdi dogrulama | `docs/security.md` |
| Sema degisikligi gerekiyor | `docs/database-rules.md` (Sema degisikligi bolumu) |
| Oturum acildi, nereden devam | `PROGRESS.md` + `DECISIONS.md` |
| Karar gerekceleri | `DECISIONS.md` |

## Dev environment

- Python 3.11+.
- Bagimliliklar: `make setup` (`pip install -r requirements.txt`).
- Calistirma: `make dev` (uvicorn reload).

## Testing

- `make test` tum testleri kosturur.
- Smoke testleri `tests/test_smoke.py` icinde; her PR'da yesil olmali.
- Skip edilmis testler is yarim demektir; gizlenmis degildir, ertelenmistir.

## PR conventions

- Commit basligi: `tip: kapsam — kisa aciklama` (ornek: `feat: search — bos q reddedildi`).
- Her PR yesil `make test` ile gelir.
- Tek bir konuyu kapsa; karisik PR bolunur.

## Vardiya alimi (clock-in)

Yeni oturum aciliyor. Asagidaki adimlar sirayla, atlamadan:

1. `./init.sh` calistir. `make setup` ve `make test` calisir, `PROGRESS.md` ekrana basilir.
2. `PROGRESS.md` "Su anki durum" bolumunu oku: son commit, test durumu, lint.
3. `DECISIONS.md` son uc kaydi oku. Onceki vardiyanin reddettigi alternatifleri tekrar onerme.
4. `PROGRESS.md` "Bilinen sorunlar" + "Siradaki adimlar" listelerini oku. Tek bir maddeyi sec ve baslay.
5. Belirsiz nokta varsa kodda degisiklik yapmadan once kullaniciya sor; cevabi `DECISIONS.md`'ye yaz.

## Vardiya teslimi (clock-out)

Oturum bitiyor. Asagidaki adimlar olmadan vardiya teslim alinmamis sayilir:

1. `PROGRESS.md` guncelle: "Su anki durum" (son commit hash, test sayisi, skip sayisi), "Tamamlandi" listesine bugun biteni ekle, "Devam ediyor"u guncel yuzdeye cek, "Siradaki adimlar"i yeniden sirala.
2. Bugun alinan her baglayici karar icin `DECISIONS.md`'ye tarih + neden + reddedilen alternatif + kisit ekle.
3. `make check` yesil olmali. Degilse "Bilinen sorunlar"a yaz, kapanis commit'ine ekleme.
4. Tek descriptive commit at: `chore: vardiya teslim — <ozet>` ya da feature commit'i ne ise.
5. Cevabi belirsiz acik sorulari `PROGRESS.md` sonuna "Acik sorular" baslikli madde olarak birak; kullaniciya da ilet.
