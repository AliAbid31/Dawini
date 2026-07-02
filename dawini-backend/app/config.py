import os
from dotenv import load_dotenv
from supabase import create_client, Client

load_dotenv()

class Settings:
    SUPABASE_URL: str = os.getenv("SUPABASE_URL")
    SUPABASE_SERVICE_ROLE_KEY: str = os.getenv("SUPABASE_SERVICE_ROLE_KEY")
    API_SECRET_KEY: str = os.getenv("API_SECRET_KEY")

    def __init__(self):
        if not self.SUPABASE_URL or not self.SUPABASE_SERVICE_ROLE_KEY:
            raise ValueError("Incomplete Supabase configuration. Check your .env file.")

settings = Settings()
if not settings.SUPABASE_URL:
    raise ValueError("Missing SUPABASE_URL")
if not settings.SUPABASE_SERVICE_ROLE_KEY:
    raise ValueError("Missing SUPABASE_SERVICE_ROLE_KEY")
supabase: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_SERVICE_ROLE_KEY)