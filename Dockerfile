# Use the static-web-server x.x.x-alpine as a base
FROM ghcr.io/static-web-server/static-web-server:2.38.1-alpine

# Set environment variables with sensible defaults
ENV SERVER_PORT=3000 \
    SERVER_ROOT=/app/public \
    SERVER_HEALTH=true

# Create working directory
WORKDIR /app

# Install curl, git, and openssl for healthcheck & repo cloning
RUN apk update && apk add --no-cache curl git openssl

# Define an argument for the RomPatcher.js tag (optional override)
ARG UPSTREAM_TAG

# Clone RomPatcher.js at the specified tag into SERVER_ROOT
# If UPSTREAM_TAG is not set, automatically fetch the latest release tag from GitHub
RUN if [ -z "$UPSTREAM_TAG" ]; then \
        echo "Fetching latest RomPatcher.js release tag..." && \
        UPSTREAM_TAG=$(curl -s https://api.github.com/repos/marcrobledo/RomPatcher.js/releases/latest | \
                       grep -oP '"tag_name":\s*"\K(.*)(?=")'); \
    fi && \
    echo "Cloning RomPatcher.js project with tag ${UPSTREAM_TAG}..." && \
    git clone --depth 1 --branch "${UPSTREAM_TAG}" https://github.com/marcrobledo/RomPatcher.js.git "${SERVER_ROOT}" || \
    (echo "Git clone failed with exit code $? (UPSTREAM_TAG=${UPSTREAM_TAG})" && exit 1)

# Expose the configured server port
EXPOSE ${SERVER_PORT}

# Run static-web-server with TLS (if certs are mounted/configured)
CMD ["static-web-server"]
