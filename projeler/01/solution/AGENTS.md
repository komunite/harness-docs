# AGENTS.md

Bu dosya bir ansiklopedi değil, bir router'dır. Ajan repoya girdiğinde
buradan yığını, sıkı kısıtları ve doğrulama komutlarını öğrenir; gerisini
kodun kendisinden okur.

## Sıkı kısıtlar

- Tüm `/notes` endpoint'leri `Authorization: Bearer <API_TOKEN>` ister.
- Token eksik veya hatalı ise yanıt `401` olur; sızdırılmış mesaj yazılmaz.
- Tüm SQL parametrize edilir (`?` placeholder). Hiçbir koşulda f-string
  ile SQL birleştirilmez.
- `make check` yeşil olmadan teslim yapılmaz. "Tamamlandı" demenin tek
  geçerli kanıtı budur.
- `app.py` baseline'ı korunur. Bağımlılık eklemek ya da imza değiştirmek
  gerekirse önce `DECISIONS.md` (gerekirse oluştur) içine gerekçe yazılır.

## Dev Environment Tips

- Python 3.11+ zorunludur (`pyproject.toml` içinde sabitlenmiştir).
- Tek komutla kurulum: `make setup`. Sanal ortam yönetimini ajan değil
  geliştirici seçer; `requirements.txt` her iki yolla da uyumludur.
- Yerel sunucu: `make dev` — `uvicorn app:app --reload` çalıştırır.
- Token: varsayılan `dev-token`. Üretim simülasyonu için `API_TOKEN=...`
  environment variable ile geçilir.
- Veritabanı: `DB_PATH` ortam değişkeniyle değiştirilebilir SQLite
  dosyası. Testler her koşumda izole bir dosya kullanır.

## Testing Instructions

- Smoke testleri: `make test` — `pytest tests/ -x` koşar.
- Test dosyası `fastapi.testclient.TestClient` kullanır; canlı sunucu
  gerektirmez. Ağ erişimi açmaz, dış servis çağırmaz.
- Yeni endpoint eklenirse smoke test'e en az bir "401 without token" ve
  bir "200/201 with token" durumu eklenir.
- Tip denetimi ve lint opsiyoneldir; varsa `make check` içine eklenir,
  yoksa `pytest` tek başına geçerli doğrulayıcıdır.
- "Lokalde geçti" yetmez; CI'da koşacak hedef `make check`'tir.

## PR Instructions

- PR başlığı: kısa, emir kipi, Türkçe. Örn: "Bearer auth: 401 yanıt mesajını standartlaştır".
- PR açıklaması üç bölüm içerir:
  1. **Ne değişti** — tek paragraf.
  2. **Neden** — düzeneğin hangi katmanını iyileştirdiği
     (talimat / araç / ortam / durum / geri bildirim).
  3. **Doğrulama** — `make check` çıktısı yapıştırılır.
- Bağımlılık eklendiyse `requirements.txt` ve `pyproject.toml` aynı PR
  içinde güncellenir.
- Baseline `app.py` davranışını bozan değişiklik tek başına yeterli
  gerekçedir; reddedilir.

## Doğrulama komutları

- Test: `pytest tests/ -x`
- Tam doğrulama: `make check`

Bu blok bir referans değil bir **sözleşmedir**. Ajan teslim etmeden önce
`make check` koşturur ve çıktısını rapor eder.
