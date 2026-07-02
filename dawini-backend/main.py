from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.middleware.auth_middleware import WebhookSecurityMiddleware
from app.routes import auth, patient, pharmacy, admin, webhooks

app = FastAPI(
    title="Dawini Core Engine API",
    description="Complete backend API for Dawini, the healthcare platform.",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(WebhookSecurityMiddleware)

app.include_router(auth.router)
app.include_router(patient.router)
app.include_router(pharmacy.router)
app.include_router(admin.router)
app.include_router(webhooks.router)

@app.get("/health", tags=["Diagnostic"])
def get_system_health():
    return {"status": "fully_operational", "database": "connected"}