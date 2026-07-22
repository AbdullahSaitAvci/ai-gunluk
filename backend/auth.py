"""Supabase Auth access token'larını LOKAL olarak doğrulayan FastAPI dependency'si.

Her istekte Supabase'e sormak yerine, Supabase'in JWKS endpoint'inden aldığı
public key ile JWT imzasını doğrular. Bu sayede /me gibi korumalı endpoint'ler
ekstra ağ gecikmesi olmadan yetkilendirme yapabilir.
"""
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel
import jwt
from jwt import PyJWKClient
from jwt.exceptions import PyJWKClientError, PyJWKClientConnectionError

from constants import SUPABASE_URL

# JWKS client modül seviyesinde tek sefer oluşturulur; her istekte yeniden
# kurulursa hem gereksiz nesne yaratılır hem de cache_keys avantajı kaybolur.
_jwks_client = PyJWKClient(
    f"{SUPABASE_URL}/auth/v1/.well-known/jwks.json",
    cache_keys=True,
    lifespan=600,
    timeout=10,
)

# auto_error=False: header eksikse FastAPI'nin varsayılan 403'ü yerine
# aşağıda elle 401 döndürüyoruz (spesifikasyona göre doğru kod 401'dir).
_bearer_scheme = HTTPBearer(auto_error=False)


class CurrentUser(BaseModel):
    """Doğrulanmış JWT'den çıkarılan kullanıcı bilgisi."""
    id: str            # JWT "sub" claim'i — auth.users.id
    email: str | None
    token: str          # Ham JWT; ileride PostgREST'e (RLS için) iletilecek


def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(_bearer_scheme),
) -> CurrentUser:
    """
    Authorization header'ındaki Bearer token'ı doğrular ve CurrentUser döner.

    ÖNEMLİ: Bu fonksiyon `async def` DEĞİL, düz `def`dir. PyJWKClient
    senkron (bloklayan) HTTP isteği yapabildiği için, düz def olduğunda
    FastAPI bu dependency'yi thread pool'da çalıştırır ve event loop
    bloklanmaz.
    """
    if credentials is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Kimlik doğrulama bilgisi eksik.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    token = credentials.credentials

    try:
        signing_key = _jwks_client.get_signing_key_from_jwt(token)
        payload = jwt.decode(
            token,
            signing_key.key,
            # Sadece ES256 kabul edilir; HS256'ya izin vermek algorithm
            # confusion saldırısına (public key'i HMAC secret'ı gibi
            # kullanarak sahte token üretme) kapı açar.
            algorithms=["ES256"],
            audience="authenticated",
            issuer=f"{SUPABASE_URL}/auth/v1",
            options={"require": ["exp", "sub", "aud", "iss"]},
        )
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Oturum süresi doldu. Tekrar giriş yapın.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except PyJWKClientConnectionError:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Kimlik doğrulama servisine ulaşılamadı.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except PyJWKClientError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Geçersiz oturum.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    except jwt.InvalidTokenError:
        # Token asla loglanmaz veya hata mesajında dönülmez.
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Geçersiz oturum.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return CurrentUser(
        id=payload["sub"],
        email=payload.get("email"),
        token=token,
    )
