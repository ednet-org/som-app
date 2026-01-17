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

## Start Supabase
```
scripts/start_supabase.sh
```
This wrapper excludes the `vector` container (avoids Docker name conflicts).

If the schema changes, reset the local DB:
```
supabase db reset --yes
```
To obtain local keys and JWT secret:
```
supabase status
```

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

## Code Generation
```
dart run build_runner build --delete-conflicting-outputs
```
