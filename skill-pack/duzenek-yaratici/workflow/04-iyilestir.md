# Faz 4 — İyileştir

Bu fazda ajan Faz 3'te işaretlediği en zayıf aparatı bir oturumda yükseltir. Geri kalan dört aparata dokunmaz.

## Hedef

Tek aparat, tek oturum kuralı. En zayıf aparatın notu en az bir bant yükselsin; geri kalanlar değişmesin. Çıktı: yeşil `make check`, güncel Quality.md, temiz commit.

## Tek aparat kuralı neden

Birden fazla aparata aynı oturumda dokunmak iki problem yaratır. Birincisi, değişikliğin etkisini izole edemezsin — düzelten hangi değişiklik? İkincisi, bir aparat yükselirken başkasının düşmesi çok yaygındır (yeni bir test eklersin, doğrulama A'ya çıkar; aynı testte flaky sebep test kararlılığı B'den C'ye düşer). Tek aparatlı sprint bu çatışmayı görünür kılar.

İstisna: Faz 3'te birkaç aparat aynı seviyede düşükse, **birini** seç. Diğerleri sonraki oturumlarda.

## Adımlar

### 1. Hedef aparatı oku

`Quality.md`'deki "← Önce buraya gir" işareti hangi aparatta? O aparatın template'ını aç:

- Talimat → `templates/AGENTS.md.template` + `kutuphane/agents-md.mdx`
- Araç → `templates/Makefile.template` + `templates/init.sh.template` + `kutuphane/bootstrap.mdx`
- Ortam → `templates/features.json.template` + `kutuphane/features-json.mdx`
- Durum → `templates/PROGRESS.md.template` + `templates/DECISIONS.md.template` + `kutuphane/progress-decisions.mdx`
- Geri bildirim → `templates/verifier.md.template` + `kutuphane/verifier-dod.mdx`

Şablondaki "Konvansiyon" ve "Otomasyona bağlama" bölümlerini özellikle oku — A bandına çıkmak için bu iki bölüm yeşil olmalı.

### 2. Tek değişiklik prensibi

Aparatı yükseltmek için tek bir mantıksal değişiklik yap. Tipik örnekler:

- **AGENTS.md C → B**: 600 satırı 180'e indir; konu bölümlerini `docs/*.md` altına çıkar. Sıkı kısıtları dosyanın başına taşı.
- **Makefile B → A**: `check` hedefini lokal ve CI ile eşle; sapmayı sil. `help` hedefiyle öz-belgele.
- **features.json C → B**: Her kayda `verification` komutu ve `depends_on` ekle. WIP=1 kontrolünü init.sh'e bir grep ile kontrol satırı koy.
- **PROGRESS.md B → A**: "Son güncelleme" satırını otomatize et — pre-commit hook tarih eklesin.
- **Verifier C → B**: `three_layer_check.sh` içine `set -euo pipefail` ekle; ilk başarısızlıkta dur.

### 3. Değişiklikten önce mevcut yeşili kanıtla

`make check` koşturursun. Yeşilse devam. Kırmızıysa **önce** mevcut kırmızıyı yeşile çevir — değişiklik üzerine değişiklik yapma. Yeşil yoksa Faz 1'e geri dön; orada bir şey kaçmış.

### 4. Değişikliği uygula, tekrar koş

```bash
# örnek: AGENTS.md kısaltması
mkdir -p docs
# API bölümünü çıkar
sed -n '/^## API Patterns/,/^## /p' AGENTS.md > docs/api-patterns.md
# AGENTS.md'den o bloğu sil ve linkle değiştir
# (manuel düzenleme)
wc -l AGENTS.md  # 200 altında olmalı
make check       # yine yeşil
```

### 5. Quality.md'yi güncelle

İlgili aparatın yeni notunu yaz. Diğer aparatlar değişmedi mi? Değişmediyse aynı kalsın. Değiştiyse (yan etki var) bunu DECISIONS.md'ye yaz: "Talimat aparatını B'ye çıkarmak için 60 satırı docs/api-patterns.md'ye taşıdık; mimari sınır A'dan B'ye düştü çünkü docs/ klasörü artık talimat aparatının uzantısı haline geldi."

### 6. PROGRESS.md ve commit

PROGRESS.md "Tamamlandı" listesine bir satır ekle: "Talimat aparatı C → B (200 satır altı, sıkı kısıtlar başa)".

```bash
git add AGENTS.md docs/api-patterns.md Quality.md PROGRESS.md DECISIONS.md
git commit -m "improve: talimat aparati C -> B (router kisaltma)"
```

Commit mesajı tek mantıksal değişimi söyler; aparat adı + bant geçişi.

### 7. session_close.sh

```bash
bash scripts/session_close.sh
```

Beş boyut yeşil olmalı: build, test, progress, artifact, startup. Düşen varsa oturum kapanmaz; düzelt, tekrar koş.

## Döngü

Faz 4 biterse otomatik olarak Faz 2'ye dön — değişikliği test et. Sonra Faz 3 — yeni puanı yaz, sıradaki zayıf aparatı belirle. Beş aparatın hepsi A bandına çıkana kadar bu döngü işler. Pratikte ekipler "B-ortalama" bandında dengelenir; A bandı haftalık iterasyonun hedefi olur.

## Kanıt

Faz 4'ün tamamlandığını kanıtlayan dört şey:

1. `make check` yeşil — değişiklik mevcut testleri kırmadı.
2. `Quality.md`'de hedef aparatın notu en az bir bant yükseldi.
3. `bash scripts/session_close.sh` yeşil.
4. Commit mesajı tek mantıksal değişimi tarif ediyor; PROGRESS.md güncel.

## Yapma listesi

- **Yapma**: İki aparatı aynı oturumda yükseltmek. Yan etkiyi göremezsin.
- **Yapma**: Quality.md'ye not vermeden değişiklik commit'lemek. Trend kaybolur.
- **Yapma**: "Geri kalan dört aparat zaten iyi" diye o turdaki rubrik tablosunu yenilememek. Tablo tarihlidir; her oturum yeniden bakılır.
- **Yapma**: A bandına çıkmak için doğrulamayı zayıflatmak (örnek: testi atlamak). Bant tanımları sözleşme; sıyrılma yok.
