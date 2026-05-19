# INDEX — Dosya haritası

Her dosyanın derslere ve kütüphane sayfalarına bağlandığı yer.

## Manifest ve dokümantasyon

| Dosya | Türev ders | Türev kütüphane |
| --- | --- | --- |
| `SKILL.md` | Ders 02 — Düzeneğin Anatomisi | `kutuphane/index` |
| `README.md` | Ders 06 — Başlangıç Fazı | `kutuphane/bootstrap` |
| `INDEX.md` | — | — |

## Workflow

| Dosya | Türev ders | Türev kütüphane |
| --- | --- | --- |
| `workflow/01-taslak.md` | Ders 02, Ders 04 | `kutuphane/agents-md` |
| `workflow/02-test.md` | Ders 06, Ders 10 | `kutuphane/bootstrap`, `kutuphane/verifier-dod` |
| `workflow/03-degerlendir.md` | Ders 11 | `kutuphane/sprint-rubric` |
| `workflow/04-iyilestir.md` | Ders 12 | `kutuphane/session-close` |

## Recipes

| Dosya | Türev ders | Türev kütüphane |
| --- | --- | --- |
| `recipes/soguk-baslangic.md` | Ders 03, Ders 06 | `kutuphane/bootstrap` |
| `recipes/vardiya-teslimi.md` | Ders 05 | `kutuphane/progress-decisions` |
| `recipes/verifier-kurulumu.md` | Ders 09, Ders 10 | `kutuphane/verifier-dod` |
| `recipes/gozlemlenebilirlik.md` | Ders 11 | `kutuphane/otel-trace` |
| `recipes/temiz-teslim.md` | Ders 12 | `kutuphane/session-close` |

## Templates

| Dosya | Kaynak |
| --- | --- |
| `templates/AGENTS.md.template` | `kutuphane/agents-md` + `projeler/06/solution/AGENTS.md` |
| `templates/PROGRESS.md.template` | `kutuphane/progress-decisions` |
| `templates/DECISIONS.md.template` | `kutuphane/progress-decisions` |
| `templates/features.json.template` | `kutuphane/features-json` |
| `templates/verifier.md.template` | `kutuphane/verifier-dod` + `projeler/06/solution/verifier.md` |
| `templates/Makefile.template` | `kutuphane/bootstrap` + `projeler/06/solution/Makefile` |
| `templates/init.sh.template` | `kutuphane/bootstrap` + `projeler/06/solution/init.sh` |
| `templates/session-close.md.template` | `kutuphane/session-close` |

## Scripts

| Dosya | Kaynak |
| --- | --- |
| `scripts/verify.sh` | `projeler/06/solution/scripts/verify.sh` |
| `scripts/three_layer_check.sh` | `projeler/06/solution/three_layer_check.sh` |
| `scripts/session_close.sh` | `projeler/06/solution/scripts/session_close.sh` |
| `scripts/cleanup.sh` | `projeler/06/solution/scripts/cleanup.sh` |

## Memory

| Dosya | Türev ders | Türev kütüphane |
| --- | --- | --- |
| `memory/PATTERNS.md` | Ders 05, Ders 12 | `kutuphane/progress-decisions`, `kutuphane/session-close` |

## Beş aparat eşlemesi

| Aparat | Birincil artefakt | Yardımcı |
| --- | --- | --- |
| Talimat | `templates/AGENTS.md.template` | `templates/verifier.md.template` |
| Araç | `templates/Makefile.template`, `templates/init.sh.template` | `scripts/*.sh` |
| Ortam | `templates/features.json.template` | `scripts/verify.sh` |
| Durum | `templates/PROGRESS.md.template`, `templates/DECISIONS.md.template` | `memory/PATTERNS.md` |
| Geri bildirim | `templates/verifier.md.template` | `scripts/three_layer_check.sh` |

Üstüne iki kesik: gözlemlenebilirlik (`recipes/gozlemlenebilirlik.md`) ve temiz teslim (`scripts/session_close.sh`, `scripts/cleanup.sh`).

## Önerilen okuma sırası

İlk kez bakıyorsan: `SKILL.md` → `README.md` → `workflow/01-taslak.md` → `templates/AGENTS.md.template` → `recipes/soguk-baslangic.md` → `memory/PATTERNS.md`.

Mevcut bir düzeneği revize ediyorsan: `workflow/03-degerlendir.md` → en düşük puanlı aparatın template'ı → `workflow/04-iyilestir.md`.
