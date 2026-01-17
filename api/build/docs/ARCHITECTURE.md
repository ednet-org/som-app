# SOM API Architecture

## Overview

The SOM API is a Dart Frog REST API serving the Smart Offer Management platform. It connects a Flutter frontend to a Supabase PostgreSQL database.

## System Architecture

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│    Flutter App      │────▶│    Dart Frog API    │────▶│     Supabase        │
│  (Mobile/Desktop)   │◀────│   (REST Endpoints)  │◀────│    PostgreSQL       │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
         │                           │                           │
         │                           │                           │
    OpenAPI Client            Repositories               Database Tables
    (Generated)               (Data Access)              (125k+ records)
```

## Directory Structure

```
api/
├── lib/
│   ├── domain/                 # Domain models (som_domain.dart)
│   ├── infrastructure/
│   │   └── repositories/       # Data access layer
│   │       ├── company_repository.dart
│   │       ├── provider_repository.dart
│   │       ├── inquiry_repository.dart
│   │       └── ...
│   ├── models/                 # Data transfer objects
│   │   └── models.dart
│   └── services/               # Business logic services
│       ├── auth_service.dart
│       └── ...
├── routes/                     # API endpoints (Dart Frog routes)
│   ├── providers/
│   │   └── index.dart          # GET /providers
│   ├── inquiries/
│   └── ...
├── test/                       # Unit and integration tests
├── docs/                       # API documentation
└── openapi.yaml                # OpenAPI specification
```

## Key Components

### 1. Repository Layer

Repositories handle database access using Supabase client:

```dart
class ProviderRepository {
  ProviderRepository(this._client);
  final SupabaseClient _client;

  Future<ProviderSearchResult> searchProviders(
    ProviderSearchParams params,
    CompanyRepository companyRepo,
  ) async {
    // JOIN query with filters and pagination
  }
}
```

### 2. Route Handlers

Dart Frog routes handle HTTP requests:

```dart
Future<Response> onRequest(RequestContext context) async {
  // Authentication
  final auth = await parseAuth(context, ...);

  // Parse parameters
  final params = context.request.uri.queryParameters;

  // Call repository
  final result = await providerRepo.searchProviders(...);

  // Return response with headers
  return Response.json(body: result, headers: paginationHeaders);
}
```

### 3. Models

Data transfer objects for API communication:

```dart
class ProviderSearchParams {
  final int limit;
  final int offset;
  final String? search;
  final String? branchId;
  // ...
}

class ProviderSearchResult {
  final int totalCount;
  final List<ProviderSummaryRecord> items;
}
```

## Provider Data Flow

### Pagination Architecture

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Flutter UI  │───▶│  API Route   │───▶│  Repository  │
│              │    │              │    │              │
│ ScrollCtrl   │    │ Parse params │    │ JOIN query   │
│ offset=0     │    │ limit=50     │    │ w/ filters   │
│ hasMore=?    │    │ offset=0     │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │
       │                   │                   ▼
       │                   │           ┌──────────────┐
       │                   │           │  PostgreSQL  │
       │                   │           │              │
       │                   │           │ - Indexes    │
       │                   │           │ - JOIN       │
       │                   │           │ - LIMIT/OFF  │
       │                   │           └──────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Update state │◀───│  Headers:    │◀───│ Return rows  │
│ totalCount   │    │ X-Total-Count│    │ + count      │
│ hasMore      │    │ X-Has-More   │    │              │
│ providers[]  │    │              │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
```

### Query Optimization

**Before (O(n*4) queries):**
```
for each company:
  - SELECT provider_profile
  - SELECT count(inquiry_assignments)
  - SELECT count(offers)
  - SELECT count(offers WHERE status='won')
```

**After (O(1) + O(pageSize*3) queries):**
```
1. SELECT providers JOIN companies (with filters, LIMIT/OFFSET)
2. For each provider in page:
   - SELECT count(inquiry_assignments)
   - SELECT count(offers)
   - SELECT count(offers WHERE status='won')
```

### Database Indexes

```sql
-- Provider type filtering
CREATE INDEX idx_provider_profiles_provider_type
ON provider_profiles(provider_type);

-- Status filtering
CREATE INDEX idx_provider_profiles_status
ON provider_profiles(status);

-- Company name search (case-insensitive)
CREATE INDEX idx_companies_name_lower
ON companies(lower(name));

-- Composite index for type + status
CREATE INDEX idx_provider_profiles_type_status
ON provider_profiles(provider_type, status);

-- Company type filtering
CREATE INDEX idx_companies_type
ON companies(type);
```

## Testing Strategy

### Test Structure

```
test/
├── provider_search_test.dart       # Repository unit tests
├── providers_pagination_test.dart  # Route handler tests
├── test_utils.dart                 # In-memory repositories
└── ...
```

### In-Memory Repositories

Tests use in-memory implementations for isolation:

```dart
class InMemoryProviderRepository implements ProviderRepository {
  final Map<String, ProviderProfileRecord> _profiles = {};

  @override
  Future<ProviderSearchResult> searchProviders(...) async {
    // In-memory filtering and pagination
  }
}
```

### Test Categories

1. **Repository Tests:** Verify search, filtering, pagination logic
2. **Route Tests:** Verify HTTP responses, headers, parameter parsing
3. **Integration Tests:** End-to-end API contract verification

## Performance Metrics

| Metric | Before | After |
|--------|--------|-------|
| API Response Time | Timeout (>30s) | < 500ms |
| Memory Usage | OOM (load all) | Constant (50 per page) |
| DB Queries per request | 500k+ | 2 + (pageSize * 3) |
| UX | Broken | Smooth infinite scroll |

## Security

### Authentication

- JWT tokens with configurable secret
- Role-based access control (buyer, provider, consultant, admin)

### Authorization Checks

```dart
if (auth == null || !auth.roles.contains('consultant')) {
  return Response(statusCode: 403);
}
```

### Input Validation

- Limit capped at 200 to prevent abuse
- SQL injection prevented via parameterized queries
- XSS prevented via JSON encoding

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SUPABASE_URL` | Supabase project URL | - |
| `SUPABASE_ANON_KEY` | Supabase anonymous key | - |
| `SUPABASE_JWT_SECRET` | JWT signing secret | `som_dev_secret` |
| `API_BASE_URL` | API base URL | `http://127.0.0.1:8081` |

## OpenAPI Integration

The API specification in `openapi.yaml` is used to:

1. Generate Dart Dio client for Flutter app
2. Document API endpoints
3. Validate request/response schemas

**Regenerate client:**
```bash
openapi-generator-cli generate \
  -i api/openapi.yaml \
  -g dart-dio \
  -o openapi \
  --additional-properties=pubName=openapi,pubVersion=1.0.0
```

## Flutter App Integration

### Provider Components

| Component | Location | Purpose |
|-----------|----------|---------|
| **ProvidersAppBody** | `lib/ui/pages/providers/providers_app_body.dart` | Main provider management UI with infinite scroll |
| **ProviderSelectionDialog** | `lib/ui/pages/inquiry/widgets/provider_selection_dialog.dart` | Multi-select dialog for assigning providers to inquiries |
| **InquiryPage** | `lib/ui/pages/inquiry/inquiry_page.dart` | Orchestrates inquiry management including provider assignment |

### Pagination Pattern (Flutter)

```dart
// State management
int _totalCount = 0;
int _currentOffset = 0;
bool _hasMore = true;
bool _isLoadingMore = false;

// Scroll detection
void _onScroll() {
  if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
      !_isLoadingMore &&
      _hasMore) {
    _loadMoreProviders();
  }
}

// API call with pagination headers
final response = await api.getProvidersApi().providersGet(
  limit: _pageSize,
  offset: _currentOffset,
  search: _search,
  // ... filters
);

final totalCountHeader = response.headers.value('X-Total-Count');
final hasMoreHeader = response.headers.value('X-Has-More');
```

### Provider Search Result

```dart
class ProviderSearchResult {
  final List<ProviderSummary> providers;
  final int totalCount;
  final bool hasMore;
}
```

This pattern is used consistently across:
- Provider management page (infinite scroll)
- Provider selection dialog (for inquiry assignment)
