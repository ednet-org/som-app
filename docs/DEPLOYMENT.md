# SOM Deployment Guide

Comprehensive deployment guide for the Smart Offer Management (SOM) Flutter application and Dart Frog API backend.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Configuration](#environment-configuration)
- [Backend Deployment (Dart Frog API)](#backend-deployment-dart-frog-api)
- [Frontend Deployment](#frontend-deployment)
- [Supabase Setup](#supabase-setup)
- [Firebase Setup (Optional)](#firebase-setup-optional)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring & Logging](#monitoring--logging)
- [Rollback Procedures](#rollback-procedures)
- [Additional Resources](#additional-resources)

---

## Prerequisites

### Required Tools

- **Flutter SDK**: 3.8.0 or higher
  ```bash
  flutter --version
  # Flutter 3.8.0 or higher required
  ```

- **Dart SDK**: 3.0.0 or higher (bundled with Flutter)
  ```bash
  dart --version
  # Dart SDK version: 3.0.0 or higher
  ```

- **Dart Frog CLI**: Latest version
  ```bash
  dart pub global activate dart_frog_cli
  dart_frog --version
  ```

### Required Accounts

- **Supabase Account**: For PostgreSQL database, authentication, and storage
  - Sign up at [supabase.com](https://supabase.com)
  - Create a new project
  - Note your project URL and anon/service role keys

- **Firebase Account** (Optional): For web hosting and analytics
  - Sign up at [firebase.google.com](https://firebase.google.com)
  - Create a new project
  - Install Firebase CLI: `npm install -g firebase-tools`

### Development Tools

- **Git**: Version control
- **VS Code** or **Android Studio**: Recommended IDEs
- **Docker** (Optional): For local Supabase development
- **PostgreSQL Client**: For database management (psql, pgAdmin, or DBeaver)

---

## Environment Configuration

### 1. Environment Variables Setup

Copy the example environment file and configure for your environment:

```bash
cp .env.example .env
```

### 2. Required Environment Variables

#### API Configuration (Dart Frog Backend)

```bash
# API Base URL
APP_BASE_URL=http://localhost:8090

# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
SUPABASE_JWT_SECRET=your_jwt_secret_here
SUPABASE_STORAGE_BUCKET=som-assets
SUPABASE_SCHEMA=som
SUPABASE_PROJECT_ID=your_project_id
SUPABASE_APPLY_STORAGE_RLS=true
SUPABASE_APPLY_STORAGE_RLS_STRICT=false

# Development Fixtures
DEV_FIXTURES=true
DEV_FIXTURES_PASSWORD=DevPass123!
SYSTEM_ADMIN_EMAIL=admin@yourdomain.com
SYSTEM_ADMIN_PASSWORD=SecurePassword123!
```

#### Email Configuration

```bash
# Email Provider (smtp or sendgrid)
EMAIL_PROVIDER=smtp
EMAIL_FROM=no-reply@yourdomain.com
EMAIL_FROM_NAME=SOM
EMAIL_DEFAULT_LOCALE=en

# SMTP Configuration
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USERNAME=apikey
SMTP_PASSWORD=your_sendgrid_api_key
SMTP_USE_TLS=true
SMTP_ALLOW_INSECURE=false

# SendGrid (Alternative)
SENDGRID_API_KEY=your_sendgrid_api_key
```

#### Security & CORS

```bash
# CORS Configuration
CORS_ALLOWED_ORIGINS=https://yourdomain.com,https://app.yourdomain.com
CORS_ALLOW_CREDENTIALS=true

# Security Headers
ENABLE_HSTS=true
HSTS_MAX_AGE_SECONDS=31536000
CSP=default-src 'self'; script-src 'self' 'unsafe-inline'
```

#### Rate Limiting

```bash
# Rate Limits (requests per window)
RATE_LIMIT_LOGIN=10
RATE_LIMIT_LOGIN_WINDOW_MINUTES=15
RATE_LIMIT_RESET=5
RATE_LIMIT_RESET_WINDOW_MINUTES=15
RATE_LIMIT_PDF=60
RATE_LIMIT_PDF_WINDOW_MINUTES=60
RATE_LIMIT_EXPORT=20
RATE_LIMIT_EXPORT_WINDOW_MINUTES=60
```

#### Scheduler Configuration

```bash
# Background Scheduler
ENABLE_SCHEDULER=true
SCHEDULER_INTERVAL_MINUTES=5
SCHEDULER_RUN_ONCE=false
```

#### Flutter App Configuration

```bash
# Flutter Runtime (for web/mobile builds)
API_BASE_URL=https://api.yourdomain.com
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SCHEMA=som
DEV_QUICK_LOGIN=false
```

### 3. Build-time Configuration

Pass environment variables to Flutter builds using `--dart-define`:

```bash
flutter build web \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key
```

Or create a `.env.production` file and use a script to load variables.

---

## Backend Deployment (Dart Frog API)

### Local Development

Start the Dart Frog development server:

```bash
cd api
dart_frog dev
```

The API will be available at `http://localhost:8080`.

### Production Build

Build the production-ready server:

```bash
cd api
dart_frog build
```

This generates a standalone executable in `api/build/bin/server.exe`.

### Deployment Options

#### Option 1: Google Cloud Run

1. **Create a Dockerfile** (if not exists):

```dockerfile
FROM dart:stable AS build

WORKDIR /app
COPY api/pubspec.* ./
RUN dart pub get

COPY api/ .
RUN dart_frog build

FROM dart:stable-slim
COPY --from=build /app/build /app
WORKDIR /app

EXPOSE 8080
CMD ["./bin/server"]
```

2. **Build and deploy**:

```bash
# Build Docker image
docker build -t som-api .

# Tag for Google Cloud
docker tag som-api gcr.io/YOUR_PROJECT_ID/som-api

# Push to Google Container Registry
docker push gcr.io/YOUR_PROJECT_ID/som-api

# Deploy to Cloud Run
gcloud run deploy som-api \
  --image gcr.io/YOUR_PROJECT_ID/som-api \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars="$(cat .env.production | xargs)"
```

#### Option 2: Railway

1. **Connect your repository** to Railway
2. **Set environment variables** in Railway dashboard
3. **Deploy**:

```bash
# Railway auto-deploys on git push
git push origin main
```

Railway will automatically detect the Dart Frog API and deploy it.

#### Option 3: Fly.io

1. **Install Fly CLI**:

```bash
curl -L https://fly.io/install.sh | sh
```

2. **Initialize Fly app**:

```bash
cd api
fly launch
```

3. **Set environment variables**:

```bash
fly secrets set SUPABASE_URL=https://your-project.supabase.co
fly secrets set SUPABASE_ANON_KEY=your_key
# ... set all required secrets
```

4. **Deploy**:

```bash
fly deploy
```

#### Option 4: Self-Hosted (Linux/VPS)

1. **Copy build to server**:

```bash
scp -r api/build/* user@yourserver.com:/var/som-api/
```

2. **Create systemd service** (`/etc/systemd/system/som-api.service`):

```ini
[Unit]
Description=SOM Dart Frog API
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/som-api
EnvironmentFile=/var/som-api/.env
ExecStart=/var/som-api/bin/server
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

3. **Start service**:

```bash
sudo systemctl daemon-reload
sudo systemctl enable som-api
sudo systemctl start som-api
```

4. **Setup reverse proxy** (Nginx):

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

---

## Frontend Deployment

### Web Deployment

#### Build for Production

```bash
flutter build web --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key \
  --dart-define=SUPABASE_SCHEMA=som
```

Output will be in `build/web/`.

#### Deploy to Firebase Hosting

```bash
firebase login
firebase init hosting
# Select build/web as public directory
firebase deploy --only hosting
```

#### Deploy to Netlify

```bash
npm install -g netlify-cli
netlify login
netlify deploy --prod --dir=build/web
```

#### Deploy to Vercel

```bash
npm install -g vercel
vercel --prod build/web
```

### Android Deployment

#### Build APK

```bash
flutter build apk --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Build App Bundle (for Google Play)

```bash
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key
```

Output: `build/app/outputs/bundle/release/app-release.aab`

Upload to [Google Play Console](https://play.google.com/console).

### iOS Deployment

#### Build IPA

```bash
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your_key
```

Output: `build/ios/ipa/som.ipa`

Upload to [App Store Connect](https://appstoreconnect.apple.com/) using Xcode or Transporter.

### Desktop Builds

#### macOS

```bash
flutter build macos --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com
```

Output: `build/macos/Build/Products/Release/som.app`

#### Linux

```bash
flutter build linux --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com
```

Output: `build/linux/x64/release/bundle/`

#### Windows

```bash
flutter build windows --release \
  --dart-define=API_BASE_URL=https://api.yourdomain.com
```

Output: `build/windows/runner/Release/`

---

## Supabase Setup

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Note your project URL and API keys
3. Configure project settings

### 2. Database Schema Setup

Run the database migrations:

```sql
-- Create SOM schema
CREATE SCHEMA IF NOT EXISTS som;

-- Set search path
SET search_path TO som, public;

-- Create tables (example)
CREATE TABLE som.inquiries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE som.companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Add indexes for performance
CREATE INDEX idx_companies_name ON som.companies(name);
CREATE INDEX idx_inquiries_status ON som.inquiries(status);
```

You can also use Supabase Dashboard SQL Editor to run migrations.

### 3. Row Level Security (RLS) Policies

Enable RLS and create policies:

```sql
-- Enable RLS on tables
ALTER TABLE som.inquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE som.companies ENABLE ROW LEVEL SECURITY;

-- Example: Allow authenticated users to read all inquiries
CREATE POLICY "Allow authenticated read on inquiries"
  ON som.inquiries
  FOR SELECT
  TO authenticated
  USING (true);

-- Example: Allow users to update their own inquiries
CREATE POLICY "Allow users to update own inquiries"
  ON som.inquiries
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id);

-- Example: Allow service role full access
CREATE POLICY "Service role full access on companies"
  ON som.companies
  FOR ALL
  TO service_role
  USING (true);
```

### 4. Storage Buckets Configuration

Create storage buckets for file uploads:

```sql
-- Create bucket for SOM assets
INSERT INTO storage.buckets (id, name, public)
VALUES ('som-assets', 'som-assets', false);

-- Set RLS policies for storage
CREATE POLICY "Allow authenticated users to upload"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'som-assets');

CREATE POLICY "Allow authenticated users to read"
  ON storage.objects
  FOR SELECT
  TO authenticated
  USING (bucket_id = 'som-assets');
```

Configure in Supabase Dashboard:
1. Go to Storage section
2. Create bucket `som-assets`
3. Set public/private access
4. Configure RLS policies

### 5. Authentication Setup

Configure authentication providers:

1. **Email/Password**: Enabled by default
2. **Google OAuth**: Configure in Supabase Dashboard → Authentication → Providers
3. **Email Templates**: Customize confirmation and reset emails

### 6. Edge Functions (Optional)

Deploy Supabase Edge Functions for serverless operations:

```bash
supabase functions deploy som-process-inquiry
```

### 7. Database Migrations (with Supabase CLI)

```bash
# Initialize Supabase locally
supabase init

# Create migration
supabase migration new create_som_schema

# Edit migration file in supabase/migrations/

# Apply migrations
supabase db push
```

---

## Firebase Setup (Optional)

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Add web app

### 2. Install Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

### 3. Initialize Firebase in Project

```bash
cd /path/to/som-app
firebase init
```

Select:
- **Hosting**: For web deployment
- **Firestore** (Optional): For real-time database
- **Authentication** (Optional): For additional auth providers

### 4. Configure Firebase Hosting

Edit `firebase.json`:

```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### 5. Deploy to Firebase

```bash
flutter build web --release
firebase deploy --only hosting
```

### 6. Custom Domain (Optional)

1. Go to Firebase Console → Hosting
2. Add custom domain
3. Follow DNS configuration instructions

---

## CI/CD Pipeline

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy SOM App

on:
  push:
    branches: [main, production]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.0'

      - name: Install dependencies
        run: flutter pub get

      - name: Run tests
        run: flutter test

      - name: Analyze code
        run: flutter analyze

  build-web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.0'

      - name: Build web
        run: |
          flutter build web --release \
            --dart-define=API_BASE_URL=${{ secrets.API_BASE_URL }} \
            --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
            --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}

      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          channelId: live
          projectId: your-firebase-project

  build-api:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Setup Dart
        uses: dart-lang/setup-dart@v1

      - name: Install Dart Frog CLI
        run: dart pub global activate dart_frog_cli

      - name: Build API
        run: |
          cd api
          dart_frog build

      - name: Deploy to Cloud Run
        uses: google-github-actions/deploy-cloudrun@v1
        with:
          service: som-api
          image: gcr.io/${{ secrets.GCP_PROJECT_ID }}/som-api
          region: us-central1
          credentials: ${{ secrets.GCP_CREDENTIALS }}
```

### Required GitHub Secrets

Add these secrets in GitHub repository settings:

- `API_BASE_URL`
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `FIREBASE_SERVICE_ACCOUNT`
- `GCP_PROJECT_ID`
- `GCP_CREDENTIALS`

---

## Monitoring & Logging

### Error Tracking

#### Sentry Integration

1. **Add Sentry to pubspec.yaml**:

```yaml
dependencies:
  sentry_flutter: ^7.0.0
```

2. **Initialize Sentry**:

```dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://your-sentry-dsn';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp()),
  );
}
```

3. **Configure in Sentry Dashboard**:
   - Create project
   - Set up alerts
   - Configure release tracking

### Performance Monitoring

#### Firebase Performance

```yaml
dependencies:
  firebase_performance: ^0.9.0
```

```dart
final performance = FirebasePerformance.instance;
final trace = performance.newTrace('api_call');
await trace.start();
// ... API call
await trace.stop();
```

### Logging

#### Structured Logging

```dart
import 'package:logging/logging.dart';

final logger = Logger('SOM');

logger.info('User logged in', {'userId': user.id});
logger.warning('Rate limit approaching', {'limit': 100, 'current': 95});
logger.severe('API call failed', error, stackTrace);
```

#### Log Aggregation

Use **Google Cloud Logging**, **Datadog**, or **Logz.io** for centralized log management.

### Health Checks

Add health check endpoint to Dart Frog API:

```dart
// api/routes/health.dart
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return Response.json(
    body: {
      'status': 'healthy',
      'timestamp': DateTime.now().toIso8601String(),
    },
  );
}
```

Monitor with uptime services like **UptimeRobot** or **Pingdom**.

---

## Rollback Procedures

### Web Rollback (Firebase Hosting)

```bash
# List previous deployments
firebase hosting:channel:list

# Rollback to previous release
firebase hosting:clone SOURCE_SITE_ID:SOURCE_CHANNEL_ID TARGET_SITE_ID:live
```

Or use Firebase Console → Hosting → Release History → Rollback.

### API Rollback (Cloud Run)

```bash
# List revisions
gcloud run revisions list --service=som-api

# Rollback to previous revision
gcloud run services update-traffic som-api \
  --to-revisions=PREVIOUS_REVISION=100
```

### Database Rollback (Supabase)

```bash
# Revert migration
supabase migration down

# Or restore from backup
supabase db restore --backup-id=BACKUP_ID
```

### Mobile App Rollback

#### Android (Google Play)

1. Go to Google Play Console
2. Select app → Production → Releases
3. Promote previous release

#### iOS (App Store)

1. Go to App Store Connect
2. Select app → TestFlight or App Store
3. Submit previous build for review

### Emergency Rollback Checklist

- [ ] Identify problematic deployment
- [ ] Communicate with team
- [ ] Execute rollback command
- [ ] Verify service health
- [ ] Monitor error rates
- [ ] Document incident
- [ ] Plan fix for next deployment

---

## Additional Resources

### Documentation

- [Main README](../README.md) - Project overview and getting started
- [API Documentation](../api/docs/API.md) - REST API endpoint reference
- [Provider Management](./PROVIDERS.md) - User guide for provider management
- [Documentation Index](./README.md) - Full documentation index

### External Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Frog Documentation](https://dartfrog.vgv.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Firebase Documentation](https://firebase.google.com/docs)

### Support

For issues or questions:
- Create an issue in the repository
- Contact the development team
- Refer to project documentation

---

**Last Updated**: January 2026
**Version**: 1.0.0
