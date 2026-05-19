# AGENTS.md

Bu dosya ajan için iniş sayfasıdır. Kısadır, kalmalıdır. Ayrıntı için konu dokümanlarına yönlendirir.

## Proje

Notes API: FastAPI üzerinde Bearer auth ile korumalı, SQLite ile saklanan minimal bir not servisi. Kaynak kodu `app.py`'de; modül-yerel mimari notu `src/api/ARCHITECTURE.md`'dedir.

## Sıkı kısıtlar (ihlal edilemez)

- Tüm SQL sorguları parametreli olur; string birleştirme ile sorgu kurmak yasaktır.
- Tüm endpoint'ler `Depends(auth)` ile korunur; istisna yalnızca açık karar gerektirir.
- Authorization header asla loglanmaz; token değeri prod log'una düşemez.
- Secret'lar repoya commit edilmez; `API_TOKEN` yalnızca env üzerinden gelir.
- Her PR `make check` yeşil olmadan birleşmez.

Bu liste kısadır ve kasıtlı kısadır. Yeni bir sıkı kısıt eklemeden önce konu dokümanına ait olup olmadığını sor.

## Hızlı başlangıç

- Kurulum: `make setup`
- Dev sunucu: `make dev`
- Test: `make test`
- Tam doğrulama: `make check`

## Konu dokümanları

Görev tipi ile doküman eşlemesi. Sadece görevinizle ilgili dokümanı okuyun; hepsini birden okumayın.

- Endpoint eklerken veya değiştirirken: `docs/api-patterns.md`
- Veritabanı şeması, sorgu, transaction değiştirirken: `docs/database-rules.md`
- Auth, secret, token rotation, input validation: `docs/security.md`
- API modülünün iç düzeni hakkında: `src/api/ARCHITECTURE.md`

## Bu dosyanın disiplini

- Üst sınır: iki yüz satır. Hedef: yüz satır civarı.
- Sıkı kısıtlar dosyanın başında durur; ortaya kural gömülmez.
- Bir hata her zaman buraya kural eklemeyi gerektirmez; çoğu zaman doğru cevap kuralı ilgili konu dokümanına taşımaktır.
- Aylık bakım: artık geçerli olmayan satırlar silinir. Silmek eklemek kadar bir düzenek işidir.

## Soğuk başlangıç testi

Yeni bir oturum bu repoya geldiğinde şu beş soruya yalnızca dosyalara bakarak cevap verebilmelidir:

- Proje nedir? Bu dosyanın "Proje" bölümü.
- Nasıl çalıştırılır? Bu dosyanın "Hızlı başlangıç" bölümü.
- Nasıl doğrulanır? `make check`, bu dosyada listeli.
- Hangi kurallar ihlal edilemez? Bu dosyanın "Sıkı kısıtlar" bölümü.
- Detaya inmek gerekirse nereye bakılır? Bu dosyanın "Konu dokümanları" haritası.

Beşine de evet diyebiliyorsa bu dosya görevini yapıyor demektir.
