# Solution — Yönlendirici AGENTS.md (Progressive Disclosure)

Aynı kod tabanı, aynı `Makefile`, aynı testler — ama bilgi mimarisi değişti. `AGENTS.md` artık üç yüz satırlık bir ansiklopedi değil, yaklaşık yüz satırlık bir **yönlendiricidir**. Kök dosya yalnızca üç şeyi tutar: projenin tek cümlelik tanımı, ihlal edilemez sıkı kısıtların kısa listesi, ve "şu görev tipinde şu dokümana git" haritası. Ayrıntı `docs/` altındaki konu dokümanlarına ve modül başına `ARCHITECTURE.md` dosyalarına dağıtılmıştır.

Bu yapı [Ders 03 — Repo: Hakikat Kaynağı](../../../dersler/03-repo-neden-hakikat-kaynagi-olmali)'ndaki dört ilkenin doğrudan uygulamasıdır: bilgi kodun yanında yaşar, standardize bir giriş dosyası vardır, her doküman minimum ama tam tutulur, kodla birlikte güncellenir. Aynı zamanda [Ders 04 — Şişmiş Talimat Sendromu](../../../dersler/04-tek-buyuk-talimat-dosyasi-neden-basarisiz)'nun çözüm önerisini somutlaştırır: giriş dosyası ansiklopedi değil router'dır, ayrıntı **just-in-time** olarak yüklenir.

`../starter/` ile diff'e bakın: `AGENTS.md` satır sayısının üçte birine düştü ama bilgi kaybı yok; konu dokümanları toplamı starter'dan daha uzun olabilir, çünkü amaç sıkıştırma değil **doğru yerleştirme**dir. Lost-in-the-middle riski ortadan kalktı çünkü her doküman kendi sıkı kısıtlarını başında taşıyor. Öncelik karmaşası çözüldü çünkü stil tercihleri (`docs/api-patterns.md`) ile güvenlik kuralları (`docs/security.md`) artık fiziksel olarak ayrı.

## Çalıştırma

```
make setup
make check
```

`make check` testleri koşar ve "ok" basar; bu solution'ın doğrulama sözleşmesi yeşildir.

## Düzen

- `AGENTS.md` — router, üç yüz satır altında, yaklaşık yüz satır
- `docs/api-patterns.md` — endpoint, response, validation, pagination konvansiyonları
- `docs/database-rules.md` — SQLite kullanımı, parametreli sorgular, transaction'lar, migration
- `docs/security.md` — Bearer auth, secret yönetimi, token rotation
- `src/api/ARCHITECTURE.md` — API modülü için modül-yerel mimari notu
- `app.py`, `Makefile`, `tests/test_smoke.py`, `pyproject.toml`, `requirements.txt` — starter ile aynı
