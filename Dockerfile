# Use the static-web-server Dockerfile as a base
FROM ghcr.io/static-web-server/static-web-server:2.22.1-alpine

# Set a custom port as a default (3000 if not specified)
ENV PORT=3000

# Create a directory to store your files
WORKDIR /public

# Install curl and Git for healthcheck and cloning the repository
RUN apk update && apk add --no-cache curl git

# Define an argument for the RomPatcher.js tag
ARG UPSTREAM_TAG

# Add an echo to indicate that the project is being cloned and debug output
RUN echo "Cloning RomPatcher.js project with tag ${UPSTREAM_TAG}..." && \
    git clone --depth 1 --branch ${UPSTREAM_TAG} https://github.com/marcrobledo/RomPatcher.js.git . || \
    echo "Git clone failed with exit code $?, UPSTREAM_TAG=$UPSTREAM_TAG"

# Expose the port specified by the PORT environment variable
EXPOSE $PORT

# Start the static-web-server (Twisted-based) using the specified port and enable HTTPS redirect
CMD sh -c "static-web-server --port $PORT --health --http2 --https-redirect"

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail https://localhost:$PORT/health || exit 1
