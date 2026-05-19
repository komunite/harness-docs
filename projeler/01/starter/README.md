# Starter — Yalnız Prompt (Cold Start)

Burada düzenek yok. Sadece bir prompt (`task.md`) ve neredeyse boş bir `app.py` var. `AGENTS.md` yok, `Makefile` yok, test yok, doğrulama komutu yok. Ajan görevi sıfırdan tahmin etmek zorunda: hangi Python sürümü, hangi kütüphane konvansiyonu, "tamamlandı"nın ne anlama geldiği — hiçbiri yazılı değil.

Bu klasörün amacı bilinçli olarak eksiklik göstermektir. Aynı görev burada koşturulduğunda ajanın tipik davranışı şunlardır: belirsizlikleri sohbette tekrar tekrar sormak, isteğe bağlı kararlar üretmek, kodunu çalıştırmadan teslim etmek, ve "tamam" demek için harici bir doğrulayıcı bulunmadığından erken zafer ilan etmek. Bu, [Ders 01](../../../dersler/01-yetkin-ajanlar-neden-basarisiz)'de tarif edilen doğrulama boşluğu örüntüsünün yaşayan kopyasıdır.

Aynı görevi `../solution/` altında yeniden koştur ve farkı gözle: orada `AGENTS.md` router'ı, `Makefile` doğrulama sözleşmesi ve `tests/test_smoke.py` davranış kanıtı vardır. Düzeneğin (harness) neden modelden önce sorgulanması gerektiğini bu iki klasörün diff'i somutlaştırır.
