# Use the static-web-server Dockerfile as a base
FROM ghcr.io/static-web-server/static-web-server:2-alpine

# Set a custom port as a default (3000 if not specified)
ENV SERVER_PORT=3000
ENV SERVER_ROOT=/app/public
ENV SERVER_HEALTH=true

# Create a directory to store your files
WORKDIR /app

# Install curl and Git for healthcheck and cloning the repository
RUN apk update && apk add --no-cache curl git openssl

# Define an argument for the RomPatcher.js tag
ARG UPSTREAM_TAG

# Add an echo to indicate that the project is being cloned and debug output
RUN echo "Cloning RomPatcher.js project with tag ${UPSTREAM_TAG}..." && \
    git clone --depth 1 --branch ${UPSTREAM_TAG} https://github.com/marcrobledo/RomPatcher.js.git $SERVER_ROOT || \
    echo "Git clone failed with exit code $?, UPSTREAM_TAG=$UPSTREAM_TAG"

# Expose the port specified by the PORT environment variable
EXPOSE $SERVER_PORT

# Start the static-web-server with TLS
CMD sh -c "static-web-server"
