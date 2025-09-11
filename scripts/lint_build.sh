#!/usr/bin/env bash
set -euo pipefail

echo "==> Flutter/Dart versions"
flutter --version || true
dart --version || true

echo "==> Cleaning project"
flutter clean
rm -rf build .dart_tool/build 2>/dev/null || true

echo "==> Getting dependencies"
flutter pub get

echo "==> Cleaning build_runner"
dart run build_runner clean || true

echo "==> Running build_runner (delete conflicting outputs)"
dart run build_runner build --delete-conflicting-outputs

echo "==> Checking formatting (no changes applied)"
dart format . --output=none --set-exit-if-changed

echo "==> Analyzing with strict lints"
flutter analyze

echo "==> Done"


