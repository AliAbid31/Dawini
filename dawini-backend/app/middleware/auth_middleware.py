from fastapi import Request, HTTPException, status
from starlette.middleware.base import BaseHTTPMiddleware
from app.config import settings

class WebhookSecurityMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        if request.url.path.startswith("/api/v1/webhooks"):
            api_key = request.headers.get("X-API-KEY")
            if not api_key or api_key != settings.API_SECRET_KEY:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Unauthorized: Invalid or missing X-API-KEY"
                )
        response = await call_next(request)
        return response