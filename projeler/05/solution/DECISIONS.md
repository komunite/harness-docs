# DECISIONS

Mimari ve sozleşme kararları. Her madde tarih + gerekce icerir.

- 2026-05-10 — Bearer token tek auth yontemidir. Sebep: minimal yuzey.
- 2026-05-12 — Arama LIKE ile parametrize edilir; baslik **ve** govdede
  arar. Sebep: f-string SQL injection riskini ortadan kaldirmak; kullanim
  alanini iki alana acmak.
- 2026-05-15 — **Rol ayrimi.** executor (yapan) + verifier (denetleyen)
  sozleşmesi ayrıldı. Sebep: kalibrasyon yanliligi. Tek rol modelinde
  starter'daki PUT-404 defekti gozden kactı; iki rol modelinde aynı
  defekt e2e ilk koşumunda yakalandı.
- 2026-05-15 — **Uc katmanli kapi.** `scripts/three_layer_check.sh`
  lint → unit → e2e sirasini zorlar. Sebep: Ders 09'daki "atlanmaz
  seviyeler" prensibi + Ders 10'daki birim test mimari korlugu.
- 2026-05-15 — **Definition of Done bloku** AGENTS.md'ye eklendi.
  Tamamlanma yargisi verifier'a devredildi. Sebep: ajan kendi cikti
  uzerinde sistematik olarak fazla guvenli kalibrasyon uretiyor.
- 2026-05-15 — Hata mesajlari **ERROR / WHY / FIX** formatinda. Sebep:
  hata mesaji da bir prompt'tur; ajan bunu okuyup eyleme dokecek.
- 2026-05-16 — PUT /notes/{nid} rowcount==0 icin 404 doner. Sebep: e2e
  test_put_missing_id_returns_404 onceki davranisi reddetti; FIX adimi
  uygulandi.
