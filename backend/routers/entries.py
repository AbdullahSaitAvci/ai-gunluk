"""Günlük girişleri CRUD endpoint'leri."""
import datetime
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from auth import CurrentUser, get_current_user
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
async def get_entries(current_user: CurrentUser = Depends(get_current_user)):
    """Giriş yapmış kullanıcının kendi günlük girişlerini döner."""
    try:
        supabase = get_supabase_client(current_user.token)
        response = supabase.table("entries") \
            .select("*") \
            .eq("user_id", current_user.id) \
            .order("created_at", desc=True) \
            .execute()
        return {"entries": response.data, "total": len(response.data)}
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail={"error": type(e).__name__, "message": str(e)},
        )


@router.post("/", status_code=201, summary="Yeni günlük girişi kaydet")
async def create_entry(
    entry: EntryCreate,
    current_user: CurrentUser = Depends(get_current_user),
):
    """
    Zenginleştirilmiş günlük girişini Supabase'e kaydeder.
    user_id, JWT'den doğrulanan giriş yapmış kullanıcının kimliğidir.
    """
    try:
        supabase = get_supabase_client(current_user.token)

        # entries.user_id sütunu hâlâ TEXT tipinde; UUID string'i sorunsuz
        # yazılır, ayrı bir migration gerekmez.
        payload = {
            "user_id": current_user.id,
            "date": str(datetime.date.today()),
            "question": entry.question,
            "raw_text": entry.raw_text,
            "enriched_text": entry.enriched_text,
            "tone": entry.tone,
            "mood": entry.mood,
        }

        response = supabase.table("entries").insert(payload).execute()

        return {"entry": response.data[0], "message": "Giriş kaydedildi"}
    except Exception as e:
        raise HTTPException(
            status_code=400,
            detail={
                "error": type(e).__name__,
                "message": str(e),
                "payload": {
                    "question": entry.question,
                    "tone": entry.tone,
                    "mood": entry.mood,
                },
            },
        )


@router.get("/{entry_id}", summary="Tek giriş detayı")
async def get_entry(
    entry_id: str,
    current_user: CurrentUser = Depends(get_current_user),
):
    """Belirli bir günlük girişinin detayını döner."""
    try:
        supabase = get_supabase_client(current_user.token)
        response = supabase.table("entries") \
            .select("*") \
            .eq("id", entry_id) \
            .eq("user_id", current_user.id) \
            .single() \
            .execute()
        return response.data
    except Exception:
        # Ham hata metni dışarı verilmez; kaydın var olup olmadığı ya da
        # başkasına ait olduğu bilgisi sızdırılmaz.
        raise HTTPException(status_code=404, detail="Kayıt bulunamadı.")