# MEMORY.md

Bu dosya projenin **yapım hafızası**dır. Yeni bir oturumun ilk yapması
gereken şey: en son fazı okumak, "şu an proje neresi" sorusuna cevap
vermek. Her oturum kapanışında ya mevcut fazı tamamlamalı ya yeni
bir faz eklemelidir.

`CLAUDE.md` "kuralları" tutar; bu dosya **gerekçeleri** ve **hangi
kararın neden alındığını** tutar. Compaction'ın kaybettiği "neden"
burada yaşar.

## Faz endeksi

| # | Tarih | Faz |
| --- | --- | --- |
| 1 | 2026-05-18 | [Mintlify kurulumu ve marka paleti](#1-2026-05-18--mintlify-kurulumu-ve-marka-paleti) |
| 2 | 2026-05-18 | [12 ders ilk taslak (skeleton)](#2-2026-05-18--12-ders-ilk-taslak-skeleton) |
| 3 | 2026-05-18 | [Multi-source kalite pas'ı (12 ders)](#3-2026-05-18--multi-source-kalite-pasi-12-ders) |
| 4 | 2026-05-18 | [Üç kalite kapısı (tutarlılık + dil + akış)](#4-2026-05-18--uc-kalite-kapisi-tutarlilik--dil--akis) |
| 5 | 2026-05-19 | [Terim migration: aparat → düzenek](#5-2026-05-19--terim-migration-aparat--duzenek) |
| 6 | 2026-05-19 | [Kütüphane şablonları (8 sayfa)](#6-2026-05-19--kutuphane-sablonlari-8-sayfa) |
| 7 | 2026-05-19 | [Proje kodları (6 starter/solution)](#7-2026-05-19--proje-kodlari-6-startersolution) |
| 8 | 2026-05-19 | [Skill paketi + SEO/OG + deploy hazırlığı](#8-2026-05-19--skill-paketi--seoog--deploy-hazirligi) |
| 9 | 2026-05-19 | [Açık kaynak hijyeni + CLAUDE/MEMORY](#9-2026-05-19--acik-kaynak-hijyeni--claudememory) |
| 10 | 2026-05-19 | [Diyagram redesign + README cila](#10-2026-05-19--diyagram-redesign--readme-cila) |
| 11 | 2026-05-21 | [Diyagram mobil uyumu + dark logo](#11-2026-05-21--diyagram-mobil-uyumu--dark-logo) |
| 12 | 2026-08-15 | [komunite org'una taşınma + yeni domain](#12-2026-08-15--komunite-orguna-tasinma--yeni-domain) |
| 13 | 2026-08-15 | [Mintlify Cloud'dan çıkış: Vercel'de statik self-host](#13-2026-08-15--mintlify-clouddan-cikis-vercelde-statik-self-host) |

## Terim haritası

| Türkçe | İngilizce | Kullanım |
| --- | --- | --- |
| **Düzenek Mühendisliği (Harness Engineering)** | Harness Engineering | Disiplin adı. Her geçtiğinde parantez içinde İngilizce karşılığıyla birlikte. |
| **düzenek** | harness | Bütün sistem. İlk geçişte `düzenek (harness)`; sonra `düzenek`. |
| **aparat** | element / component | Düzenek içindeki bir bileşen (talimat dosyası, durum dosyası, doğrulama scripti). |
| **vardiya alımı / vardiya teslimi** | clock-in / clock-out | Oturum açılış/kapanış rutinleri. |
| **bilgi görünürlüğü boşluğu** | knowledge visibility gap | Proje bilgisinin repoda yazılı olmayan oranı. |
| **doğrulama boşluğu** | verification gap | Ajanın doğrulamadan "tamamlandı" demesi (en yaygın anti-örüntü). |
| **erken zafer ilanı** | premature completion declaration | Aynı boşluğun tipik dışavurumu. |
| **soğuk başlangıç** | cold-start | Yeni oturum, repo'yu sıfırdan okuyor. |
| **sıcak başlangıç** | hot-start | Yeni oturum, init artefaktları sayesinde dakikalar içinde bağlam kuruyor. |
| **temiz teslim** | clean handoff / clean exit | Oturum sonunda repo'nun beş boyutta temiz olması. |
| **beş aparat** | five subsystems | Talimat, araç, ortam, durum, geri bildirim. |

### Terim seçimi gerekçesi

Önce **aparat** hem disiplin (Aparat Mühendisliği) hem bütün (aparat) hem
de element için kullanılıyordu. Karışıklık ortaya çıkınca üç düzeyi ayırmak
için **2026-05-19**'da migration yapıldı:

- Disiplin = **Düzenek Mühendisliği (Harness Engineering)**
- Bütün = **düzenek**
- Element = **aparat**

Migration script'i (Python) 170 word-form replacement + 28 alt sistem → aparat
+ 16 slug rename uyguladı. Tüm Türkçe ekler (aparatın → düzeneğin, aparatı →
düzeneği, vb.) ele alındı. Bir partial-match bug'ı (aparatıni → aparatını)
sonradan elle düzeltildi.

## Sıradaki adımlar

- [x] Mintlify Cloud üzerinde deploy edildi; Vercel proxy yaklaşımı
  bırakıldı.
- [x] ~~Mintlify dashboard'da custom domain değişikliği~~ — geçersiz:
  Faz 13'te hosting tamamen Mintlify Cloud'dan çıkarıldı, site Vercel'de
  self-host ediliyor. 301 redirect `vercel.json` içinde.
- [ ] Mintlify Cloud aboneliği/projesi artık kullanılmıyor — dashboard
  üzerinden kapat/iptal et (kullanıcı; billing erişimi gerekir).
- [ ] Statik modda arama yok (arama UI'ı build'de gizleniyor).
  İstenirse Pagefind ile client-side arama eklenebilir:
  build-static.sh sonunda `npx pagefind --site dist` + UI entegrasyonu.
- [x] 12 dersin diyagramları yeniden tasarlandı; SVG sanitizer
  sorunundan dolayı tamamı pure HTML/CSS'e geçirildi.
- [x] README global standartlarda yeniden yazıldı + OG cover hero
  olarak eklendi.
- [ ] OG image production'da çalıştığını kontrol et — `og:image`
  meta'sındaki URL `harness.komunite.com.tr/images/og-cover.png`
  olmalı; debugger: https://www.opengraph.xyz/url/
- [ ] `mint validate` ve `mint broken-links`'i CI'da koştur (workflow
  bunu yapıyor; ilk PR'da görüleceğiz).
- [ ] GitHub repo description + topics doldurulacak (öneri sohbette
  verildi: `harness-engineering`, `ai-agents`, `coding-agents`,
  `claude-code`, `codex`, `llm-agents`, `context-engineering`,
  `agent-orchestration`, `turkish`, `turkce`, `curriculum`,
  `mintlify`).
- [ ] `yetenekler/duzenek-yaratici` sayfasını ne zaman geri açacağına
  karar ver: skill paketinin Claude Code Skills marketplace'inde
  yayınlanması güzel bir tetikleyici.
- [ ] (Uzun vade) İngilizce çeviri, ayrı `en/` dizini olarak.

---

## 1. 2026-05-18 — Mintlify kurulumu ve marka paleti

**Hedef**: Boş repo'dan Türkçe Mintlify docs sitesi.

### Yapıldı

- `mintlify/starter` klonu üzerine inşa edildi.
- Lokomotif.ai logosu `logo/{light,dark}.svg` olarak eklendi.
- Marka paleti CSS override'ı yazıldı (`style.css`):
  - **Surfaces**: paper `#E8E8E3`, paper-elev `#F0F0EB`
  - **Text**: ink `#0E1417`, slate `#20333C`
  - **Accent**: electric lime `#E5FF59`, accent-ink `#1A2300`
  - **Mute ladder**: 50–600 (sıcak gri)
  - **Rule**: `rgba(14, 20, 23, 0.08)` hairline
- Callout, kart, kod bloğu, scrollbar, sidebar fade — hepsi paletle uyumlu.
- Türkçe terim konvansiyonu: "Aparat Mühendisliği (Harness Engineering)"
  her geçişte parantezli (sonradan 5. fazda değişti).

### Önemli karar

Mintlify, ana yüzey renklerini `--background-light` ve `--background-dark`
CSS değişkenleri üzerinden **RGB triplet** (virgülsüz) olarak yönetiyor.
Tailwind v3 modern color syntax: `rgb(var(--background-light) / <alpha>)`.

Önce her sınıfı (`bg-background-light`, `bg-background-light/95`,
`from-background-light`, `data-[is-opaque]:bg-background-light`) tek tek
override etmeye çalıştık — kırılgan, eksik. **Çözüm**: değişkeni
kaynağında override et:

```css
:root {
  --background-light: 232 232 227;   /* paper */
  --background-dark:  14 20 23;      /* dark paper */
}
```

Tek atışta tüm opaklık varyantları doğru renge düşer.

### Yan etki

Sidebar üst fade gradient'i (`from-background-light`) otomatik palete
döndü. Callout (Note) içindeki `[&_kbd]:bg-background-light` arbitrary
variant'i, başlangıçta greedy `[class*="bg-background-light"]` selector
ile yanlışlıkla yakalanmıştı; explicit liste'ye dönüldü.

---

## 2. 2026-05-18 — 12 ders ilk taslak (skeleton)

**Hedef**: 12 dersin yapısı + temel içeriği yazılsın.

### Yapıldı

Tek tek elle yazıldı; her ders: hook → tez → anti-örüntü → mekanizma →
pratik → veri → kontrol listesi → müfredat içindeki yer.

Ders başlıkları (ilk versiyonda "Ders N — Why X" formundaydı):

01. Yetkin Ajanlar Neden Hâlâ Başarısız Oluyor
02. Aparat (Harness) Gerçekte Nedir
03. Repo Neden Hakikat Kaynağı Olmalı
04. Tek Büyük Talimat Dosyası Neden Başarısız Olur
05. Uzun Süren Görevler Neden Süreklilik Kaybeder
06. Başlangıç (Initialization) Neden Kendi Fazına Sahip Olmalı
07. Ajanlar Neden Aşırıya Kaçar ve Yarım Bırakır
08. Özellik Listeleri Neden Aparatın Temel Bileşenleridir
09. Ajanlar Neden Erken Zafer İlan Eder
10. Uçtan Uca Test Neden Sonuçları Değiştirir
11. Gözlemlenebilirlik Neden Aparatın İçinde Olmalı
12. Her Oturum Neden Temiz Bir Durum Bırakmalı

Bu noktada içerik orijinal kaynağa (walkinglabs/learn-harness-engineering)
yakın ve birincil kaynak tek (oradan türetilmiş).

### Sorun

11. ders'in tablosunda `<%80` yazılmıştı → MDX parser bunu JSX tag
başlangıcı + geçersiz isim sayıp **tüm dosyanın parse'ını iptal etti**;
title okunamadı; sidebar slug fallback'ine düştü
(`11 gozlemlenebilirlik neden aparatin icinde olmali`). Düzeltme: `%80
altı`. Bu olay MDX güvenlik kuralının doğmasına yol açtı.

---

## 3. 2026-05-18 — Multi-source kalite pas'ı (12 ders)

**Hedef**: Tek kaynaktan çok kaynağa, dünya standardı kalite.

### Yapıldı

12 paralel subagent dispatch edildi. Her ajan:

- 5 birincil kaynağı WebFetch ile çekti
- Cross-check'lenmiş içerik üretti
- Kaynaklarını body'de attribution ile sundu
- Doğrulayamadığı sayıyı **çıkardı veya yumuşattı** (örn. OpenAI Codex
  "1M satır" iddiası kaynak erişilemez olduğu için kaldırıldı)

Yeni başlıklar (kitap bölümü gibi, daha az direkt çeviri kokulu):

01. Aynı Model, Farklı Sonuç
02. Aparatın Anatomisi
03. Repo: Hakikat Kaynağı
04. Şişmiş Talimat Sendromu
05. Vardiya Defteri
06. Önce Temel, Sonra Duvar
07. WIP=1 Disiplini
08. Özellik Listesi Bir Primitiftir
09. Erken Zafer İlanı
10. Üç Katmanlı Doğrulama Kapısı
11. Aparatın Gözleri (sonradan: Düzeneğin Gözleri)
12. Temiz Teslim

### Yedirilen birincil kaynaklar

- Anthropic: *Effective Harnesses for Long-Running Agents*, *Harness
  Design for Long-Running Apps*, *Building Effective Agents*,
  *Effective Context Engineering*, *Infrastructure Noise*,
  *Demystifying Evals*, *Multi-Agent Research System*, *Writing Tools
  for Agents*, *Code Execution with MCP*, *Claude Code Sandboxing*
- OpenAI: *Harness Engineering for Codex*
- HumanLayer: *Skill Issue*, *Writing a Good CLAUDE.md*, *12-Factor
  Agents*, *Context-Efficient Backpressure*
- Manus: *Context Engineering Lessons*
- Thoughtworks (Martin Fowler): *Harness Engineering*, *Context
  Engineering for Coding Agents*, *Anchoring to Reference*, *Assessing
  Internal Quality*, *SDD-3-tools*
- LangChain: *Anatomy of an Agent Harness*, *Improving Deep Agents
  with Harness Engineering*
- OpenHands: *Learning to Verify*, *Context Condensation*, *Evaluating
  Agent Skills*
- Inngest: *Your Agent Needs a Harness*
- OpenTelemetry: GenAI semconv
- Inspect AI (UK AISI)
- ghuntley: Ralph pattern
- Liu et al. 2023: *Lost in the Middle*

Her ders kaynaklarını metin içinde named attribution ile sunuyor.

---

## 4. 2026-05-18 — Üç kalite kapısı (tutarlılık + dil + akış)

**Hedef**: 12 paralel ajan farklı sesle yazdığı için yan yana okunduğunda
tutarsızlık olabilir. Üç pas:

### A) Cross-consistency sweep

- 3 kanonik ifade hatası düzeltildi ("aparat Mühendisliği" →
  "Aparat Mühendisliği")
- 9 tekrarlanan `(harness)` glossu silindi (her derste sadece ilk
  geçişte kalacak)
- 7 `features.md` → `features.json` uyumu (Ders 06, 07'de — Ders 08
  şemasıyla)

### B) Türkçe prose editor (18 düzeltme)

- Ondalık ayraç: prose'da virgül (`%90,2`), version string'lerde nokta
  (`Python 3.11`)
- Anglicism temizliği: "Slack thread'inde" → "iş parçacığında",
  "commit'lendi" → "commit edildi", "pile of files" → "dosya yığını"
- Sözcük sırası: "Doksan beş yüzde üstü" → "Yüzde doksan beş üstü"

### C) Pedagojik akış audit

- **Tüm 12 "Müfredat içindeki yeri" bölümü yeniden yazıldı** —
  formülaik şablon yerine doğal geçiş cümleleri
- Ders 08'deki 4-durum tablosu trim'lendi: Ders 07'nin listesini
  tekrar yerine pointer + formalleşme
- Ders 02 ve Ders 10'a bridge cümleleri eklendi

Bu pas'tan sonra müfredat **dünya standardı kalite**ye yakın bir
baseline.

---

## 5. 2026-05-19 — Terim migration: aparat → düzenek

**Hedef**: Disiplin / bütün / element ayrımını netleştir.

### Önce vs sonra

| Anlam | Önce | Sonra |
| --- | --- | --- |
| Disiplin | Aparat Mühendisliği (Harness Engineering) | **Düzenek Mühendisliği (Harness Engineering)** |
| Bütün | aparat | **düzenek** |
| Element | (yoktu — alt sistem deniyordu) | **aparat** |

### Sebep

"Aparat" hem disiplin hem bütün için kullanılınca yazılı metinde
hangisi olduğu belirsizleşiyordu. Yeni şema her seviyeyi ayrı sözcükle
tutuyor: **düzenek = bütün**, **aparat = parça**.

### Migration sonuçları

- **170** word-form replacement (`aparat → düzenek`, tüm Türkçe ekleriyle)
- **28** `alt sistem → aparat` (tüm ekler)
- **16** slug update (`02-aparat-gercekte-nedir` →
  `02-duzenek-gercekte-nedir`, vb.)
- **5** dosya rename
- **1** partial-match bug (aparatıni → aparatını) elle düzeltildi

### Sidebar başlıkları

- 02 "Aparatın Anatomisi" → **Düzeneğin Anatomisi**
- 11 "Aparatın Gözleri" → **Düzeneğin Gözleri**

Diğer 10 ders başlığı zaten "aparat" içermediği için değişmedi.

---

## 6. 2026-05-19 — Kütüphane şablonları (8 sayfa)

**Hedef**: Her aparat tipi için kopyala-kullan şablon.

### Yapıldı

8 paralel subagent ile her biri 1 sayfa yazdı; sırasıyla:

1. `AGENTS.md` — talimat aparatı (router + sıkı kısıtlar)
2. `PROGRESS.md & DECISIONS.md` — durum aparatları
3. `Makefile & init.sh` — ortam aparatları
4. `features.json` — geri bildirim primitifi
5. `verifier.md & Definition of Done` — doğrulama sözleşmesi
6. Sprint sözleşmesi & rubrik — süreç gözlemlenebilirliği
7. OpenTelemetry İz — runtime gözlemlenebilirliği
8. Session Close & Quality Doc — kapanış aparatları

Her sayfa: hook → ne işe yarar → şablon (kopyala-kullan) → konvansiyon
→ özelleştirme → otomasyona bağlama → ilgili dersler.

Birincil kaynaklara dayalı her sayfa (OTel için
opentelemetry.io/docs/specs/semconv/gen-ai, AGENTS.md için
agentsmd/agents.md vb).

---

## 7. 2026-05-19 — Proje kodları (6 starter/solution)

**Hedef**: Her dersi gerçek çalıştırılabilir koda dönüştür.

### Mimari karar

Tüm 6 proje **aynı Notes API** üzerinde inşa edildi (FastAPI + SQLite +
Bearer auth). Her proje önceki projenin solution'ı + dersinin
uygulaması.

```
P01 starter (sıfır)
P01 solution = baseline + AGENTS.md + Makefile + smoke test
P02 starter = P01 solution + scattered docs (kötü)
P02 solution = P01 solution + router AGENTS.md + topic docs
P03 starter = P02 solution + half-done search endpoint
P03 solution = P02 solution + PROGRESS + DECISIONS + init.sh + routines
P04 starter = P03 solution + features.md (free-form)
P04 solution = P03 solution + features.json + verify.sh + WIP=1
P05 starter = P04 solution + executor.md + PUT-404 bug
P05 solution = P04 solution + verifier.md + three_layer_check + DoD
P06 starter = P05 solution + broken OTel attempt
P06 solution = P05 solution + full OTel + Quality.md + session_close + cleanup
```

### Sonuç

6 ajan paralel, 6 proje. Toplam **167 dosya** (`projeler/0N/starter` ve
`projeler/0N/solution` altında).

Her solution kendi smoke testini geçiyor:
- P01: 4/4
- P02: 4/4
- P03: 2/2 + 2 bilinçli skip
- P04: 6/6 + verify.sh WIP=1 enforce
- P05: 14/14 (lint + 10 unit + 4 e2e); PUT-404 bug fix doğrulandı
- P06: 8/8 + OTel JSON çıktısı stdout'a düşüyor

### Pedagojik mekanizma

Project 05'in kasıtlı bug'ı (`PUT /notes/{nid}` `rowcount==0` kontrolü
yok) — tek başına executor'un kaçırdığı, sadece **verifier rolü +
e2e test** ile yakalanabilen bir defekt. "Erken zafer ilanı" dersinin
somut karşılığı.

---

## 8. 2026-05-19 — Skill paketi + SEO/OG + deploy hazırlığı

**Hedef**: harness-creator (Düzenek Yaratıcı) skill paketi + arama
motorları için SEO + sosyal paylaşımlar için OG image + production
deploy hazırlığı.

### Skill paketi

`skill-pack/duzenek-yaratici/` altında 25 dosya:

```
SKILL.md            README.md       INDEX.md
workflow/   01-taslak  02-test  03-degerlendir  04-iyilestir
recipes/    soguk-baslangic  vardiya-teslimi  verifier-kurulumu
            gozlemlenebilirlik  temiz-teslim
templates/  AGENTS.md.template  PROGRESS.md.template  ... (8 tane)
scripts/    verify.sh  three_layer_check.sh  session_close.sh  cleanup.sh
            (hepsi `set -euo pipefail`, idempotent, chmod +x)
memory/PATTERNS.md
```

Müfredat döngüsü kapandı: **dersler → kütüphane şablonları →
çalıştırılabilir skill paketi**. Reader artık
`cp templates/* my-repo/` ile dersi koda dönüştürebilir.

### SEO + Open Graph

`docs.json` içinde `seo.metatags` bloğu eklendi:

- `og:site_name`, `og:type`, `og:locale=tr_TR`
- `og:image=/images/og-cover.png` (w 1200, h 630, alt yazısıyla)
- `twitter:card=summary_large_image`, `twitter:site=@lokomotifai`
- `keywords`, `author`, `theme-color`, `robots`, `googlebot`
  (max-image-preview:large), `referrer`, `format-detection`

Page title + description'ları Mintlify otomatik `og:title` ve
`og:description`'a yansıtıyor; ek frontmatter gerekmedi.

Index page title önce site adıyla aynıydı → `"X - X"` duplikasyonu;
**düzeltildi**: title = "Açık kaynak müfredat",
sidebarTitle = "Genel Bakış".

### OG image

`images/og-cover.html` (paper background + hairline grid + paper-elev
çerçeve + ink başlık + slate alt başlık + lime accent + Lokomotif.ai
gerçek logosu + chips + URL) → chrome-headless-shell ile
`images/og-cover.png` olarak render (1200×630, ~84 KB).

İlk versiyonda custom marka SVG vardı; sonradan **gerçek Lokomotif.ai
logosu** (logo/light.svg'den) embed edildi. URL placeholder
`harness-docs.lokomotif.ai` → `harness.lokomotif.ai`.

`yetenekler/duzenek-yaratici` sayfası gizlendiği için OG image'daki
"harness-creator skill" CTA chip → "Türkçe müfredat" oldu.

### Deploy

Önce Vercel'i proxy olarak düşündük (vercel.json hazırlandı), ama
kullanıcı doğrudan Mintlify Cloud üzerinde deploy ettiğini bildirdi.
Vercel adımı bırakıldı; `vercel.json` silindi. Mintlify Cloud doğrudan
host eder, `harness.lokomotif.ai` özel alan adı Mintlify dashboard
üzerinden ayarlandı, TLS otomatik.

### Yetenekler sayfası gizlendi

Kullanıcı isteği üzerine `yetenekler/duzenek-yaratici` sayfası şimdilik
sakladı:

- `docs.json` navigation'dan Yetenekler grubu kaldırıldı
- `index.mdx` CardGroup'taki 4. kart kaldırıldı (CardGroup cols=3)
- `.mintignore`'a `yetenekler/` eklendi → direkt URL 404
- Skill paketi (`skill-pack/`) saldı; sadece docs sayfası gizli

---

## 9. 2026-05-19 — Açık kaynak hijyeni + CLAUDE/MEMORY

**Hedef**: Repo public oldu; global standartlarda açık kaynak hijyeni.

### Eklenenler

- **LICENSE** — Mintlify MIT 2023 yerine **CC0 1.0 Universal** (Türkçe
  + İngilizce nezaket atfı önerisiyle).
- **README.md** — badges, what/why, install, structure, deploy,
  contribute, license sections.
- **CODE_OF_CONDUCT.md** — Contributor Covenant 2.1 (Türkçe).
- **CONTRIBUTING.md** — katkı türleri, terim haritası, stil, MDX
  güvenliği, PR akışı.
- **SECURITY.md** — gizli bildirim kanalları, yanıt süreleri, eğitim
  amaçlı kasıtlı kusurların listesi.
- **CHANGELOG.md** — Keep a Changelog, v1.0.0 ilk sürüm.
- **CLAUDE.md** — router talimat (sıkı kısıtlar + içerik haritası +
  vardiya rutinleri).
- **MEMORY.md** — bu dosya.
- **.github/ISSUE_TEMPLATE/** — bug + feature + config.yml.
- **.github/PULL_REQUEST_TEMPLATE.md**.
- **.github/workflows/validate.yml** — mint validate + broken-links +
  Python MDX safety scan.

### Karar gerekçeleri

- **Neden CC0**: Müfredat içerik + öğretici kod; en geniş yeniden
  kullanılabilirlik. Awesome harness ekosistemi (walkinglabs vb.) de
  CC0.
- **Neden Türkçe community files**: Hedef kitle Türkçe konuşan
  geliştiriciler; bilingual fragmentation yerine tek dil.
- **Neden ayrı CLAUDE.md ve MEMORY.md**: Ders 04'ün kuralı. CLAUDE.md
  **kuralları** (router); MEMORY.md **gerekçeleri** (compaction
  kaybetmesin diye).
- **Neden Python MDX safety scan**: 2. fazda yaşadığımız `<%80` bug'ı
  bir daha tekrar etmesin. CI gate.

---

## 10. 2026-05-19 — Diyagram redesign + README cila

**Hedef**: Müfredat içeriği hazır; görsel kalite ve repo karşılama
deneyimi de aynı seviyeye çıksın.

### 12 dersin diyagramları yeniden tasarlandı

Önce SVG (rect/line/circle/text/polygon karışımı) ile yazılmıştı. Üç
ders (04, 08, 12) live site'ta tuhaf görünüyordu. Tek tek inceledikçe
**Mintlify sanitizer'ının** SVG child element'lerini sessizce strip
ettiği keşfedildi:

- **Survive eden**: `<rect>`, `<path>`
- **Strip edilen**: `<text>`, `<line>`, `<circle>`, `<polygon>`

`<g>` wrapper'ları kaldırmak, `xmlns` eklemek, top-level taşımak —
hiçbiri fark etmedi. Sanitizer kuralı bu. HTTP 200 dönüyor ama
element'ler DOM'da hiç yok.

**Çözüm**: tüm 12 dersin diyagramları **pure HTML + inline CSS**'e
çevrildi. Her diyagram için bir kompozisyon stratejisi:

| Ders | Diyagram | Strateji |
| --- | --- | --- |
| 01 | "9 vs 200" karşılaştırması | grid 1fr-1px-1fr, büyük rakam tipografisi |
| 02 | 5 aparat spec sheet | 5 satır, her satırda numbered badge + label + artifact pill |
| 03 | Dağıtık vs repo karşılaştırması | editorial tablo, lime accent kolonu |
| 04 | Şişme eğrisi (curve) | path-only SVG (curve + zone rect'leri); axis label'ları HTML overlay |
| 05 | Vardiya defteri timeline | iki oturum box'ı + handoff envelope + token bar |
| 06 | İki fazlı timeline | bootstrap → init kabul → implementation flow |
| 07 | Buffet vs tek tabak | iki kolon, Little's Law formülü altta |
| 08 | Feature durum makinesi | 4 rounded box flow + CSS arrow + lime verifier pill + ✓ rozet |
| 09 | Üç katmanlı kapı | executor → katman 1/2/3 → verifier flow |
| 10 | Test piramidi + tally | descending bar + 5'li tally (0/1/5) |
| 11 | İki paralel katman → KARAR | runtime + süreç katmanları → kanıtlı karar |
| 12 | Pentagon radar | 5×2 horizontal bar chart (diagonal-stripe vs solid+lime accent) |

### Öğrenilen MDX kısıtları

CLAUDE.md sıkı kısıtlar bölümüne "Mintlify render kısıtları" maddesi
eklendi (3. madde). Üç sub-rule:

1. SVG'de yalnız `rect`/`path` render olur.
2. MDX expression `.map()` güvenilmez — bir-iki iterasyon basıp kalan
   satırlar sessiz drop olabilir (L12 bar chart bunu yaşadı; 5 satır
   yerine 2 göründü). **Çözüm**: explicit yaz, DRY'ı feda et.
3. JSX inline style **object syntax** zorunlu: `style={{...}}`.
   String style `style="..."` HTTP 500 verir; bir kez L01'i 500'e
   düşürdü, `git checkout` ile geri alındı.

### README cila

Eski README community-doc tarzı klasik bir layout'a sahipti. Global
açık kaynak müfredat README'leri (Next.js, Astro, Supabase tarzı)
standardına yakınlaştırıldı:

- **Hero key visual**: `images/og-cover.png` başa centered olarak
  yerleştirildi (1200×630, full width).
- **Top-of-page nav**: Tez · İçerik · Hızlı başlangıç · Öğrenme yolu
  · Kaynaklar · Katkı (anchor linkler).
- **Badges**: site, lisans, Mintlify, sürüm, dil.
- **İçindekiler**: 2×2 HTML table — 12 Ders / 6 Proje / 8 Şablon /
  Skill Pack, her hücrede label + 1-cümle açıklama + path.
- **Öğrenme yolu**: ASCII flow şeması (teorik zemin → uygulama →
  capstone).
- **Mekanizma tablosu**: 5 aparat (Repo, State, Feedback,
  Self-verification, Observability) Türkçe-İngilizce eşli.
- **Kaynaklar**: birincil kaynak listesi (Anthropic, OpenAI,
  HumanLayer, Thoughtworks, Manus, OpenHands, LangChain, OTel,
  walkinglabs).
- **AI ajanlar için**: CLAUDE.md / MEMORY.md / skill-pack üçlüsü.

### Commits

- `91aeb10` — feat: dersler için SVG diyagramlar + projeler
  zenginleştirildi (önceki oturum)
- `bc7cd30` — feat: 12 dersin diyagramları SVG'den pure HTML/CSS'e
  geçti
- `5e7bd54` — docs: README yeniden yazıldı + hero key visual eklendi

### Yan etki: kullanılmayan asset'ler

`images/checks-passed.png`, `images/hero-dark.png`,
`images/hero-light.png` — hiçbir yerde referans yok, silindi
(bc7cd30'e dahil).

## 11. 2026-05-21 — Diyagram mobil uyumu + dark logo

**Hedef**: Ders sayfalarındaki diyagramlar desktop'ta iyi
görünüyordu; mobilde sabit pixel grid'ler ve 128px rakamlar
viewport'u taşırıyordu. Dark mode'da ise logo kontrastsız kaldı.

### Diyagram mobil override pattern

Diyagramlar inline `style={{...}}` ile yazılı; sabit pixel ölçüleri
ve `gridTemplateColumns:'1fr 1px 1fr'` gibi çok kolonlu yapılar
mobilde kırılıyor. Iki adımlık çözüm:

1. Tüm 12 outer wrapper'a `className="lesson-diagram"` eklendi.
   (Borderradius 20px outer-wrapper'a özel olduğundan Edit ile
   unique substring match'lendi.)
2. `style.css`'e `@media (max-width: 768px)` bloğu eklendi:
   - Outer padding 24px 18px'e iniyor.
   - Tüm iç `[style*="grid-template-columns"]` → `1fr` (tek kolon).
   - 1px-genişlikteki vertical divider'lar `display:none`.
   - `font-size:128px` → 64px, 34px → 26px, 22px → 17px, vs.
   - Flex satırları wrap.

Inline style'ı override etmek için `!important` zorunlu. Mintlify
inline style serializer'ı **boşluksuz** form (`font-size:128px`)
kullanıyor — curl ile doğrulandı. Yine de iki varyantı (boşluklu +
boşluksuz) ekledim, ileride bir React sürüm değişikliği olursa
break olmasın.

### Dark mode logo

`logo/dark.svg` beyaz versiyonla değiştirildi (kullanıcının
gönderdiği `logo-white.svg`). Light versiyon (`logo/light.svg`)
korundu. Mintlify zaten `docs.json` > `logo.light` / `logo.dark`
swap'ını otomatik yapıyor; ek config gerekmedi.

### Commits

- (bu commit) — `fix:` mobil diyagram override + dark logo.

## 12. 2026-08-15 — komunite org'una taşınma + yeni domain

**Hedef**: Repo `lokomotifai` → `komunite` GitHub org'una, yayın
adresi `harness.lokomotif.ai` → `harness.komunite.com.tr`.

### Yapılanlar

- GitHub transfer: `gh api repos/lokomotifai/harness-docs/transfer
  -f new_owner=komunite`. Eski URL'ler GitHub tarafından otomatik
  redirect ediliyor; local remote yine de güncellendi.
- Repo içindeki tüm `github.com/lokomotifai` ve
  `harness.lokomotif.ai` referansları güncellendi (docs.json,
  README, CONTRIBUTING, LICENSE, SECURITY, CLAUDE.md, issue
  template, skill-pack). CHANGELOG'daki tarihsel satırlar
  bilinçli olarak korundu.
- `images/og-cover.html` içindeki URL değişti;
  `og-cover.png` chrome-headless-shell ile yeniden render edildi
  (1200×630). Sol üstteki lokomotif.ai logosu marka kararı
  netleşene kadar korundu.
- Cloudflare `komunite.com.tr` zone'una CNAME eklendi:
  `harness` → `cname.mintlify.builders`, **DNS only** (Mintlify
  proxy istemiyor; eski lokomotif.ai kaydı da DNS only idi).
- GitHub repo metadata: homepage `harness.komunite.com.tr`,
  description + 12 topic dolduruldu (eski "Sıradaki adımlar"
  maddesiydi).
- Mintlify GitHub App'in `komunite` org'unda **zaten kurulu**
  olduğu doğrulandı (`gh api orgs/komunite/installations`).

### Bekleyenler

Mintlify dashboard login gerektirdiği için iki adım manuel kaldı:
custom domain değişikliği + repo bağlantısı doğrulaması ve
sonrasında eski domain'den 301 redirect ("Sıradaki adımlar"da).

### Commits

- (bu commit) — `chore:` org taşınması + domain migration.

## 13. 2026-08-15 — Mintlify Cloud'dan çıkış: Vercel'de statik self-host

**Hedef**: Repo transferi Mintlify Cloud'un GitHub bağlantısını
kopardı (deploy tetiklenmiyordu, dashboard login'i gerekiyordu).
Kullanıcı kararı: Mintlify Cloud'dan tamamen çık, `mint export`
statik çıktısını kendi Vercel team'inde host et.

### Mimari

- `mint export` (ücretsiz CLI, login gerektirmiyor — izole HOME ile
  doğrulandı) 29 sayfayı `dizin/index.html` yapısında tamamen statik
  export ediyor; Next.js asset'leri dahil ~50 MB.
- `scripts/build-static.sh`: export → `dist/`'e aç → post-process:
  1. `https://undefined.mintlify.app` → gerçek domain (export,
     custom domain'i bilmediği için OG/canonical URL'lerini böyle
     basıyor).
  2. Arama UI'ı gizleyen `<style>` inject (`#search-bar-entry`,
     `#search-bar-entry-mobile`, `[aria-label="Open search"]`) —
     statik modda arama Mintlify backend'i istiyor, modal ziyaretçiye
     "Run mint login" gösteriyordu. Not: repo'daki `style.css` export
     HTML'inde referans edilmiyor (stil inline gömülü), o yüzden
     inject `</head>` öncesine yapılıyor.
  3. `serve.js` / `Start Docs.*` local önizleme dosyaları silinir.
- `vercel.json`: `buildCommand` = build-static.sh, `outputDirectory`
  = dist, `installCommand` boş (repo'da package.json yok), host-bazlı
  301: `harness.lokomotif.ai/*` → `harness.komunite.com.tr/*`.
- Vercel projesi `harness-docs` (komunite team), GitHub
  `komunite/harness-docs`'a bağlı; `main`'e push → otomatik deploy.
- DNS (Cloudflare): `harness.komunite.com.tr` ve
  `harness.lokomotif.ai` CNAME → `cname.vercel-dns.com` (DNS only).

### Bilinen kısıtlar

- Export, FontAwesome ikonlarını ve KaTeX CSS'ini Mintlify'ın public
  CloudFront CDN'inden çeker — çalışıyor ama tam air-gap değil.
  Gerekirse asset'ler bundle edilebilir.
- Hosted search + AI assistant statik modda yok. Pagefind ile arama
  geri getirilebilir ("Sıradaki adımlar").
- `mint dev` / `mint validate` / CI workflow'u aynen çalışmaya devam
  ediyor; içerik formatı değişmedi, sadece hosting değişti.

### Commits

- (bu commit) — `feat:` Vercel statik self-host pipeline.
