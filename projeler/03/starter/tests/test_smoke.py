# tests/test_smoke.py — temel duman testi
from fastapi.testclient import TestClient
from app import app

client = TestClient(app)
HEAD = {"Authorization": "Bearer dev-token"}


def test_unauthorized_without_token():
    r = client.get("/notes")
    assert r.status_code == 401


def test_create_and_read_note(tmp_path, monkeypatch):
    monkeypatch.setenv("DB_PATH", str(tmp_path / "smoke.db"))
    r = client.post("/notes", json={"title": "ilk", "body": "icerik"}, headers=HEAD)
    assert r.status_code == 201
    nid = r.json()["id"]
    r2 = client.get(f"/notes/{nid}", headers=HEAD)
    assert r2.status_code == 200
    assert r2.json()["title"] == "ilk"
