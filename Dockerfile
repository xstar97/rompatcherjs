# Use the lightweight static website base
FROM lipanski/docker-static-website:2.6.0@sha256:66a530684a934a9b94f65a90f286cba291a7daf4dd7d55dcc17f217915056cd5

# Set environment variables with sensible defaults
ENV SERVER_PORT=3000

# Working directory is already /home/static in this base image
WORKDIR /home/static

# Copy RomPatcher.js files cloned by the workflow
COPY ./RomPatcher.js .

# Expose the configured server port directly
EXPOSE ${SERVER_PORT}

# Run the static web server with dynamic port support
CMD sh -c "/busybox-httpd -f -v -p ${SERVER_PORT}"
