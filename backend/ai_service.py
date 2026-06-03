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
    "Sen Ayna AI'sın — kullanıcının günlük deneyimlerini yansıtan bir yazı asistanısın. "
    "Kullanıcı kısa ve ham bir metin yazar, sen bunu seçilen tonda akıcı, "
    "anlamlı ve içten bir günlük paragrafına dönüştürürsün. "
    "Kurallar:\n"
    "1. Kullanıcının söylemediği hiçbir olay veya bilgiyi ekleme\n"
    "2. Kullanıcının duygusunu ve sesini koru\n"
    "3. Kısa metni 2-4 cümlelik zengin bir paragrafa genişlet\n"
    "4. Türkçe yaz, 1. tekil şahıs kullan\n"
    "5. Sadece zenginleştirilmiş metni döndür, başka hiçbir şey yazma"
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
