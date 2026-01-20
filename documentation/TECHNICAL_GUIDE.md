# Technical Guide (Local Full Stack)

## Prerequisites
- Flutter + Dart SDK
- Supabase CLI
- Chrome (for web) or another Flutter-supported target

## Ports (Fixed)
- Supabase API: `http://127.0.0.1:55511`
- Supabase DB: `127.0.0.1:55512`
- Supabase Studio: `http://127.0.0.1:55513`
- Supabase Inbucket: `http://127.0.0.1:55514`
- API Server: `http://127.0.0.1:8081`
- Flutter Web: `http://localhost:8090`

## Local Domains (Optional)
For tenant-style domains in local dev (recommended for auth redirect testing):

1) Add hosts entries:
```
127.0.0.1 som.localhost tenant.localhost
```

Or run the helper (idempotent; prints instructions if missing):
```
scripts/ensure_hosts.sh
```
Optional flags:
- `SOM_REQUIRE_HOSTS=true` to fail if entries are missing.
- `SOM_SKIP_HOSTS_CHECK=true` to skip the check entirely.
- `SOM_PING_HOSTS=false` to skip the ping verification.

2) Update `supabase/config.toml`:
- `site_url = "http://som.localhost:8090"`
- `additional_redirect_urls = ["http://som.localhost:8090/*", "http://tenant.localhost:8090/*"]`

3) Export app URLs:
```
export APP_BASE_URL=http://som.localhost:8090
export API_BASE_URL=http://127.0.0.1:8081
export CORS_ALLOWED_ORIGINS=http://som.localhost:8090,http://tenant.localhost:8090
```

`APP_BASE_URL` is used by the API for email links (activation, reset, notifications).

If DNS caching blocks the hostname:
```
sudo sh -c 'printf "127.0.0.1 som.localhost tenant.localhost\n" >> /etc/hosts'
sudo dscacheutil -flushcache
ping -c 1 som.localhost
```
Expected:
```
PING som.localhost (127.0.0.1): 56 data bytes
64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=...
```

## Start Supabase
```
scripts/start_supabase.sh
```
This wrapper excludes the `vector` container (avoids Docker name conflicts).
It also applies migrations and privileged storage RLS (if enabled).

Optional config:
- `SUPABASE_PROJECT_ID` to pin the project container name.
- `SUPABASE_APPLY_STORAGE_RLS` (default true)
- `SUPABASE_APPLY_STORAGE_RLS_STRICT` (default false; true fails if RLS apply fails).
- `SUPABASE_SCHEMA` defaults to `som` (dedicated schema for app data).

Manual re-apply (privileged):
```
scripts/apply_storage_rls.sh
```

Environment template:
- Copy `.env.example` to `.env` and update keys if you want to run without the helper scripts.

If the schema changes, reset the local DB:
```
supabase db reset --yes
```
To obtain local keys and JWT secret:
```
supabase status
```

## Email (Local Inbucket / SMTP)
- Local uses Supabase Inbucket at `http://127.0.0.1:55514` (view sent emails).
- `scripts/start_api.sh` defaults to SMTP delivery via Inbucket. Override:
  - `EMAIL_PROVIDER=outbox` to write mail to `api/storage/outbox`
  - `EMAIL_PROVIDER=sendgrid` with `SENDGRID_API_KEY` for production.
- SMTP envs: `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `SMTP_USE_TLS`.

## Start API (Dart Frog)
```
scripts/start_api.sh
```
The dev fixtures seed data for demo flows and are idempotent.
API logs are written to `api/storage/logs/api.log` when using `scripts/start_full_stack.sh`.

## Start Flutter Web
```
scripts/start_flutter.sh
```
Optional overrides:
- `DEV_FIXTURES_PASSWORD` (default `DevPass123!`)
- `SYSTEM_ADMIN_EMAIL` (default `system-admin@som.local`)
- `SYSTEM_ADMIN_PASSWORD` (default `ChangeMe123!`)
- `FLUTTER_WEB_MODE=release` to build a production-like web bundle and serve `build/web` via `python3 -m http.server`.

## Start Flutter macOS (Debug/Profile)
Debug mode on macOS uses JIT entitlements and can fail with:
`Error waiting for a debug connection: The log reader stopped unexpectedly`
and an `amfid` log mentioning provisioning profiles.

If that happens:
- Open `macos/Runner.xcworkspace` in Xcode and set the signing Team for the Runner target.
- Enable "Automatically manage signing" and let Xcode create/install a Mac Development provisioning profile.
- Rebuild with `flutter run -d macos`.

If debug still fails, run in profile mode:
```
flutter run -d macos --profile \
  --dart-define=API_BASE_URL=http://127.0.0.1:8081 \
  --dart-define=DEV_QUICK_LOGIN=true
```

Note: `macos/Runner/DebugProfile.entitlements` explicitly sets
`com.apple.security.get-task-allow` to `false`. If you need LLDB attach,
set it back to `true` and ensure a valid Mac Development profile is installed.

## Full Stack (Supabase + API + Flutter)
```
scripts/start_full_stack.sh
```
Disable Flutter launch:
```
START_FLUTTER=false scripts/start_full_stack.sh
```

## Tests
```
dart test
```
```
dart test api/test
```
```
flutter test
```
Start Supabase + API before integration tests. Run integration tests one-by-one on macOS:
```
scripts/run_integration_tests.sh
```
Running each test individually avoids macOS runner connection issues.
The integration script stubs `open` to avoid macOS foreground warnings during headless runs.
The integration script also starts Supabase and the API automatically and writes
logs to `api/storage/logs/api-test.log`.

## GitHub Actions (Local Supabase CI)
To run integration tests in GitHub Actions using local Supabase:
- Install Supabase CLI (npm).
- Ensure Docker is available.
- Run `scripts/run_integration_tests.sh` with:
  - `DEVICE=chrome`
  - `SUPABASE_PROJECT_ID` set to match the Supabase container name (e.g., `som-app`)
  - `SUPABASE_APPLY_STORAGE_RLS_STRICT=true`
  - `SOM_SKIP_HOSTS_CHECK=true` (skip `/etc/hosts` edits in CI)

Secrets/inputs needed (if enabling deploy workflows):
- `FIREBASE_SERVICE_ACCOUNT_SMART_OFFER_MANAGEMENT` for Firebase Hosting workflows.

## Code Generation
```
dart run build_runner build --delete-conflicting-outputs
```
