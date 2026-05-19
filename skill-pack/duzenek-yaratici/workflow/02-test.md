# Faz 2 — Test

Bu fazda ajan iskeletin gerçekten çalışıp çalışmadığını kanıtlar. Hedef: kâğıt üstünde olan her sözleşmenin runtime'da da yeşil olduğunu görmek.

## Hedef

Faz 1'de yerleştirilen aparatların **kullanılabilir** olduğunu kanıtla. Three layer check yeşil; soğuk başlangıç testi yeşil; ilk bir özellik baştan sona doğrulanabilir.

## Adımlar

### 1. Smoke test — init.sh ikinci kez idempotent mi?

İdempotentlik beyanı kanıtsız tutmaz.

```bash
rm -rf .venv build dist
bash init.sh                  # ilk koşum
bash init.sh                  # ikinci koşum — değişiklik yok beklenir
git status --porcelain        # boş olmalı; init.sh kirli iz bırakmamalı
```

`git status` boş değilse `init.sh` idempotent değil. Eksik koruma neyse (örnek: dosya zaten varsa atla) ekle ve tekrar dene.

### 2. make check — üç katman yeşil mi?

```bash
make check
```

Çıktı yeşilse Faz 2'nin yarısı tamam. Kırmızıysa hangi katmanda düştüğünü oku — `three_layer_check.sh` `[1/3]`, `[2/3]`, `[3/3]` etiketleriyle hangi katmanın çöktüğünü söyler. Düşen katmandan yukarısı koşmaz; ilk hatayı düzelt, yine koş.

İlk faz repolarında genelde 3. katman (e2e) eksiktir çünkü gerçek bir endpoint henüz yok. Geçici çözüm: `scripts/verify.sh` içine `echo "no e2e yet — placeholder OK"` koy ve features.json'a bir TODO ekle. Ama bu durumu DECISIONS.md'ye yaz, üstünü örtme.

### 3. Soğuk başlangıç testi

Yeni bir terminal aç. Repoya hiç bakmamış gibi davran. Beş soruyu **yalnız reposundaki dosyalara bakarak** cevapla:

1. Bu projenin amacı nedir? (AGENTS.md → "Proje" bölümü)
2. Nasıl kurarım? (AGENTS.md → "Dev tips" veya Makefile → `setup`)
3. Şu an hangi özellik üzerinde çalışılıyor? (features.json `active` ve PROGRESS.md)
4. Hangi mimari karar dışlanmış? (DECISIONS.md "Reddedilen alternatif" satırları)
5. Bir özelliği "tamamlandı" saymak için ne yapmalı? (verifier.md → üç katman + DoD)

Bir soruya cevap veremezsen ilgili dosya eksik veya yanlış konumda. Sözel cevap kabul etme; **dosyada yazıyorsa** yeşil.

### 4. İlk özelliği canlandır

features.json'da F01'i seç, `state: active` yap. `behavior` alanı dışarıdan gözlenebilir tek cümle olmalı. Örnek: "GET /health endpoint'i 200 ve `{status: ok}` döner."

İlgili kodu (en küçük canlı endpoint) yaz. `scripts/verify.sh` içindeki TODO'yu gerçek bir doğrulama ile değiştir — curl çağrısı, çıkış kodu kontrolü.

`make check` yeniden koş. Üç katman yeşilse F01'i `passing` yap (verifier yazar, sen değil — ama bu fazda manuel test sırasında elle de güncelleyebilirsin; sözleşmeyi Faz 4'te sertleştireceğiz).

### 5. OTel duman testi (opsiyonel ama önerilir)

`recipes/gozlemlenebilirlik.md` adımlarını koş. `verify.sh` çıktısında en az bir GenAI semconv span'ı görünmeli (`gen_ai.operation.name` etiketli satır). Görünmüyorsa instrumentation eksik veya exporter sessiz; ikisini de DECISIONS.md'ye not düş.

## Kanıt

Faz 2'nin tamamlandığını kanıtlayan dört şey:

1. `bash init.sh && bash init.sh && git status --porcelain` boş çıktı verir.
2. `make check` yeşil.
3. Soğuk başlangıç testi beş sorudan en az dördünü dosyalardan cevaplar.
4. features.json'da en az bir özellik `passing`, evidence dolu.

Üçü yeşilse Faz 3'e geç. Soğuk başlangıç testi düşmüşse Faz 1'in talimat aparatına dön — AGENTS.md eksik bölüm vardır.

## Yapma listesi

- **Yapma**: "Geçici olarak `make check`'i atla". Geçici kabul, kalıcı borçtur.
- **Yapma**: Smoke testi olarak `make test` koşmak. Smoke = `init.sh` + `make check`. Test ayrı katman.
- **Yapma**: `verify.sh` içine ajan-okunabilir olmayan opak komutlar yığmak. Her satır gerekçesiyle.
- **Yapma**: features.json'a "passing" yazmak verifier scripti olmadan. Geçici elle güncellemeyi yapsan bile bir TODO bırak.
