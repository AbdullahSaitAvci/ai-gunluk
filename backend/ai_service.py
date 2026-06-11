"""Anthropic Claude API ile metin zenginleştirme servisi."""
import os
import anthropic

ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY", "")
_MODEL = "claude-haiku-4-5"

_TONE_GUIDE = {
    "Neşeli": "pozitif, enerjik ve umut dolu bir ton kullan",
    "Hüzünlü": "içe dönük, melankolik ve duygusal bir ton kullan",
    "Minnettar": "şükran dolu, minnettarlık hissettiren bir ton kullan",
    "Motive": "kararlı, ileri bakışlı ve güçlü bir ton kullan",
    "Sakin": "nötr, sade ve sakin bir ton kullan",
}

_SYSTEM_PROMPT = (
    "Sen bir günlük yazma asistanısın.\n"
    "Kullanıcının yazdığı metni seçilen tonda yeniden ifade et.\n"
    "Kısa tut: maksimum 2-3 cümle.\n"
    "Kullanıcının söylemediği olayları veya bilgileri ekleme.\n"
    "Türkçe yaz. 1. tekil şahıs kullan.\n"
    "Sadece sonucu döndür."
)


class AIService:
    def __init__(self):
        self._client = anthropic.AsyncAnthropic(api_key=ANTHROPIC_API_KEY)

    async def enrich_entry(self, raw_text: str, tone: str) -> str:
        tone_instruction = _TONE_GUIDE.get(tone, _TONE_GUIDE["Sade"])
        user_message = (
            f"Ton talimatı: {tone_instruction}\n\n"
            f"Orijinal metin ({len(raw_text.split())} kelime):\n{raw_text}\n\n"
            f"Çıktı maksimum {len(raw_text.split()) + 5} kelime olsun. "
            f"Sadece düzenlenmiş metni yaz, başka hiçbir şey yazma."
        )

        message = await self._client.messages.create(
            model=_MODEL,
            max_tokens=500,
            system=_SYSTEM_PROMPT,
            messages=[{"role": "user", "content": user_message}],
        )
        return message.content[0].text
