"""Ayna AI Backend — Ana uygulama dosyası."""
from dotenv import load_dotenv
load_dotenv()  # En üstte olmalı, import'lardan önce

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from routers import entries, questions, enrich
from limiter import limiter
from constants import SUPABASE_URL, SUPABASE_ANON_KEY

app = FastAPI(
    title="Ayna AI Backend",
    description="AI destekli Türkçe günlük uygulaması — Ayna AI",
    version="1.0.0"
)

app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://ayna-ai-yga.netlify.app",
        "http://localhost:51926",
        "http://localhost:8080",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Router'ları ana uygulamaya bağla
app.include_router(entries.router)
app.include_router(questions.router)
app.include_router(enrich.router)


@app.get("/health", tags=["Sistem"])
async def health() -> dict[str, str]:
    """Servisin ayakta olduğunu kontrol eder.

    cron-job.org zaten bu endpoint'i 10 dakikada bir çağırıyor; buradaki
    hafif Supabase sorgusu bu ping'i Supabase için de "aktivite" sayılır hale
    getirip ücretsiz tier'ın 7 günlük hareketsizlik nedeniyle pause olmasını önler.
    """
    try:
        from supabase import create_client
        supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
        supabase.table("entries").select("id").limit(1).execute()
        supabase_status = "ok"
    except Exception:
        supabase_status = "unreachable"

    return {"status": "ok", "version": "1.0.0", "supabase": supabase_status}