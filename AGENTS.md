# Repository Guidelines

## Scope
This repository hosts the SOM Flutter web app and the Dart Frog API, backed by Supabase for auth, persistence, storage, and policies. It is greenfield work; keep app, API, and DB aligned to the latest schemas without backward compatibility.

## Project Structure
- `lib/`: Flutter app UI, state, and domain models.
- `api/`: Dart Frog API, repositories, and services.
- `supabase/`: local Supabase config and migrations.
- `documentation/`: domain model and product docs.
- `openapi/`: API specs and tests.

## Local Development
- Start Supabase: `supabase start` (ports are fixed in `supabase/config.toml`).
- Start API:
  `PORT=8081 dart run -DDEV_FIXTURES=true -DDEV_FIXTURES_PASSWORD='DevPass123!' \
  -DSUPABASE_URL=http://127.0.0.1:55511 \
  -DSUPABASE_ANON_KEY=... -DSUPABASE_SERVICE_ROLE_KEY=... \
  -DSUPABASE_JWT_SECRET=... build/bin/server.dart`
- Start Flutter:
  `flutter run -d chrome --web-port 8090 \
  --dart-define=API_BASE_URL=http://127.0.0.1:8081 \
  --dart-define=DEV_QUICK_LOGIN=true`

## Testing
- `dart test`
- `dart test api/test`
- `flutter test`
- `flutter test integration_test/ui_smoke_test.dart`

## LLM Instructions
- Follow TDD (red/green/refactor). Update or add tests before production code.
- Use Supabase for all persistence, auth, storage, and RLS; avoid ad-hoc local stores.
- Keep demo fixtures in `api/lib/services/system_bootstrap.dart` and ensure idempotent seeds.
- Do not add mocks outside test suites; keep shared test models centralized.
- Keep `documentation/USER_GUIDE.md` and `documentation/TECHNICAL_GUIDE.md` in sync with changes.
