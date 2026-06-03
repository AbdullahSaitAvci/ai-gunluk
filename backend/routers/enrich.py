"""POST /enrich — ham metni AI ile zenginleştirir."""
import traceback
from fastapi import APIRouter
from pydantic import BaseModel
from ai_service import AIService

router = APIRouter(prefix="/enrich", tags=["AI Zenginleştirme"])

_ai = AIService()


class EnrichRequest(BaseModel):
    raw_text: str
    tone: str  # "Stoacı" | "Neşeli" | "Sade"


@router.post("/", summary="Metni AI ile zenginleştir")
async def enrich_entry(request: EnrichRequest):
    try:
        enriched = await _ai.enrich_entry(request.raw_text, request.tone)
        return {"enriched_text": enriched}
    except Exception as e:
        print(f"ENRICH ERROR: {e}")
        traceback.print_exc()
        return {"enriched_text": request.raw_text}
