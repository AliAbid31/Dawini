from fastapi import APIRouter, HTTPException, status
from pydantic import BaseModel

router = APIRouter(prefix="/api/v1/webhooks", tags=["n8n Pipelines"])

class SystemAlertEvent(BaseModel):
    event_type: str
    payload: dict

@router.post("/process-alert", status_code=status.HTTP_200_OK)
async def log_processed_alert_from_n8n(payload: SystemAlertEvent):
    if not payload.event_type:
        raise HTTPException(status_code=400, detail="Invalid payload.")
    print(f"Log Automation: Event {payload.event_type} executed successfully.")
    return {"status": "archived"}