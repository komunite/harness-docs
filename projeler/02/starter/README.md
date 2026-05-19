# Starter — Şişmiş AGENTS.md (Instruction Bloat)

Burada aparat *var* ama yanlış şekilde var. `Makefile`, `tests/test_smoke.py`, `pyproject.toml` ve hatta bir `AGENTS.md` mevcut. Eksiklik mekanik değil; **bilgi mimarisinde**. Bütün talimat tek bir dev dosyaya — yaklaşık üç yüz satırlık bir `AGENTS.md`'ye — tıkıştırılmış. Proje tanıtımı, API konvansiyonu, veritabanı kuralları, deployment notları, kod stili tercihleri, edge case'ler, troubleshooting ipuçları, geçmişte yapılmış hatalardan üretilmiş düzeltici kurallar ve örnekler hepsi yan yana, aynı tire ile maddelenmiş.

Bu klasörün amacı [Ders 04 — Şişmiş Talimat Sendromu](../../../dersler/04-tek-buyuk-talimat-dosyasi-neden-basarisiz)'nun anlattığı dört başarısızlık mekanizmasını somut hâle getirmektir. Dosyayı bir ajana açtırıp aynı görevi koşturduğunda tipik sonuçlar şunlardır: ajan dosyanın başını okuyup ortayı atlar (lost-in-the-middle), ihlal edilemez güvenlik kısıtları stil tercihlerinden ayırt edilemediği için aynı önem ağırlığıyla muamele görür (öncelik karmaşası), giriş dosyasının bağlam bütçesini yemesi nedeniyle esas iş için daha az pay kalır (context budget tüketimi), ve dosyada çelişen kurallar görünmeden birikir (bakım çürümesi).

Aynı kod tabanı `../solution/` altında yeniden yapılandırılmış: `AGENTS.md` artık ansiklopedi değil, yaklaşık yüz satırlık bir yönlendiricidir. Ayrıntı `docs/` altındaki konu dokümanlarına ve modül başına `ARCHITECTURE.md` dosyalarına dağıtılmıştır. İki klasörün diff'i, "talimat ekledikçe performans düşer" paradoksunun saha kanıtıdır.

## Çalıştırma

```
make setup
make test
```

Kod testleri geçer; bu starter'ın derdi davranış değil, **bilgi görünürlüğüdür**.
