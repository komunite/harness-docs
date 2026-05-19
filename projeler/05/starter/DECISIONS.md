# DECISIONS

Mimari ve sozleşme kararları. Her madde tarih + gerekce icerir.

- 2026-05-10 — Bearer token tek auth yontemidir. Sebep: minimal yuzey,
  baseline ile uyum.
- 2026-05-12 — Arama LIKE ile parametrize edilir. Sebep: f-string SQL
  injection riskini ortadan kaldirmak.
- 2026-05-14 — Tek rol modeli (executor). Sebep: hizli iterasyon. Risk:
  oz-degerlendirme yanliligi. Bu risk solution'da rol ayrimi ile giderilir.
