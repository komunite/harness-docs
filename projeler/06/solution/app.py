# app.py — Notes API, OpenTelemetry ile gozlemlenebilir.
# Her HTTP istegi bir middleware span'i ile sarilir; her handler kendi child
# span'ini acar. GenAI semconv attribute'lari set_genai_attrs ile baglanir.
from fastapi import FastAPI, HTTPException, Header, Depends, Request
from pydantic import BaseModel
import sqlite3, os

from otel_setup import tracer, set_genai_attrs

DB = os.getenv("DB_PATH", "notes.db")
TOKEN = os.getenv("API_TOKEN", "dev-token")
app = FastAPI()


class Note(BaseModel):
    id: int | None = None
    title: str
    body: str


def conn():
    c = sqlite3.connect(DB)
    c.execute(
        "CREATE TABLE IF NOT EXISTS notes (id INTEGER PRIMARY KEY, title TEXT, body TEXT)"
    )
    return c


def auth(authorization: str | None = Header(None)):
    if not authorization or authorization != f"Bearer {TOKEN}":
        raise HTTPException(401, "missing or invalid token")


@app.middleware("http")
async def trace_requests(request: Request, call_next):
    # Her HTTP istegi icin bir parent span. Method/path/status attribute'lari
    # runtime gozlemlenebilirliginin birinci katmanidir.
    span_name = f"{request.method} {request.url.path}"
    with tracer.start_as_current_span(span_name) as span:
        span.set_attribute("http.method", request.method)
        span.set_attribute("http.target", request.url.path)
        set_genai_attrs(span, "http.request")
        response = await call_next(request)
        span.set_attribute("http.status_code", response.status_code)
        return response


@app.post("/notes", response_model=Note, status_code=201, dependencies=[Depends(auth)])
def create_note(n: Note):
    with tracer.start_as_current_span("create_note") as span:
        set_genai_attrs(span, "create_note")
        with conn() as c:
            cur = c.execute(
                "INSERT INTO notes (title, body) VALUES (?, ?)", (n.title, n.body)
            )
            n.id = cur.lastrowid
        span.set_attribute("note.id", n.id)
        return n


@app.get("/notes/search", response_model=list[Note], dependencies=[Depends(auth)])
def search_notes(q: str):
    with tracer.start_as_current_span("search_notes") as span:
        set_genai_attrs(span, "search_notes")
        span.set_attribute("search.q", q)
        if not q.strip():
            span.set_attribute("search.result_count", 0)
            return []
        with conn() as c:
            rows = c.execute(
                "SELECT id, title, body FROM notes WHERE title LIKE ?",
                (f"%{q}%",),
            ).fetchall()
        span.set_attribute("search.result_count", len(rows))
        return [Note(id=r[0], title=r[1], body=r[2]) for r in rows]


@app.get("/notes/{nid}", response_model=Note, dependencies=[Depends(auth)])
def get_note(nid: int):
    with tracer.start_as_current_span("get_note") as span:
        set_genai_attrs(span, "get_note")
        span.set_attribute("note.id", nid)
        with conn() as c:
            row = c.execute(
                "SELECT id, title, body FROM notes WHERE id=?", (nid,)
            ).fetchone()
        if not row:
            raise HTTPException(404)
        return Note(id=row[0], title=row[1], body=row[2])


@app.get("/notes", response_model=list[Note], dependencies=[Depends(auth)])
def list_notes():
    with tracer.start_as_current_span("list_notes") as span:
        set_genai_attrs(span, "list_notes")
        with conn() as c:
            rows = c.execute("SELECT id, title, body FROM notes").fetchall()
        span.set_attribute("list.result_count", len(rows))
        return [Note(id=r[0], title=r[1], body=r[2]) for r in rows]


@app.put("/notes/{nid}", response_model=Note, dependencies=[Depends(auth)])
def update_note(nid: int, n: Note):
    with tracer.start_as_current_span("update_note") as span:
        set_genai_attrs(span, "update_note")
        span.set_attribute("note.id", nid)
        with conn() as c:
            row = c.execute("SELECT id FROM notes WHERE id=?", (nid,)).fetchone()
            if not row:
                raise HTTPException(404)
            c.execute(
                "UPDATE notes SET title=?, body=? WHERE id=?", (n.title, n.body, nid)
            )
        n.id = nid
        return n


@app.delete("/notes/{nid}", status_code=204, dependencies=[Depends(auth)])
def delete_note(nid: int):
    with tracer.start_as_current_span("delete_note") as span:
        set_genai_attrs(span, "delete_note")
        span.set_attribute("note.id", nid)
        with conn() as c:
            row = c.execute("SELECT id FROM notes WHERE id=?", (nid,)).fetchone()
            if not row:
                raise HTTPException(404)
            c.execute("DELETE FROM notes WHERE id=?", (nid,))
        return None
