# Sprint Contract: Notes Search Iyilestirmeleri

Ust paragraf: Bu sozlesme generator (executor) ve evaluator (verifier) arasinda kod yazimi baslamadan once mutabakat saglar. Uretilen sonradan reddedilmez; cunku kapsam yazili.

## Kapsam

- SQLite FTS5 sanal tablosu kurulumu (`notes_fts`).
- `/notes/search` endpoint'i FTS5'i kullanir, `LIKE` fallback'i kalir.
- Yeni note olusturma ve guncelleme FTS5 tablosunu da senkronize eder (trigger).
- En az uc test:
  - `test_search_finds_whole_word` — tam kelime esleşmesi.
  - `test_search_case_insensitive` — buyuk kucuk harf duyarsiz.
  - `test_search_fallback_when_fts_unavailable` — FTS5 yok ise eski yol calisir.

## Dogrulama standartlari

- `make test` yesil — tum mevcut testler kirilmadi.
- `make verify` yesil — e2e search response'lari beklenen sonucu donuyor.
- `three_layer_check.sh` yesil — uc katman.
- OTel ciktisinda `search_notes` span'i `search.q` ve `search.result_count` attribute'larini tasir.
- Performans: 1000 kayitta search 50 ms altinda (manuel olcum, kanit not edilir).

## Disinda birakilanlar

- **UTF-8 disi encoding kapsam disi.** FTS5 tokenizer'i `unicode61` ile sinirlandirilir. Latin-1 veya CP-1254 destegi yok.
- **Stemming kapsam disi.** "running" ve "run" ayri kelime sayilir.
- **Synonim/eş anlamli sözlügü kapsam disi.**
- **Cok dilli tokenization kapsam disi.** Tek dil varsayilir; gelecekteki bir sprint icin acik.
- **Front-end degisikligi yok.** API kontrati ayni.

## Kabul edildiginde

`features.json` icine `F07 — Notes search improvements (FTS5)` eklenir, `Quality.md` `db` modulu yeniden notlanir.
