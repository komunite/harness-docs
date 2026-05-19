# app.py — minimal Notes API with Bearer auth
from fastapi import FastAPI, HTTPException, Header, Depends
from pydantic import BaseModel
import sqlite3, os

DB = os.getenv("DB_PATH", "notes.db")
TOKEN = os.getenv("API_TOKEN", "dev-token")
app = FastAPI()

class Note(BaseModel):
    id: int | None = None
    title: str
    body: str

def conn():
    c = sqlite3.connect(DB)
    c.execute("CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, title TEXT, body TEXT)")
    return c

def auth(authorization: str | None = Header(None)):
    if not authorization or authorization != f"Bearer {TOKEN}":
        raise HTTPException(401, "missing or invalid token")

@app.post("/notes", response_model=Note, status_code=201, dependencies=[Depends(auth)])
def create_note(n: Note):
    with conn() as c:
        cur = c.execute("INSERT INTO notes (title, body) VALUES (?, ?)", (n.title, n.body))
        n.id = cur.lastrowid
    return n

@app.get("/notes/search", response_model=list[Note], dependencies=[Depends(auth)])
def search_notes(q: str):
    if not q.strip():
        return []
    with conn() as c:
        rows = c.execute(
            "SELECT id, title, body FROM notes WHERE title LIKE ?",
            (f"%{q}%",),
        ).fetchall()
    return [Note(id=r[0], title=r[1], body=r[2]) for r in rows]

@app.get("/notes/{nid}", response_model=Note, dependencies=[Depends(auth)])
def get_note(nid: int):
    with conn() as c:
        row = c.execute("SELECT id, title, body FROM notes WHERE id=?", (nid,)).fetchone()
    if not row:
        raise HTTPException(404)
    return Note(id=row[0], title=row[1], body=row[2])

@app.get("/notes", response_model=list[Note], dependencies=[Depends(auth)])
def list_notes():
    with conn() as c:
        rows = c.execute("SELECT id, title, body FROM notes").fetchall()
    return [Note(id=r[0], title=r[1], body=r[2]) for r in rows]
