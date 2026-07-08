from fastapi import APIRouter, HTTPException, status
from app.config import supabase
from pydantic import BaseModel, Field

router = APIRouter(prefix="/api/v1/pharmacies", tags=["Pharmacies"])
class Pharmacy(BaseModel):
    owner_id: str
    name: str
    address: str
    license_number: str

class InventoryItem(BaseModel):
    pharmacy_id: str
    medicine_id: str
    quantity: int = Field(default=0, ge=0)
    status: str = Field(..., pattern="^(AVAILABLE|WEAK_STOCK|UNAVAILABLE)$")

class HandleRequestAction(BaseModel):
    request_id: str
    status: str = Field(..., pattern="^(CONFIRMED|OUT_OF_STOCK|REFUSED)$")
    message: str | None = None

@router.post("/details", status_code=status.HTTP_201_CREATED)
async def create_pharmacy_details(pharmacy: Pharmacy):
    try:
        profile = supabase.table("profiles").select("id").eq("id", pharmacy.owner_id).execute()
        if not profile.data:
            raise HTTPException(
                status_code=400,
                detail="Profile not found. Call /api/v1/auth/sync-profile first."
            )

        response = supabase.table("pharmacies").upsert({
            "owner_id": pharmacy.owner_id,
            "name": pharmacy.name,
            "address": pharmacy.address,
            "license_number": pharmacy.license_number,
            "is_verified": False
        }, on_conflict="license_number").execute()
        if not response.data:
            raise HTTPException(status_code=400, detail="Pharmacy creation failed.")
        return {"success": True, "pharmacy": response.data[0]}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.get("/dashboard/{owner_id}", status_code=status.HTTP_200_OK)
async def get_dashboard_metrics(owner_id: str):
    try:
        pharmacy_res = supabase.table("pharmacies").select("id").eq("owner_id", owner_id).single().execute()
        pharmacy_id = pharmacy_res.data.get("id")

        if not pharmacy_id:
            raise HTTPException(status_code=404, detail="Pharmacy not found.")

        pending_requests = supabase.table("requests").select("id").eq("pharmacy_id", pharmacy_id).eq("status", "PENDING").execute()
        low_stock_items = supabase.table("inventory").select("id").eq("pharmacy_id", pharmacy_id).eq("status", "WEAK_STOCK").execute()

        return {
            "pharmacy_id": pharmacy_id,
            "pending_requests_count": len(pending_requests.data or []),
            "low_stock_count": len(low_stock_items.data or []),
            "inventory_health": "94%"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/inventory", status_code=status.HTTP_200_OK)
async def update_or_create_inventory(inventory: InventoryItem):
    try:
        response = supabase.table("inventory").upsert({
            "pharmacy_id": inventory.pharmacy_id,
            "medicine_id": inventory.medicine_id,
            "quantity": inventory.quantity,
            "status": inventory.status,
            "updated_at": "now()"
        }).execute()
        return {"success": True, "inventory": response.data[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.patch("/requests/handle", status_code=status.HTTP_200_OK)
async def handle_incoming_request(payload: HandleRequestAction):
    try:
        response = supabase.table("requests") \
            .update({"status": payload.status, "message": payload.message}) \
            .eq("id", payload.request_id) \
            .execute()
        if not response.data:
            raise HTTPException(status_code=404, detail="Request not found.")
        return {"success": True, "request": response.data[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))