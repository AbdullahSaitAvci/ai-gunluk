# Ayna AI — Veritabanı ER Diyagramı

```mermaid
erDiagram
    USERS {
        uuid id PK
        varchar email
        boolean biometric_enabled
        time notification_time
        timestamp created_at
    }

    ENTRIES {
        uuid id PK
        uuid user_id FK
        date date
        text question
        text raw_text
        text enriched_text
        varchar tone
        integer mood
        timestamp created_at
        timestamp updated_at
    }

    AI_INTERACTIONS {
        uuid id PK
        uuid user_id FK
        varchar prompt_type
        integer token_usage
        timestamp created_at
    }

    USERS ||--o{ ENTRIES : "yazar"
    USERS ||--o{ AI_INTERACTIONS : "üretir"
```