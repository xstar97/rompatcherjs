# Use the static-web-server alpine image as a base
FROM ghcr.io/static-web-server/static-web-server:2.38.1-alpine

# Set environment variables with sensible defaults
ENV SERVER_PORT=3000 \
    SERVER_ROOT=/app/public \
    SERVER_HEALTH=true

# Create working directory
WORKDIR /app

# Expose the configured server port
EXPOSE ${SERVER_PORT}

# Copy pre-fetched RomPatcher.js files into SERVER_ROOT
COPY ./RomPatcher.js ${SERVER_ROOT}

# Verify critical files exist
RUN test -f "${SERVER_ROOT}/index.html" || (echo "ERROR: index.html not found in ${SERVER_ROOT}" && exit 1)

# Run static-web-server
CMD ["static-web-server"]
