# Recipe — Temiz teslim

Bir oturum ya commit ya rollback ile biter; ortada kalış yok.

## Hedef

Vardiya kapanışında repo'yu beş boyutta yeşil bırakmak — build, test, progress, artifact, startup. Yarım state push'lanamaz, pre-push hook mekanik olarak engeller.

## Önkoşullar

- `scripts/session_close.sh` ve `scripts/cleanup.sh` mevcut, çalıştırılabilir.
- `Makefile`'da `setup`, `test`, `check` hedefleri yeşil.
- `PROGRESS.md` bugünün vardiyasında dokunulmuş.

## Adımlar

### 1. cleanup.sh — bayat artefaktları sil

```bash
bash scripts/cleanup.sh
```

İdempotent script şunları yapar:

- `/tmp/debug-*.log` siler.
- Repo içindeki geçici DB dosyalarını (`*.db`, `*.db-journal`) siler.
- `.env` varsa şablona döner (`git checkout -- .env`).
- `__pycache__`, `.pytest_cache` temizler.
- Testleri koşar — kanıt üretir.

İkinci kez koşturursan aynı sonucu üretir. Bu önemli: cleanup hata kaynağı olamaz.

### 2. session_close.sh — beş boyut

```bash
bash scripts/session_close.sh
```

Çıktıda beş satır:

```
[1/5] Build       [OK]   make setup
[2/5] Test        [OK]   make test
[3/5] Progress    [OK]   PROGRESS.md bugun guncel
[4/5] Artifact    [OK]   bayat artefakt yok
[5/5] Startup     [OK]   uvicorn ayaga kalkti
Toplam: PASS=5  FAIL=0
Oturum temiz kapanabilir.
```

Beşinden biri kırmızıysa script exit code 1 verir. Pre-push hook bunu okur, push'u engeller.

### 3. PROGRESS.md son güncelleme

```bash
TODAY=$(date -u +%Y-%m-%d)
# PROGRESS.md ilk satırlarını gözden geçir
head -3 PROGRESS.md
```

İlk üç satırda bugünün tarihi yoksa `## Şu anki durum` bölümünü güncelle:

```markdown
_Son güncelleme: 2026-05-19 18:42 — vardiya kapanışı_
```

session_close.sh bu satırın bugüne ait olup olmadığını kontrol eder; eksikse 3. boyut kırmızı.

### 4. DECISIONS.md — yeni karar var mı?

Bu vardiyada bağlayıcı bir karar verdiysen `DECISIONS.md`'ye yeni bir giriş:

```markdown
## 2026-05-19 — <Başlık>

- **Neden**: ...
- **Reddedilen alternatif**: ...
- **Kısıt**: ...

---
```

Üç bilgi de zorunlu. Eksiklerse karar değil, niyet beyanı.

### 5. features.json güncel mi?

```bash
cat features.json | python -m json.tool 2>/dev/null | grep -E '"state"|"id"'
```

Bu oturumda biten feature `passing`'e mi geçmiş? Yeni eklenen feature `not_started` mi? Tek bir `active` var mı (WIP=1)?

### 6. Commit

```bash
git add PROGRESS.md DECISIONS.md features.json Quality.md
git diff --cached --stat
git commit -m "shift: <ne yapildi + neden>"
```

Stat'a bak — beklenen dosyalar mı değişti? Sürpriz değişiklik varsa `git restore --staged` ile çıkar.

### 7. Pre-push kontrolü

```bash
git push
```

Pre-push hook `scripts/session_close.sh` çağırır. Beş boyut yeşil değilse push reddedilir. Bu mekanik kapı:

```bash
# .git/hooks/pre-push
#!/usr/bin/env bash
set -euo pipefail
bash scripts/session_close.sh
```

`chmod +x .git/hooks/pre-push` ile aktif et.

## Kanıt

- `bash scripts/session_close.sh` exit code 0.
- `git status --porcelain` boş veya yalnız son commit ile temiz.
- `tail -1 PROGRESS.md` bugünün tarihiyle bir satır.
- Pre-push hook çalışıyor; `git push` öncesi session_close koşuyor.

## Yaygın hatalar

- **`session_close.sh` katı bulundu, kapatıldı** — Sertliği gevşetme; sözleşmeyi delik bırakırsın. Yarım state kabul etmek istiyorsan bunu PROGRESS.md'ye yaz ve `git commit --no-verify` ile geç. İz kalsın.
- **cleanup.sh testleri kırıyor** — Cleanup kanıt üretmek için test koşar; test kırıyorsa repo zaten yeşil değildi. Cleanup'ı suçlama, asıl kırıklığı düzelt.
- **PROGRESS.md kapanışta yazıldı ama commit'lenmedi** — Pre-push hook tarihi okuyor ama commit'lenmemiş değişiklik var. `git diff PROGRESS.md` boş olmalı.
- **Pre-push hook bypass ediliyor** — `--no-verify` kullanımı izlenebilir olsun. CI tarafında ek bir kontrol koy: PR'da `session_close.sh` çıktısı yorum olarak istensin.
