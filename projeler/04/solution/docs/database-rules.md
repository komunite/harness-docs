# Veritabani Kurallari

## Baglanti

- SQLite. Yol `DB_PATH` ortam degiskeninden okunur; varsayilan `notes.db`.
- Her istek icin yeni baglanti acilir; `with conn() as c:` blogu ile kapatilir.
- `CREATE TABLE IF NOT EXISTS` her baglanti acilisinda guvenli sekilde calistirilir.

## Sorgu yazimi

- Parametreli sorgu zorunludur. `?` placeholder kullanilir.
- Asla string interpolation ile sorgu olusturma (f-string, `%`, `+`).
- `LIKE` aramalarinda bile parametre olarak gecirilir; `(f"%{q}%",)` argumantli formatta.

## Migration

- Bu projede formal migration aract yok. Kolon eklenecekse `CREATE TABLE` deyimi guncellenir ve **temiz** veritabanina karsi test edilir.
- Veri kaybi riski olan degisikliklerde `DECISIONS.md`'ye not dusulur.

## Test ortami

- Testler her zaman `tempfile.NamedTemporaryFile` ile izole veritabani uretir.
- `app` modulu `importlib.reload` ile yeniden yuklenir; modul-duzeyi durum sizmasi onlenir.
