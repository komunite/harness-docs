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


def test_search_finds_title_match():
    client, _ = _fresh_client()
    client.post("/notes", json={"title": "alpha", "body": "first"}, headers=H)
    client.post("/notes", json={"title": "beta", "body": "second"}, headers=H)
    r = client.get("/notes/search", params={"q": "alpha"}, headers=H)
    assert r.status_code == 200
    titles = [n["title"] for n in r.json()]
    assert "alpha" in titles
    assert "beta" not in titles


def test_search_finds_body_match():
    client, _ = _fresh_client()
    client.post("/notes", json={"title": "x", "body": "needle in body"}, headers=H)
    r = client.get("/notes/search", params={"q": "needle"}, headers=H)
    assert r.status_code == 200
    assert len(r.json()) == 1


def test_search_empty_result():
    client, _ = _fresh_client()
    client.post("/notes", json={"title": "x", "body": "y"}, headers=H)
    r = client.get("/notes/search", params={"q": "nope"}, headers=H)
    assert r.status_code == 200
    assert r.json() == []


def test_search_injection_attempt_treated_as_literal():
    # "1' OR '1'='1" parametre olarak bagli; LIKE pattern olarak yorumlanir,
    # SQL kontrol akisini bozmaz. Hicbir kayit eslesemez.
    client, _ = _fresh_client()
    client.post("/notes", json={"title": "safe", "body": "ok"}, headers=H)
    r = client.get("/notes/search", params={"q": "1' OR '1'='1"}, headers=H)
    assert r.status_code == 200
    assert r.json() == []
