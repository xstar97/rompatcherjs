# Use an official Alpine Linux image as a base
FROM alpine:latest

# Set a custom port as a default (3000 if not specified)
ENV PORT=3000

# Create a directory to store your files
WORKDIR /app

# Install curl and Git for healthcheck and cloning the repository and Caddy web server
RUN apk update && apk add --no-cache curl git caddy

# Define an argument for the RomPatcher.js tag
ARG UPSTREAM_TAG

# Add an echo to indicate that the project is being cloned
RUN echo "Cloning RomPatcher.js project with tag ${UPSTREAM_TAG}..."

# Clone the specified RomPatcher.js tag from the GitHub repository into the private "public" directory
RUN git clone --depth 1 --branch ${UPSTREAM_TAG} https://github.com/marcrobledo/RomPatcher.js.git /public

# Verification step: Check if /app/public directory exists
RUN if [ ! -d /public ]; then \
      echo "GitHub repository was not cloned successfully into /app/public"; \
      exit 1; \
    fi

# Expose the port specified by the PORT environment variable
EXPOSE $PORT

# Copy a Caddyfile with HTTPS configuration
COPY Caddyfile /app

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail https://localhost:$PORT || exit 1

# Start Caddy web server
CMD ["caddy", "run", "--config", "/app/Caddyfile"]
