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
FROM dart:stable AS dependencies

WORKDIR /app

# Copy local path dependency first (som_manager from lib/generated)
# This must be copied before pubspec.yaml because it's referenced as a path dependency
COPY lib/generated /app/lib/generated

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

# Get dependencies
RUN dart pub get

# ==============================================================================
# Stage 2: Build
# ==============================================================================
FROM dependencies AS build

WORKDIR /app/api

# Copy API source code
COPY api/lib ./lib
COPY api/routes ./routes
COPY api/public ./public
COPY api/main.dart ./main.dart

# Build production server with dart_frog
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog build

# Compile to native executable for faster startup
RUN dart compile exe build/bin/server.dart -o build/bin/server

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
