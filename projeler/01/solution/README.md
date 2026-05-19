# Solution — Kural Öncelikli (Minimum Düzenek)

Aynı görev, aynı `task.md`. Tek fark: bu klasör artık bir düzeneğe (harness) sahip. Repoda `AGENTS.md` (talimat router'ı), `Makefile` (yürütme ortamı), `pyproject.toml` (sürüm sözleşmesi) ve `tests/test_smoke.py` (geri bildirim aparatı) yaşıyor. Görev şartnamesi belirsiz kalsa bile, "tamamlandı"nın ne demek olduğunu artık kod söylüyor: `make check` yeşilse iş bitmiştir.

Reproduksiyon iki komuta indi: `make setup && make check`. Dört kanonik hedef — `setup`, `dev`, `test`, `check` — [Ders 02](../../../dersler/02-duzenek-gercekte-nedir)'de tarif edilen düzeneğin beş aparatından üçünü (ortam, geri bildirim, talimat) tek dosyada somutlaştırır. `app.py` baseline'ı korunur; ekleme bir prompt değişikliği değil, **repo düzeyinde bir sözleşmedir.**

Bu klasörün starter ile diff'i, müfredatın tezini görsel olarak ispatlar: model sabit, prompt sabit, çıktı kategorik olarak farklı. Aradaki tek değişken düzenektır. Aynı diff'i okuyup hangi aparatın hangi başarısızlığı kapattığını işaretlemek bu projenin öğrenme egzersizidir.
