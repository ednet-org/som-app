# SOM Secrets Management

This project uses **1Password CLI** for secure secrets management across all environments.

## Environment Architecture

| Environment | Database | API | Purpose |
|-------------|----------|-----|---------|
| Local | Local Supabase (`supabase start`) | Local Dart Frog | Development & testing |
| Staging | Supabase Cloud (`som-staging`) | Google Cloud Run | Pre-production testing |
| Production | Supabase Cloud (`som-production`) | Google Cloud Run | Live users |

## 1Password Vault Structure

| Environment | Vault Name | Vault ID | Supabase Project |
|-------------|------------|----------|------------------|
| Local | som-dev | `vehfvsl3zshyc7u6c62yu5ujwu` | Local (no secrets needed) |
| Staging | som-staging | `e7gtn55crs57nibqqnkpnm47xe` | `som-staging` (rzbfaqfyqznsdecbmamw) |
| Production | som-production | `fu3rwri5pc25bgdfny2sk3x2rq` | TBD |

## Required Secrets per Environment

Each **remote** vault (staging, production) should contain the following items:

### Supabase Credentials (Item: `supabase`)

| Field | Description |
|-------|-------------|
| `token` | Supabase CLI access token (for migrations, CLI operations) |
| `url` | Supabase project URL (e.g., `https://xxx.supabase.co`) |
| `anon-key` | Supabase anon/public key |
| `service-role-key` | Supabase service role key (secret!) |
| `jwt-secret` | JWT secret for token verification |
| `project-id` | Supabase project reference ID |

### Google Cloud Credentials (Item: `gcloud`)

| Field | Description |
|-------|-------------|
| `project-id` | GCloud project ID |
| `region` | Deployment region (e.g., `europe-west1`) |
| `service-account` | Service account JSON (for CI/CD) |

### SMTP/Email Credentials (Item: `smtp`)

| Field | Description |
|-------|-------------|
| `host` | SMTP server host |
| `port` | SMTP port |
| `username` | SMTP username |
| `password` | SMTP password |

## CLI Usage Patterns

### Authentication

```bash
# Login to 1Password CLI (run once per session)
eval $(op signin)

# Verify access
op vault list
```

### Reading Secrets (Safe Patterns)

**Direct piping (PREFERRED)**:
```bash
# Supabase CLI login (use staging or production vault)
op read "op://som-staging/supabase cli token/token" | supabase login --token -

# Set environment variable for session
export SUPABASE_ACCESS_TOKEN=$(op read "op://som-staging/supabase cli token/token")
```

**Inline injection**:
```bash
# Use in commands without storing
curl -H "Authorization: Bearer $(op read op://som-staging/supabase/service-role-key)" \
  https://rzbfaqfyqznsdecbmamw.supabase.co/rest/v1/

# Docker build with secrets
docker build \
  --secret id=supabase_key,src=<(op read "op://som-production/supabase/service-role-key") \
  -t som-api .
```

### Environment-Specific Commands

**Local Development**:
```bash
# No remote secrets needed - uses local Supabase
supabase start
cd api && dart_frog dev
```

**Staging**:
```bash
export SUPABASE_ACCESS_TOKEN=$(op read "op://som-staging/supabase cli token/token")
supabase link --project-ref $(op read "op://som-staging/supabase/project-id")
```

**Production**:
```bash
export SUPABASE_ACCESS_TOKEN=$(op read "op://som-production/supabase cli token/token")
supabase link --project-ref $(op read "op://som-production/supabase/project-id")
```

## Creating New Secrets

```bash
# Create a new item in a vault (example for production)
op item create \
  --vault som-production \
  --category login \
  --title "supabase" \
  "url=https://xxx.supabase.co" \
  "anon-key=eyJ..." \
  "service-role-key=eyJ..." \
  "jwt-secret=xxx" \
  "project-id=xxx"

# Create CLI token item separately
op item create \
  --vault som-production \
  --category "Secure Note" \
  --title "supabase cli token" \
  "token=sbp_xxx"
```

## Populating Secrets from Supabase Dashboard

After creating a Supabase project, populate secrets:

1. Go to **Supabase Dashboard → Settings → API**
2. Copy values to 1Password:

```bash
# Example for production vault
op item edit supabase \
  --vault som-production \
  "url=https://YOUR_PROJECT.supabase.co" \
  "anon-key=YOUR_ANON_KEY" \
  "service-role-key=YOUR_SERVICE_ROLE_KEY" \
  "project-id=YOUR_PROJECT_REF"

# Get JWT secret from Settings → API → JWT Settings
op item edit supabase \
  --vault som-production \
  "jwt-secret=YOUR_JWT_SECRET"
```

## CI/CD Integration

### GitHub Actions

Use 1Password GitHub Action or store secrets in GitHub Secrets:

```yaml
# .github/workflows/deploy.yml
env:
  SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
```

### Google Cloud Build

Store secrets in Secret Manager (synced from 1Password):

```bash
# Sync 1Password secret to GCloud Secret Manager
op read "op://som-production/supabase/service-role-key" | \
  gcloud secrets create SUPABASE_SERVICE_ROLE_KEY --data-file=-
```

## Security Rules

1. **NEVER** echo, print, or log secrets
2. **NEVER** store secrets in shell variables that might be displayed
3. **ALWAYS** use direct piping: `op read ... | command`
4. **ALWAYS** use process substitution for file-based secrets: `<(op read ...)`
5. **ROTATE** tokens immediately if exposed

## Vault Access

Grant team members access to appropriate vaults:

- **Developers**: som-dev
- **DevOps/QA**: som-dev, som-staging
- **Production Admin**: all vaults

---

**Last Updated**: January 2026
