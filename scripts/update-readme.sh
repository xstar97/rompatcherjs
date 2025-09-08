#!/bin/bash
set -e

VERSION="$1"
TEMPLATE="README.template.md"
OUTPUT="README.md"

# If no version is provided, fetch the latest tag from GitHub
if [ -z "$VERSION" ]; then
  echo "No VERSION provided, fetching latest tag from GitHub..."
  VERSION=$(curl -s https://api.github.com/repos/xstar97/rompatcherjs/tags | jq -r '.[0].name')
  echo "Using latest tag: $VERSION"
fi

echo "Updating README with version $VERSION..."

# Use | as sed delimiter to avoid problems with / in VERSION
sed "s|{{VERSION}}|$VERSION|g" "$TEMPLATE" > "$OUTPUT"
