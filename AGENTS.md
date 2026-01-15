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
- Start Supabase: `scripts/start_supabase.sh` (ports are fixed in `supabase/config.toml`).
- Start API: `scripts/start_api.sh` (pulls Supabase keys via `supabase status`).
- Start Flutter: `scripts/start_flutter.sh`.

## Testing
- `dart test`
- `dart test api/test`
- `flutter test`
- `scripts/run_integration_tests.sh`

## LLM Instructions
- Follow TDD (red/green/refactor). Update or add tests before production code.
- Use Supabase for all persistence, auth, storage, and RLS; avoid ad-hoc local stores.
- Keep demo fixtures in `api/lib/services/system_bootstrap.dart` and ensure idempotent seeds.
- Do not add mocks outside test suites; keep shared test models centralized.
- Keep `documentation/USER_GUIDE.md` and `documentation/TECHNICAL_GUIDE.md` in sync with changes.
