# Testing

Birim testler `fastapi.testclient.TestClient` uzerinden kosar. Canli
sunucu gerekmez.

## Kosum

```
make test
```

## Kapsam

- Auth (401)
- Create + get (happy path)
- List
- Search (happy path)
- Update (happy path)
- Delete (happy path)

## Eksiklik (bilerek)

Sinir hatalari (ornegin "PUT olmayan nid'e 404 doner mi?") bu suit'te
**yoktur**. Executor kendi yazdigi koda kendi yazdigi testle bakar; sinir
durumunu yazmadigi icin ona dair test de yazmaz. Solution'da uctan uca
test bu boslugu kapatir.
