"""Günlük AI sorusu endpoint'i."""
import random
from fastapi import APIRouter, HTTPException, Header

router = APIRouter(prefix="/daily-question", tags=["Soru Motoru"])

# AI entegrasyonu gelene kadar kullanılacak fallback sorular
FALLBACK_QUESTIONS = [
    "Bugün seni en çok ne düşündürdü?",
    "Bugün kendine karşı nazik miydin?",
    "Bugün öğrendiğin küçük ama değerli bir şey var mıydı?",
    "Bugün neyi farklı yapardın?",
    "Şu an minnettar olduğun üç şey nedir?",
    "Bugün seni zorlayan bir şey oldu mu? Nasıl aştın?",
    "Bugün enerjini en çok ne tüketti?",
    "Bu hafta kendine verdiğin en güzel hediye neydi?",
]


@router.get("/", summary="Günün sorusunu getir")
async def get_daily_question():
    """
    Kullanıcıya günlük soru döner.
    Şimdilik statik havuzdan rastgele seçer.
    AI entegrasyonu sonrasında kişiselleştirilmiş soru üretecek.
    """
    try:
        question = random.choice(FALLBACK_QUESTIONS)
        return {
            "question": question,
            "category": "genel",
            "is_personalized": False
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))