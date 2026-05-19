# Veritabani Kurallari

Bu proje sqlite3 kullanir. Migration aracligi yok; semayi `conn()` icindeki `CREATE TABLE IF NOT EXISTS` yonetir.

## Baglanti

- `conn()` her cagrida yeni baglanti acar. `with conn() as c:` ile kapat.
- DB yolu `DB_PATH` env degiskeniyle override edilir; testler `tmp_path` kullanir.

## Sorgular

- **Parametrize edilmis sorgu zorunlu.** String interpolation ile SQL kurmak yasaktir; SQL injection riski yaratir.
- Dogru: `c.execute("SELECT ... WHERE title=?", (val,))`
- Yanlis: `c.execute(f"SELECT ... WHERE title='{val}'")`

## Sema degisikligi

- Yeni alan eklemek: `CREATE TABLE IF NOT EXISTS` satirini guncelle ve mevcut DB dosyalarini sil veya migration yaz.
- Mevcut alanin tipini degistirme; yeni tablo + kopyalama tercih edilir.

## Transaction

- `with conn() as c:` baglami commit'i otomatik yapar.
- Yazma + okumayi tek baglanti icinde yapma; her endpoint yeni baglanti acar.
