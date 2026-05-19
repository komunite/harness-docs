# Database Rules

Ne zaman oku: SQL sorgusu eklerken veya değiştirirken, şema değişikliği yaparken, migration konusunda karar verirken. Endpoint stili ile ilgili sorular için `api-patterns.md`'ye git.

## Sıkı kısıtlar

- Tüm sorgular parametreli olur. String concatenation ile sorgu kurmak yasaktır. Bu kural ihlal edilemez; bir kez ihlal edildi, prod incident'i çıktı.
- Tek bir mantıksal işlem tek bir `with conn() as c` bloğu içinde tutulur; manuel commit/rollback çağrılmaz.
- Şema değişikliği `app.py` içindeki `CREATE TABLE IF NOT EXISTS` deyimi ile değil, bir migration dosyası ile yapılmalıdır — migration sistemi eklenene kadar şema sadeliği korunur.

## Bağlantı yönetimi

- `DB_PATH` env değişkeni dosya yolunu verir; default `notes.db`.
- Her request yeni bağlantı açar. SQLite için connection pool gereksizdir.
- `conn()` fonksiyonu hem bağlantıyı açar hem tablo varlığını doğrular. İdeal değildir; refactor edildiğinde bağlantı ve şema doğrulama ayrılacak. O zamana kadar bu davranışa güven.

## Parametreli sorgu deseni

Doğru:

```
c.execute("SELECT id, title, body FROM notes WHERE id=?", (nid,))
```

Yanlış (yasaktır):

```
c.execute("SELECT * FROM notes WHERE id=" + str(nid))
```

Soru işaretli yer tutucular SQLite'ın standart yöntemidir; named parameter (`:name`) da kullanılabilir.

## Transaction'lar

- `with conn() as c:` deyimi blok başarılı biterse commit, exception olursa rollback yapar.
- İç içe transaction kullanma; SQLite savepoint destekler ama burada gerek yok.
- Çok adımlı işlemleri tek `with` bloğunda topla.

## Şema ve migration

- Şu an tek tablo: `notes (id INTEGER PRIMARY KEY, title TEXT, body TEXT)`.
- Yeni kolon eklemek istiyorsan bir migration aracı eklemek gerekir. Tercih: Alembic. Karar bu dokümana yazılır.
- `CREATE TABLE IF NOT EXISTS` deyimi development için kabul edilebilir; production'da migration aracı zorunlu olur.

## Index'ler

- Şu an index yok. `notes` tablosu küçükken yeterli.
- `title` üzerinde search eklenirse FTS5 sanal tablo veya basit bir index düşünülür; karar performans ölçümü sonrası yazılır.

## Backup

- Production'da SQLite dosyası periyodik olarak kopyalanır. Detay deployment dokümantasyonunda olur; bu repoda henüz deployment dokümanı yok.

## Bu dosyanın kapsamı

Persistence katmanı. Şu konular **bu dosyada değil**:

- Endpoint stili → `api-patterns.md`
- Auth → `security.md`
