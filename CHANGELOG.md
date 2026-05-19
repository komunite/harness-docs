# Changelog

Tüm önemli değişiklikler bu dosyaya işlenir.

Format [Keep a Changelog](https://keepachangelog.com/) ve sürümleme
[Semantic Versioning](https://semver.org/) prensiplerine uyar.

## [Unreleased]

### Eklenenler
- Mintlify Cloud + Vercel proxy ile production deploy zinciri.
- `harness.lokomotif.ai` özel alan adı yapılandırması.

### Değişenler
- _henüz yok_

### Düzeltmeler
- _henüz yok_

---

## [1.0.0] — 2026-05-19

İlk açık kaynak sürüm.

### Eklenenler

**İçerik**
- 12 ders (Düzeneğin Anatomisi'nden Temiz Teslim'e); birincil
  kaynaklarla (Anthropic, OpenAI, HumanLayer, Thoughtworks, Manus,
  LangChain, OpenTelemetry, OpenHands) cross-check edilmiş.
- 6 hands-on proje, kümülatif Notes API üzerinde; her birinde
  çalıştırılabilir `starter/` + `solution/` (Python + FastAPI).
- 8 kütüphane şablonu (`AGENTS.md`, `PROGRESS.md`+`DECISIONS.md`,
  `Makefile`+`init.sh`, `features.json`, `verifier.md`+DoD,
  sprint sözleşmesi+rubrik, OpenTelemetry iz iskelesi,
  session-close+Quality Document).

**Yetenek paketi**
- `skill-pack/duzenek-yaratici/` — 25 dosya; workflow (4 faz),
  recipes (5), templates (8 `.template`), scripts (4 idempotent
  `.sh`), memory patterns. Şu an docs sayfası `.mintignore`'da
  (gizli); skill paketi GitHub'dan erişilebilir.

**Marka ve UX**
- Marka paleti CSS override'ı (paper #E8E8E3, ink #0E1417,
  electric lime accent #E5FF59, mute ladder, hairline rule).
- Mintlify `--background-light` / `--background-dark` CSS değişken
  override'ı ile tüm opaklık varyantları tek atışta uyumlu.
- Callout, kart, kod bloğu, scrollbar, sidebar fade — hepsi
  paletle uyumlu.

**SEO ve sosyal**
- Global Open Graph + Twitter Card meta tags (`docs.json
  seo.metatags`).
- 1200×630 OG image, gerçek Lokomotif.ai logosu + marka paleti
  (HTML → PNG, chrome-headless-shell ile render).
- `keywords`, `author`, `theme-color`, `robots`, `googlebot`
  (max-image-preview:large) ayarları.
- `og:locale=tr_TR`.

**Deploy**
- `vercel.json` ile Vercel → Mintlify Cloud proxy.
- Güvenlik header'ları (X-Frame-Options, X-Content-Type-Options,
  Referrer-Policy, Permissions-Policy).

**Açık kaynak hijyeni**
- CC0 1.0 Universal lisansı.
- README, CODE_OF_CONDUCT (Contributor Covenant 2.1 TR),
  CONTRIBUTING, SECURITY, CHANGELOG.
- GitHub issue ve PR şablonları, validate workflow.
- CLAUDE.md (router talimat) + MEMORY.md (proje hafızası).

### Notlar

Bu sürüm tamamen Türkçe içerikle gönderildi. İngilizce çeviri sonraki
sürümlerin konusu.

[Unreleased]: https://github.com/lokomotifai/harness-docs/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/lokomotifai/harness-docs/releases/tag/v1.0.0
