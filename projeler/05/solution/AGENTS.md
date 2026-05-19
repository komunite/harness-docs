# AGENTS.md

Bu dosya bir router'dir. Yiğini, sıkı kısıtları, rol ayrımını ve doğrulama
komutlarını ozetler; gerisi `executor.md`, `verifier.md` ve kodun
kendisinden okunur.

## Sıkı kısıtlar

- Tum `/notes` endpoint'leri `Authorization: Bearer <API_TOKEN>` ister.
- SQL parametrize edilir; f-string ile SQL birleştirilmez.
- `app.py` baseline'ı korunur; imza değiştirmek icin `DECISIONS.md`'ye
  gerekce yazılır.

## Roller

- **executor** — kod ve birim test yazar. Bkz. `executor.md`.
- **verifier** — kod yazmaz; uc katmanlı kapıyı koşar, raporlar. Bkz.
  `verifier.md`.

Aynı oturumda aynı ajan iki rolu birden ustlenmez. Pratikte iki ayrı
prompt / oturum / model orneği onerilir.

## Definition of Done

- **Feature complete** = uctan uca davranış doğrulandı; "kod yazıldı"
  yetmez.
- **Zorunlu doğrulama seviyeleri** (sıralı, atlanamaz):
  1. Lint / sozdizimi (Katman 1)
  2. Birim + integration (Katman 2)
  3. Uctan uca (Katman 3)
- Katman N başarısızken N+1'e gecme.
- Oncelik: **doğruluk → performans → stil**. İlk ikisi bitmeden refactor
  yok.
- **Tamamlanma yargısı verifier tarafindan verilir, executor tarafindan
  değil.**
- Hata mesajları **ERROR / WHY / FIX** formatında, ajan-okunur.
- `features.json` icinde her madde icin dışsal `passes: bool` alanı
  tutulur; bayrağı verifier set eder.

## Doğrulama komutları

- Hizli geri besleme (executor): `pytest -q`
- Tam kapı (verifier): `bash scripts/three_layer_check.sh`
- Uyumluluk: `make verify` (uc katmanlı scripti cağırır)

## Dev Environment Tips

- Python 3.11+ zorunludur.
- Kurulum: `make setup`.
- Yerel sunucu: `make dev`.
- Token: varsayılan `dev-token`. `API_TOKEN` ile uzerine yazılır.
- Veritabanı: `DB_PATH` ile SQLite dosyası secilir.

## PR Instructions

- PR başlığı kısa, emir kipi.
- Aciklama uc bolum: ne değişti / neden / verifier kapanış raporu (passing
  veya blocked + gerekce).
- "Lokalde gecti" yetmez; gecerli kanıt `scripts/three_layer_check.sh`
  cıktısıdır.
