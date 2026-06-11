"""Anthropic Claude API ile metin zenginleştirme servisi."""
import os
import anthropic

ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY", "")
_MODEL = "claude-haiku-4-5"

_TONE_GUIDE = {
    "Stoacı": "sakin, nesnel ve felsefi bir ton kullan",
    "Neşeli": "pozitif ve enerjik bir ton kullan",
    "Sade": "düz ve samimi bir ton kullan",
}

_SYSTEM_PROMPT = (
    "Sen bir günlük yazma asistanısın. Kullanıcının yazdığı metni olduğu gibi koru.\n"
    "Sadece şunları yap:\n"
    "1. Açık dilbilgisi hatalarını düzelt\n"
    "2. Cümleleri daha akıcı hale getir\n"
    "3. Gerekirse maksimum 1 kısa cümle ekle — sadece kullanıcının zaten ima ettiği bir şeyi\n\n"
    "Kesinlikle yapma:\n"
    "- Kullanıcının söylemediği duygu, olay veya yorum ekleme\n"
    "- Metni uzatma veya şiirsel hale getirme\n"
    "- Felsefi yorumlar yapma\n"
    "- Kullanıcının sesini değiştirme\n\n"
    "Türkçe yaz. 1. tekil şahıs kullan. Sadece zenginleştirilmiş metni döndür."
)


class AIService:
    def __init__(self):
        self._client = anthropic.AsyncAnthropic(api_key=ANTHROPIC_API_KEY)

    async def enrich_entry(self, raw_text: str, tone: str) -> str:
        tone_instruction = _TONE_GUIDE.get(tone, _TONE_GUIDE["Sade"])
        user_message = f"Ton talimatı: {tone_instruction}\n\nMetin:\n{raw_text}"

        message = await self._client.messages.create(
            model=_MODEL,
            max_tokens=500,
            system=_SYSTEM_PROMPT,
            messages=[{"role": "user", "content": user_message}],
        )
        return message.content[0].text
