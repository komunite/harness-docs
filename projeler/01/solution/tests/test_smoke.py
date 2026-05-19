# tests/test_smoke.py — düzeneğin geri bildirim aparatı.
# Bu testler "tamamlandı"nın operasyonel tanımıdır. Hepsi yeşil değilse
# görev bitmemiştir.
import os
import tempfile

import pytest
from fastapi.testclient import TestClient


@pytest.fixture()
def client(monkeypatch):
    # Her testte izole bir SQLite dosyası kullan; baseline app.py'i değiştirme.
    tmp = tempfile.NamedTemporaryFile(suffix=".db", delete=False)
    tmp.close()
    monkeypatch.setenv("DB_PATH", tmp.name)
    monkeypatch.setenv("API_TOKEN", "test-token")

    # Modülü ortam değişkenleri ayarlandıktan sonra yükle ki sabitler
    # doğru DB ve token ile başlasın.
    import importlib
    import app as app_module
    importlib.reload(app_module)

    with TestClient(app_module.app) as c:
        yield c

    os.unlink(tmp.name)


def test_missing_token_returns_401(client):
    r = client.get("/notes")
    assert r.status_code == 401


def test_post_with_valid_token_returns_201(client):
    r = client.post(
        "/notes",
        headers={"Authorization": "Bearer test-token"},
        json={"title": "ilk not", "body": "merhaba"},
    )
    assert r.status_code == 201
    data = r.json()
    assert data["id"] is not None
    assert data["title"] == "ilk not"
    assert data["body"] == "merhaba"


def test_get_by_id_returns_same_body(client):
    created = client.post(
        "/notes",
        headers={"Authorization": "Bearer test-token"},
        json={"title": "ikinci", "body": "icerik"},
    ).json()
    nid = created["id"]

    r = client.get(
        f"/notes/{nid}",
        headers={"Authorization": "Bearer test-token"},
    )
    assert r.status_code == 200
    assert r.json() == {"id": nid, "title": "ikinci", "body": "icerik"}


def test_list_contains_created_note(client):
    client.post(
        "/notes",
        headers={"Authorization": "Bearer test-token"},
        json={"title": "listede", "body": "var"},
    )

    r = client.get(
        "/notes",
        headers={"Authorization": "Bearer test-token"},
    )
    assert r.status_code == 200
    titles = [n["title"] for n in r.json()]
    assert "listede" in titles
