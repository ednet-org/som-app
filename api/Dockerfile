# Dockerfile for SOM API (Dart Frog)
# Optimized for Google Cloud Run deployment
#
# IMPORTANT: Build from PROJECT ROOT, not from api/ directory:
#   docker build -t som-api -f api/Dockerfile .
#
# Run locally:
#   docker run -p 8080:8080 --env-file .env som-api

# ==============================================================================
# Stage 1: Dependencies
# ==============================================================================
# Using Flutter image since ednet_core depends on shared_preferences (Flutter SDK package)
FROM ghcr.io/cirruslabs/flutter:stable AS dependencies

WORKDIR /app

# Copy local path dependency first (som_manager from lib/generated)
# This must be copied before pubspec.yaml because it's referenced as a path dependency
COPY lib/generated /app/lib/generated

# Override som_manager pubspec with production version (uses git dependency for ednet_core)
COPY lib/generated/pubspec.production.yaml /app/lib/generated/pubspec.yaml

# Copy API dependency files (use production pubspec with git dependencies)
COPY api/pubspec.production.yaml /app/api/pubspec.yaml
COPY api/pubspec.lock /app/api/pubspec.lock

WORKDIR /app/api

# Note: pubspec.production.yaml uses git dependency for ednet_core:
#   ednet_core:
#     git:
#       url: https://github.com/ednet-dev/cms.git
#       path: packages/core
#       ref: main

# Get dependencies (using flutter pub for packages with Flutter dependencies)
RUN flutter pub get

# ==============================================================================
# Stage 2: Build
# ==============================================================================
FROM dependencies AS build

# Build arguments for compile-time configuration
ARG SUPABASE_URL
ARG SUPABASE_ANON_KEY
ARG SUPABASE_SERVICE_ROLE_KEY
ARG SUPABASE_JWT_SECRET
ARG SUPABASE_SCHEMA=public
ARG SUPABASE_STORAGE_BUCKET=som-assets

WORKDIR /app/api

# Copy API source code
COPY api/lib ./lib
COPY api/routes ./routes

# Add pub-cache/bin to PATH for global executables
ENV PATH="${PATH}:/root/.pub-cache/bin"

# Build production server with dart_frog
RUN dart pub global activate dart_frog_cli
RUN dart_frog build

# Compile to native executable with environment configuration
# Note: These are compile-time constants baked into the binary
RUN dart compile exe build/bin/server.dart -o build/bin/server \
    -DSUPABASE_URL="${SUPABASE_URL}" \
    -DSUPABASE_ANON_KEY="${SUPABASE_ANON_KEY}" \
    -DSUPABASE_SERVICE_ROLE_KEY="${SUPABASE_SERVICE_ROLE_KEY}" \
    -DSUPABASE_JWT_SECRET="${SUPABASE_JWT_SECRET}" \
    -DSUPABASE_SCHEMA="${SUPABASE_SCHEMA}" \
    -DSUPABASE_STORAGE_BUCKET="${SUPABASE_STORAGE_BUCKET}"

# ==============================================================================
# Stage 3: Production runtime
# ==============================================================================
FROM gcr.io/distroless/cc-debian12 AS production

WORKDIR /app

# Copy the compiled server
COPY --from=build /app/api/build/bin/server /app/server

# Cloud Run expects PORT environment variable
ENV PORT=8080
EXPOSE 8080

# Health check endpoint expected by Cloud Run
# Dart Frog serves on / by default, add /health endpoint if needed

# Run the server
CMD ["/app/server"]
