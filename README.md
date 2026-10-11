<div align="center">

<h1>Düzenek Mühendisliği (Harness Engineering)</h1>

<p>
  <strong>AI kod ajanlarını güvenilir kılan çevreyi tasarla.</strong><br/>
  Modeli değil, modeli kuşatan düzeneği (harness).
</p>

<p>
  <a href="https://harness.komunite.com.tr"><img alt="Site" src="https://img.shields.io/badge/site-harness.komunite.com.tr-0E1417?style=flat-square&labelColor=20333C"></a>
  <a href="LICENSE"><img alt="Lisans CC0-1.0" src="https://img.shields.io/badge/lisans-CC0--1.0-20333C?style=flat-square"></a>
  <img alt="Dil: Türkçe" src="https://img.shields.io/badge/dil-T%C3%BCrk%C3%A7e-20333C?style=flat-square">
</p>

</div>

---

## Müfredat artık sitede

Müfredatın yayındaki hali **[harness.komunite.com.tr](https://harness.komunite.com.tr)** adresinde, Komünite'nin dizin
sisteminde. Adresler aynı kaldı: `/dersler/<slug>`, `/projeler/<slug>`, `/kutuphane/<slug>`. Her sayfanın düz Markdown
hali de var: sayfa adresinin sonuna `.md` ekle.

Metinlerin güncel hali sitede. Bu repodaki `dersler/`, `projeler/` ve `kutuphane/` altındaki `.mdx` dosyaları 11 Ekim
2026'daki aktarımdan önceki Mintlify kaynağıdır ve artık yayına çıkmaz.

**Bu repo şunları taşır:**

- `projeler/0N/starter` ve `projeler/0N/solution`: altı projenin çalışan kodu
- `skill-pack/duzenek-yaratici/`: başka bir repoda düzenek kurmak için yetenek paketi
- `kutuphane/` şablonlarının ilk kaynağı

## Projeyi çalıştır

```bash
git clone https://github.com/komunite/harness-docs
cd harness-docs/projeler/01/starter
make setup
make test
```

Her projenin adımları, starter ile solution arasındaki fark ve beklenen sonuçlar sitedeki proje sayfasında:
[Proje 01: Kural Öncelikli](https://harness.komunite.com.tr/projeler/01-yalniz-prompt-vs-kural-oncelikli).

## İçerik

| Bölüm | Ne var |
| --- | --- |
| [12 ders](https://harness.komunite.com.tr/#dersler) | Her ders bir anti-örüntü teşhisi: yetkin ajanlar neden başarısız olur, hangi mekanizma çözer. |
| [6 proje](https://harness.komunite.com.tr/#projeler) | Kümülatif Notes API üzerinde `starter/` ve `solution/` zinciri. Her proje bir aparat ekler. |
| [8 şablon](https://harness.komunite.com.tr/kutuphane) | Kopyala-kullan iskelet: `AGENTS.md`, `PROGRESS.md` ve `DECISIONS.md`, `Makefile` ve `init.sh`, `features.json`, `verifier.md`, sprint sözleşmesi, OTel izi, session close. |
| [Skill paketi](skill-pack/duzenek-yaratici/) | Claude Code uyumlu yetenek paketi: workflow, recipe, template, script. |

## Kaynak ve lisans

Bu müfredat [walkinglabs/learn-harness-engineering](https://github.com/walkinglabs/learn-harness-engineering) (MIT,
Copyright (c) 2025 WalkingLab) temel alınarak Türkçe'ye uyarlanmıştır. Derslerin dayandığı birincil kaynaklar her
sayfanın sonunda listelidir.

Bu repodaki metin, kod, şablon ve skill paketi [CC0 1.0 Universal](LICENSE): kamu malı, atıf zorunlu değil.
Uyarlamanın kaynağı ve alıntılanan yayınlar kendi lisanslarını korur.

## Katkı

| Konu | Yer |
| --- | --- |
| Hata raporu ya da öneri | [GitHub Issues](https://github.com/komunite/harness-docs/issues) |
| Pull request kuralları | [CONTRIBUTING.md](CONTRIBUTING.md) |
| Davranış kuralları | [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) |
| Güvenlik bildirimi | [SECURITY.md](SECURITY.md) |

<div align="center">
  <br/>
  <sub>Düzenek Mühendisliği · <a href="https://komunite.com.tr">Komünite</a> · 2026</sub>
</div>
