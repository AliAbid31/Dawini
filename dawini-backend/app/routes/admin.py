from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel
from app.config import supabase

router = APIRouter(prefix="/api/v1/admin", tags=["Admin Control Panel"])

class PharmacyPayload(BaseModel):
    pharmacy_id: str
    approve: bool

@router.get("/metrics", status_code=status.HTTP_200_OK)
async def get_system_global_metrics():
    try:
        users = supabase.table("profiles").select("id").execute()
        pharmacies = supabase.table("pharmacies").select("id").eq("is_verified", True).execute()
        pending = supabase.table("pharmacies").select("id").eq("is_verified", False).execute()

        return {
            "total_users": len(users.data or []),
            "active_pharmacies": len(pharmacies.data or []),
            "pending_validations": len(pending.data or [])
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.patch("/pharmacies/verify", status_code=status.HTTP_200_OK)
async def verify_pharmacy_status(payload: PharmacyPayload):
    try:
        response = supabase.table("pharmacies") \
            .update({"is_verified": payload.approve}) \
            .eq("id", payload.pharmacy_id) \
            .execute()
        if not response.data:
            raise HTTPException(status_code=404, detail="Pharmacy not found.")
        return {"success": True, "pharmacy": response.data[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))