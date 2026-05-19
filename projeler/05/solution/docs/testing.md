# Testing

Uc seviye + uc dosya. Her seviye `scripts/three_layer_check.sh`'in bir
adimi.

## Seviyeler

1. **Katman 1 — Lint / sozdizimi.** `ruff check .` ya da
   `python -m py_compile`. Saniyeler surer.
2. **Katman 2 — Unit / integration.** `tests/test_smoke.py` (CRUD happy
   path + auth) + `tests/test_search.py` (arama edge case + injection
   denemesi).
3. **Katman 3 — E2E.** `tests/test_e2e.py`. Tam akis ve sinir testleri.
   Burada PUT-missing-id 404 dogrulamasi yapilir.

## Kural

Katman N basarisizken N+1'e gecilmez. Verifier kapida durur ve ERROR /
WHY / FIX blogu yazar.

## Calistirma

- Executor (hizli): `pytest -q`
- Verifier (tam kapi): `bash scripts/three_layer_check.sh` ya da
  `make verify`

## Birim testin korlugu — neden e2e?

Birim testler izolasyon icin tasarlanmistir; izolasyon kusurlarin yasadigi
bilesen sinirlarini mock'lar ile siler. PUT-missing-id defekti tam bu
sinir hatasidir: endpoint kendi icinde "calisir gorunur" (SELECT/UPDATE
calisir, hata atmaz) ama uctan uca "guncelleme olmayan satira yazilirsa
ne olur" davranisi bos kalir. Yalniz uctan uca test bu yokluga isaret
edebilir.
