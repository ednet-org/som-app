# SOM Deployment Guide

Comprehensive deployment guide for the Smart Offer Management (SOM) Flutter application and Dart Frog API backend.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Recommended Stack: Supabase Cloud + Google Cloud Run](#recommended-stack-supabase-cloud--google-cloud-run)
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

## Recommended Stack: Supabase Cloud + Google Cloud Run

This is the recommended production deployment approach, optimized for cost and simplicity.

**Estimated Monthly Cost**: ~$25-35/month
- Supabase Pro: $25/month (PostgreSQL, Auth, Storage)
- Google Cloud Run: $0-10/month (scale-to-zero, pay-per-request)

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    Production Architecture                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌─────────────┐      ┌─────────────┐     ┌────────────┐  │
│   │   Flutter   │─────▶│  Cloud Run  │────▶│  Supabase  │  │
│   │   Web/App   │      │   (API)     │     │   Cloud    │  │
│   └─────────────┘      └─────────────┘     └────────────┘  │
│         │                    │                   │          │
│         │              ┌─────┴─────┐      ┌──────┴──────┐  │
│         │              │  Secret   │      │  PostgreSQL │  │
│         └─────────────▶│  Manager  │      │  + Auth     │  │
│                        └───────────┘      │  + Storage  │  │
│                                           └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Step 1: Supabase Cloud Setup

1. **Create Supabase Project**
   - Go to [supabase.com](https://supabase.com) and sign up
   - Click "New Project"
   - Choose organization (or create one)
   - Set project name: `som-production`
   - Set database password (save it securely!)
   - Select region: Choose closest to your users (e.g., `eu-central-1` for Europe)
   - Click "Create new project"

2. **Get API Credentials**
   - Go to **Settings → API**
   - Copy these values:
     - `Project URL` → `SUPABASE_URL`
     - `anon/public` key → `SUPABASE_ANON_KEY`
     - `service_role` key → `SUPABASE_SERVICE_ROLE_KEY` (keep secret!)
   - Go to **Settings → API → JWT Settings**
     - Copy `JWT Secret` → `SUPABASE_JWT_SECRET`

3. **Create Storage Bucket**
   - Go to **Storage**
   - Click "New bucket"
   - Name: `som-assets`
   - Public: No (private bucket)
   - Click "Create bucket"

4. **Run Database Migrations**
   - Go to **SQL Editor**
   - Run migration scripts from `seed-data/migrations/`
   - Or use Supabase CLI:
     ```bash
     supabase link --project-ref your-project-ref
     supabase db push
     ```

### Step 2: Google Cloud Setup

1. **Create Google Cloud Project**
   ```bash
   # Install gcloud CLI: https://cloud.google.com/sdk/docs/install
   gcloud auth login

   # Create project
   gcloud projects create som-production --name="SOM Production"
   gcloud config set project som-production

   # Enable billing (required for Cloud Run)
   # Go to: https://console.cloud.google.com/billing
   ```

2. **Enable Required APIs**
   ```bash
   gcloud services enable \
     cloudbuild.googleapis.com \
     run.googleapis.com \
     artifactregistry.googleapis.com \
     secretmanager.googleapis.com
   ```

3. **Create Artifact Registry Repository**
   ```bash
   gcloud artifacts repositories create som-docker \
     --repository-format=docker \
     --location=europe-west1 \
     --description="SOM Docker images"
   ```

4. **Configure Secret Manager**
   ```bash
   # Store Supabase secrets
   echo -n "your-service-role-key" | \
     gcloud secrets create SUPABASE_SERVICE_ROLE_KEY --data-file=-

   echo -n "your-jwt-secret" | \
     gcloud secrets create SUPABASE_JWT_SECRET --data-file=-

   # Grant Cloud Run access to secrets
   PROJECT_NUMBER=$(gcloud projects describe som-production --format='value(projectNumber)')

   gcloud secrets add-iam-policy-binding SUPABASE_SERVICE_ROLE_KEY \
     --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"

   gcloud secrets add-iam-policy-binding SUPABASE_JWT_SECRET \
     --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
     --role="roles/secretmanager.secretAccessor"
   ```

5. **Grant Cloud Build Permissions**
   ```bash
   PROJECT_NUMBER=$(gcloud projects describe som-production --format='value(projectNumber)')

   # Allow Cloud Build to deploy to Cloud Run
   gcloud projects add-iam-policy-binding som-production \
     --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
     --role="roles/run.admin"

   # Allow Cloud Build to act as compute service account
   gcloud iam service-accounts add-iam-policy-binding \
     ${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
     --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
     --role="roles/iam.serviceAccountUser"
   ```

### Step 3: Configure Local Environment

1. **Update `.env` for Production**
   ```bash
   cp .env.example .env.production
   ```

   Edit `.env.production`:
   ```bash
   # Supabase Cloud
   SUPABASE_URL=https://your-project-id.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   SUPABASE_JWT_SECRET=your-jwt-secret
   SUPABASE_PROJECT_ID=your-project-id

   # Google Cloud
   GCLOUD_PROJECT_ID=som-production
   GCLOUD_REGION=europe-west1
   GCLOUD_SERVICE_NAME=som-api

   # Production settings
   DEV_FIXTURES=false
   ENABLE_HSTS=true
   CORS_ALLOWED_ORIGINS=https://your-domain.com
   ```

2. **Authenticate Docker with Artifact Registry**
   ```bash
   gcloud auth configure-docker europe-west1-docker.pkg.dev
   ```

### Step 4: Deploy API to Cloud Run

**Option A: Manual Deployment**

```bash
# Build and push Docker image
cd api
docker build -t europe-west1-docker.pkg.dev/som-production/som-docker/som-api:latest ..

docker push europe-west1-docker.pkg.dev/som-production/som-docker/som-api:latest

# Deploy to Cloud Run
gcloud run deploy som-api \
  --image europe-west1-docker.pkg.dev/som-production/som-docker/som-api:latest \
  --region europe-west1 \
  --platform managed \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 10 \
  --memory 512Mi \
  --cpu 1 \
  --set-env-vars "SUPABASE_URL=https://your-project.supabase.co" \
  --set-env-vars "SUPABASE_ANON_KEY=your-anon-key" \
  --set-secrets "SUPABASE_SERVICE_ROLE_KEY=SUPABASE_SERVICE_ROLE_KEY:latest" \
  --set-secrets "SUPABASE_JWT_SECRET=SUPABASE_JWT_SECRET:latest"
```

**Option B: Automated CI/CD with Cloud Build**

1. **Connect GitHub to Cloud Build**
   - Go to [Cloud Build Console](https://console.cloud.google.com/cloud-build/triggers)
   - Click "Connect Repository"
   - Select GitHub and authorize
   - Choose your repository

2. **Create Build Trigger**
   - Click "Create Trigger"
   - Name: `deploy-main`
   - Event: Push to branch
   - Branch: `^main$`
   - Configuration: Cloud Build configuration file
   - Location: `cloudbuild.yaml`
   - Add substitution variables:
     - `_SUPABASE_URL`: `https://your-project.supabase.co`
     - `_SUPABASE_ANON_KEY`: `your-anon-key`

3. **Trigger Deployment**
   ```bash
   git push origin main
   # Cloud Build will automatically build and deploy
   ```

### Step 5: Configure Custom Domain (Optional)

1. **Map Custom Domain in Cloud Run**
   ```bash
   gcloud beta run domain-mappings create \
     --service som-api \
     --domain api.your-domain.com \
     --region europe-west1
   ```

2. **Configure DNS**
   - Add CNAME record pointing to `ghs.googlehosted.com`
   - Or add A records as instructed by Cloud Run

### Step 6: Deploy Flutter Web App

Build and deploy the Flutter web app:

```bash
# Build for production
flutter build web --release \
  --dart-define=API_BASE_URL=https://api.your-domain.com \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key

# Deploy to Firebase Hosting (recommended)
firebase deploy --only hosting

# Or deploy to any static hosting (Netlify, Vercel, etc.)
```

### Cost Breakdown

| Service | Free Tier | Pro Tier | Notes |
|---------|-----------|----------|-------|
| Supabase | 500MB DB, 1GB storage | $25/mo - 8GB DB, 100GB storage | Includes Auth, Realtime |
| Cloud Run | 2M requests/mo | ~$0.00002/request | Scale to zero |
| Artifact Registry | 500MB free | $0.10/GB/month | Docker images |
| Secret Manager | 6 active secrets free | $0.06/secret/month | Sensitive configs |
| **Total** | **~$0** | **~$25-35/mo** | Production ready |

### Monitoring & Alerts

1. **Cloud Run Metrics**
   ```bash
   # View logs
   gcloud run services logs read som-api --region europe-west1

   # Stream logs
   gcloud run services logs tail som-api --region europe-west1
   ```

2. **Set Up Alerts**
   - Go to [Cloud Monitoring](https://console.cloud.google.com/monitoring)
   - Create alerting policies for:
     - Error rate > 1%
     - Latency p95 > 2s
     - Instance count > 5 (cost alert)

3. **Supabase Dashboard**
   - Monitor database size and connections
   - View auth logs
   - Check storage usage

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

#### Option 1: Google Cloud Run (Recommended)

> **Note**: See [Recommended Stack](#recommended-stack-supabase-cloud--google-cloud-run) section above for detailed setup instructions.

The project includes pre-configured deployment files:
- `api/Dockerfile` - Multi-stage Docker build optimized for Cloud Run
- `api/pubspec.production.yaml` - Production dependencies (git-based for Docker)
- `cloudbuild.yaml` - Automated CI/CD pipeline configuration
- `.gcloudignore` - Files to exclude from deployment

**Quick Deployment**:

```bash
# Authenticate with Google Cloud
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Configure Docker
gcloud auth configure-docker europe-west1-docker.pkg.dev

# Build and push image
docker build -t europe-west1-docker.pkg.dev/YOUR_PROJECT_ID/som-docker/som-api:latest -f api/Dockerfile .
docker push europe-west1-docker.pkg.dev/YOUR_PROJECT_ID/som-docker/som-api:latest

# Deploy to Cloud Run
gcloud run deploy som-api \
  --image europe-west1-docker.pkg.dev/YOUR_PROJECT_ID/som-docker/som-api:latest \
  --platform managed \
  --region europe-west1 \
  --allow-unauthenticated \
  --min-instances 0 \
  --max-instances 10 \
  --memory 512Mi
```

**Automated CI/CD with Cloud Build**:

The `cloudbuild.yaml` file automates the entire deployment process. Connect your GitHub repository to Cloud Build and create a trigger on the `main` branch. See [Recommended Stack](#recommended-stack-supabase-cloud--google-cloud-run) for detailed setup.

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
**Version**: 1.1.0

---

## Quick Reference: Configuration Files

| File | Purpose |
|------|---------|
| `.env.example` | Environment variable template |
| `api/Dockerfile` | Docker build for Cloud Run |
| `api/pubspec.production.yaml` | Production dependencies |
| `cloudbuild.yaml` | Google Cloud Build CI/CD |
| `.gcloudignore` | Files excluded from deployment |
