# Düzenek Yaratıcı (Harness Creator)

Üretim kalitesinde bir AI ajan düzeneği (harness) inşa etmek için yetenek paketi. Düzenek Mühendisliği (Harness Engineering) çerçevesinin beş aparatını — talimat, araç, ortam, durum, geri bildirim — somut artefaktlara çevirir; üzerine gözlemlenebilirlik ve temiz teslim ekler.

## Ne işe yarar

Boş bir repodan başlasanız da, şişmiş bir CLAUDE.md ile gelseniz de aynı dört fazlı döngüyü işletir: taslak → test → değerlendir → iyileştir. Her fazın çıktısı kanıttır, niyet değil. Sonuç: AGENTS.md (router), Makefile (dört kanonik hedef), init.sh (idempotent bootstrap), features.json (durum makinesi), PROGRESS.md (vardiya defteri), DECISIONS.md (gerekçe günlüğü), verifier.md (rol sözleşmesi), üç katmanlı doğrulama scripti, OTel iskeleti ve oturum kapanış scripti.

## Nasıl yüklenir

İki yol var. Birincisi paket yöneticisiyle:

```bash
npx skills add duzenek-yaratici
```

İkincisi git klonu — repo zaten klonluysa şu komut yeterli:

```bash
cp -r skill-pack/duzenek-yaratici/* /yeni/repo/.skill/duzenek-yaratici/
```

Skill çağırıcı çalışma dizinine `.skill/duzenek-yaratici/` altında yerleşir; içerideki `SKILL.md` ajanın aktivasyon noktasıdır.

## Hızlı başlangıç

Üç komutta düzeneği kurun:

```bash
cp -r .skill/duzenek-yaratici/templates/* ./    # şablonlar repo köküne
chmod +x scripts/*.sh init.sh                    # bootstrap idempotent
bash init.sh && make check                       # ilk yeşil sinyal
```

İlki şablonları çoğaltır; ikincisi script'leri çalıştırılabilir yapar; üçüncüsü bootstrap'i koşturur ve üç katmanı yeşilden geçirir. Yedi dakikadan az sürer. Bittiğinde repo soğuk başlangıç sözleşmesini taşır: `cat AGENTS.md && cat PROGRESS.md && cat features.json`.

## Çıktı

Yeni reponuzda görülecekler:

- **Beş aparat aktif** — AGENTS.md router; Makefile dört hedef; features.json durum makinesi; PROGRESS.md/DECISIONS.md vardiya devri; verifier.md üç katmanlı kapı.
- **Gözlemlenebilirlik bağlı** — `harness.*` namespace altında session/feature/verify span ağacı; GenAI semconv attribute'ları stdout'a düşer.
- **Temiz teslim zorunlu** — `bash scripts/session_close.sh` beş boyutu (build/test/progress/artifact/startup) tek tek doğrular; yarım state push'lanamaz.

## Lisans

CC0. Türetip kullanabilir, kapatabilir, satabilirsiniz. Atıf zorunlu değil ama makbul.
