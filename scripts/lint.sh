#!/bin/bash

if command -v ./scripts/swiftlint >/dev/null; then
  ./scripts/swiftlint --fix && ./scripts/swiftlint
else
  echo "warning: SwiftLint not working. Check ./scripts/swiftlint"
fi
