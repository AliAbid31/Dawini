from datetime import date
from pydantic import BaseModel, Field
from fastapi import HTTPException, status, APIRouter
from app.config import supabase
from typing import Literal

router = APIRouter(prefix="/api/v1/patients", tags=["Patients"])

class Patient(BaseModel):
    profile_id: str
    location: str | None = None
    birth_date: date | None = None
    gender: Literal["M", "F"]
class ReservationRequest(BaseModel):
    patient_id: str
    pharmacy_id: str
    medicine_id: str
    quantity: int = Field(default=1, ge=1)
    message: str | None = None

class StockAlert(BaseModel):
    patient_id: str
    pharmacy_id: str
    medicine_id: str

@router.post("/details", status_code=status.HTTP_201_CREATED)
async def create_patient_details(patient: Patient):
    profile = supabase.table("profiles").select("id").eq("id", patient.profile_id).execute()
    if not profile.data:
        raise HTTPException(
            status_code=400,
            detail="Profile not found. Call /api/v1/auth/sync-profile first."
        )
    try:
        response = supabase.table("patients").upsert({
            "profile_id": patient.profile_id,
            "location": patient.location,
            "birth_date": patient.birth_date.isoformat() if patient.birth_date else None,
            "gender": patient.gender
        }, on_conflict="profile_id").execute()
        if not response.data:
            raise HTTPException(status_code=400, detail="Information Creation failed.")
        return {"success": True, "patient": response.data[0]}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.get("/medicines/search", status_code=status.HTTP_200_OK)
async def search_medicines(query: str):
    try:
        response = supabase.table("medicines") \
            .select("*") \
            .or_(f"name.ilike.%{query}%,dci.ilike.%{query}%") \
            .execute()
        return {"results": response.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.get("/medicines/{medicine_id}", status_code=status.HTTP_200_OK)
async def get_medicine_details(medicine_id: str):
    try:
        response = supabase.table("medicines").select("*").eq("id", medicine_id).execute()
        if not response.data:
            raise HTTPException(status_code=404, detail="Unavailable medicine.")
        return {"medicine": response.data[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.post("/reservations", status_code=status.HTTP_201_CREATED)
async def make_medicine_reservation(payload: ReservationRequest):
    try:
        response = supabase.table("requests").insert({
            "patient_id": payload.patient_id,
            "pharmacy_id": payload.pharmacy_id,
            "medicine_id": payload.medicine_id,
            "quantity": payload.quantity,
            "status": "PENDING",
            "message": payload.message
        }).execute()
        return {"success": True, "request": response.data[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.get("/requests/{patient_id}", status_code=status.HTTP_200_OK)
async def get_patient_request_history(patient_id: str):
    try:
        response = supabase.table("requests") \
            .select("*, pharmacies(name, address), medicines(name, dosage)") \
            .eq("patient_id", patient_id) \
            .order("created_at", descending=True) \
            .execute()
        return {"history": response.data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.post("/alerts", status_code=status.HTTP_201_CREATED)
async def subscribe_to_stock_alert(payload: StockAlert):
    try:
        response = supabase.table("alerts").insert({
            "patient_id": payload.patient_id,
            "pharmacy_id": payload.pharmacy_id,
            "medicine_id": payload.medicine_id,
            "is_active": True
        }).execute()
        return {"success": True, "alert": response.data[0]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))