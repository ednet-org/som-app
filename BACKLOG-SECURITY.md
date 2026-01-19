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
- Public company listing/detail endpoints expose PII (addresses, registration numbers).
- Inquiry detail + offer list endpoints are missing buyer company ownership checks.
- Consultant‑admin governance is not consistently enforced (e.g., consultant creation, provider list access).
- Supabase RLS is not enabled; realtime uses anon key → potential leakage if direct access occurs.
- No rate limiting or origin allowlist in production.

---

## Backlog Items

### P0 — Tenant isolation on inquiry/offer detail
**Goal:** Buyers/providers cannot access cross‑tenant inquiries or offers.

- [ ] API: enforce buyer company ownership in `GET /inquiries/{id}`.
- [ ] API: enforce buyer company ownership in `GET /inquiries/{id}/offers`.
- [ ] API: ensure provider access requires assignment on offer list/detail routes.
- [ ] Tests: add cross‑tenant access checks for inquiry/offer routes.

### P0 — Lock down company endpoints
**Goal:** Company data is not publicly accessible.

- [ ] API: require auth for `GET /Companies` and `GET /Companies/{id}`.
- [ ] API: restrict to consultant or same‑company users; scrub sensitive fields in any public view.
- [ ] Tests: anonymous and cross‑tenant access cases.

### P0 — PDF access (Offers/Inquiries) (Done)
**Goal:** PDF files are accessible only to authorized users (buyer/provider company, consultants).

- [x] Bucket set to private and file paths stored (no public URLs).
- [x] Signed URL endpoints added with authZ checks (`/inquiries/{id}/pdf`, `/offers/{id}/pdf`).
- [x] UI downloads PDFs via signed URL endpoints.

### P0 — Centralize multi‑tenant authorization checks
**Goal:** Every API endpoint enforces resource‑level authorization.

- [ ] API: create shared access helpers for inquiry/offer/company checks to avoid drift.
- [ ] API: audit all routes that return tenant data (`inquiries`, `offers`, `ads`, `statistics`, `users`, `companies`, `providers`, `subscriptions`) and enforce scope.
- [ ] Tests: route‑level authorization coverage for each resource.

### P1 — Consultant‑admin governance
**Goal:** Admin‑only actions require consultant+admin.

- [ ] API: restrict consultant creation (`POST /consultants`) to consultant admin.
- [ ] API: require consultant admin for provider list access (`GET /providers`) and billing creation.
- [ ] Tests: governance checks for consultant admin vs consultant.

### P1 — Storage hardening
**Goal:** Tighten storage policies and upload validation.

- [ ] Supabase: configure bucket constraints (max size, allowed MIME types).
- [ ] API: validate MIME type and file size server‑side for PDFs.
- [ ] Infra: optional malware scanning pipeline for uploads (future).

### P1 — Supabase RLS + Realtime policies
**Goal:** Defense‑in‑depth tenant isolation in DB and realtime.

- [ ] DB: add RLS policies for `inquiries`, `offers`, `companies`, `users`, `ads`, `storage.objects`.
- [ ] Realtime: ensure subscriptions respect RLS (set auth, disable tables that should not broadcast).
- [ ] Tests: RLS policy verification for cross‑tenant access.

### P1 — Audit logging & monitoring
**Goal:** Trace access to sensitive resources (PDFs, user management, exports).

- [ ] API: log PDF download events (userId, companyId, offer/inquiryId, timestamp).
- [ ] API: capture admin actions (user create/delete, role changes, subscription changes).

### P1 — Rate limiting & abuse protection
**Goal:** Protect auth and export endpoints from brute‑force and scraping.

- [ ] Infra: add rate limits on login, password reset, export, and PDF download endpoints.
- [ ] API: return `429` on abuse thresholds.

### P2 — Secure exports
**Goal:** Ensure CSV exports are scoped and free of sensitive content.

- [ ] API: ensure export endpoints enforce tenant scope and exclude PDFs.
- [ ] API: add audit entries for exports.

### P2 — CORS & Production Hardening
**Goal:** Reduce attack surface for public deployments.

- [ ] API: restrict CORS allowlist via env (remove `*` in prod).
- [ ] API: add basic security headers (HSTS, X‑Content‑Type‑Options, CSP for web).

---

## Implementation Notes (Local vs Production)
- **Local:** Supabase CLI creates buckets; ensure bucket is private and constraints applied. API should generate signed URLs via service role client.
- **Production:** Same flow; verify bucket privacy and policies via Supabase dashboard. Secrets must be in environment variables; no hard‑coded keys.

## Status
- **Done:** Signed PDF URLs + private storage bucket + UI integration.
- **Next:** Close cross‑tenant access gaps on inquiry/offer/company routes + add RLS defense‑in‑depth.
