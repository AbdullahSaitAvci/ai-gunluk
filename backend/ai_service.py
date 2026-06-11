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
    "Kullanıcının yazdığı Türkçe metni minimal şekilde düzenle.\n"
    "KURAL: Çıktı, girdiden maksimum %30 daha uzun olabilir.\n"
    "Sadece yap: dilbilgisi düzeltme, sözcük akıcılığı.\n"
    "Asla ekleme: yorum, felsefi düşünce, metafor, sonuç cümlesi.\n"
    "Kullanıcının yazmadığı hiçbir fikri metne katma.\n"
    "1. tekil şahıs. Sadece düzenlenmiş metni döndür."
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
