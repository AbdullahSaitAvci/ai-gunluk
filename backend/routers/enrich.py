"""POST /enrich — ham metni AI ile zenginleştirir."""
import re
import traceback
from fastapi import APIRouter, Request
from pydantic import BaseModel
from ai_service import AIService
from limiter import limiter

router = APIRouter(prefix="/enrich", tags=["AI Zenginleştirme"])

_ai = AIService()

_VALID_TONES = {"Neşeli", "Hüzünlü", "Minnettar", "Motive", "Sakin"}
_INJECTION_RE = re.compile(
    r"\b(ignore|forget|system|prompt|talimat|kural|önceki)\b",
    re.IGNORECASE,
)
_MAX_LEN = 500


class EnrichRequest(BaseModel):
    raw_text: str
    tone: str


@router.post("/", summary="Metni AI ile zenginleştir")
@limiter.limit("10/minute")
async def enrich_entry(request: Request, body: EnrichRequest):
    raw_text = body.raw_text[:_MAX_LEN]
    tone = body.tone if body.tone in _VALID_TONES else "Sakin"

    if _INJECTION_RE.search(raw_text):
        return {"enriched_text": raw_text}

    try:
        enriched = await _ai.enrich_entry(raw_text, tone)
        return {"enriched_text": enriched}
    except Exception as e:
        print(f"ENRICH ERROR: {e}")
        traceback.print_exc()
        return {"enriched_text": raw_text}
