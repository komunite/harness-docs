---
name: duzenek-yaratici
display_name: Düzenek Yaratıcı (Harness Creator)
description: Üretim kalitesinde bir AI ajan düzeneği (harness) inşa etmeyi taslaktan iterasyona taşıyan yetenek paketi.
version: 1.0.0
language: tr
homepage: https://github.com/lokomotifai/harness-docs
tags: [harness-engineering, claude-code, codex, agents]
compatibility:
  - claude-code
  - openclaw
license: CC0
---

# Düzenek Yaratıcı (Harness Creator)

Düzenek Mühendisliği (Harness Engineering) — bir AI kod ajanının çalıştığı ortamı (repo + durum + araç + geri bildirim + gözlem) yapı taşı yapı taşı kurma disiplini. Bu yetenek paketi, herhangi bir repoda bu beş aparatın tamamını taslaktan iterasyona kadar somut artefaktlara dönüştürür: AGENTS.md, Makefile, init.sh, features.json, PROGRESS.md, DECISIONS.md, verifier.md, OTel kurulumu ve oturum kapanış scripti.

Pakette ne öğreti var ne de pasif şablon: aktif bir workflow ve aktif bir kontrol listesi. Skill çağrıldığında ajan dört fazlı bir döngüye girer — taslak, test, değerlendir, iyileştir — ve her geçişte beş aparatın durumunu kanıtla yansıtır.

## Ne zaman kullanılır

Üç somut tetikleyici:

- **Yeni proje** — boş bir repo veya yeni klonlanmış bir kod tabanı için ilk oturumda. Ajan henüz hiçbir Makefile, AGENTS.md, features.json yokken çağrılır.
- **Mevcut düzenek revizyonu** — şişmiş bir CLAUDE.md veya 600 satırlık bir AGENTS.md beş aparat çerçevesine göre yeniden bölünmek istendiğinde.
- **Süreklilik kaybı sinyali** — "ajan dün ne yaptığını hatırlamıyor", "erken zafer ilan ediyor", "her oturum sıfırdan başlıyor" gibi belirtiler için. Boyut tanılaması ve eksik aparatı pinpoint etmek için workflow/03-degerlendir.md fazına doğrudan girilir.

## Workflow

Skill her zaman dört fazda ilerler. Bir önceki bitmeden sonrakine geçilmez.

1. **Taslak** — `workflow/01-taslak.md`. Repoyu ablasyon et: beş aparattan hangileri eksik? Eksik olanlar için iskelet artefaktları templates/ üzerinden yerleştir. Bir commit at: `init: bootstrap complete`.
2. **Test** — `workflow/02-test.md`. `bash init.sh` ve `make check` çalışır mı? Smoke testi geçer mi? Soğuk başlangıç testi: yeni bir oturum açılınca düzenek kendi kendini açıklıyor mu?
3. **Değerlendir** — `workflow/03-degerlendir.md`. Sprint rubrik tablosunu doldur. Beş boyut: doğrulama, ajan-okunabilirlik, test kararlılığı, mimari sınır, konvansiyon. En düşük puanlı aparatı işaretle.
4. **İyileştir** — `workflow/04-iyilestir.md`. En düşük puanlı aparatı bir oturumda yükselt; geri kalanına dokunma. Test → değerlendir adımına geri dön.

Detay her dosyada. Skill çağrıldığında sırasıyla okunur; atlama yapılmaz.

## Beş aparat kapsamı

Skill her artefaktı bir aparata bağlar:

- **Talimat aparatı** — `templates/AGENTS.md.template`. Router; 50-200 satır; sıkı kısıtlar, DoD, oturum kapanış kontrol listesi.
- **Araç aparatı** — `templates/Makefile.template` ve `templates/init.sh.template`. Dört kanonik hedef: setup, dev, test, check. Idempotent bootstrap.
- **Ortam aparatı** — `templates/features.json.template` + verifier scripti. Makine-okunabilir özellik listesi; durum makinesi WIP=1.
- **Durum aparatı** — `templates/PROGRESS.md.template` ve `templates/DECISIONS.md.template`. Vardiya defteri ve gerekçe günlüğü.
- **Geri bildirim aparatı** — `templates/verifier.md.template` + `scripts/three_layer_check.sh`. Üç katmanlı kapı: lint, unit, e2e.

Üstüne iki yatay kesik: gözlemlenebilirlik (`recipes/gozlemlenebilirlik.md`) ve temiz teslim (`scripts/session_close.sh` + `scripts/cleanup.sh`).

## Memory and handoff

Skill sadece dosya yerleştirmez; oturumlar arası süreklilik için iki kanıtı zorlar. `PROGRESS.md` her vardiya kapanışında bugünün tarihiyle güncellenir; `DECISIONS.md` her bağlayıcı kararda yeni bir blok alır. Açılışta okunan dosyalar (AGENTS.md → PROGRESS.md → DECISIONS.md → features.json), kapanışta yazılan dosyalar (PROGRESS.md → DECISIONS.md → commit) `memory/PATTERNS.md` dokümanında tek bir protokole bağlanır. Pause-resume sözleşmesi 12-Factor Agents faktör 5/6'nın somut karşılığıdır.

## Activation

Bir ajan bu yeteneği çağırırken:

1. Önce `INDEX.md`'yi okur, hangi dosyanın hangi derse karşılık geldiğini görür.
2. `workflow/01-taslak.md` ile başlar; ablasyon adımını koşar.
3. Templates klasöründen ihtiyaç duyulanları repo köküne kopyalar (`cp templates/AGENTS.md.template ./AGENTS.md` gibi).
4. Scripts klasörünü `./scripts/` altına çoğaltır; `chmod +x` verir.
5. `bash init.sh` koşturur.
6. Workflow dosyalarını sırayla bitirir; dört faz tamamlanmadan teslim etmez.

Skill çıktısı somut: yeni repoda bes aparatın canlı, kanıtlı, otomasyona bağlı hali.
