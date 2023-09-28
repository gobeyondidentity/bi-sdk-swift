#!/bin/bash

# Download swiftlint from Beyond Identity S3 bucket, if it doesn't exist.
# TODO - can't we just download this from an actual place? Or even run this
# in Docker?

SWIFTLINT=./scripts/swiftlint
if ! test -f "$SWIFTLINT"; then
  echo "$SWIFTLINT binary does not exist locally, downloading..."
  curl https://downloads.byndid.run/builddeps/swiftlint -o $SWIFTLINT
  chmod +x $SWIFTLINT
else
  echo "$SWIFTLINT binary found locally, executing..."
fi

if command -v "$SWIFTLINT" >/dev/null; then
  "$SWIFTLINT" --fix && "$SWIFTLINT"
else
  echo "warning: SwiftLint not working. Check $SWIFTLINT"
fi
