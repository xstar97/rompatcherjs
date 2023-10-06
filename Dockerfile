# Use an official Alpine Linux image as a base
FROM alpine:latest

# Set a custom port as a default (3000 if not specified)
ENV PORT=3000

# Create a directory to store your files
WORKDIR /app

# Install curl and Git for healthcheck and cloning the repository
RUN apk update && apk add --no-cache curl git

# Install Caddy web server (as a rootless user)
RUN apk add --no-cache caddy

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

# Create a non-root user to run Caddy
RUN adduser -D -H -u 568 apps

# Make the /app directory writable by the non-root user
RUN chown -R apps:apps /app

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail https://localhost:$PORT || exit 1

# Switch to the non-root user and start Caddy web server
USER apps

CMD ["caddy", "run", "--config", "/app/Caddyfile"]
