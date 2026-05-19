import os, tempfile, importlib
from fastapi.testclient import TestClient


def _fresh_client():
    tmp = tempfile.NamedTemporaryFile(suffix=".db", delete=False)
    tmp.close()
    os.environ["DB_PATH"] = tmp.name
    os.environ["API_TOKEN"] = "test-token"
    import app as app_module
    importlib.reload(app_module)
    return TestClient(app_module.app), tmp.name


H = {"Authorization": "Bearer test-token"}


def test_unauthorized_get_returns_401():
    client, _ = _fresh_client()
    r = client.get("/notes")
    assert r.status_code == 401


def test_create_then_get_roundtrip():
    client, _ = _fresh_client()
    r = client.post("/notes", json={"title": "t", "body": "b"}, headers=H)
    assert r.status_code == 201
    nid = r.json()["id"]
    g = client.get(f"/notes/{nid}", headers=H)
    assert g.status_code == 200
    assert g.json()["title"] == "t"


def test_list_after_two_inserts():
    client, _ = _fresh_client()
    client.post("/notes", json={"title": "a", "body": "x"}, headers=H)
    client.post("/notes", json={"title": "b", "body": "y"}, headers=H)
    r = client.get("/notes", headers=H)
    assert r.status_code == 200
    assert len(r.json()) == 2


def test_missing_note_get_returns_404():
    client, _ = _fresh_client()
    r = client.get("/notes/9999", headers=H)
    assert r.status_code == 404


def test_update_existing_note():
    client, _ = _fresh_client()
    r = client.post("/notes", json={"title": "old", "body": "x"}, headers=H)
    nid = r.json()["id"]
    u = client.put(f"/notes/{nid}", json={"title": "new", "body": "y"}, headers=H)
    assert u.status_code == 200
    assert u.json()["title"] == "new"


def test_delete_existing_note():
    client, _ = _fresh_client()
    r = client.post("/notes", json={"title": "x", "body": "y"}, headers=H)
    nid = r.json()["id"]
    d = client.delete(f"/notes/{nid}", headers=H)
    assert d.status_code == 204
