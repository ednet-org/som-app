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
- Close inquiries and remove uploaded PDFs from the inquiry detail view.
- Browse ads and view statistics.
- Update profile details and change password from My Profile.

Provider
- View assigned inquiries, upload offers, and mark outcomes.
- Create ads in draft, activate/deactivate them from the ad detail view, and view provider statistics.
- Ads auto‑expire after their scheduled end date/banner day; admins receive an expiry email.
- Pending providers can log in but cannot access inquiries until approved.

Consultant
- Review all inquiries, filter, and forward to providers.
- Assignment selection warns when you exceed the allowed provider count.
- Manage branches/categories (including rename) and approve/decline pending provider branch requests (with optional rejection reason).
- Manage ads across companies.
- Consultants receive notifications when providers create or activate ads.
- Access cross-company statistics and exports.

Consultant Admin
- Manage consultants, companies, and provider subscription data.
- Create, update, or delete subscription plans; updates with active subscribers require confirmation.
- Provider admins can downgrade plans within the 3‑month renewal window.
- Activate or deactivate companies as needed.

## Seed Data
The system boots with sample companies, users, branches, inquiries, offers, and ads. This allows end-to-end exploration without manual setup. Data is stored in the local Supabase instance, so changes persist across restarts unless you reset the local DB.
