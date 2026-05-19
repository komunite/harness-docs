# Katkı Rehberi

Düzenek Mühendisliği (Harness Engineering) müfredatına katkıda
bulunmak istediğin için teşekkürler. Bu doküman küçük bir tipo
düzeltmesinden yeni bir dersin tartışmasına kadar her ölçekteki
katkıyı kapsar.

## Tek satırlık kural

Bir katkı **müfredatın bir parçasını okuyan birinin işine yarayacaksa**
ve **terim/stil rehberine uyuyorsa** memnuniyetle karşılanır.

## Hızlı başlangıç

```bash
git clone https://github.com/lokomotifai/harness-docs.git
cd harness-docs
npm install -g mint
mint dev                  # http://localhost:3000
```

Search ve AI assistant'ı local'de aktive etmek için: `mint login`.

Doğrulama:

```bash
mint validate             # MDX + frontmatter + nav bütünlüğü
mint broken-links         # tüm iç linkler çözülüyor mu
```

## Katkı türleri

### 1. Tipo / yazım düzeltmeleri

Tek dosya değişen küçük PR'ler. Issue açmana gerek yok; doğrudan PR
gönderebilirsin.

### 2. İçerik geliştirme

Mevcut dersin / projenin / şablonun bir bölümünü iyileştirme. Şu
prensiplere uy:

- **Birincil kaynak**: yeni bir iddia ekliyorsan kaynak göster
  (URL veya yayın atfı).
- **Sayılar**: bir sayı eklediysen kaynağı dipnot/bağlantı olarak ver.
- **Terim**: aşağıdaki terim haritasından sapma.
- **MDX güvenliği**: prose'da `<` + dijit/`%`/non-letter yok, raw `{...}` yok.

### 3. Yeni içerik

Yeni bir ders, proje veya şablon önermek istiyorsan:

1. Önce **issue aç**. Niye gerekli, kapsam, kaynaklar.
2. Konsensüse vardıktan sonra PR aç.

### 4. Çeviri

Şu an müfredat Türkçe. İngilizce veya başka dile çeviri ilgi çekici;
ama önce issue açıp koordine edelim — yapıyı bozmadan paralel dil
dizinleri kurmak isteriz.

## Terim haritası (ihlal edilemez)

| Türkçe | İngilizce | Anlam |
| --- | --- | --- |
| **Düzenek Mühendisliği (Harness Engineering)** | Harness Engineering | Disiplin adı. Her geçtiğinde parantez içinde İngilizce karşılığıyla birlikte yazılır. |
| **düzenek** | harness | Bütün sistem. İlk geçişte `düzenek (harness)`; sonra `düzenek`. |
| **aparat** | element | Düzenek içindeki bir bileşen (talimat, durum dosyası, doğrulama scripti vb.). |
| **vardiya alımı / vardiya teslimi** | clock-in / clock-out | Oturum başı/sonu rutinleri. |
| **bilgi görünürlüğü boşluğu** | knowledge visibility gap | Proje bilgisinin repoda yazılı olmayan oranı. |
| **doğrulama boşluğu** | verification gap | Ajanın doğrulamadan "tamamlandı" demesi. |
| **erken zafer ilanı** | premature completion declaration | Aynı boşluğun tipik dışavurumu. |

Tam terminoloji ve karar gerekçeleri için [MEMORY.md — Terim
haritası](MEMORY.md#terim-haritasi) bölümüne bak.

## Stil

- **Türkçe profesyonel teknik dil**; mizah yok, küfür yok.
- **"Sen" tonu** (ikinci tekil).
- **Kısa, yüklü cümleler**. Pazarlama jargonu yok.
- **Kod identifier'ları İngilizce**; prose Türkçe.
- **Sayılar atfedilebilir**; "yaklaşık %30 daha iyi" cinsinden iddialar
  ya kaynaklıdır ya da kaldırılır.

## MDX güvenliği

MDX, prose içinde `<` ve `{...}` görünce JSX/expression olarak parse
etmeye çalışır. Bu yüzden:

- `<%80` YAZMA → `%80 altı` yaz.
- `<5` YAZMA → `5 altı` yaz.
- Prose'da `{x}` YAZMA → kod bloğuna al ya da `\{x\}` ile escape et.
- JSX bileşenleri `<Card>`, `<CardGroup cols={2}>`, `<Steps>`, `<Step>`,
  `<Note>` OK — sadece düz prose'da `<` + harf-olmayan kombinasyonu
  tehlikeli.

CI'da `mint validate` çalışır; ihlal varsa PR yeşil çıkmaz.

## Pull request

1. **Dal aç**: `git checkout -b ozellik/kisa-aciklama`
2. **Değişiklikleri yap**: bir kavrama bir PR; karışık PR bölünür.
3. **Yerel doğrulama**:
   ```bash
   mint validate
   mint broken-links
   ```
4. **Commit mesajı**: kısa imperatif Türkçe + (isteğe bağlı) `fix:` /
   `feat:` / `docs:` / `chore:` prefixi.
5. **PR aç**: PR şablonu (`.github/PULL_REQUEST_TEMPLATE.md`) doldur.
6. **CI yeşil olunca**: incelemeye sunulur.

PR'ı küçük tut. 500 satırı geçen PR muhtemelen ikiye bölünmelidir.

## Issue açma

- **Bug**: `.github/ISSUE_TEMPLATE/bug_report.md` şablonunu kullan.
- **Öneri**: `.github/ISSUE_TEMPLATE/feature_request.md`.
- **Soru**: GitHub Discussions (eğer açıksa) ya da kısa issue.

## Davranış kuralları

[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md). Özet: misafirperver,
düşünceli, empatik. Taciz yok.

## Güvenlik bildirimi

Bir güvenlik açığı bulduysan **kamuya açık issue açma**.
[SECURITY.md](SECURITY.md)'deki adımları izle.

## Deploy

Site **Mintlify Cloud**'da host edilir. Özel alan adı:
[harness.lokomotif.ai](https://harness.lokomotif.ai). Üretim deploy'ı
yalnızca `main` dalına push olunca tetiklenir (otomatik).

Production'a doğrudan dokunma; her zaman PR.

## Teşekkür

Sorunu açan, PR gönderen, tartışmaya katılan herkesin adı release
notlarında geçer.
