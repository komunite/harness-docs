# Security

Ne zaman oku: auth değiştirirken, secret yönetimi tartışırken, token rotation veya input validation karar verirken. Diğer endpoint mekaniği için `api-patterns.md`'ye git.

## Sıkı kısıtlar

- Authorization header asla loglanmaz. Token değeri prod log'una düşemez. Bu kural Haziran token sızıntısı incident'inden gelir.
- Secret'lar repoya commit edilmez. `.env` dosyaları `.gitignore`'a eklidir.
- Default `dev-token` değeri prod'da kullanılmaz; `API_TOKEN` env değişkeni deploy sırasında set edilir.
- Token karşılaştırması ileride constant-time olur; düz string eşitlik zayıftır. Şu anki kod basit eşitlik kullanıyor; iyileştirme listesine yazılı.

## Bearer token mekaniği

- Token `API_TOKEN` env değişkeninden okunur.
- `auth` dependency'si `Authorization` header'ı bekler; format `Bearer DEGER` şeklinde olmalıdır.
- Format yanlışsa veya değer eşleşmezse 401 döner; gövdede `missing or invalid token` mesajı bulunur. Internal detay sızdırılmaz.

## Token rotation

- Manuel: `API_TOKEN`'i deploy ortamında güncelle, sunucuyu yeniden başlat.
- Rotation sırasında downtime istenmiyorsa iki token'lı bir geçiş mekanizması eklenmelidir; şu an yok, karar tartışılmadı.
- Rotation sıklığı: prod için en az üç ayda bir önerilir.

## Logging disiplini

- Authorization header'ı asla loglanmaz. Hangi katmanda olursa olsun (FastAPI middleware, uvicorn access log, reverse proxy).
- Reverse proxy yapılandırması (nginx, traefik) Authorization header'ını access log formatından çıkarır.
- Structured logging eklendiğinde token alanları için bir redaction listesi tanımlanır.

## CORS

- Şu an CORS yapılandırılmamıştır; tüm cross-origin istekler tarayıcıda engellenir.
- Bir frontend eklendiğinde origin whitelist tanımlanır. Wildcard CORS kullanılmaz.

## Input validation

- Pydantic `BaseModel` ile yapılır; ayrıntı `api-patterns.md`'de.
- Güvenlik açısından kritik kontroller (uzunluk üst sınırı, izin verilen karakter setleri) Pydantic alanlarında `Field` ile ifade edilir.
- Validation katmanı aşıldıktan sonra hâlâ SQL parametreli kullanılır; validation tek başına SQL injection'a karşı yeterli değildir.

## Rate limiting ve brute-force

- Şu an yok. Bir gün Redis tabanlı middleware eklenir.
- Eklenince bu doküman güncellenir; rate sınırı, ban süresi, exempt endpoint'leri burada listelenir.

## Bu dosyanın kapsamı

Auth, secret, ve token disiplini. Şu konular **bu dosyada değil**:

- Endpoint status code haritası → `api-patterns.md`
- DB sorgu kuralları → `database-rules.md`
