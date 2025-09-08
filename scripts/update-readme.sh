#!/bin/bash
set -e

VERSION="$1"
TEMPLATE="README.template.md"
OUTPUT="README.md"
VERSION_FILE="VERSION"

# If no version provided, fetch latest upstream tag
if [ -z "$VERSION" ]; then
  echo "No VERSION provided, fetching latest upstream tag..."
  VERSION=$(curl -s https://api.github.com/repos/marcrobledo/RomPatcher.js/releases/latest | jq -r '.tag_name')
fi

echo "Updating README with version $VERSION..."

# Update README.md from template
sed "s|{{VERSION}}|$VERSION|g" "$TEMPLATE" > "$OUTPUT"

# Update VERSION file
echo "$VERSION" > "$VERSION_FILE"
