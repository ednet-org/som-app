# SOM API

REST API for the Smart Offer Management platform built with Dart Frog.

## Quick Start

```bash
# Install dependencies
dart pub get

# Run development server
dart_frog dev

# Run tests
dart test

# Run analyzer
dart analyze --fatal-infos
```

## Documentation

- [API Documentation](docs/API.md) - Endpoint reference and examples
- [Architecture Documentation](docs/ARCHITECTURE.md) - System design and patterns

## Project Structure

```
api/
├── lib/
│   ├── domain/                 # Domain models
│   ├── infrastructure/
│   │   └── repositories/       # Data access layer
│   ├── models/                 # DTOs
│   └── services/               # Business logic
├── routes/                     # API endpoints
├── test/                       # Tests
├── docs/                       # Documentation
└── openapi.yaml                # API specification
```

## Key Features

### Provider Management (v1.1)

Efficient pagination and search for 125k+ provider records:

- **Pagination:** Limit/offset with `X-Total-Count` and `X-Has-More` headers
- **Search:** Case-insensitive company name search
- **Filters:** Branch, status, type, ZIP prefix, company size
- **Performance:** Optimized JOIN queries with database indexes

```bash
# Example: Search providers
curl -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8081/providers?search=acme&limit=50&offset=0"
```

## Database Migrations

Migrations are in `supabase/migrations/`:

```bash
# Apply migrations
supabase migration up

# Key migration: Provider search indexes
# 20260117100000_provider_search_indexes.sql
```

## OpenAPI Client Generation

```bash
# Regenerate Flutter client
openapi-generator-cli generate \
  -i api/openapi.yaml \
  -g dart-dio \
  -o openapi \
  --additional-properties=pubName=openapi,pubVersion=1.0.0
```

## Testing

```bash
# Run all tests
dart test

# Run specific test file
dart test test/provider_search_test.dart
dart test test/providers_pagination_test.dart
```

## Environment Variables

All environment variables are **compile-time constants** passed via `dart compile exe -D...` flags.

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `SUPABASE_URL` | Supabase project URL | Yes | - |
| `SUPABASE_ANON_KEY` | Supabase anonymous key | Yes | - |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key | Yes | - |
| `SUPABASE_JWT_SECRET` | JWT signing secret | Yes | - |
| `SUPABASE_SCHEMA` | Database schema name | No | `som` |
| `SUPABASE_STORAGE_BUCKET` | Storage bucket name | No | `som-assets` |
| `CORS_ALLOWED_ORIGINS` | Comma-separated allowed origins | No | `*` |
| `APP_BASE_URL` | Frontend application URL | No | - |

### Docker Build Example

```bash
docker build \
  --build-arg SUPABASE_URL="https://xxx.supabase.co" \
  --build-arg SUPABASE_ANON_KEY="eyJ..." \
  --build-arg SUPABASE_SERVICE_ROLE_KEY="eyJ..." \
  --build-arg SUPABASE_JWT_SECRET="xxx" \
  --build-arg CORS_ALLOWED_ORIGINS="https://your-app.com,http://localhost:8080" \
  --build-arg APP_BASE_URL="https://your-app.com" \
  -f api/Dockerfile .
```

**Important**: These are compile-time values. Runtime environment variables will not work.
