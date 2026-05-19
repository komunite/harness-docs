# Faz 3 — Değerlendir

Bu fazda ajan düzeneğin (harness) hangi aparatının zayıf olduğunu kanıt tabanlı belirler. Hedef: bir sonraki oturumun nereden başlayacağını sezgiyle değil rubrikle söylemek.

## Hedef

Beş aparatın her birine bir not ver. Notlar A/B/C/D bandında. En düşük puanlı aparat = sonraki fazın hedefi.

## Sprint rubrik tablosu

`kutuphane/sprint-rubric.mdx` dosyasındaki rubriği aparat eksenine taşıyoruz. Her aparat beş boyutta puanlanır.

| Aparat | Doğrulama | Ajan-okunabilirlik | Test kararlılığı | Mimari sınır | Konvansiyon |
| --- | --- | --- | --- | --- | --- |
| Talimat (AGENTS.md) | ? | ? | ? | ? | ? |
| Araç (Makefile + init.sh) | ? | ? | ? | ? | ? |
| Ortam (features.json) | ? | ? | ? | ? | ? |
| Durum (PROGRESS + DECISIONS) | ? | ? | ? | ? | ? |
| Geri bildirim (verifier.md + 3LC) | ? | ? | ? | ? | ? |

### Bant tanımları

- **A** — temiz, kanıtlı, otomasyona bağlı.
- **B** — çalışıyor ama teknik borç var; haftalar içinde yükseltilmeli.
- **C** — müdahale gerek; bir sonraki oturumun ana işi.
- **D** — sözleşmeyi ihlal eden bir noktası var; düzeneği sahteye çeviriyor.

Herhangi bir aparat D alırsa sprint başarısız — Faz 1'e geri dön.

## Boyut başına ölçüt

### Doğrulama

Bu aparat bir kapı mı, yoksa süs mü? Test, çıkış kodu, kontrol listesi ile mekanik olarak doğrulanabiliyor mu?

- A: `make check` ya da otomatik bir hook aparatın gerçeğini her commit'te kontrol ediyor.
- B: Manuel doğrulama mümkün ama otomasyona bağlı değil.
- C: Doğrulama belge düzeyinde kalıyor; kimse koşturmuyor.
- D: Aparatın iddia ettiği davranış gerçekte koşturulduğunda kırmızı veriyor.

### Ajan-okunabilirlik

Yeni bir oturum aparatı tek bakışta anlıyor mu?

- A: 200 satır altı, doğru başlıklarla, soğuk başlangıç testinin sorularına net cevap veriyor.
- B: Anlaşılır ama gereksiz uzunlukta veya başlık disiplini eksik.
- C: Birkaç soruya cevap için iki dosya açmak gerekiyor.
- D: Dosyada içerik var ama yapı yok; ajan kaybolur.

### Test kararlılığı

Aparatın doğrulama mekanizması flaky mi?

- A: 10 koşumda 10 yeşil.
- B: 10 koşumda 9 yeşil; flaky kaynağı bilinir.
- C: 10 koşumda 6-8 yeşil; retry'la geçiyor.
- D: Sık başarısız; gerçek bir sinyal taşımıyor.

### Mimari sınır

Aparat yetki alanı içinde mi?

- A: Sadece kendi sorumluluğunu yazıyor (talimat aparatı stil kuralı tutmaz, linter'a delege).
- B: Bir küçük sızıntı var, dokümante edilmiş.
- C: İki-üç sızıntı; düzenek araç-doküman ayrımını ihlal ediyor.
- D: Aparat başka aparatın işini yapıyor; düzenek çatallandı.

### Konvansiyon

İsimlendirme, konum, format tutarlı mı?

- A: Standart isim, standart konum, format temiz.
- B: Bir küçük sapma, gerekçesi yazılı.
- C: Birkaç sapma, ekip refleksini bozuyor.
- D: Konvansiyon yok; her oturum kendi adlandırmasını yapıyor.

## Adımlar

### 1. Her aparat için beş soruyu cevapla

Yukarıdaki rubriği `Quality.md` (yoksa oluştur) dosyasına yapıştır ve doldur. Her hücreye not + tek satırlık gerekçe.

```markdown
| Aparat | Doğrulama | Ajan-okunabilirlik | ... |
| --- | --- | --- | --- |
| Talimat | A — `check-agents` hook'u CI'de | B — sıkı kısıtlar ortada, başta olmalı (Lost in the Middle) | ... |
```

### 2. En düşük puanlı aparatı işaretle

Tablonun sağ tarafına "← Önce buraya gir" oku koy. Birden fazla aparat aynı düşük notu alırsa, **doğrulama** boyutunda düşük olanı seç — doğrulama aparatın gerçekliğini taşır.

### 3. Hedef notunu yaz

Sonraki oturumda hangi nottan hangi nota geçiş yapacaksın? Örnek: "Geri bildirim aparatı: C → B. Üç katmanlı kapıyı kapanışta otomatik koş, retry mantığını kaldır."

### 4. PROGRESS.md'ye taşı

`PROGRESS.md`'nin "Sıradaki adımlar" bölümüne aparatın adını ve hedef notunu yaz. DECISIONS.md'ye girmez — bu bir karar değil, bir öncelik sıralaması.

### 5. Commit at

```bash
git add Quality.md PROGRESS.md
git commit -m "eval: aparat puanlama + en zayıf aparatı işaretle"
```

## Kanıt

Faz 3'ün tamamlandığını kanıtlayan üç şey:

1. `Quality.md` dosyası var, beş aparatın beş boyutu doldurulmuş.
2. Tablonun sağ tarafında bir "← Önce buraya gir" oku var.
3. `PROGRESS.md` sıradaki adımlar bölümü o aparatın hedef notuyla başlıyor.

## Yapma listesi

- **Yapma**: Tek bir nihai puan üretmek. Beş boyut ayrı kalır; "ortalama" puan bilgi kaybı.
- **Yapma**: A'yı "çok iyi", D'yi "kötü" diye yorumlamak. Eşikler ölçülebilir; sözel değil.
- **Yapma**: Aparatı yükseltmek için Faz 4'e geçmeden başka bir aparata dokunmak. Tek aparat, tek oturum kuralı.
- **Yapma**: Eski Quality.md'yi silmek. Üstüne yaz veya tarihle yeni satır ekle — trendi takip edebil.
