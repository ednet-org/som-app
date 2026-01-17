# SOM API Documentation

## Overview

The SOM API provides REST endpoints for the Smart Offer Management platform. It handles authentication, companies, providers, inquiries, offers, and subscriptions.

## Base URL

- Development: `http://127.0.0.1:8081`
- Production: Configured via `API_BASE_URL` environment variable

## Authentication

All protected endpoints require a Bearer token in the Authorization header:

```
Authorization: Bearer <jwt_token>
```

---

## Providers API

The Providers API enables consultant administrators to manage provider companies with efficient pagination and search capabilities.

### GET /providers

List providers with pagination, filtering, and search.

**Authorization:** Requires `consultant` role with `admin` permissions.

#### Query Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | integer | 50 | Results per page (max: 200) |
| `offset` | integer | 0 | Number of results to skip |
| `search` | string | - | Case-insensitive company name search |
| `branchId` | string | - | Filter by branch ID |
| `companySize` | string | - | Filter by company size (0-10, 11-50, etc.) |
| `providerType` | string | - | Filter by type (haendler, hersteller, dienstleister, grosshaendler) |
| `zipPrefix` | string | - | Filter by ZIP code prefix |
| `status` | string | - | Filter by status (active, pending, declined) |
| `claimed` | string | - | Filter claimed providers (true/false) |
| `format` | string | - | Set to `csv` for CSV export |

#### Response Headers

| Header | Type | Description |
|--------|------|-------------|
| `X-Total-Count` | integer | Total number of matching providers |
| `X-Has-More` | boolean | Whether more results exist after this page |

#### Response Body (JSON)

```json
[
  {
    "companyId": "uuid",
    "companyName": "Company Name",
    "companySize": "0-10",
    "providerType": "haendler",
    "postcode": "1010",
    "branchIds": ["branch-1", "branch-2"],
    "pendingBranchIds": [],
    "status": "active",
    "rejectionReason": null,
    "rejectedAt": null,
    "claimed": true,
    "subscriptionPlanId": "plan-uuid",
    "paymentInterval": "monthly",
    "iban": "AT123...",
    "bic": "BIC123",
    "accountOwner": "Owner Name",
    "registrationDate": "2024-01-15T10:30:00Z",
    "receivedInquiries": 5,
    "sentOffers": 3,
    "acceptedOffers": 1
  }
]
```

#### Example Requests

**Paginated request:**
```bash
curl -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8081/providers?limit=50&offset=0"
```

**Search by company name:**
```bash
curl -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8081/providers?search=acme&limit=20"
```

**Filter by status and type:**
```bash
curl -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8081/providers?status=pending&providerType=haendler"
```

**CSV export:**
```bash
curl -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:8081/providers?format=csv" > providers.csv
```

#### Response Codes

| Code | Description |
|------|-------------|
| 200 | Success |
| 403 | Forbidden (not consultant admin) |
| 405 | Method not allowed |

---

### POST /providers/{companyId}/approve

Approve a provider's branch request.

**Authorization:** Requires `consultant` role with `admin` permissions.

#### Path Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `companyId` | string | Provider company ID |

#### Request Body

```json
{
  "approvedBranchIds": ["branch-1", "branch-2"]
}
```

---

### POST /providers/{companyId}/decline

Decline a provider's branch request.

**Authorization:** Requires `consultant` role with `admin` permissions.

#### Path Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `companyId` | string | Provider company ID |

#### Request Body

```json
{
  "reason": "Reason for declining"
}
```

---

## Performance Considerations

### Pagination

The providers endpoint is optimized for handling large datasets (100k+ records):

- **Default page size:** 50 records
- **Maximum page size:** 200 records
- **Infinite scroll support:** Use `X-Has-More` header to determine if more pages exist

### Database Indexes

The following indexes optimize provider queries:

```sql
-- Provider type filtering
CREATE INDEX idx_provider_profiles_provider_type ON provider_profiles(provider_type);

-- Status filtering
CREATE INDEX idx_provider_profiles_status ON provider_profiles(status);

-- Company name search (case-insensitive)
CREATE INDEX idx_companies_name_lower ON companies(lower(name));

-- Composite index for type + status
CREATE INDEX idx_provider_profiles_type_status ON provider_profiles(provider_type, status);
```

### Query Optimization

The API uses a single JOIN query to fetch provider data instead of multiple sequential queries:

```
Before: O(n * 4) queries (500k+ for 125k providers)
After:  O(1) query for paginated results
```

---

## OpenAPI Specification

The full API specification is available at `api/openapi.yaml`. Generate client libraries using:

```bash
openapi-generator-cli generate \
  -i api/openapi.yaml \
  -g dart-dio \
  -o openapi \
  --additional-properties=pubName=openapi,pubVersion=1.0.0
```
