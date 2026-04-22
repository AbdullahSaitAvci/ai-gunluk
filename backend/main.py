from fastapi import FastAPI


app = FastAPI(title="Ayna AI Backend")


@app.get("/health")
async def health() -> dict[str, str]:
    """Servisin ayakta olduğunu kontrol eder."""
    return {"status": "ok"}
