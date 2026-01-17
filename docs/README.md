# SOM Documentation

Documentation for the Smart Offer Management platform.

## User Guides

- [Provider Management](PROVIDERS.md) - Managing provider companies (search, filter, approve/decline)

## Technical Documentation

- [API Documentation](../api/docs/API.md) - REST API endpoint reference
- [Architecture Documentation](../api/docs/ARCHITECTURE.md) - System architecture and design

## Quick Links

### For Consultants

- [Provider Management Guide](PROVIDERS.md) - How to manage providers with search and filters

### For Developers

- [API README](../api/README.md) - API setup and development
- [API Endpoints](../api/docs/API.md) - Full API reference
- [Architecture](../api/docs/ARCHITECTURE.md) - Technical architecture

## Recent Updates

### Provider Pagination (January 2026)

Added efficient pagination and search for 125k+ provider records:

- **Infinite scroll** in Flutter app
- **Search by company name** (case-insensitive)
- **Pagination headers** (`X-Total-Count`, `X-Has-More`)
- **Database indexes** for optimized queries
- **Performance improvement:** Response time from timeout to < 500ms

See [Provider Management](PROVIDERS.md) for usage details.
