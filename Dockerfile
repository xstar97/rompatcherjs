# Use an official Python runtime as a parent image
FROM python:3.8-alpine

# Set a custom port as a default (3000 if not specified)
ENV PORT=3000

# Create a directory to store your files
WORKDIR /app

# Install curl and Git for healthcheck and cloning the repository
RUN apk update && apk add --no-cache curl git

# Define an argument for the RomPatcher.js tag
ARG UPSTREAM_TAG

# Add an echo to indicate that the project is being cloned
RUN echo "Cloning RomPatcher.js project with tag ${UPSTREAM_TAG}..."

# Clone the specified RomPatcher.js tag from the GitHub repository into the private "public_path" directory
RUN git clone --depth 1 --branch ${UPSTREAM_TAG} https://github.com/marcrobledo/RomPatcher.js.git /public

# Verification step: Check if /public directory exists
RUN if [ ! -d /public ]; then \
      echo "GitHub repository was not cloned successfully into /public"; \
      exit 1; \
    fi

# Expose the port specified by the PORT environment variable
EXPOSE $PORT

# Start the Python HTTPS server using a self-signed certificate
CMD sh -c "echo 'Starting server on port $PORT' && python -m http.server --directory /public --bind 0.0.0.0 $PORT --cgi --cert /usr/local/share/ca-certificates/self-signed.crt --key /usr/local/share/ca-certificates/self-signed.key"

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail https://localhost:$PORT || exit 1
