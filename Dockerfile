# Use the static-web-server Dockerfile as a base
FROM staticwebserver/alpine:latest

# Set a custom port as a default (3000 if not specified)
ENV PORT=3000

# Create a directory to store your files
WORKDIR /public

# Install curl and Git for healthcheck and cloning the repository
RUN apk update && apk add --no-cache curl git

# Define an argument for the RomPatcher.js tag
ARG UPSTREAM_TAG

# Add an echo to indicate that the project is being cloned
RUN echo "Cloning RomPatcher.js project with tag ${UPSTREAM_TAG}..."

# Clone the specified RomPatcher.js tag from the GitHub repository into the private "public" directory
RUN git clone --depth 1 --branch ${UPSTREAM_TAG} https://github.com/marcrobledo/RomPatcher.js.git .

# Verification step: Check if /public directory exists
RUN if [ ! -d /public ]; then \
      echo "GitHub repository was not cloned successfully into /public"; \
      exit 1; \
    fi

# Expose the port specified by the PORT environment variable
EXPOSE $PORT

# Start the static-web-server (Twisted-based) using the specified port and enable HTTPS redirect
CMD ["static-web-server", "--port", "$PORT", "--health", "true", "--http2", "true", "--https-redirect", "true"]

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail https://localhost:$PORT/health || exit 1
