"""Uygulama sabitleri ve environment variable yönetimi."""
import os
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_ANON_KEY = os.getenv("SUPABASE_ANON_KEY", "")

MAX_TOKENS_PER_REQUEST = 500
MAX_DAILY_AI_CALLS = 10