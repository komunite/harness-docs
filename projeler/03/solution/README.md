# Solution — Cok Oturumlu Sureklilik (Vardiya Defteri Acik)

Bu klasorde kod, starter ile **birebir aynidir.** `GET /notes/search` hala yarim, SQL injection riski hala duruyor, bos `q` testi hala skip. Bu proje bug duzeltme projesi degil; **devir teslim** projesidir.

Starter ile bu klasor arasindaki fark dort dosyada yasar:

- `PROGRESS.md` — su anki durum, tamamlanmislar, devam edenler, bilinen sorunlar, sirali bir sonraki adimlar.
- `DECISIONS.md` — gerekceli karar gunlugu. Her karar icin neden, reddedilen alternatif, kisit.
- `AGENTS.md` — sona iki bolum eklendi: vardiya alimi (clock-in) ve vardiya teslimi (clock-out).
- `init.sh` — idempotent baslangic script'i. `make setup` + `make test || true` + `cat PROGRESS.md`.

## Yeni bir oturum nasil baslar

```bash
./init.sh
```

Cikti `PROGRESS.md`'yi yazdirir ve sonraki adimi soyler. Ajan oturum baslangicinda bu uc dosyayi okumak zorundadir; sohbete degil dosyaya guvenir.

## Calistirma

```bash
./init.sh             # vardiya alimi
# ...is...
# vardiya teslimi: PROGRESS.md guncelle, make check yesil, commit at
```

## Tez

Starter ile solution arasindaki diff, dersin tezini gosterir: **sureklilik sohbete degil dosya sistemine dayanir.** Iki klasorde de kod ayni, tamamlanma yuzdesi ayni, hatta hata ayni. Fark, bir sonraki oturumun **kac dakikada uretken hale geleceginde** yasar. Init artefakti olan klasorde bu sure dakikalar, olmayan klasorde onlarca dakikadir.
