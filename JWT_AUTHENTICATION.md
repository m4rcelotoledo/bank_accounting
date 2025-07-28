# JWT Authentication

This application now uses JWT (JSON Web Token) authentication instead of Basic HTTP authentication.

## Authentication Endpoints

### 1. Login
**POST** `/auth/login`

**Body:**
```json
{
  "cpf": "12345678901",
  "password": "password123"
}
```

**Success Response (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 1,
    "name": "John Doe",
    "cpf": "12345678901"
  }
}
```

### 2. Logout
**POST** `/auth/logout`

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "message": "Logout successful"
}
```

### 3. User Information
**GET** `/auth/me`

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "cpf": "12345678901"
  }
}
```

## How to use in other requests

To access protected endpoints, include the JWT token in the `Authorization` header:

```
Authorization: Bearer <token>
```

### Example using curl:

```bash
# 1. Login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"cpf": "12345678901", "password": "password123"}'

# 2. Use the returned token in other requests
curl -X GET http://localhost:3000/balance \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9..."
```

## Security

- Tokens expire in 24 hours
- Tokens are signed with the application's secret key
- Encryption algorithm: HS256
- Tokens contain user information (ID and CPF)

## Migration from Basic Authentication

Basic HTTP authentication has been removed and replaced with JWT. Now it's necessary to:

1. Login via `/auth/login` to obtain a token
2. Include the token in the `Authorization` header for all subsequent requests
3. Tokens are valid for 24 hours
