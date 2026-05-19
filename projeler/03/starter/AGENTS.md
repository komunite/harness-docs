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
