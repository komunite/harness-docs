# Güvenlik Politikası

## Desteklenen sürümler

| Sürüm | Destek |
| --- | --- |
| 1.0.x | ✅ Aktif |

Çalışan production sitesi yalnız `main` dalından deploy edilir.
Eski tag'lerin güvenlik güncellemesi yapılmaz.

## Açık bildirme

Bir güvenlik açığı bulduysan **kamuya açık issue açma**. Şu kanallardan
gizli ulaş:

- **E-posta**: `security@lokomotif.ai`
- **GitHub Security Advisory**: [Yeni özel rapor](https://github.com/komunite/harness-docs/security/advisories/new)
- **PGP** (isteğe bağlı): anahtar `https://lokomotif.ai/.well-known/pgp.txt`

Raporunda en azından şunlar olsun:

- Etkilenen dosya/path/komponent
- Yeniden üretme adımları (ya da PoC)
- Etki tahmini (örn. XSS, CSRF, gizli sızıntısı, supply-chain)
- (İstersen) düzeltme önerisi

## Yanıt süresi

| Aşama | Süre |
| --- | --- |
| İlk yanıt | 48 saat içinde |
| Etki değerlendirmesi | 7 gün içinde |
| Düzeltme PR'ı | Kritik: 14 gün; orta: 30 gün; düşük: 60 gün |
| Kamuya açıklama | Düzeltmeden sonra, koordineli |

## Kapsam

Bu repodaki:

- **MDX içeriği** — XSS, prompt injection vektörleri, iç URL atlamaları
- **`skill-pack/duzenek-yaratici/` script'leri** — shell injection,
  zincirleme command, yetersiz pipefail koruması
- **`projeler/*/solution/` kodu** — eğitim amaçlı Python örneklerinde
  güvenlik açıkları (zaten Proje 03/05'te öğretim için bilinçli
  bırakılmış olanlar hariç)
- **`vercel.json`, `docs.json`** — yapılandırma açıkları
- **`style.css`** — CSS injection / clickjacking

Kapsam dışı:

- Mintlify Cloud platformunun kendisindeki açıklar — [Mintlify
  güvenliği](https://mintlify.com/security)'ne yönlendir.
- Vercel platformundaki açıklar — Vercel HackerOne'a yönlendir.
- Üçüncü taraf kaynak URL'lerindeki içerik — orijinal sahiplerine
  yönlendir.

## Eğitim amaçlı kasıtlı kusurlar

Bazı `projeler/*/starter/` kodlarında **bilinçli güvenlik açıkları**
mevcuttur:

- `projeler/03/starter/app.py` ve `projeler/03/solution/app.py`:
  yarım kalmış search endpoint'inde SQL injection (öğretim için).
- `projeler/05/starter/app.py`: PUT endpoint'inde 404 kontrolü yok.

Bunlar **bug değil, müfredatın parçası**. Açıklama ilgili proje
README ve PROGRESS dosyalarında. Lütfen bu kasıtlı kusurları
güvenlik açığı olarak raporlama.

## Teşekkür

Yardımcı olan herkes (istediği takdirde) [SECURITY-HALL.md](SECURITY-HALL.md)'ye eklenir.
