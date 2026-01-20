# Domain Delta Backlog (som.manager.yaml vs current system)

## User & Access Management
### Epic: Account Security & Lifecycle
- [x] DB: add failed_login_attempts, last_failed_login_at, locked_at, lock_reason to users table.
- [x] API: increment failed attempts on login failure and lock account at threshold (>=5).
- [x] API: add unlock endpoint for consultant admin and system admin.
- [x] UI: show lockout message and lockout reason on login failure.
- [x] Tests: unit + integration tests for lockout and unlock flows.

### Epic: Password & Session Management
- [x] API: add authenticated change-password endpoint (requires current password).
- [x] UI: add change-password form in profile menu for logged-in users.
- [x] API: invalidate refresh token on logout (Supabase sign-out) and clear session.
- [x] UI: logout should revoke session and redirect to login.
- [x] Tests: integration tests for change password, logout, and session invalidation.

### Epic: Role Management & Governance
- [x] DB: add roles table if dynamic roles are required (or document fixed roles policy).
- [x] API: add role CRUD for consultant admin if dynamic roles are required.
- [x] UI: add role management page for consultant admin if roles are dynamic.
- [x] Tests: role CRUD + authorization tests (consultant/admin only).

### Epic: User Notifications
- [x] API: send welcome email on activation and password-changed notification on change.
- [x] DB: store email event audit entries (user_id, type, created_at).
- [x] Tests: email event creation + content templates.

## Company Management
### Epic: Company Status Lifecycle
- [x] DB: ensure company status supports active/inactive/pending (if not present).
- [x] API: add activate/reactivate company endpoint (consultant/admin).
- [x] UI: add company activate/reactivate controls in Company/Companies pages.
- [x] Tests: company activate/deactivate with role checks.

### Epic: Company Type Policy Enforcement
- [x] API: enforce buyerRole/providerRole selection on register/update (error if neither).
- [x] UI: enforce type selection validation at registration and company edit.
- [x] Tests: registration/update validation for type selection.

### Epic: User Association Management
- [x] API: add explicit remove-user command with notification (distinct from deactivate).
- [x] UI: add remove user action for company admin with confirmation.
- [x] Tests: remove user notification and permission enforcement.

### Epic: Company Notifications
- [x] API: notify consultants/admins on company registration/update/activation/deactivation.
- [x] Tests: verify notification triggers for each company lifecycle event.

## Provider Company & Provider Profile
### Epic: Provider Product Catalog
- [x] DB: add provider_products table or provider_products_json on provider_profiles.
- [x] API: CRUD provider products (branch/category/product tags).
- [x] UI: provider product editor in Company Management.
- [x] Tests: product CRUD and visibility scoped to provider company.

### Epic: Provider Registration Status Enforcement
- [x] API: block inquiry assignment to provider companies with status != active.
- [x] API: block provider inquiry list access when status is pending.
- [x] UI: show pending registration banner for providers.
- [x] Tests: assignment and provider query constraints for pending providers.

### Epic: Provider Registration Rejection Handling
- [x] DB: store rejection reason and rejected_at on provider_profiles.
- [x] API: include rejection reason in provider summary and approve/decline endpoints.
- [x] UI: show rejection reason to provider admin and consultant.
- [x] Tests: decline flow persists reason and notifies provider admin.

### Epic: Payment Details Management
- [x] API: add update payment details endpoint (IBAN/BIC/owner) with validation.
- [x] UI: provider admin payment details form in Company Management.
- [x] Tests: payment update with audit log and permission checks.

## Subscription Catalog & Policies
### Epic: Subscription Catalog Completeness
- [x] DB: add subscription fields (maxUsers, setupFee, bannerAdsPerMonth, normalAdsPerMonth, freeMonths, commitmentPeriod).
- [x] API: extend subscription plan DTOs to include new fields.
- [x] UI: update Subscriptions page to edit new fields.
- [x] Tests: subscription CRUD covers all new fields.

### Epic: Subscription Enforcement Policies
- [x] API: enforce company user limit when adding/registering users.
- [x] UI: show user limit errors in user management.
- [x] Tests: user limit policy enforcement.

### Epic: Subscription Downgrade Rules
- [x] API: add downgrade endpoint with rule (allowed only within 3 months of renewal).
- [x] UI: show downgrade options with eligibility window and confirmation.
- [x] Tests: downgrade allowed/blocked cases.

### Epic: Subscription Update Policy
- [x] API: require confirmation for plan updates if active subscribers exist.
- [x] UI: prompt confirmation when updating plans with subscribers.
- [x] Tests: update policy enforcement.

## Inquiry Management
### Epic: Inquiry Attachment Lifecycle
- [x] API: add remove inquiry attachment endpoint (delete from storage, clear pdfPath).
- [x] UI: add remove attachment button in inquiry detail.
- [x] Tests: attachment upload/remove and storage cleanup.

### Epic: Inquiry Status Lifecycle
- [x] API: add explicit close inquiry endpoint (buyer/admin/consultant).
- [x] API: persist assignment date when assigning providers.
- [x] UI: add close inquiry action and show assignment/closed dates.
- [x] Tests: inquiry status transitions and audit fields.

### Epic: Provider Assignment Policy
- [x] API: enforce assignedProviders.count <= numberOfProviders.
- [x] UI: warn when selection exceeds allowed number.
- [x] Tests: assignment limit enforcement.

### Epic: Deadline Notifications
- [x] API: ensure assignment triggers provider notifications and deadline reminders.
- [x] Scheduler: add deadline reminder job and buyer notification at deadline.
- [x] Tests: notification scheduling and delivery checks.

## Offer Management
### Epic: Offer Creation Policy
- [x] API: enforce offer creation only before inquiry deadline.
- [x] API: require provider is assigned to inquiry before creating offer.
- [x] Tests: deadline and assignment constraints.

### Epic: Offer Status Normalization
- [x] API: align provider lifecycle statuses (open/offer_created/lost/won/ignored) with buyer decisions.
- [x] UI: map statuses consistently in provider and buyer offer views.
- [x] Tests: status mapping and transitions.

### Epic: All-Offers-Received Signal
- [x] API: emit event when offer count reaches numberOfProviders.
- [x] API: notify buyer when all offers received and include inquiry link.
- [x] Tests: offer count threshold notifications.

## Advertisement Management
### Epic: Ad Activation Lifecycle
- [x] API: add explicit activate/deactivate endpoints (separate from update).
- [x] UI: add activate/deactivate actions and show status timeline.
- [x] Tests: status transition and permission checks.

### Epic: Ad Notifications & Expiry
- [x] Scheduler: add ad expiry job to mark expired and notify provider.
- [x] API: notify consultant on new ad creation/activation.
- [x] Tests: expiry job and notification triggers.

## Branch & Category Management
### Epic: Update Operations
- [x] API: add branch update endpoint (rename) and category update endpoint.
- [x] UI: add edit branch/category dialogs.
- [x] Tests: update operations with consultant permissions.

### Epic: Provider Impact Notifications
- [x] API: notify affected providers on branch/category deletion or rename.
- [x] Tests: notification delivery when branch/category changes.

## Cross-Cutting Policies & Events
### Epic: Domain Events
- [x] API: introduce domain event emission for command success/failure (per DSL triggers).
- [x] Service: add event handlers for notifications and policy enforcement.
- [x] Tests: event emission and handler execution.

### Epic: Audit & Compliance
- [x] DB: add audit_log table (actor, action, entity, metadata, timestamp).
- [x] API: log security-sensitive actions (login failure, role change, subscription change).
- [x] UI: add consultant admin audit viewer.
- [x] Tests: audit log created for security actions.

## Data Model & EDNet Alignment
### Epic: Aggregate Alignment
- [x] Align EDNet aggregates with DSL entities and required attributes.
- [x] Enforce relation invariants (offer↔inquiry↔provider, inquiry↔creator, provider↔subscription).
- [x] Add schema version checks on startup to ensure DB matches DSL attributes.
- [x] Tests: invariant enforcement and schema version validation.

## Infrastructure & Platform
### Epic: Email Delivery & Templates
- [x] API: replace file-based `EmailService` with a provider-backed implementation (SMTP/SendGrid) selected by env.
- [x] API: introduce HTML/text templates (EN/DE) for registration, reminders, offers, ads, and admin actions.
- [x] Docs: document local Inbucket workflow + production SMTP configuration + `APP_BASE_URL` behavior.
- [x] Tests: template rendering and provider selection for local vs prod.

### Epic: Background Jobs & Reliability
- [x] Infra: move `Scheduler` jobs (expiry reminders, offer deadline checks, ad expiry) to a dedicated worker or Supabase cron/edge job.
- [x] API: add health/status endpoint exposing last-run timestamps for scheduled tasks.
- [x] Tests: job idempotency and failure recovery.

### Epic: CSV Export Completeness
- [x] API: align inquiry CSV export with user story fields (full list columns + offer details, exclude PDFs).
- [x] API: add per-user stats CSVs for buyer/provider as specified in user stories.
- [x] UI: wire export buttons to include active filters and provide download feedback.
- [x] Tests: CSV content, headers, and escaping for commas/newlines.

### Epic: PDF Generation (Optional/If Required)
- [x] API: add PDF generation for inquiry/offer summaries and store via Supabase Storage.
- [x] UI: add “Generate PDF” actions alongside upload/download.
- [x] Tests: PDF generation with representative data.

### Epic: Multi‑Role / Multi‑Company Accounts
- [x] Data: support a single email having both buyer and provider roles (same or multiple companies).
- [x] API: update role switching to include company context and validate access.
- [x] UI: add role/company switcher and persist last context.
- [x] Tests: cross‑role session switching and access checks.

### Epic: Local Provisioning & Domains
- [x] Scripts/Docs: add local domain mapping guidance (e.g., `som.localhost`, `tenant.localhost`) and align Supabase auth redirects.
- [x] Config: add `.env.example` with `APP_BASE_URL`, `API_BASE_URL`, and Supabase keys for local/prod.
