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

def _seed(client):
    client.post("/notes", json={"title": "alpha note", "body": "x"}, headers=H)
    client.post("/notes", json={"title": "beta note", "body": "y"}, headers=H)
    client.post("/notes", json={"title": "gamma", "body": "z"}, headers=H)

def test_search_returns_matching_titles():
    client, _ = _fresh_client()
    _seed(client)
    r = client.get("/notes/search", params={"q": "note"}, headers=H)
    assert r.status_code == 200
    titles = sorted(n["title"] for n in r.json())
    assert titles == ["alpha note", "beta note"]

def test_search_empty_query_returns_empty_list():
    client, _ = _fresh_client()
    _seed(client)
    r = client.get("/notes/search", params={"q": "   "}, headers=H)
    assert r.status_code == 200
    assert r.json() == []

def test_search_requires_auth():
    client, _ = _fresh_client()
    r = client.get("/notes/search", params={"q": "note"})
    assert r.status_code == 401

def test_search_quote_is_not_injected():
    # Bir quote karakteri ham SQL'e enjekte edilseydi 500 donerdi.
    # Parametreli sorgu sayesinde guvenli sekilde 200 ve bos sonuc beklenir.
    client, _ = _fresh_client()
    _seed(client)
    r = client.get("/notes/search", params={"q": "no'te"}, headers=H)
    assert r.status_code == 200
    assert r.json() == []
