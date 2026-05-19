# Recipe — Vardiya teslimi

Bir oturumdan diğerine süreklilik bırakmanın somut adımları.

## Hedef

Oturum kapanışında ve oturum açılışında **aynı** dosyaları kullanarak ajanın kaldığı yerden devam etmesini sağlamak. 12-Factor Agents faktör 5 (state birleşik) ve faktör 6 (pause-resume) sözleşmesinin pratik karşılığı.

## Önkoşullar

- Repoda `AGENTS.md`, `PROGRESS.md`, `DECISIONS.md`, `features.json` mevcut.
- `scripts/session_close.sh` çalıştırılabilir.
- Çalışılan dal commitsiz değilse, en az `git stash` yapılmış.

## Adımlar — vardiya bırakırken (clock-out)

### 1. make check yeşil

```bash
make check
```

Kırmızıysa **iki seçenek var**, ortası yok:

- Düzelt, yeşile çevir, commit at.
- Tüm değişiklikleri geri al (`git restore .`) ve `PROGRESS.md`'ye "vardiya yarım kapandı" yaz.

Yarı yeşil bırakıp gitmek miras hata üretir.

### 2. PROGRESS.md güncelle

Son güncelleme satırına bugünün tarihini ve "vardiya kapanışı" notunu yaz. Beş bölümü gözden geçir:

- Şu anki durum — son commit hash'i, test sayısı, hangi katman yeşil.
- Tamamlandı — bu oturumda neyi bitirdin.
- Devam ediyor — yüzde tahminin, takıldığın yer.
- Bilinen sorunlar — flaky test, açık bug, dış bağımlılık.
- Sıradaki adımlar — bir sonraki oturumun ilk üç işi.

Açık sorular varsa `## Açık sorular (kullanıcıya)` bölümüne yaz; örtük bırakma.

### 3. DECISIONS.md — yeni karar var mı?

Bu oturumda bağlayıcı bir karar verdin mi? Karar üç soruyu karşılar:

- Bir alternatifi açıkça reddettin mi?
- Bu seçim ileride değişirse maliyet üretir mi?
- Hatırlanması gereken bir kısıt var mı?

Üçü "evet" ise yeni bir giriş aç: tarih + başlık + neden + reddedilen alternatif + kısıt. Eski girişler kalır; bu karar geri çekilirse silmek yerine "iptal edildi: bkz. <yeni tarih>" notu ekle.

### 4. session_close.sh

```bash
bash scripts/session_close.sh
```

Beş boyut yeşil olmalı (build, test, progress, artifact, startup). Düşen varsa kapanma; düzelt veya `git restore .` ile geri al.

### 5. Commit

```bash
git add PROGRESS.md DECISIONS.md features.json Quality.md
git commit -m "shift: <kisa ozet>"
```

Mesaj formatı: `shift: <ne yapildi>`. Örnek: `shift: F03 search params + decision rate-limit user+ip`.

## Adımlar — vardiya alırken (clock-in)

Sırayla, atlama yapmadan:

### 1. README ve AGENTS.md

```bash
cat README.md AGENTS.md
```

Bir gece içinde değişmiş olabilir. Sıkı kısıtlar bölümünü taze hafızaya al.

### 2. PROGRESS.md

```bash
cat PROGRESS.md
```

Son güncelleme tarihi bugünden eski mi? Kaç gün geçti? Bu sürede `DECISIONS.md`'ye giriş eklenmiş mi? Diff'i de gör:

```bash
git log -p PROGRESS.md | head -100
```

### 3. DECISIONS.md son birkaç giriş

```bash
tail -80 DECISIONS.md
```

Son 2-3 karar bu oturumu çerçeveler. "Reddedilen alternatif" satırlarını oku — tekrar önereceğin bir şey burada olabilir.

### 4. features.json durumu

```bash
cat features.json | python -m json.tool 2>/dev/null || cat features.json
```

Hangi feature `active`? `passing` oranı kaç? `blocked` olan var mı?

### 5. Quality.md — başlangıç noktası

```bash
cat Quality.md 2>/dev/null
```

"← Önce buraya gir" oku hangi modülde? Bu oturumun ana hedefi.

### 6. Üç katman yeşil mi?

```bash
make check
```

Bu komut başarılı tamamlanmadan kod yazmaya başlama. Dün yeşil bırakılan repo bugün kırmızı olabilir — flaky test, dış bağımlılık, ortam değişikliği. Önce yeşili kanıtla.

### 7. PROGRESS.md "Sıradaki adımlar" üstüne git

İlk satırı al, başla.

## Kanıt

Kapanışta:

- `tail -1 PROGRESS.md` bugünün tarihini içeren bir satır.
- `git status --porcelain` boş ya da yalnız son commit ile temiz.
- `bash scripts/session_close.sh` exit code 0.

Açılışta:

- Soğuk başlangıç testinin beş sorusunu dosyalardan cevapladın.
- `make check` yeşilden geçti.
- PROGRESS.md "Sıradaki adımlar" başında somut bir TODO var.

## Yaygın hatalar

- **PROGRESS.md'yi son cümleden çıkıp commit etmek** — Vardiya defteri sözleşme. Bugünün tarihi yoksa pre-commit hook patlamalı.
- **Açılışta `make check` atlamak** — Önceki vardiyanın yeşili bugün hâlâ yeşil mi belli değil. Önce kanıt.
- **DECISIONS.md'yi geriye dönük yazmak** — Karar verildiği anda yazılmalı; üç gün sonra hatırlanan gerekçe yarı hayali olur.
