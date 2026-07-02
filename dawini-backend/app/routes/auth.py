from fastapi import APIRouter, HTTPException, status
from app.config import supabase
from pydantic import BaseModel, EmailStr
from typing import Literal

router = APIRouter(prefix="/api/v1/auth", tags=["Auth"])

class UserProfile(BaseModel):
    id: str
    email: EmailStr
    full_name: str
    role: Literal["patient", "pharmacy", "admin"]
    phone: str | None = None
    preferred_language: str = "fr"

@router.post("/sync-profile", status_code=status.HTTP_201_CREATED)
async def sync_user_profile(profile: UserProfile):
    if profile.role not in ["patient", "pharmacy", "admin"]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid role. Must be 'patient', 'pharmacy', or 'admin'."
        )
    try:
        response = supabase.table("profiles").insert({
            "id": profile.id,
            "full_name": profile.full_name,
            "email": profile.email,
            "role": profile.role,
            "phone": profile.phone,
            "preferred_language": profile.preferred_language
        }).execute()
        if not response.data:
            raise HTTPException(
                status_code=400,
                detail="Failed to create user profile."
            )
        return {"success": True, "profile": response.data[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))