#!/bin/sh
set -e

VERSION="$1"
TEMPLATE="README.template.md"
OUTPUT="README.md"

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

echo "Updating README with version $VERSION..."

sed "s/{{VERSION}}/$VERSION/g" "$TEMPLATE" > "$OUTPUT"