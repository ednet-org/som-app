# Security Backlog (Multi‑Tenant Resource Access)

## Scope
This backlog covers multi-tenant access control and data protection for SOM across the Flutter web app, Dart Frog API, and Supabase (auth, DB, storage). It is derived from **PM - SOM - User stories.md** and current implementation.

## Key Security Requirements (from user stories)
- Buyers and providers must only access inquiries/offers belonging to their company.
- Only assigned providers can access a buyer inquiry (including the inquiry PDF).
- Buyers can download offer PDFs for their inquiries; providers can download their own offer PDFs.
- Consultants and system admin can access everything.
- Admin role is a company admin; it must not grant cross‑tenant access by itself.
- CSV exports must exclude PDFs and must respect company scope.

## Current Gaps (high‑level)
- Storage bucket is public; offer/inquiry PDFs can be accessed by anyone with the URL.
- PDF download links are opened directly without authorization.
- API uses Supabase service role for data access, so **all** authorization must be enforced in API routes.

---

## Backlog Items

### P0 — Block public PDF access (Offers/Inquiries)
**Goal:** PDF files must be accessible only to authorized users (buyer/provider company, consultants, system admin).

- **Task:** Make Supabase bucket private; stop returning public URLs; store file paths; provide signed URLs via API.
- **Task:** Add `GET /inquiries/{inquiryId}/pdf` and `GET /offers/{offerId}/pdf` to return signed URLs after authZ checks.
- **Task:** Update UI to request signed URL via API before opening a PDF.
- **Acceptance:**
  - Anonymous or cross‑tenant users receive `401/403`.
  - Signed URLs expire quickly (e.g., 5 minutes).
  - PDF URLs are never public.

### P0 — Centralize multi‑tenant authorization checks
**Goal:** Every API endpoint enforces resource‑level authorization.

- **Task:** Create shared access helpers for inquiry/offer/company checks to avoid drift between routes.
- **Task:** Audit all routes that return tenant data (`inquiries`, `offers`, `ads`, `statistics`, `users`, `companies`, `providers`, `subscriptions`) and enforce scope.
- **Acceptance:**
  - All read/write routes verify company ownership or consultant role.
  - Provider access requires assignment where applicable.

### P0 — Ensure deactivated/locked users cannot access resources
**Goal:** Inactive/locked users are denied before any resource is returned.

- **Task:** Ensure `parseAuth` checks are used by all routes; deny access for inactive/locked users.
- **Acceptance:**
  - Deactivated users receive `401` across all protected endpoints.

### P1 — Storage hardening
**Goal:** Tighten storage policies and upload validation.

- **Task:** Set bucket to private and configure bucket constraints (max size, allowed MIME types) in Supabase.
- **Task:** Validate MIME type and file size server‑side for PDFs.
- **Task:** Add optional malware scanning pipeline for uploads (future).
- **Acceptance:**
  - Only PDFs within size limit are accepted.
  - Upload attempts with other types are rejected.

### P1 — Audit logging & monitoring
**Goal:** Trace access to sensitive resources (PDFs, user management, exports).

- **Task:** Log PDF download events (userId, companyId, offer/inquiryId, timestamp).
- **Task:** Capture admin actions (user create/delete, role changes, subscription changes).
- **Acceptance:**
  - Audit log entries exist for critical actions.

### P1 — Rate limiting & abuse protection
**Goal:** Protect auth and export endpoints from brute‑force and scraping.

- **Task:** Add rate limits on login, password reset, export, and PDF download endpoints.
- **Acceptance:**
  - Excess requests receive `429`.

### P2 — RLS alignment (Supabase)
**Goal:** Prepare for partial use of anon client or direct DB access when needed.

- **Task:** Add RLS policies for `inquiries`, `offers`, `companies`, `users`, `ads`, `storage.objects`.
- **Task:** Consider switching read queries to anon client for defense‑in‑depth.
- **Acceptance:**
  - RLS policies prevent cross‑tenant reads/writes.

### P2 — Secure exports
**Goal:** Ensure CSV exports are scoped and free of sensitive content.

- **Task:** Ensure export endpoints enforce tenant scope and exclude PDFs.
- **Task:** Add audit entries for exports.
- **Acceptance:**
  - CSV exports match scope and do not leak PDF paths or URLs.

---

## Implementation Notes (Local vs Production)
- **Local:** Supabase CLI creates buckets; ensure bucket is private and constraints applied. API should generate signed URLs via service role client.
- **Production:** Same flow; verify bucket privacy and policies via Supabase dashboard. Secrets must be in environment variables; no hard‑coded keys.

## Status
- **In progress (this change set):** Secure PDF access via private bucket + signed URLs + API authorization checks + UI update.
- **Next:** Systematic authorization audit across all routes + storage policies.
