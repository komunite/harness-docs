"""Uctan uca akis testleri.

Bu suit, birim testlerin gormedigi sinir davranisini yakalar. En kritik
satir test_put_missing_id_returns_404: starter'daki PUT defekti tam burada
gorulur. Executor kendi koduna kendi happy-path testi yazdiginda bu
durumu uretmez; verifier'in dis gozune ihtiyac vardir.
"""

import os, tempfile, importlib
from fastapi.testclient import TestClient


def _fresh_client():
    tmp = tempfile.NamedTemporaryFile(suffix=".db", delete=False)
    tmp.close()
    os.environ["DB_PATH"] = tmp.name
    os.environ["API_TOKEN"] = "e2e-token"
    import app as app_module
    importlib.reload(app_module)
    return TestClient(app_module.app), tmp.name


H = {"Authorization": "Bearer e2e-token"}


def test_full_crud_flow():
    """create -> get -> list -> update -> get -> delete -> get."""
    client, _ = _fresh_client()

    # create
    r = client.post("/notes", json={"title": "draft", "body": "v1"}, headers=H)
    assert r.status_code == 201
    nid = r.json()["id"]

    # get
    g = client.get(f"/notes/{nid}", headers=H)
    assert g.status_code == 200
    assert g.json()["body"] == "v1"

    # list
    lst = client.get("/notes", headers=H)
    assert lst.status_code == 200
    assert len(lst.json()) == 1

    # update existing
    u = client.put(f"/notes/{nid}", json={"title": "final", "body": "v2"}, headers=H)
    assert u.status_code == 200
    assert u.json()["title"] == "final"

    # get -- guncellenmis veri
    g2 = client.get(f"/notes/{nid}", headers=H)
    assert g2.status_code == 200
    assert g2.json()["body"] == "v2"

    # delete
    d = client.delete(f"/notes/{nid}", headers=H)
    assert d.status_code == 204

    # silindigini dogrula
    g3 = client.get(f"/notes/{nid}", headers=H)
    assert g3.status_code == 404


def test_put_missing_id_returns_404():
    """Starter'daki defektin yakalandigi yer.

    PUT /notes/<id> olmayan bir kayit uzerinde 404 donmeli. Starter'da bu
    kontrol yoktu ve endpoint 200 + bos Note doneriyor; birim testler
    happy-path olduklari icin bu durumu gormezdi.
    """
    client, _ = _fresh_client()
    r = client.put("/notes/99999", json={"title": "ghost", "body": "ghost"}, headers=H)
    assert r.status_code == 404, (
        f"PUT olmayan id 404 donmeli; gozlenen {r.status_code}. "
        "app.py::update_note icinde cur.rowcount kontrolu eksik olabilir."
    )


def test_delete_missing_id_returns_404():
    client, _ = _fresh_client()
    r = client.delete("/notes/99999", headers=H)
    assert r.status_code == 404


def test_search_then_update_then_search():
    client, _ = _fresh_client()
    client.post("/notes", json={"title": "tag-a", "body": "x"}, headers=H)
    r = client.post("/notes", json={"title": "tag-b", "body": "x"}, headers=H)
    nid = r.json()["id"]

    # arama once tag-b'yi gormeli
    s1 = client.get("/notes/search", params={"q": "tag-b"}, headers=H)
    assert s1.status_code == 200
    assert len(s1.json()) == 1

    # guncelle ve baligi degistir
    client.put(f"/notes/{nid}", json={"title": "renamed", "body": "x"}, headers=H)

    # eski isim artik bulunmamali
    s2 = client.get("/notes/search", params={"q": "tag-b"}, headers=H)
    assert s2.status_code == 200
    assert s2.json() == []
