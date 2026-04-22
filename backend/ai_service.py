"""AI servis arayuzu için iskelet modulu."""


class AIService:
    """AI saglayici entegrasyonu icin temel sinif iskeleti."""

    async def enrich_entry(self, raw_text: str, tone: str) -> str:
        """Ham metni secilen tona gore zenginlestirmek icin placeholder."""
        raise NotImplementedError("AI entegrasyonu henuz eklenmedi.")
