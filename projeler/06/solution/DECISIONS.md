# Decisions

## D01 — SQLite varsayilan depolama

- **Karar:** Kapsam dahili oldugu surece SQLite kullan.
- **Gerekce:** Sifir bagimlilik, test ortami icin yeterli.
- **Alternatif:** Postgres — fazla erken bir karmasiklik.

## D02 — Bearer auth, tek token

- **Karar:** Env'den okunan tek token ile Bearer auth.
- **Gerekce:** Capstone scope'u; gercek auth provider kapsam disi.

## D03 — OpenTelemetry GenAI semconv

- **Karar:** Trace standardi OTel GenAI semconv olacak.
- **Gerekce:** Tasinabilirlik; AgentOps/Inspect AI gibi araclar ayni attribute'lari okur.
- **Statu:** Hala "Development". Gerekirse `OTEL_SEMCONV_STABILITY_OPT_IN` opt-in.

## D04 — ConsoleSpanExporter (capstone icin yeterli)

- **Karar:** Harici collector kurmadan stdout'a span yazdir.
- **Gerekce:** Egitim ortami; ek altyapi bagimliligi yok.
- **Alternatif:** OTLP exporter + Jaeger — ileri proje icin.

## D05 — Middleware + handler iki kademeli span

- **Karar:** HTTP middleware parent span, handler child span uretir.
- **Gerekce:** Parent span method/path/status tasir; child span ise islem semantigini (`gen_ai.operation.name`) tasir. Hata olursa hangi katmanda oldugu trace'te direkt gorunur.

## D06 — Quality Document modul basina

- **Karar:** `Quality.md` her modul icin A/B/C notu tasir; en dusuk puanli modul "onceki vardiyada buraya gir" ile isaretlenir.
- **Gerekce:** Sonraki vardiya nereden baslayacagini sezgiyle degil kanitla secer.

## D07 — Idempotent session_close.sh

- **Karar:** Oturum kapanis script'i bes boyutu (build/test/progress/artifact/startup) tek tek dogrular ve idempotenttir.
- **Gerekce:** Iki kez koshturmak hic koshturmamakla ayni veya daha guvenli olmali; script bir hata kaynagi olamaz.
