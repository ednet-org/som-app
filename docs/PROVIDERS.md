# Provider Management

## Overview

The Provider Management feature allows consultant administrators to view, search, filter, and manage provider companies in the SOM platform. The system supports over 125,000 provider records with efficient pagination and search.

## Accessing Provider Management

1. Log in as a consultant administrator
2. Navigate to the **Providers** section from the main menu
3. The provider list loads automatically with the first 50 providers

## Features

### Search

Search for providers by company name:

1. Enter a search term in the search bar at the top
2. Press Enter to search
3. Results are filtered to show only matching companies
4. Search is case-insensitive (searching "acme" matches "ACME Corporation")

To clear the search:
- Click the **X** button in the search bar, or
- Delete the search text and press Enter

### Filters

Filter providers using the expandable **Filters** panel:

| Filter | Description |
|--------|-------------|
| **Branch** | Filter by assigned branch |
| **Company Size** | Filter by employee count (0-10, 11-50, 51-100, 101-250, 251-500, 500+) |
| **Provider Type** | Filter by type (Händler, Hersteller, Dienstleister, Großhändler) |
| **ZIP Prefix** | Filter by postal code starting with specified digits |
| **Status** | Filter by status (Active, Pending, Declined) |
| **Claimed** | Filter by claimed status (Claimed = active providers) |

**To apply filters:**
1. Expand the **Filters** section
2. Select desired filter values
3. Click **Apply**

**To clear all filters:**
- Click **Clear** to reset all filters

### Infinite Scroll

The provider list uses infinite scroll for efficient browsing:

- Initial load shows the first 50 providers
- Scroll down to automatically load more
- A loading indicator appears while fetching
- The toolbar shows total count: "Providers (125,010 total)"

### Provider Details

Click on any provider in the list to view details:

- **Company Information:** Name, ID, size, type, postcode
- **Branch Assignments:** Active and pending branches
- **Status:** Current status with rejection details if applicable
- **Subscription:** Plan and payment interval
- **Bank Details:** IBAN, BIC, account owner
- **Registration Date:** When the provider registered

### Approval Actions

For providers with pending status or pending branch requests:

**Approve:**
1. Select the provider
2. Click **Approve** button
3. All pending branches will be approved

**Decline:**
1. Select the provider
2. Click **Decline** button
3. Enter a reason for declining
4. Click **Decline** to confirm

### Quick Actions

| Action | Description |
|--------|-------------|
| **Refresh** | Reload the provider list |
| **Pending Approval** | Quick filter to show only pending providers |
| **Export CSV** | Download all matching providers as CSV |

## CSV Export

Export provider data for reporting:

1. Apply any desired filters/search
2. Click **Export CSV**
3. Download includes: company name, subscription plan, registration date, bank details, payment interval

**Note:** CSV export respects current filters but includes all matching records (not just the current page).

## Troubleshooting

### Provider list not loading

- Check your internet connection
- Verify you have consultant administrator access
- Click **Refresh** to retry
- Check browser console for error messages

### Search returns no results

- Verify spelling of company name
- Try a partial name (e.g., "Acme" instead of "Acme Corporation")
- Clear filters that might be excluding results

### Slow performance

The system is optimized for 125,000+ providers:
- Use search to narrow results
- Apply filters to reduce dataset
- Initial page loads should complete in < 1 second

## Provider Selection for Inquiries

When assigning providers to an inquiry:

1. Click **Assign Providers** on an inquiry detail view
2. The provider selection dialog opens with pagination support
3. Use search or filters to find specific providers
4. Select providers using checkboxes (respects max provider limit)
5. Click **Assign** to forward the inquiry to selected providers

The dialog supports:
- **Search by company name** (case-insensitive)
- **Filter by branch, type, size, ZIP prefix**
- **Infinite scroll** for browsing large datasets
- **Selection count** with limit validation

## Technical Details

For developers and administrators:

- **API Endpoint:** `GET /providers`
- **Page Size:** 50 records per request
- **Maximum Page Size:** 200 records
- **Pagination Headers:** `X-Total-Count`, `X-Has-More`

### Flutter Components

| Component | Location | Purpose |
|-----------|----------|---------|
| ProvidersAppBody | `lib/ui/pages/providers/` | Main provider management page |
| ProviderSelectionDialog | `lib/ui/pages/inquiry/widgets/` | Multi-select dialog for inquiries |

See [API Documentation](../api/docs/API.md) for endpoint details.
See [Architecture Documentation](../api/docs/ARCHITECTURE.md) for technical architecture.
