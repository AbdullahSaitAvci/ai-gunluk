"""Ayna AI Backend — Ana uygulama dosyası."""
from dotenv import load_dotenv
load_dotenv()  # En üstte olmalı, import'lardan önce

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import entries, questions

app = FastAPI(
    title="Ayna AI Backend",
    description="AI destekli Türkçe günlük uygulaması — Ayna AI",
    version="1.0.0"
)

# Flutter'dan gelen HTTP isteklerine izin ver
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Router'ları ana uygulamaya bağla
app.include_router(entries.router)
app.include_router(questions.router)


@app.get("/health", tags=["Sistem"])
async def health() -> dict[str, str]:
    """Servisin ayakta olduğunu kontrol eder."""
    return {"status": "ok", "version": "1.0.0"}