"""Günlük girişleri CRUD endpoint'leri."""
import datetime
from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel
from constants import SUPABASE_URL, SUPABASE_ANON_KEY

router = APIRouter(prefix="/entries", tags=["Günlük Girişleri"])


# POST /entries için beklenen veri yapısı (Pydantic doğrulama yapar)
class EntryCreate(BaseModel):
    question: str
    raw_text: str
    enriched_text: str
    tone: str   # stoic | joyful | plain
    mood: int   # 1-5


def get_supabase_client(token: str):
    """
    Kullanıcının JWT token'ıyla Supabase client döner.
    RLS (Row Level Security) için token set edilmesi şart.
    """
    from supabase import create_client
    client = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
    client.postgrest.auth(token)
    return client


@router.get("/", summary="Geçmiş günlükleri listele")
async def get_entries(authorization: str = Header(...)):
    """
    Giriş yapmış kullanıcının tüm günlük girişlerini döner.
    Authorization: Bearer <supabase_jwt_token>
    """
    try:
        token = authorization.replace("Bearer ", "")
        supabase = get_supabase_client(token)
        response = supabase.table("entries") \
            .select("*") \
            .order("created_at", desc=True) \
            .execute()
        return {"entries": response.data, "total": len(response.data)}
    except Exception as e:
        raise HTTPException(status_code=401, detail=str(e))


@router.post("/", status_code=201, summary="Yeni günlük girişi kaydet")
async def create_entry(
    entry: EntryCreate,
    authorization: str = Header(...)
):
    """
    Zenginleştirilmiş günlük girişini Supabase'e kaydeder.
    Magic Flow'un son adımıdır: Soru → Cevap → Zenginleştir → Kaydet
    """
    try:
        token = authorization.replace("Bearer ", "")
        from supabase import create_client
        supabase = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)

        # Kullanıcı kimliğini token'dan al
        user = supabase.auth.get_user(token)
        user_id = user.user.id

        response = supabase.table("entries").insert({
            "user_id": user_id,
            "date": str(datetime.date.today()),
            "question": entry.question,
            "raw_text": entry.raw_text,
            "enriched_text": entry.enriched_text,
            "tone": entry.tone,
            "mood": entry.mood,
        }).execute()

        return {"entry": response.data[0], "message": "Giriş kaydedildi"}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/{entry_id}", summary="Tek giriş detayı")
async def get_entry(entry_id: str, authorization: str = Header(...)):
    """Belirli bir günlük girişinin detayını döner."""
    try:
        token = authorization.replace("Bearer ", "")
        supabase = get_supabase_client(token)
        response = supabase.table("entries") \
            .select("*") \
            .eq("id", entry_id) \
            .single() \
            .execute()
        return response.data
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))