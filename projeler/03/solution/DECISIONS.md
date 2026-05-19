# Tasarim Kararlari

Her madde bir baglayici karari kaydeder. Bir sonraki oturum reddedilen alternatifi tekrar onermesin diye gerekce + reddedilen alternatif + kisit ucusu zorunludur.

## 2026-05-12 — Auth icin Bearer token, session reddedildi

- **Neden**: API tuketicisi baska bir backend; tarayici cerez davranisina gerek yok. Bearer header tasimasi standart httpx istemcisinde tek satir. Test fixture'larinda header enjeksiyonu trivial.
- **Reddedilen alternatif**: Cookie tabanli session. CSRF korumasi, secure/samesite ayarlari ve oturum store'u bu olcekte gereksiz yuk.
- **Kisit**: Tek statik token; rotasyon manuel ve env degisikligi gerektirir. Cok kullanicili sisteme gectigimizde JWT'ye gecis acilir.

## 2026-05-14 — Depolama icin sqlite3, PostgreSQL ertelendi

- **Neden**: Tek dosya, sifir kurulum maliyeti, testler `tmp_path` ile izole. Egitim projesi kapsami icin migration aracligi gerektirmiyor.
- **Reddedilen alternatif**: PostgreSQL + alembic. Container, kullanici, sifre yonetimi ve migration script'leri ilk donemde ogrenme egrisini fazla yukseltir. Volume olmadan veri da kalici degil.
- **Kisit**: Yazma esligi yok; sqlite3 tek yazmaya kilitlenir. Yuksek esli yuke gecince geri donulur.

## 2026-05-17 — Search icin SQL LIKE secildi, FTS5 yarin degerlendirilecek

- **Neden**: Mevcut sema `title TEXT`, kayit sayisi az; LIKE ile prefix/substring eslesmesi yeterli oluyor. Migration gerekmeden tek endpoint eklenebilir.
- **Reddedilen alternatif**: sqlite3 FTS5 sanal tablosu. Daha hizli ve siralanmis sonuc verir; ama ek sema, ek senkron tetigi (notes -> fts kopyasi) ve ek test gerektirir. Bu vardiya kapsamina sigmaz.
- **Kisit**: Sorgu N satir uzerinde linear; binlerce kaydi gecince yavaslayacak. Buyuklugu gectiginde FTS5'e gecis kararini bu dosyaya yeni madde olarak yaz.

## Acik karar (bu vardiyada netlesmedi)

- **Bos `q` icin HTTP kodu**: 400 mu 422 mi? 400 elle, 422 Pydantic Query dogrulamasi ile gelir. Karar bir sonraki vardiyada verilecek ve buraya yeni madde olarak eklenecek.
