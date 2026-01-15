# User Guide (Demo)

## Demo Access
1. Start the full stack (see `documentation/TECHNICAL_GUIDE.md`).
2. Open `http://localhost:8090` in a browser.
3. In dev builds, use the quick login buttons (only visible when `DEV_QUICK_LOGIN=true`).
   If you override `DEV_FIXTURES_PASSWORD` or `SYSTEM_ADMIN_PASSWORD`, pass the
   same values to Flutter so the quick login buttons stay in sync.

## Demo Credentials
Use these accounts if you prefer manual login. Passwords come from your local
environment (`DEV_FIXTURES_PASSWORD` and `SYSTEM_ADMIN_PASSWORD`):

- System Admin: `system-admin@som.local` / `SYSTEM_ADMIN_PASSWORD` (default `ChangeMe123!`)
- Consultant Admin: `consultant-admin@som.local` / `DEV_FIXTURES_PASSWORD` (default `DevPass123!`)
- Consultant: `consultant@som.local` / `DEV_FIXTURES_PASSWORD`
- Buyer Admin: `buyer-admin@som.local` / `DEV_FIXTURES_PASSWORD`
- Buyer User: `buyer-user@som.local` / `DEV_FIXTURES_PASSWORD`
- Provider Admin: `provider-admin@som.local` / `DEV_FIXTURES_PASSWORD`
- Provider User: `provider-user@som.local` / `DEV_FIXTURES_PASSWORD`

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

Email Notifications (Local)
- Registration, welcome, password reset, and password change emails are written to `api/storage/outbox`.
- Email audit events are stored in the `email_events` table in the local Supabase DB.

## Seed Data
The system boots with sample companies, users, branches, inquiries, offers, and ads. This allows end-to-end exploration without manual setup. Data is stored in the local Supabase instance, so changes persist across restarts unless you reset the local DB.
