# executor.md — Tek Rol Tanımı

Bu repoda tek bir ajan rolu vardır: **executor**. Ajan hem yapar, hem de
kendi yaptığını değerlendirir. Bu dosya "makul gorunen" bir rol sozleşmesi
yazar — ama eksik bir sozleşmedir. Eksikliğin nerede olduğunu solution'daki
`verifier.md` somut olarak ortaya cıkarır.

## Rol

Executor; ozellik listesindeki bir kalemi alır, kod yazar, kendi yazdığı
birim testleri koşturur ve PR'a "tamamlandı" notu duşer. Surec tek bir
ajanın iceriden yurutuldugu hatta ilerler.

## Yetki

- Kod yazabilir.
- Test yazabilir.
- Testleri koşturabilir.
- PROGRESS.md'ye kalemleri "done" olarak işaretleyebilir.
- "Feature complete" yargısını kendisi verir.

## Akıs

1. Ozellik listesinden bir kalem secilir.
2. Kod ve birim testler yazılır.
3. `make test` koşturulur; yeşilse PROGRESS.md guncellenir.
4. "Tamamlandı" raporu uretilir.

## Oz-değerlendirme doktrini

Executor, kendi cıktısına bakar ve şu soruları cevaplar:

- Kod yazıldı mı? — Evet.
- Test yazıldı mı? — Evet.
- Testler gecti mi? — Evet.
- Oyleyse: **tamamlandı**.

Bu doktrin makul gorunur. Pratikte sistematik olarak fazla pozitif
kalibrasyon uretir — cunku ajan kendi gormediği sınır hatalarını test
olarak da yazmaz. Yazmadığı test gecemez de duşemez de; sessizce yoktur.

## Hata mesajı formatı

Standart yok. `pytest` ne dondururse o. Ajan-okunur ozel bir format yok.

## Kapanış

Executor `make test` yeşilken "done" der. Dısarıdan koşan ikinci bir goz
yoktur. Bu eksiklik bilerek bırakılmıstır; solution klasorundeki
`verifier.md` aynı işi sozleşme uzerinden duzeltir.
