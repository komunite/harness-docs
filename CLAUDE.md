# CLAUDE.md

Bu repoda **çalışan ajan** olarak bu dosyayı her oturum başında oku.
Burası sürekli güncellenen kuralları **listelemez**; nereye bakman
gerektiğini söyler.

## Proje

**Düzenek Mühendisliği (Harness Engineering)** — AI kod ajanlarını
güvenilir kılan çevreyi tasarlayan Türkçe açık kaynak müfredat.
12 ders + 6 proje + 8 şablon + skill paketi. Mintlify Cloud + Vercel
proxy ile [harness.lokomotif.ai](https://harness.lokomotif.ai)
adresinde host edilir.

## Hızlı başlangıç

```bash
npm install -g mint
mint dev                  # http://localhost:3000
mint login                # search ve assistant'ı local'de aktive et
mint validate             # MDX + frontmatter + nav bütünlüğü
mint broken-links         # tüm iç linkler çözülüyor mu
```

## Sıkı kısıtlar (ihlal edilemez)

1. **Terim**:
   - `Düzenek Mühendisliği (Harness Engineering)` — her geçtiğinde
     parantez içinde İngilizce karşılığıyla yaz.
   - `düzenek (harness)` ilk geçişte; sonra `düzenek`.
   - `aparat` = düzenek içindeki bir element. Bütünü değil.
   - Detay tablosu: [MEMORY.md — Terim haritası](MEMORY.md#terim-haritasi).
2. **MDX güvenliği** (parser'ı bozar):
   - Prose'da `<` + dijit / `%` / non-letter **YASAK**. `<%80` → `%80 altı`.
     `<5` → `5 altı`.
   - Prose'da raw `{...}` **YASAK**. JSX prop'ları (`cols={2}`) tag
     içinde OK.
   - Code fence (```` ``` ````) ile çevrili her şey güvenli.
3. **Stil**:
   - Türkçe profesyonel teknik dil; mizah yok.
   - "Sen" tonu (ikinci tekil).
   - Kısa, yüklü cümleler.
   - Kod identifier'ları İngilizce; prose Türkçe.
4. **Sayılar**:
   - Bir sayı (örn. `%37`, `$200`) **kaynaklı** olmalı. Doğrulayamadığın
     sayıyı yumuşat ya da kaldır.
5. **Cross-link slug'ları**:
   - Sadece var olan slug'ları kullan; tam liste:
     [docs.json](docs.json) > `navigation.tabs[].groups[].pages`.

## İçerik haritası

```
index.mdx                         giriş
dersler/01..12-*.mdx              12 teorik ders ("Aynı Model, Farklı Sonuç" → "Temiz Teslim")
projeler/01..06-*.mdx             6 proje sayfası
projeler/0N/starter/              proje N'nin başlangıç kodu (kasıtlı eksik)
projeler/0N/solution/             proje N'nin referans çözümü
kutuphane/index.mdx               şablon haritası
kutuphane/{8 sayfa}.mdx           kopyala-kullan şablonlar
yetenekler/duzenek-yaratici.mdx   (şimdilik .mintignore'da, gizli)
skill-pack/duzenek-yaratici/      Claude Code/OpenClaw uyumlu yetenek paketi
images/                           OG cover + brand assets
logo/                             marka logosu (light/dark)
style.css                         marka paleti override (paper/ink/lime)
docs.json                         Mintlify konfigürasyonu + SEO/OG
vercel.json                       Vercel → Mintlify proxy
.mintignore                       Mintlify'ın görmezden geleceği yollar
```

## Konu dokümanları

Talimat ekleyeceğin alana göre **önce şu dosyaları oku**:

| Yapacağın iş | Önce oku |
| --- | --- |
| Yeni içerik / ders güncelleme | [CONTRIBUTING.md](CONTRIBUTING.md), [MEMORY.md](MEMORY.md) |
| Stil / palet değişikliği | [style.css](style.css), [MEMORY.md — Faz: marka paleti](MEMORY.md#2026-05-18--mintlify-kurulumu-ve-marka-paleti) |
| Deploy / DNS / Vercel | [README.md — Deploy](README.md#deploy), [vercel.json](vercel.json) |
| Skill paketi | [skill-pack/duzenek-yaratici/SKILL.md](skill-pack/duzenek-yaratici/SKILL.md) |
| Güvenlik konuları | [SECURITY.md](SECURITY.md) |
| Davranış | [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) |

## Vardiya rutinleri

### Açılış (clock-in)

1. [MEMORY.md](MEMORY.md) en son fazı oku → şu an proje neresi.
2. `git status` → çalışma dizini temiz mi.
3. `mint dev` başlat → http://localhost:3000 yeşil mi.
4. Eğer açık iş varsa devam et. Yoksa MEMORY.md "Sıradaki adımlar"a
   bak.

### Kapanış (clock-out)

1. `mint validate` ve `mint broken-links` yeşil.
2. [MEMORY.md](MEMORY.md) güncelle: ya mevcut fazı tamamla, ya yeni
   bir faz ekle ya da "Sıradaki adımlar" listesini güncelle.
3. Anlamlı bir commit + push (`feat:` / `fix:` / `docs:` /
   `chore:` / `style:` prefix).
4. CI yeşil mi GitHub'da kontrol et.

## Yapma listesi

- **Force push** yapma. `main`'e doğrudan commit etme; her zaman PR.
- **`mint logout`** yapma — search ve assistant local'de bozulur.
- **`.mintignore`'dan `yetenekler/` satırını** rastgele kaldırma —
  duzenek-yaratici sayfası bilinçli gizli.
- **OG image PNG'yi elle düzenleme** — kaynak `images/og-cover.html`;
  oradan değiştirip chrome-headless-shell ile yeniden render et.
- **Birincil kaynak göstermeden sayı ekleme**. "Yaklaşık %30"
  zayıflatması bile kaynaklı olmalı.

## Acil durum

Bir şey kötü gittiyse (build kırıldı, içerik bozuldu):

```bash
git restore --staged .          # staged değişiklikleri geri al
git restore .                   # çalışma dizini değişikliklerini geri al
git log --oneline -5            # son commit'lere bak
git revert <hash>               # belirli bir commit'i geri al (yeni commit olarak)
```

`git reset --hard` **yapma** — bilinçli ve geri dönülmez tek istisna
olarak başkasının onayıyla.
