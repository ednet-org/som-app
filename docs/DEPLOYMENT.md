# SOM Deployment Guide

## Quick Reference

| Environment | Frontend | API | Supabase |
|-------------|----------|-----|----------|
| **Staging** | https://ednet-som-staging.web.app | https://som-api-i3iupxxyxq-ew.a.run.app | 1Password: `som-staging/supabase` |

---

## Prerequisites

- **Flutter SDK** 3.8+
- **Dart Frog CLI**: `dart pub global activate dart_frog_cli`
- **Firebase CLI**: `npm install -g firebase-tools`
- **1Password CLI**: `brew install 1password-cli` (for secrets)
- **gcloud CLI**: https://cloud.google.com/sdk/docs/install

---

## Staging Deployment

### Frontend (Firebase Hosting)

```bash
# Build with secrets from 1Password
flutter build web --release \
  --dart-define=API_BASE_URL=https://som-api-i3iupxxyxq-ew.a.run.app \
  --dart-define=SUPABASE_URL="$(op read 'op://som-staging/supabase/api-url')" \
  --dart-define=SUPABASE_ANON_KEY="$(op read 'op://som-staging/supabase/anon-key')" \
  --dart-define=SUPABASE_SCHEMA=som \
  --dart-define=env=staging

# Deploy
firebase use staging
firebase deploy --only hosting
```

### Backend (Cloud Run)

```bash
cd api

# Deploy from source
gcloud run deploy som-api \
  --source . \
  --region=europe-west1 \
  --project=ednet-som-staging \
  --allow-unauthenticated \
  --memory=512Mi

# Or with Cloud Build (recommended)
SHORT_SHA=$(git rev-parse --short HEAD)
gcloud builds submit . \
  --config=cloudbuild.yaml \
  --project=ednet-som-staging \
  --substitutions=SHORT_SHA="${SHORT_SHA}",_SUPABASE_URL="$(op read 'op://som-staging/supabase/api-url')",_SUPABASE_ANON_KEY="$(op read 'op://som-staging/supabase/anon-key')"
```

---

## Build-time Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `API_BASE_URL` | Backend API URL | `https://som-api-xxx.run.app` |
| `SUPABASE_URL` | Supabase project URL | From 1Password |
| `SUPABASE_ANON_KEY` | Supabase anon key | From 1Password |
| `SUPABASE_SCHEMA` | Database schema | `som` |
| `env` | Environment name | `staging` / `production` |

---

## Test Users

Credentials in 1Password vault: `som-staging`

| Role | Email |
|------|-------|
| System Admin | sysadmin@test.som-staging.at |
| Consultant | consultant@test.som-staging.at |
| Buyer Admin | buyer-admin@test.som-staging.at |
| Provider Admin | provider-admin@test.som-staging.at |

---

## Troubleshooting

### CORS Errors
CORS is compile-time configured via `--build-arg`. Rebuild Docker image with correct origins.

### Supabase JWT (ES256)
New Supabase projects use asymmetric JWT. API fetches public key from JWKS endpoint automatically.

### WebSocket Fails
Check Supabase URL is correct and project isn't paused. Verify with:
```bash
curl -s "$(op read 'op://som-staging/supabase/api-url')/rest/v1/" \
  -H "apikey: $(op read 'op://som-staging/supabase/anon-key')"
```

### Cloud Run Deploy Fails
```bash
# Check build logs
gcloud builds list --project=ednet-som-staging --limit=1

# View specific build
gcloud builds log BUILD_ID --project=ednet-som-staging
```

---

## Key Files

| File | Purpose |
|------|---------|
| `firebase.json` | Firebase Hosting config |
| `cloudbuild.yaml` | Cloud Build CI/CD |
| `api/Dockerfile` | Backend Docker build |
| `api/pubspec.production.yaml` | Production dependencies |

---

## Rollback

**Frontend:**
```bash
firebase hosting:channel:list
# Use Firebase Console → Hosting → Release History → Rollback
```

**Backend:**
```bash
gcloud run revisions list --service=som-api --region=europe-west1
gcloud run services update-traffic som-api --to-revisions=REVISION_NAME=100
```

---

**Last Updated**: January 2026
