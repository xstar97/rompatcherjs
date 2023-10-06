# Use an official Caddy builder image
FROM caddy:builder AS builder

# Set a custom port as a default (3000 if not specified)
ENV PORT=3000

# Install curl and Git for healthcheck and cloning the repository
RUN apk update && apk add --no-cache curl git

# Define an argument for the RomPatcher.js tag
ARG UPSTREAM_TAG

# Clone the specified RomPatcher.js tag from the GitHub repository into the builder's workspace
RUN git clone --depth 1 --branch ${UPSTREAM_TAG} https://github.com/marcrobledo/RomPatcher.js.git /workspace/public

# Verification step: Check if /workspace/public directory exists
RUN if [ ! -d /workspace/public ]; then \
      echo "GitHub repository was not cloned successfully into /workspace/public"; \
      exit 1; \
    fi

# Build the Caddyfile dynamically with HTTPS configuration
RUN echo "localhost {" > /workspace/Caddyfile && \
    echo "    root * /workspace/public" >> /workspace/Caddyfile && \
    echo "    encode zstd gzip" >> /workspace/Caddyfile && \
    echo "    file_server" >> /workspace/Caddyfile && \
    echo "}" >> /workspace/Caddyfile

# Use the official Caddy image as the final base image
FROM caddy:2

# Expose the port specified by the PORT environment variable
EXPOSE $PORT

# Copy the generated Caddyfile from the builder
COPY --from=builder /workspace/Caddyfile /etc/caddy/Caddyfile

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail https://localhost:$PORT || exit 1
