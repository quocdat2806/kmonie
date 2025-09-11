Param()
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Write-Host "==> Flutter/Dart versions"
try { flutter --version } catch {}
try { dart --version } catch {}

Write-Host "==> Cleaning project"
flutter clean
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force .dart_tool\build -ErrorAction SilentlyContinue

Write-Host "==> Getting dependencies"
flutter pub get

Write-Host "==> Cleaning build_runner"
try { dart run build_runner clean } catch {}

Write-Host "==> Running build_runner (delete conflicting outputs)"
dart run build_runner build --delete-conflicting-outputs

Write-Host "==> Checking formatting (no changes applied)"
dart format . --output=none --set-exit-if-changed

Write-Host "==> Analyzing with strict lints"
flutter analyze

Write-Host "==> Done"


