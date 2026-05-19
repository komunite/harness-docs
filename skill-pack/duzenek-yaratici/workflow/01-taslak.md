# Faz 1 — Taslak

Bu fazda ajan repoyu beş aparata göre ablasyona uğratır, eksik olanları belirler ve iskeleti yerleştirir. Çıktı: ilk yeşil bootstrap commit'i.

## Hedef

Repoyu "ajanın çalışabileceği" durumdan "ajanın güvenle çalışabileceği" duruma çek. Beş aparatın tamamı en az iskelet düzeyinde mevcut olsun; soğuk başlangıç testinin ilk versiyonu geçsin.

## Ablasyon — eksik aparatlar listesi

İlk iş envanter. Her aparat için tek soru sor; cevap "hayır" ise template kopyalanacak.

| Aparat | Soru | Var mı? |
| --- | --- | --- |
| Talimat | Repo kökünde `AGENTS.md` ya da `CLAUDE.md` var mı, 200 satır altında mı? | ? |
| Araç | `Makefile` var mı, `setup/dev/test/check` hedeflerinin dördü de var mı? | ? |
| Araç | `init.sh` idempotent bootstrap mevcut mu? | ? |
| Ortam | `features.json` var mı, en az bir kayıt durum makinesine bağlı mı? | ? |
| Durum | `PROGRESS.md` ve `DECISIONS.md` var mı? | ? |
| Geri bildirim | `verifier.md` ve `scripts/three_layer_check.sh` mevcut mu? | ? |

İlk faz boyunca **eksik olanları sırasıyla doldur**. Hepsini bir oturuma sıkıştırma; ama oturum sonunda en az bir aparat tam olsun.

## Adımlar

### 1. Templates klasörünü repoya kopyala

```bash
SKILL_DIR=".skill/duzenek-yaratici"
cp "$SKILL_DIR/templates/AGENTS.md.template"        ./AGENTS.md
cp "$SKILL_DIR/templates/Makefile.template"         ./Makefile
cp "$SKILL_DIR/templates/init.sh.template"          ./init.sh
cp "$SKILL_DIR/templates/features.json.template"    ./features.json
cp "$SKILL_DIR/templates/PROGRESS.md.template"      ./PROGRESS.md
cp "$SKILL_DIR/templates/DECISIONS.md.template"     ./DECISIONS.md
cp "$SKILL_DIR/templates/verifier.md.template"      ./verifier.md
cp "$SKILL_DIR/templates/session-close.md.template" ./SESSION-CLOSE.md
mkdir -p scripts
cp "$SKILL_DIR/scripts/"*.sh                        ./scripts/
chmod +x ./scripts/*.sh ./init.sh
```

Brownfield reposunda zaten dosyalar varsa **üzerine yazma**. Mevcut dosyayı oku, eksik bölümleri ekle.

### 2. AGENTS.md'yi proje kimliğiyle eşleştir

Köşeli parantezli alanları doldur:

- Proje adı, bir cümlelik tanım (B2B fatura kesme servisi, Python 3.11 + FastAPI gibi).
- Sıkı kısıtlar — dile ve sektöre özgü olanları ekle (DB parametreli sorgu, auth zorunlu, secret yönetimi).
- Konu dokümanları haritası — boş bir tablo olsa bile en az üç satır yaz (api, db, security gibi).
- Dev tips bölümünü gerçek paket yöneticisine eşleştir (pip / uv / npm / pnpm / cargo).

200 satır üst sınırı katı. Aşıyorsa fazlasını `docs/` altına çıkar.

### 3. Makefile'i toolchain'e eşleştir

Dört hedef zorunlu: `setup`, `dev`, `test`, `check`. `check` lokalde ve CI'de aynı komutu koşar. Sapma yoksa, ekleme.

Python projesi şablonu doğrudan kullanılabilir. Node, Go, Rust için `templates/Makefile.template` içindeki alternatif blokları sırayla bak.

### 4. init.sh'yi idempotent yap

`set -euo pipefail` zorunlu. Her adım iki kez koşturulduğunda aynı sonucu üretmeli. Tipik adımlar:

1. Sanal ortam veya bağımlılık kurulumu.
2. Cache temizliği.
3. `features.json`, `PROGRESS.md`, `DECISIONS.md` yoksa iskeletlerini yaz.
4. Sözdizimi sağlık kontrolü.
5. İlk commit yoksa "init: bootstrap complete" at.

İdempotentlik testi: `bash init.sh && bash init.sh` aynı çıktıyı verir; ikincide hiçbir dosya kirletilmez.

### 5. features.json'a en az üç davranış ekle

Her birinde beş alan: `id`, `behavior`, `verification`, `state`, `depends_on`. Başlangıçta hepsi `not_started`. `verification` boş kalmasın — "TODO: scripts/verify_F01.sh" gibi yer tutucu yaz.

WIP=1 kuralı şimdiden geçerli: dosyada en fazla bir `active` kayıt olabilir.

### 6. PROGRESS.md ve DECISIONS.md'yi initialize et

`PROGRESS.md`'nin "Şu anki durum" bölümüne bugünün tarihi ve "bootstrap tamamlandı" yaz. `DECISIONS.md`'ye ilk karar olarak "bootstrap tarihi ve seçilen yığın" yaz — neden, reddedilen alternatif, kısıt formatıyla.

### 7. İlk commit

```bash
git add -A
git commit -m "init: bootstrap complete"
```

Bu commit aparatların iskelet halinin yeşil sinyalidir. Sonraki fazlar bu noktanın üstüne kurulacak.

## Kanıt

Faz 1'in tamamlandığını kanıtlayan üç şey:

1. `ls AGENTS.md Makefile init.sh features.json PROGRESS.md DECISIONS.md verifier.md` — hiçbiri eksik değil.
2. `bash init.sh` hatasız tamamlanır.
3. `git log --oneline | tail -1` çıktısında `init: bootstrap complete` var.

Üçü de yeşilse Faz 2'ye geç. Biri kırmızıysa o aparatı tamamla, döngüye girme.

## Yapma listesi

- **Yapma**: AGENTS.md'ye stil kuralları doldurmak (snake_case, indentation). Linter'ın işi.
- **Yapma**: features.json'a iddialı uzun davranış metinleri yazmak. Tek cümle, dışarıdan gözlenebilir.
- **Yapma**: init.sh'i interaktif yapmak. Sorulara cevap bekleyemez; tüm girdi env veya dosya üzerinden.
- **Yapma**: DECISIONS.md'ye "geçici karar" yazmak. Karar bağlayıcıdır; geri çekilirse yeni giriş eklenir, silinmez.
