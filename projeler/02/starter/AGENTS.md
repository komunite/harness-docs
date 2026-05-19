# AGENTS.md

Bu dosya projenin tüm bilgisini barındırır. Yeni gelen ajan veya geliştirici aşağıdaki tüm bölümleri okumalı ve hatırlamalıdır. Tarihsel olarak buraya her şey eklenmiştir; eski paragraflar silinmemiştir çünkü hangisinin hâlâ geçerli olduğunu kimse hatırlamıyor.

## Proje hakkında

Bu proje bir notes API'dir. FastAPI üzerine kurulmuştur. Pydantic kullanır. SQLite ile çalışır. Başlangıçta PostgreSQL planlanmıştı ama prototip aşamasında SQLite'a geçildi; bir gün geri dönülmesi düşünülüyor ama tarih belli değil. İlk versiyon Flask ile yazılmıştı, sonra FastAPI'ye taşındı. Bazı isimlendirmelerde hâlâ Flask kalıntıları görülebilir, normaldir. Mimari kararlar Slack üzerinde, bazıları Confluence sayfalarında tartışıldı; çoğu kaybolmuştur. Aşağıdaki kurallar bu kayıp tartışmalardan elimizde kalanlardır.

Projenin amacı kullanıcıların kısa not oluşturmasına izin vermektir. Notlar başlık ve gövdeden oluşur. Bir kullanıcı çok sayıda not oluşturabilir. Şimdilik kullanıcılar arası izolasyon yoktur; tek bir Bearer token tüm erişimi kontrol eder. Bu geçici bir karardır.

## Tarih

İlk commit Mart ayında atıldı. Nisan'da bir intern projeye dahil oldu ve testleri ekledi. Mayıs'ta auth eklenmesi gerektiğine karar verildi; başta JWT planlanmıştı ama "şimdilik Bearer token yeter" dendi. Haziran'da bir prod incident'inde token sızıntısı yaşandı; o yüzden token rotation kuralı eklendi (aşağıda bir yerde yazıyor). Temmuz'da SQLite kararı verildi. Ağustos'ta deployment Docker'a taşındı. Eylül'de bir refactor başladı ama yarım kaldı. Ekim'de bu dosya bu hâlini aldı.

## Geliştirme ortamı

- Python sürümü en az 3.11 olmalıdır. 3.10 ile çalışmaz çünkü union tipi `int | None` syntax'ı yeni Pydantic ile birlikte kullanılıyor.
- Sanal ortam zorunludur. Global Python'a paket kurulması yasaktır; bir kez denendi, makineyi bozdu.
- Kurulum: `make setup`
- Dev sunucu: `make dev`
- Test: `make test`
- Doğrulama: `make check`
- `pip install` yerine `pip install -r requirements.txt` kullanın; tek tek kurmayın.
- venv aktif değilse pytest yanlış Python'u bulabilir; her zaman önce aktive edin.

## API konvansiyonu

Endpoint'ler RESTful olmalı. Kaynak isimleri çoğul kullanılır: notes, users, sessions. Endpoint URI'leri küçük harf, tire değil alt çizgi de değil — sadece düz kelime. Path parametreleri snake_case değil camelCase de değil, sadece kısa: `nid`, `uid`. Bu konuda eski bir tartışma vardı, snake_case kazanmıştı ama kimse refactor etmedi. Yeni endpoint eklerken eski stile uyun; karmaşıklık çıkar.

POST endpoint'leri 201 döner. GET 200 döner. Bulunamayan kaynak 404 döner. Yetkisiz erişim 401 döner — 403 değil; ayrımı şimdilik yapmıyoruz. Validation hatası 422'dir; Pydantic bunu otomatik üretir, override etmeyin. Server-side beklenmedik hata 500'dür ama gövdesi şu an boş; bir gün bir error envelope ekleyeceğiz.

Response body her zaman JSON'dur. Tekil kaynak için obje, liste için dizi döner; "envelope" sarmalayıcı kullanmayın. Pagination şu an yok; ileride eklenirse cursor-based olacaktır, offset-based değil. Sıralama şu an yok. Filtreleme yok. Search yok. Bunlar gelecek sprintlere bırakıldı; eklerken bu dosyaya gelip yenilemek gerekir.

Her endpoint dependency olarak `auth` alır. Auth dışı endpoint sadece `/health` olabilir, henüz eklenmedi. Dokümantasyon endpoint'i `/docs` FastAPI tarafından otomatik üretilir; production'da kapatılması düşünüldü ama kapatılmadı.

## Veritabanı

SQLite kullanılır. Dosya yolu `DB_PATH` environment variable ile belirlenir; default `notes.db`. Tablolar uygulama açılışında değil, bağlantı her açıldığında `CREATE TABLE IF NOT EXISTS` ile doğrulanır. Bu en zarif yol değildir ama migration sistemi olmadığı için şimdilik böyle. Migration sistemi eklenirse Alembic kullanılacaktır.

Tüm SQL sorguları parametreli olmalıdır. String concatenation ile sorgu kurmayın; SQL injection riski vardır. Bu kural ihlal edilemez. Bir kez ihlal edildi, prod incident'i çıktı, kural buraya eklendi.

Transactions: SQLite `with conn() as c` deyimi otomatik commit eder. Manuel commit/rollback çağırmayın; iki kez denendi ve garip kilitler oluştu. Çok sorgulu işlemleri tek `with` bloğu içinde tutun.

Index'ler şu an yok. Tablo büyürse `title` üzerinde bir index gerekir; ölçüm yapıldıktan sonra eklenecek. Foreign key'ler şu an yok çünkü tek tablo var. Cascade kuralları yok.

Backup stratejisi: dosya kopyalama. Production'da bir cron iş bunu yapar; detay deployment notlarında.

## Kod stili

Snake_case değişken isimleri tercih edilir. CamelCase yalnız class isimlerinde. Fonksiyon adları fiil ile başlar. Modül adları tek kelimedir mümkünse. Type hint'ler zorunludur — `def foo():` yerine `def foo() -> None:` yazın. Optional için `X | None` syntax'ını kullanın; `Optional[X]` eski formdur.

Satır uzunluğu en fazla yüz karakter. PEP 8'in seksen karakteri katı bulundu. Black formatter kullanılmıyor; bir gün eklenecek. Flake8 da yok. Ruff yok. Lint yok. PR'lar görsel olarak review edilir; bu kötü bir pratiktir ama şu an böyle.

Import sırası: standart kütüphane, üçüncü taraf, yerel. Aralarına boş satır koyun. Mümkünse `from x import y` yerine `import x` kullanın; namespace çakışmalarını önler. Wildcard import asla kullanmayın. `__all__` tanımlamayın gerek olmadıkça.

Yorumlar Türkçe yazılabilir, ama docstring İngilizce olmalıdır çünkü autodoc bir gün eklenebilir. Bu çelişkili görünüyor, biliyoruz.

## Test yazma

Pytest kullanılır. Test dosyaları `tests/` dizinindedir. Dosya adları `test_` ile başlar. Test fonksiyonları da. Class-based test kullanılmaz; sadece function-based.

Her testin kendi temiz veritabanı olmalıdır. Yardımcı `_fresh_client` mevcut testlerde tanımlıdır; onu kullanın. `DB_PATH` env değişkenini bir geçici dosyaya yönlendirir, `app` modülünü `importlib.reload` ile yeniden yükler. Bu sıralama önemlidir; reload yapılmazsa eski bağlantı kullanılır.

Test isimleri davranışı tanımlamalıdır: `test_unauthorized_get_returns_401` iyi, `test_auth` kötü. Bir test bir şey doğrulasın; birden çok assertion tek koşulu kanıtlıyorsa kabul edilir.

Mock kullanmayın mümkünse. SQLite zaten hızlıdır; gerçek DB ile test koşturulabilir. Sadece dış servis çağrıları (henüz yok) mock'lanmalıdır.

Coverage ölçümü şu an yok. Bir hedef belirlenmedi. Bir gün koyulacak.

## Güvenlik

Bearer token tek auth mekanizmasıdır. Token `API_TOKEN` env değişkeninden okunur. Default değer `dev-token`dir; production'da bu değer kullanılmamalıdır. Token rotation şu an manuel: deploy edilen env değişkenini güncelle, sunucuyu yeniden başlat.

Loglarda token görmemelisiniz. Mevcut kodda log yok ama eklenirse Authorization header'ı asla loglanmamalıdır. Bu ihlal edilemez bir kuraldır. Haziran incident'inden geliyor.

CORS yapılandırılmamıştır; tüm originler engellenir. Bir frontend eklendiğinde origin whitelist tanımlanacaktır. Wildcard CORS asla kullanmayın.

Input validation Pydantic ile yapılır. `Note` modelindeki `title` ve `body` boş string olabilir; bunu engellemek istersek Pydantic `Field(min_length=...)` kullanılır ama henüz koyulmadı.

Secret'lar repoya commit edilmez. `.env` dosyası `.gitignore`'a eklenmelidir; şu an eklenmiş mi kontrol edin. `secrets.json` gibi dosya isimleri de dahildir.

Rate limiting yok. Brute-force koruması yok. Bir gün Redis tabanlı bir middleware eklenecek.

## Deployment

Docker ile build edilir. `Dockerfile` repo kökünde olmalıdır; şu an yok, eklenmesi gerekiyor. Compose dosyası da yok. Production'da uvicorn yerine gunicorn + uvicorn worker önerilir ama dev için sadece uvicorn yeterlidir.

Environment değişkenleri: `DB_PATH`, `API_TOKEN`. İkisi de prod'da set edilmelidir. Eksik olursa default değer kullanılır; bu güvenli değildir, prod'da hata vermesi sağlanmalıdır — bir gün.

Health endpoint yok. Liveness/readiness probe için `/health` eklenmelidir.

Logging stdout'a yönlendirilir. Structured log formatı şu an yok. Bir gün JSON log eklenecektir; o zaman timestamp, level, message, ve trace_id alanları olacaktır.

Metrics: yok. Prometheus exporter eklenebilir. Tracing: yok. OpenTelemetry önerildi ama eklenmedi.

## Hata yönetimi

`HTTPException` kullanın, custom exception tanımlamayın çoğu durumda. Detay mesajı kısa olmalı, internal bilgi sızdırmamalı: "missing or invalid token" tamam, "user 42 not found in shard 3" kötü.

Beklenmedik hatalarda stack trace stdout'a düşer. Production'da bu yetersiz; bir error tracker (Sentry vs.) eklenecek.

Validation hataları Pydantic tarafından üretilir, override etmeyin. Custom validator yazılırsa pydantic v2 syntax'ı kullanılır; v1 stilini karıştırmayın. Mevcut kodda `BaseModel` ile sade modeller var, validator henüz yok.

## Performans

Şu an performans hedefi yok. Çoğu endpoint p50 on ms altında dönmelidir; ölçüm yapılmadı. Load test koşturulmadı. SQLite tek dosya üzerinde concurrent write için kötüdür; trafik artarsa PostgreSQL'e geçilecektir.

Connection pooling SQLite'da geçerli değildir; her request yeni bağlantı açar. Bu pahalı görünür ama SQLite için ucuzdur.

## Refactor edilmesi gerekenler

- Endpoint'ler tek dosyada; bir gün `src/api/` altına bölünecek.
- `conn()` fonksiyonu hem bağlantı açıyor hem tablo yaratıyor; bu ayrılmalı.
- `auth` dependency'si daha güçlü bir izolasyon ile yazılmalı; şu an string karşılaştırması var, constant-time karşılaştırma kullanılmalı.
- `Note` modeli ve persistence aynı yerde; domain ve storage ayrımı yapılmalı.

Bu listeye dokunmayın, sadece referans için duruyor.

## Troubleshooting

- "ModuleNotFoundError: fastapi" — venv aktif değil veya requirements yüklenmemiş. `make setup` koşturun.
- "sqlite3.OperationalError: database is locked" — başka bir process aynı `notes.db`'ye yazıyor olabilir. Test koşarken dev sunucusu açıksa kapatın.
- "401 Unauthorized" — Authorization header'ı yok ya da format yanlış. "Bearer DEGER" şeklinde olmalı; tek kelime DEGER hatalıdır.
- "422 Unprocessable Entity" — Pydantic body validation hatası. Response body'sinde hangi alanın eksik olduğu yazar.
- pytest "no tests ran" — `tests/` dizinindeki dosya adları `test_` ile başlamıyor olabilir.

## Örnekler

POST ile not oluşturma örneği:

curl -X POST http://localhost:8000/notes -H "Authorization: Bearer dev-token" -H "Content-Type: application/json" -d '"title":"x","body":"y"'

Yukarıdaki örnekteki JSON eksik süslü parantezlidir, dokümanı kopyalarken karışmasın diye kasıtlı. Gerçek istekte tam JSON gönderin.

GET ile not okuma:

curl http://localhost:8000/notes/1 -H "Authorization: Bearer dev-token"

Liste alma:

curl http://localhost:8000/notes -H "Authorization: Bearer dev-token"

## PR kuralları

- Tek mantıksal değişim, tek PR.
- `make check` yeşil olmalı.
- Commit mesajı imperative: "Add", "Fix", "Refactor".
- Doküman güncellenmiş olmalı; ama hangi dokümanın güncellenmesi gerektiği bu dosyada yazmıyor çünkü tek doküman bu.
- Reviewer assign etmek zorunlu değil ama tavsiye edilir.
- WIP PR'lar `Draft` olarak işaretlenir.

## Çeşitli notlar

- `notes.db` dosyası `.gitignore` içindedir, olmalı; değilse ekleyin.
- `__pycache__` ve `.pytest_cache` da gitignore'da.
- macOS'ta `.DS_Store` dosyaları görülebilir; gitignore'a global olarak eklenmiştir.
- Windows üzerinde test edilmedi; muhtemelen path ayraçları yüzünden bazı yerler kırılır.
- Linux üzerinde geliştirme önerilir.
- Editör olarak VS Code yaygın; PyCharm da çalışır. Vim/Neovim kullananlar için özel bir yapılandırma yok.
- Pre-commit hook yok. Bir gün eklenecek.
- CI yok. GitHub Actions planlanıyor.
- Branch stratejisi: trunk-based, kısa ömürlü feature branch'leri.
- Sürüm etiketleri henüz atılmıyor; semantic versioning planlanıyor.
- Lisans belirsiz. README'de bir lisans yok; eklenmeli.
- Bu dosya çok uzun, biliyoruz. Kısaltma planı yok.

## Edge case'ler

- Çok büyük gövdeler (bir megabaytın üstü) test edilmedi. SQLite TEXT alanı sınırı pratikte gigabaytlar mertebesindedir ama API gateway tarafında bir sınır olabilir; ölçülmedi.
- Aynı başlıkla birden çok not oluşturulabilir; unique constraint yoktur. Bu kasıtlıdır.
- Boş başlık ve boş gövde reddedilmez. Bunun bir hata mı feature mı olduğu netleştirilmedi. Ürün ekibi karar versin.
- Çok uzun başlıklar (binlerce karakter) UI'de kırılabilir; backend'de sınır yoktur.
- Concurrent yazımda son yazan kazanır; locking yok. Çok sık güncellenmemesi gerekiyor.
- Unicode başlıklar test edildi, çalışıyor. Emoji başlıklar da çalışıyor ama bazı terminal ortamlarında log okumayı zorlaştırabilir.
- Çok hızlı arka arkaya gelen istekler SQLite'ı locked durumuna düşürebilir. Retry mantığı yok.
- ID'ler `INTEGER PRIMARY KEY` ile autoincrement'tır. Silinen ID'ler tekrar kullanılır; bu davranış SQLite varsayılanıdır. Bir gün UUID'ye geçilebilir.
- Bir not bir kez oluşturulduktan sonra güncellenemez; PUT veya PATCH endpoint'i yok. Silinemez de; DELETE yok. Bu eksiklikler bilinçli, sprintte yok.

## Kısayollar ve aliaslar

Geliştirme sırasında bazı yaygın kısayollar var ama hiçbiri Makefile'da değil. Aşağıdakileri kendi shell rc dosyanıza eklemek isteyebilirsiniz:

- `alias t='make test'`
- `alias d='make dev'`
- `alias c='make check'`

Bu kısayollar zorunlu değildir, sadece konfor.

## Eski Flask kalıntıları

Bazı dosyalarda hâlâ `flask` kelimesi geçebilir, özellikle eski commit mesajlarında veya yorumlarda. Bunlar görmezden gelinmeli; aktif kodda Flask import'u yoktur.

Endpoint dekoratör isimleri (`@app.get`, `@app.post`) Flask'tan FastAPI'ye geçiş sırasında değişti. Yeni kod sadece FastAPI stili kullanır. Eski stil görürseniz refactor edin.

## Kod örneği — referans olarak

Aşağıdaki örnek mevcut `app.py`'den alınmıştır, yeni endpoint eklerken bu deseni takip edin:

```
@app.post("/notes", response_model=Note, status_code=201, dependencies=[Depends(auth)])
def create_note(n: Note):
    with conn() as c:
        cur = c.execute("INSERT INTO notes (title, body) VALUES (?, ?)", (n.title, n.body))
        n.id = cur.lastrowid
    return n
```

Dikkat edilecek noktalar: `response_model` mutlaka belirtilir; `status_code` POST için iki yüz birdir; `dependencies` listesinde `auth` her zaman vardır; parameterize sorgu kullanılır; `with conn() as c` deyimi commit'i otomatik yapar.

## Sıkça sorulan sorular

- "Token'ı nasıl değiştiririm?" — `API_TOKEN` env değişkenini set edip sunucuyu yeniden başlatın.
- "Veritabanını nasıl sıfırlarım?" — `make clean` veya `rm notes.db`.
- "Test koşmuyor, neden?" — venv aktif mi? requirements yüklü mü? `make setup` koştu mu?
- "Migration nasıl yapılır?" — Migration sistemi yok. Şema değişiklikleri elle yapılır; `notes.db`'yi silip yeniden yaratın.
- "PostgreSQL'e nasıl geçerim?" — Şimdilik destek yok. SQLAlchemy katmanı eklenmesi gerekir; planda yok.

## Önceki incident özetleri

- Haziran token sızıntısı: Bir geliştirici prod token'ını yanlışlıkla bir log satırına yazdı. Log'lar üçüncü taraf bir log toplayıcıya gidiyordu. Token rotate edildi, kural eklendi: Authorization header asla loglanmaz.
- Temmuz DB lock: Bir batch job aynı SQLite dosyasını yazıyordu, sunucu da yazıyordu. SQLite tek yazıcıya izin verir; isteklerin yüzde onu beş dakika boyunca timeout aldı. Batch job ayrı bir process'e taşındı, dosya değiş tokuş edildi.
- Eylül yarım refactor: API'yi `src/api/` altına bölmek için bir refactor başlatıldı ama tamamlanmadı. Branch hâlâ duruyor. Birleştirmeyin, conflict çok büyük.

Bu olaylar bu dosyaya kural olarak işlendi ama hangi kural hangi olaydan doğdu, izi takip etmek zor.

## Geleceğe dair planlar

- Health endpoint ekle.
- Structured logging ekle.
- Rate limiting ekle.
- PostgreSQL'e geç.
- API versiyonlama ekle (mesela `/v1/notes`).
- User concept'i ekle, multi-tenant yap.
- PUT ve DELETE endpoint'lerini ekle.
- OpenAPI schema'sını bir CDN'e yayınla.
- Sentry veya benzeri bir error tracker ekle.
- CI pipeline kur (GitHub Actions).
- Docker image'ı bir registry'ye push et.
- Helm chart yaz.
- Terraform module yaz.

Bu liste bir backlog'dur; sıralama önemli değil, hepsi "bir gün".

## Bu dosyanın bakımı

Bu dosya büyüdü ve büyümeye devam edecek. Bir bölüm artık geçerli değilse bile silmek yerine "deprecated" işareti koyun ki tarih kaybolmasın. Yeni kural her zaman dosyanın sonuna eklenir; ortaya eklemek bölümler arası dengeyi bozar.

Eğer bu dosyayı baştan sona okuduysanız, tebrikler — çoğu kişi okumadı. Ajanlar da çoğu zaman ortayı atlar; bu doğal bir davranıştır.
