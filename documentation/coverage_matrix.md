# SOM V2 Coverage Matrix (E2E)

## Contract/Spec Coherence
- **Current mismatch**: `swagger.json` exposes only legacy `/Companies`, `/Users`, `/Subscriptions`, `/auth/*` endpoints, while the live API routes and `openapi/` package include ads, branches, inquiries, offers, stats, consultants, and providers.
- **Impact**: Flutter SDK + API drift → non‑coherent E2E flows.

## Coverage Matrix (Product → API → DB → UI)

| Area | Requirement (V2) | API / Route | DB (Supabase) | UI (Flutter) | Status | Delta |
| --- | --- | --- | --- | --- | --- | --- |
| Registration | Buyer/provider registration with admin user | `POST /Companies` | `companies`, `users`, `provider_profiles`, `subscriptions` | `CustomerRegisterPage` + `RegistrationStepper` | Partial | Hardcoded plan/branch, no T&C validation, no URL validation, no password‑set flow |
| Registration | Email confirmation → set password → auto login | `GET /auth/confirmEmail`, `POST /auth/resetPassword` | `user_tokens`, `users` | `AuthConfirmEmailPage` | Missing | No set‑password endpoint, no auto‑login |
| Registration | Terms acceptance required | n/a | n/a | Registration UI | Missing | Add DB fields + API validation |
| Login/Logout | Login & session | `POST /auth/login` | Supabase Auth | `AuthLoginPage` | Partial | Logout not wired to Supabase/session state |
| Role Switch | Buyer↔Provider without re‑login | `POST /auth/switchRole` | `users.last_login_role` | n/a | Partial | Single company per user blocks dual role |
| User Mgmt | Admin create/update/deactivate users | `POST/PUT/DELETE /Companies/{id}/users/*` | `users` | `UserAppBody` | Partial | Missing auth/role enforcement + UI wiring |
| Buyer Inquiries | Create inquiry + upload PDF + criteria | `POST /inquiries` | `inquiries`, `products` | `InquiryAppBody` | Partial | UI uses mock data, no filters, no PDF download |
| Buyer Offers | Accept/Reject offers + email | `POST /offers/{id}/accept|reject` | `offers`, `inquiries` | n/a | Partial | Missing UI, no contact payload in email |
| Buyer Notifications | Offer count/deadline email | Scheduler | `inquiries`, `offers` | n/a | Partial | No links, no templates, no UI hooks |
| Buyer Stats | Open/closed per user + CSV | `GET /stats/buyer` | `inquiries`, `users` | `StatisticsAppBody` | Partial | UI stub, missing per‑user breakdown |
| Provider Registration | Branch approval workflow | `POST /providers/{id}/approve|decline` | `provider_profiles`, `branches` | Registration UI | Partial | UI lacks approval states and consultant queue |
| Provider Inquiries | List/filter/export | `GET /inquiries` | `inquiries`, `inquiry_assignments` | n/a | Missing | Filters + CSV not implemented |
| Provider Offers | Upload offer + decline + statuses | `POST /inquiries/{id}/offers` | `offers` | n/a | Partial | No decline endpoint, no full status lifecycle |
| Provider Ads | CRUD + schedule rules | `GET/POST /ads`, `PUT/DELETE /ads/{id}` | `ads`, `subscription_plans` | `AdsAppBody` | Partial | UI stub, missing activate/reactivate flows |
| Provider Stats | Per‑user stats + CSV | `GET /stats/provider` | `offers`, `inquiries` | `StatisticsAppBody` | Partial | Missing per‑user aggregation + UI |
| Consultant Mgmt | Create consultants | `POST /consultants` | `users` | n/a | Partial | UI missing |
| Consultant Inquiries | Assign providers + filters | `POST /inquiries/{id}/assign` | `inquiry_assignments` | n/a | Partial | Missing provider suggestion filters + UI |
| Branch Mgmt | Add/delete branches/categories | `/branches`, `/categories` | `branches`, `categories` | n/a | Partial | UI missing |
| Consultant Stats | Status/period/provider type/size + CSV | `GET /stats/consultant` | `inquiries`, `offers` | `StatisticsAppBody` | Partial | Missing required stats dimensions |

## Immediate E2E Gaps (Blocking)
1) Single‑company user model blocks buyer+provider dual role.
2) No password‑set confirmation flow; registration cannot complete as specified.
3) UI is largely stubbed (inquiries/ads/stats) and not wired to API.
4) Contract drift between `swagger.json` and `openapi/` breaks SDK coherence.
5) Terms acceptance and role‑based authorization are missing on critical routes.

