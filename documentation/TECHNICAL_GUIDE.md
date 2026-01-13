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
supabase start
```
To obtain local keys and JWT secret:
```
supabase status
```

## Start API (Dart Frog)
```
PORT=8081 dart run \
  -DDEV_FIXTURES=true \
  -DDEV_FIXTURES_PASSWORD='DevPass123!' \
  -DSUPABASE_URL=http://127.0.0.1:55511 \
  -DSUPABASE_ANON_KEY=... \
  -DSUPABASE_SERVICE_ROLE_KEY=... \
  -DSUPABASE_JWT_SECRET=... \
  -DSUPABASE_STORAGE_BUCKET='som-assets' \
  build/bin/server.dart
```
The dev fixtures seed data for demo flows and are idempotent.

## Start Flutter Web
```
flutter run -d chrome --web-port 8090 \
  --dart-define=API_BASE_URL=http://127.0.0.1:8081 \
  --dart-define=DEV_QUICK_LOGIN=true
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
```
flutter test integration_test/ui_smoke_test.dart
```

## Code Generation
```
dart run build_runner build --delete-conflicting-outputs
```
