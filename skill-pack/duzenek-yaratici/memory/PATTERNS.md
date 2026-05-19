# PATTERNS — Bellek (memory) örüntüleri

Ajanın çalışma zamanı belleği ile reponun kalıcı belleği arasındaki sınırı sözleşmeye bağlayan örüntüler. Süreklilik kaybını ve gerekçe kaybını yapısal olarak engeller.

## Bellek sınırı: repo vs runtime

İki ayrı bellek katmanı var; karıştırılırsa süreklilik kaybeder.

### Runtime belleği (ajan oturumu içi)

- Conversation buffer (Claude / Codex / Cursor)
- Aktif tool çağrı zinciri ve geçici state
- Compaction sırasında özetlenen önceki turlar
- O an açık dosya içerikleri

Sınırı: oturum kapanınca kaybolur. Hatta uzun bir oturum içinde **compaction** sırasında özetlenir; "ne yapıldı" çoğunlukla korunur, "neden yapıldı" ve hassas bağlam çoğunlukla erir.

### Repo belleği (kalıcı, git izli)

- `AGENTS.md` — talimat
- `PROGRESS.md` — vardiya defteri
- `DECISIONS.md` — gerekçe günlüğü
- `features.json` — özellik durum makinesi
- `Quality.md` — modül sağlık tablosu
- `docs/*.md` — konu dokümanları
- `artifacts/*.log` — verifier kanıtı

Sınırı: git ile versiyonlanır, klonlanabilir, başka bir ajan tarafından okunabilir.

### Kural

Runtime'da hatırlanması gereken her şey **bir an önce** repoya iner. "Akılda tut, sonra yazarım" kontratı kırar; ya o anda yaz ya da bağlamı kaybetmeyi kabul et.

Pratik karşılığı: bir karar verildiğinde DECISIONS.md anında açılır; bir engel keşfedildiğinde PROGRESS.md "Bilinen sorunlar" listesine anında yazılır.

## Compaction kaybı: neden DECISIONS.md zorunlu

Compaction süreci özet üretir; özet uzun girdileri sıkıştırır. Özet "ne"yi tutarken "neden"i sistematik olarak kaybeder çünkü gerekçe genelde dağınık birden çok turda biriken bilgidir.

Tipik kayıp senaryosu:

1. Tur 3'te ajan "bcrypt yerine Argon2id kullanalım" der; gerekçe "memory-hard, GPU saldırılarına dayanıklı".
2. Tur 12'de compaction tetiklenir; özet "Argon2id seçildi" satırına iner. "Neden" satırı atlanır.
3. Tur 28'de başka bir tartışma açılır: "bcrypt daha yaygın, neden Argon2id?" Ajan gerekçeyi bulamaz; alternatifi savunamadan kararı zayıf kılar.

`DECISIONS.md` bu kaybın sigortası. Karar verildiği anda yazılır; "neden + reddedilen alternatif + kısıt" üç bilgi mecburi. Gelecek bir oturum compaction'dan etkilenmez; dosyaya bakar, gerekçeyi okur.

### Yazma anı testi

Bir karar bağlayıcı mı? Üç soruyu cevapla:

- Bu seçim ileride değişirse maliyet üretir mi? (Evet → karar.)
- Bir alternatifi açıkça reddediyor mu? (Evet → karar.)
- Bu kararı bir hafta sonra hatırlamamak risk üretir mi? (Evet → karar.)

Üçü "evet" ise DECISIONS.md açılır; girinti formatına uyulur; oturum kapanmadan commit'lenir.

## Handoff protokolü

Vardiya teslim ve devralma için kesin sıralı dosya okuma/yazma şeması.

### Clock-in (vardiya alımı)

Sırasıyla, atlama yapmadan:

1. `cat README.md` — projenin tek cümlelik tanımı taze hafızaya gelir.
2. `cat AGENTS.md` — router'dan sıkı kısıtlar ve DoD bloğu.
3. `cat PROGRESS.md` — son durum, sıradaki üç adım.
4. `tail -80 DECISIONS.md` — son birkaç karar; gerekçeli reddedilenler.
5. `cat features.json | python -m json.tool` — durum dağılımı.
6. `cat Quality.md` — en düşük puanlı modül = bugünün hedefi.
7. `make check` — yeşili kanıtla; dünün yeşili bugün hâlâ yeşil mi?

Yedi adım tamamlanmadan kod yazma. Hızlı görünür ama atlama uzun vadede çok pahalı.

### Clock-out (vardiya tesliminde)

Tersi sırayla, hepsi tamamlandıktan sonra commit:

1. `make check` yeşil — değilse düzelt veya `git restore .`.
2. `bash scripts/session_close.sh` — beş boyut yeşil.
3. `PROGRESS.md` güncelle — bugünün tarihi, son commit, sıradaki üç adım, açık sorular.
4. `DECISIONS.md` — yeni karar varsa giriş ekle.
5. `features.json` — durum güncelle; passing'e geçen, blocked olan, yeni eklenen.
6. `Quality.md` — bant değiştiyse not düş; "← Önce buraya gir" işareti taşınabilir.
7. `git add ... && git commit -m "shift: <ozet>"` — commit mesajı tek mantıksal değişim.

Pre-push hook `session_close.sh` çağırır; beş boyut yeşil değilse push reddedilir.

## Pause-resume: 12-Factor faktör 5/6 eşlemesi

12-Factor Agents'ın iki faktörü doğrudan bu örüntüye eşlenir.

### Faktör 5 — unified execution + business state

Faktörün isteği: "execution state ile business state'i tek olay akışında birleştir." Pratik karşılık: durum tek bir kaynaktan serileştirilebilir olmalı.

Bu pakette durum üç dosyadan ibaret: `PROGRESS.md` + `DECISIONS.md` + `features.json`. Üçü birlikte oturumun anlık durumunu eksiksiz tarif eder. Bir oturum bu üç dosyayı okuyup kaldığı yerden devam edebilir; başka bir ajan da aynı üç dosyayı okuyup aynı yere düşebilir.

Karışık state — bir kısmı dosyada bir kısmı kafa içinde — pause-resume'u kırar.

### Faktör 6 — launch/pause/resume basit API'larla

Faktör 5'in üstüne biner. Eğer durum dosyada serileşmişse, "pause" basit bir commit'tir; "resume" `cat` üç dosyadır; "launch" `bash init.sh`'tir.

Pratik karşılık:

- **Launch**: yeni bir oturum açılır, `bash init.sh` koşturulur, repo "ajanın çalışabileceği" duruma geçer.
- **Pause**: oturum biter, `bash scripts/session_close.sh` koşturulur, beş boyut yeşil, son commit atılır.
- **Resume**: yeni bir oturum açılır, clock-in protokolü işletilir, yedi adımda kaldığı yere düşer.

İki dakikada da iki haftada da aynı protokol işler. Aradaki süre önemsiz hale gelir.

## Memory ratchet kuralı

Aparat dosyaları yalnızca **şişebilir**, kasten daraltılır. Ratchet kuralı:

- AGENTS.md satır sayısı yalnız düşebilir; her commit sonrası kontrol edilir.
- DECISIONS.md girişleri eklenir, silinmez; iptal edilen kararlar "iptal edildi" notuyla kalır.
- features.json'da `passing` durumu geri alınamaz; geri alınması gerekirse özellik baştan yanlış kesilmiştir, kaldırılıp yeniden tanımlanır.
- PROGRESS.md her vardiyada baştan yazılır; ama git geçmişi tüm versiyonları taşır.

Bu kural compaction'ın tersini garanti eder: kalıcı bellek zamanla derinleşir, sığlaşmaz.

## Hızlı referans

| Soru | Cevap | Dosya |
| --- | --- | --- |
| "Şu an ne yapıyorum?" | Vardiya defteri | `PROGRESS.md` |
| "Bu kararı neden verdim?" | Gerekçe günlüğü | `DECISIONS.md` |
| "Hangi özelliği bitirmem gerek?" | Durum makinesi | `features.json` |
| "Sıkı kısıtlar neler?" | Router | `AGENTS.md` |
| "Nereden başlamalıyım?" | Kalite tablosu | `Quality.md` |
| "Tamamlandı saymak için ne gerek?" | DoD | `verifier.md` + `AGENTS.md` |
