"""Ayna AI Backend — Ana uygulama dosyası."""
from dotenv import load_dotenv
load_dotenv()  # En üstte olmalı, import'lardan önce

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from routers import entries, questions, enrich
from limiter import limiter

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
    """Servisin ayakta olduğunu kontrol eder."""
    return {"status": "ok", "version": "1.0.0"}