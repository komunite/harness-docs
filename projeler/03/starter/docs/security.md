# Guvenlik Kurallari

## Auth

- Tum endpoint'ler Bearer token zorunlu. `API_TOKEN` env degiskeniyle ayarlanir.
- Token kontrolu `auth()` icindedir; bypass yolu eklenemez.
- 401 cevabi sabittir: govdesi `{"detail": "missing or invalid token"}`. Bu bicimi degistirme.

## SQL injection

- Kullanici girdisi DOGRUDAN SQL string'ine konamaz.
- Tum sorgular parametrize edilmek zorunda (`?` placeholder).
- LIKE sorgularinda da kural ayni: pattern, parametre olarak gecirilir.
- Ornek: `c.execute("SELECT ... WHERE title LIKE ?", (f"%{q}%",))`

## Girdi dogrulamasi

- Pydantic modeli ile dogrula. Ham `dict` parametre alma.
- Bos string parametre, anlamli durumda 400 ile reddedilir; sessizce "tum kayitlar" donme.

## Sirlar

- Token, DB yolu vb. env degiskeninden. Hard-code etme.
- Test fixture'lari `tmp_path` kullanir; gercek DB'ye dokunma.
