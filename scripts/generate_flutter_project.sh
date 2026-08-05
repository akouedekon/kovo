#!/usr/bin/env bash
set -e
# Generate a Flutter app skeleton in the mobile/ directory if android/ is missing.
# Run from repository root.
MOBILE_DIR="$(pwd)/mobile"
if [ ! -d "$MOBILE_DIR" ]; then
  echo "Mobile directory not found at $MOBILE_DIR"
  exit 1
fi
cd "$MOBILE_DIR"
if [ ! -d android ]; then
  echo "Android folder missing — running: flutter create -t app ."
  flutter create -t app .
else
  echo "Android folder already exists — skipping"
fi
