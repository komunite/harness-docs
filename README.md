# Düzenek Mühendisliği (Harness Engineering)

> AI kod ajanlarını güvenilir kılan **çevreyi** tasarlamak: repo, durum,
> geri bildirim, doğrulama ve gözlemlenebilirlik. Modeli değil, modeli
> kuşatan **düzeneği** mühendislik problemi olarak ele alan Türkçe açık
> kaynak müfredat.

<p>
  <a href="https://harness.lokomotif.ai"><img alt="Site" src="https://img.shields.io/badge/site-harness.lokomotif.ai-0E1417?style=flat-square&labelColor=20333C"></a>
  <a href="LICENSE"><img alt="License: CC0-1.0" src="https://img.shields.io/badge/license-CC0--1.0-E5FF59?style=flat-square&labelColor=1A2300"></a>
  <a href="https://www.mintlify.com"><img alt="Built with Mintlify" src="https://img.shields.io/badge/built%20with-Mintlify-20333C?style=flat-square"></a>
  <img alt="Status: 1.0.0" src="https://img.shields.io/badge/status-1.0.0-20333C?style=flat-square">
</p>

---

## Nedir bu

12 ders, 6 proje, 8 kopyala-kullan şablon. Hedef kitle: Claude Code,
Codex ve benzeri AI ajanlarla üretim yapan yazılım mühendisleri.

Müfredat tek bir tezi savunur: **bir görevde başarısızlık çıktığında
önce modeli değil, modeli kuşatan düzeneği (harness) sorgula.**
Düzenek aparatları (talimat, araç, ortam, durum, geri bildirim) +
öz-doğrulama + gözlemlenebilirlik + temiz teslim disiplini ile
güvenilirlik kategorik olarak değişir.

İçeriğin tamamı Türkçe; teknik terimler İngilizce karşılıklarıyla
birlikte verilir.

## Ne içerir

| Bölüm | İçerik |
| --- | --- |
| **12 Ders** | "Aynı Model, Farklı Sonuç"tan "Temiz Teslim"e — her ders bir anti-örüntü teşhisi + mekanizma + saha kanıtı |
| **6 Proje** | Kümülatif bir Notes API üzerinde `starter/` + `solution/` zinciri; her proje önceki çözüm üzerine bir aparat ekler |
| **8 Şablon** | `AGENTS.md`, `PROGRESS.md`+`DECISIONS.md`, `Makefile`+`init.sh`, `features.json`, `verifier.md`+DoD, sprint+rubrik, OTel iz, session-close+Quality |
| **harness-creator skill paketi** | `skill-pack/duzenek-yaratici/` — workflow + recipes + templates + scripts (25 dosya) |

Birincil kaynaklara dayalı: Anthropic'in *Effective Harnesses for
Long-Running Agents* + *Harness Design for Long-Running Apps* +
*Infrastructure Noise*; OpenAI'ın *Harness Engineering for Codex*;
HumanLayer'ın *Skill Issue* + *Writing a Good CLAUDE.md* + *12-Factor
Agents*; Thoughtworks/Martin Fowler; Manus *Context Engineering*;
OpenHands; LangChain; OpenTelemetry GenAI semconv; walkinglabs
*Learn Harness Engineering*. Her ders kaynaklarını cite eder.

## Yerel önizleme

```bash
npm install -g mint
mint dev
# → http://localhost:3000
```

Search ve AI assistant'ı local'de açmak için: `mint login`.

Çapraz link bütünlüğünü ve MDX güvenliğini doğrulama:

```bash
mint validate
mint broken-links
```

## Yapı

```
.
├── index.mdx                       # giriş
├── dersler/        01..12          # 12 teorik ders
├── projeler/       01..06          # 6 proje (her biri *.mdx + 0N/{starter,solution}/)
├── kutuphane/                      # 8 şablon + genel bakış
├── yetenekler/                     # (şimdilik .mintignore'da)
├── skill-pack/duzenek-yaratici/    # Claude Code / OpenClaw uyumlu yetenek paketi
├── images/                         # OG cover + brand assets
├── logo/                           # marka logosu
├── style.css                       # marka paleti override
└── docs.json                       # Mintlify konfigürasyonu + SEO/OG
```

## Deploy

Site **Mintlify Cloud**'da host edilir. Üretim deploy'ı yalnızca
`main` dalına push olunca tetiklenir (otomatik).

- Özel alan adı: [harness.lokomotif.ai](https://harness.lokomotif.ai)
- TLS Mintlify tarafından otomatik
- Search ve AI assistant entegre

Mintlify yapılandırması [`docs.json`](docs.json) içinde; SEO ve Open
Graph yapılandırması `seo.metatags` bloğunda.

## Katkı

Hatalar, geliştirmeler, çeviriler — her şey memnuniyetle karşılanır.

- **Hata raporu / öneri**: [GitHub Issues](https://github.com/lokomotifai/harness-docs/issues)
- **Pull request kuralları**: [CONTRIBUTING.md](CONTRIBUTING.md)
- **Davranış kuralları**: [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)
- **Güvenlik bildirimi**: [SECURITY.md](SECURITY.md)

## AI ajanlar için

Bu repo aynı zamanda AI kod ajanları için bir referans projedir.
Kendi reposunda çalışan bir ajan:

- [CLAUDE.md](CLAUDE.md) — router talimat dosyası (sıkı kısıtlar +
  konu dokümanları haritası + vardiya rutinleri)
- [MEMORY.md](MEMORY.md) — projenin yapım hikayesi, alınmış kararlar,
  terim haritası, sıradaki adımlar
- `skill-pack/duzenek-yaratici/` — kendi reposuna kopyalayabileceği
  yetenek paketi

## Lisans

[CC0 1.0 Universal](LICENSE). Atıf zorunlu değil; takdir edilir.

```
Düzenek Mühendisliği (Harness Engineering) — Lokomotif.ai
https://harness.lokomotif.ai
```

## Bağlantılar

- **Site**: [harness.lokomotif.ai](https://harness.lokomotif.ai)
- **GitHub**: [github.com/lokomotifai/harness-docs](https://github.com/lokomotifai/harness-docs)
- **İlham veren müfredat**: [walkinglabs/learn-harness-engineering](https://github.com/walkinglabs/learn-harness-engineering) (CC0)
- **İlgili koleksiyon**: [walkinglabs/awesome-harness-engineering](https://github.com/walkinglabs/awesome-harness-engineering) (CC0)
