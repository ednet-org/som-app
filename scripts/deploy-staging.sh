#!/bin/bash
# Staging Deployment Script
# Usage: ./scripts/deploy-staging.sh [frontend|api|all]
#
# Prerequisites:
#   - 1Password CLI authenticated: op whoami
#   - Firebase CLI authenticated: firebase login
#   - gcloud CLI authenticated: gcloud auth login
#   - Flutter SDK installed
#   - Dart Frog CLI: dart pub global activate dart_frog_cli

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Staging Configuration
API_BASE_URL="https://som-api-i3iupxxyxq-ew.a.run.app"
SUPABASE_SCHEMA="som"
GCP_PROJECT="ednet-som-staging"
GCP_REGION="europe-west1"

# Fetch secrets from 1Password
get_supabase_url() {
    op read 'op://som-staging/supabase/api-url'
}

get_supabase_anon_key() {
    op read 'op://som-staging/supabase/anon-key'
}

# Deploy Frontend to Firebase Hosting
deploy_frontend() {
    log_info "Building Flutter web app for staging..."
    cd "$PROJECT_ROOT"

    SUPABASE_URL=$(get_supabase_url)
    SUPABASE_ANON_KEY=$(get_supabase_anon_key)

    flutter build web --release \
        --dart-define=API_BASE_URL="$API_BASE_URL" \
        --dart-define=SUPABASE_URL="$SUPABASE_URL" \
        --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
        --dart-define=SUPABASE_SCHEMA="$SUPABASE_SCHEMA" \
        --dart-define=env=staging

    log_info "Deploying to Firebase Hosting..."
    firebase deploy --only hosting

    log_info "Frontend deployed successfully!"
    echo "  URL: https://ednet-som-staging.web.app"
}

# Deploy API to Cloud Run
deploy_api() {
    log_info "Building API with dart_frog..."
    cd "$PROJECT_ROOT/api"
    dart_frog build

    log_info "Deploying API to Cloud Run..."
    cd "$PROJECT_ROOT"

    SHORT_SHA=$(git rev-parse --short HEAD)
    SUPABASE_URL=$(get_supabase_url)
    SUPABASE_ANON_KEY=$(get_supabase_anon_key)

    gcloud builds submit . \
        --config=cloudbuild.yaml \
        --project="$GCP_PROJECT" \
        --substitutions=SHORT_SHA="$SHORT_SHA",_SUPABASE_URL="$SUPABASE_URL",_SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"

    log_info "API deployed successfully!"
    echo "  URL: $API_BASE_URL"
}

# Push database migrations
deploy_migrations() {
    log_info "Pushing database migrations..."
    cd "$PROJECT_ROOT"
    supabase db push --linked
    log_info "Migrations applied successfully!"
}

# Main deployment logic
main() {
    local target="${1:-all}"

    log_info "Starting staging deployment..."
    log_info "Target: $target"
    echo ""

    # Check prerequisites
    if ! command -v op &> /dev/null; then
        log_error "1Password CLI (op) is not installed. Install with: brew install 1password-cli"
        exit 1
    fi

    if ! op whoami &> /dev/null; then
        log_error "1Password CLI is not authenticated. Run: eval \$(op signin)"
        exit 1
    fi

    case "$target" in
        frontend|fe|web)
            deploy_frontend
            ;;
        api|backend)
            deploy_api
            ;;
        migrations|db)
            deploy_migrations
            ;;
        all)
            deploy_api
            deploy_frontend
            ;;
        *)
            echo "Usage: $0 [frontend|api|migrations|all]"
            echo ""
            echo "Options:"
            echo "  frontend, fe, web  - Deploy Flutter web app to Firebase Hosting"
            echo "  api, backend       - Deploy API to Cloud Run"
            echo "  migrations, db     - Push database migrations to Supabase"
            echo "  all                - Deploy both API and frontend (default)"
            exit 1
            ;;
    esac

    echo ""
    log_info "Deployment complete!"
}

main "$@"
