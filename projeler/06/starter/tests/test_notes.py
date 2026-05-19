def test_auth_required(client):
    r = client.get("/notes")
    assert r.status_code == 401


def test_create_and_get(client, auth_headers):
    r = client.post(
        "/notes",
        headers=auth_headers,
        json={"title": "first", "body": "hello"},
    )
    assert r.status_code == 201
    nid = r.json()["id"]
    r = client.get(f"/notes/{nid}", headers=auth_headers)
    assert r.status_code == 200
    assert r.json()["title"] == "first"


def test_list(client, auth_headers):
    client.post("/notes", headers=auth_headers, json={"title": "a", "body": "x"})
    client.post("/notes", headers=auth_headers, json={"title": "b", "body": "y"})
    r = client.get("/notes", headers=auth_headers)
    assert r.status_code == 200
    assert len(r.json()) == 2


def test_search(client, auth_headers):
    client.post("/notes", headers=auth_headers, json={"title": "alpha", "body": "a"})
    client.post("/notes", headers=auth_headers, json={"title": "beta", "body": "b"})
    r = client.get("/notes/search?q=alp", headers=auth_headers)
    assert r.status_code == 200
    titles = [n["title"] for n in r.json()]
    assert "alpha" in titles
    assert "beta" not in titles


def test_search_empty_returns_empty(client, auth_headers):
    r = client.get("/notes/search?q=%20", headers=auth_headers)
    assert r.status_code == 200
    assert r.json() == []


def test_put_missing_returns_404(client, auth_headers):
    r = client.put(
        "/notes/999",
        headers=auth_headers,
        json={"title": "x", "body": "y"},
    )
    assert r.status_code == 404


def test_put_updates(client, auth_headers):
    r = client.post(
        "/notes", headers=auth_headers, json={"title": "old", "body": "v1"}
    )
    nid = r.json()["id"]
    r = client.put(
        f"/notes/{nid}",
        headers=auth_headers,
        json={"title": "new", "body": "v2"},
    )
    assert r.status_code == 200
    assert r.json()["title"] == "new"


def test_delete(client, auth_headers):
    r = client.post(
        "/notes", headers=auth_headers, json={"title": "tmp", "body": "z"}
    )
    nid = r.json()["id"]
    r = client.delete(f"/notes/{nid}", headers=auth_headers)
    assert r.status_code == 204
    r = client.get(f"/notes/{nid}", headers=auth_headers)
    assert r.status_code == 404
