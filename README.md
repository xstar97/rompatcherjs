# RomPatcher.js

This service requires a reverse proxy to function.  
This image also uses [static-web-server](https://static-web-server.net/configuration/environment-variables/) as a base, so most env variables will function normally.

```yaml
version: "3.8"

services:
  rompatcherjs:
    image: ghcr.io/xstar97/rompatcherjs:v3.0_v0.0.2
    ports:
      - "3000:3000"
    environment:
      - SERVER_PORT=3000
    restart: unless-stopped
```
