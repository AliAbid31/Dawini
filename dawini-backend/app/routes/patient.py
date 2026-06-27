from pydantic import BaseModel, EmailStr
from fastapi import HttpException, status, APIRouter
from app.config import supabase

router = APIRouter(prefix="/api/v1/patients", tags=["Patients"])

