# Recipe — Soğuk başlangıç

Boş bir repodan ilk yeşil commit'e kadar geçen yol.

## Hedef

Yeni klonlanmış (veya yeni `git init` yapılmış) bir repoda, beş aparat iskeletini yerleştirip `make check` yeşilden geçen ilk commit'i atmak. Hedef süre: 7-15 dakika.

## Önkoşullar

- `git`, `make`, bir paket yöneticisi (uv / pip / npm / pnpm / cargo) kurulu.
- Skill pack `.skill/duzenek-yaratici/` altında veya `cp` ile erişilebilir.
- Repo en az boş bir `git init` yapılmış halde; remote bağlı olması zorunlu değil.

## Adımlar

### 1. Şablonları kopyala

```bash
SKILL_DIR=".skill/duzenek-yaratici"
cp "$SKILL_DIR/templates/AGENTS.md.template"        ./AGENTS.md
cp "$SKILL_DIR/templates/Makefile.template"         ./Makefile
cp "$SKILL_DIR/templates/init.sh.template"          ./init.sh
cp "$SKILL_DIR/templates/features.json.template"    ./features.json
cp "$SKILL_DIR/templates/PROGRESS.md.template"      ./PROGRESS.md
cp "$SKILL_DIR/templates/DECISIONS.md.template"     ./DECISIONS.md
cp "$SKILL_DIR/templates/verifier.md.template"      ./verifier.md
mkdir -p scripts
cp "$SKILL_DIR/scripts/"*.sh                        ./scripts/
chmod +x init.sh scripts/*.sh
```

### 2. AGENTS.md'yi proje kimliğine eşle

En az dört yer doldur:

- Proje adı satırı.
- Tek cümlelik proje tanımı.
- Sıkı kısıtlar listesi (dile/sektöre özel).
- Konu dokümanları haritası (üç satır yeter).

### 3. Makefile'i toolchain'e eşle

Eğer Python kullanmıyorsan `templates/Makefile.template` içindeki Node / Go / Rust bloklarından birini al, ana bloğun üzerine yapıştır. Dört hedef sabit: `setup`, `dev`, `test`, `check`.

### 4. init.sh'i koş

```bash
bash init.sh
```

Çıktıda `OK` veya `Bootstrap tamam.` görmelisin. Hata varsa init.sh içindeki adımı düzelt — tipik olarak paket yöneticisi yolu yanlış.

### 5. İlk smoke testi

```bash
make check
```

İlk koşumda muhtemelen 3. katmanda (e2e) düşer çünkü endpoint yok. `scripts/verify.sh` içine bir placeholder yaz: `echo "no e2e yet"; exit 0`. Tekrar koş. Yeşil olmalı. Bu placeholder'ı `DECISIONS.md`'ye not düş.

### 6. İlk commit

```bash
git add -A
git commit -m "init: bootstrap complete"
```

### 7. Soğuk başlangıç testi

Yeni bir terminal aç, sıfırdan ajan gibi davran:

```bash
cat AGENTS.md
cat PROGRESS.md
cat features.json
```

Bu üç komut "ne, nereden, sıradaki ne" sorularını cevaplıyor mu? Cevaplıyorsa düzenek hazır.

## Kanıt

- `ls AGENTS.md Makefile init.sh features.json PROGRESS.md DECISIONS.md verifier.md` — yedi dosya.
- `git log --oneline` — en az bir commit, mesajı `init: bootstrap complete`.
- `make check` — yeşil.
- `cat AGENTS.md PROGRESS.md features.json` — üç dosya da boş değil, en az iskelet içeriyor.

Dördü de yeşilse recipe başarılı. Workflow Faz 1 ve Faz 2 tamamlanmış sayılır; Faz 3 (Değerlendir) bir sonraki oturumun girişi olur.

## Yaygın hatalar

- **`init.sh` interaktif sorular soruyor** — Bootstrap interaktif olamaz. Env üzerinden parametre al, yoksa varsayılan kullan.
- **Makefile boşluk-sekme karışıklığı** — Make girintileri **tab** olmak zorunda. Editör boşluğa çevirmişse `expand`/`unexpand` ile düzelt.
- **Şablon değişkenleri boş kaldı** — `<Proje adı>`, `[Konu]` gibi yer tutucular işlemediyse soğuk başlangıç testi düşer. Bul ve doldur.
