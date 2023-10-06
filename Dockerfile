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

# Clone the specified RomPatcher.js tag from the GitHub repository into the private "public_path" directory
ENV public_path="/public/$UPSTREAM_TAG"
RUN git clone --depth 1 --branch v${UPSTREAM_TAG} https://github.com/marcrobledo/RomPatcher.js.git ${public_path}

# Expose the port specified by the PORT environment variable
EXPOSE $PORT

# Start the Python HTTP server using a shell command to substitute the environment variable
CMD sh -c "echo 'Starting server on port $PORT' && python -m http.server $PORT --directory $public_path"

# Add a healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl --fail http://localhost:$PORT/ || exit 1
