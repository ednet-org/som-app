# User Guide (Demo)

## Demo Access
1. Start the full stack (see `documentation/TECHNICAL_GUIDE.md`).
2. Open `http://localhost:8090` in a browser.
3. In dev builds, use the quick login buttons (only visible when `DEV_QUICK_LOGIN=true`).

## Demo Credentials
Use these accounts if you prefer manual login:

- System Admin: `system-admin@som.local` / `ChangeMe123!`
- Consultant Admin: `consultant-admin@som.local` / `DevPass123!`
- Consultant: `consultant@som.local` / `DevPass123!`
- Buyer Admin: `buyer-admin@som.local` / `DevPass123!`
- Buyer User: `buyer-user@som.local` / `DevPass123!`
- Provider Admin: `provider-admin@som.local` / `DevPass123!`
- Provider User: `provider-user@som.local` / `DevPass123!`

## What You Can Demo
Buyer
- Create inquiries with branch/category, deadlines, delivery ZIPs, and optional PDFs.
- Review offers, accept/reject, and export inquiry lists.
- Browse ads and view statistics.

Provider
- View assigned inquiries, upload offers, and mark outcomes.
- Manage ads (draft/active/expired) and view provider statistics.

Consultant
- Review all inquiries, filter, and forward to providers.
- Manage branches/categories and ads across companies.
- Access cross-company statistics and exports.

Consultant Admin
- Manage consultants and provider subscription data (demo data included).

## Seed Data
The system boots with sample companies, users, branches, inquiries, offers, and ads. This allows end-to-end exploration without manual setup. Data is stored in the local Supabase instance, so changes persist across restarts unless you reset the local DB.
