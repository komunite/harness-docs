# PROGRESS

Iki imzali kayit: executor "awaiting verification" yazar, verifier
"passing" veya "blocked" karari verir. Yalniz verifier satiri kalemi
tamamlar.

## Tamamlanan kalemler

- [F-001] executor=awaiting verification
- [F-001] verifier=passing — three_layer_check.sh OK
- [F-002] executor=awaiting verification
- [F-002] verifier=passing — three_layer_check.sh OK
- [F-003] executor=awaiting verification
- [F-003] verifier=passing — three_layer_check.sh OK
- [F-004] executor=awaiting verification
- [F-004] verifier=passing — three_layer_check.sh OK
- [F-005] executor=awaiting verification (PUT 404 eklendi)
- [F-005] verifier=passing — e2e test_put_missing_id_returns_404 yesil
- [F-006] executor=awaiting verification
- [F-006] verifier=passing — e2e test_delete_missing_id_returns_404 yesil

## Acik kalemler

(yok)

## Tarihce — neden iki imza?

Onceki bir oturumda starter'in PUT defekti executor kendi raporu ile
"done" damgasi yemisti. Dis goz olmadigi icin defekt uretime kadar
gizlendi. Bu klasorde rol ayrimindan sonra ayni defekt verifier'in ilk
e2e kosumunda 30 saniyede yakalandi; ERROR/WHY/FIX blogu ile geri
gonderildi, executor tek satir ekledi, ikinci kosumda passing geldi.
