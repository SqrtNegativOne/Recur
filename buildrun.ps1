# buildrun.ps1 - Run code generation then launch on Windows
Write-Host "Running build_runner..." -ForegroundColor Cyan
dart run build_runner build --delete-conflicting-outputs
if ($LASTEXITCODE -ne 0) {
    Write-Host "build_runner failed." -ForegroundColor Red
    exit 1
}

Write-Host "Launching on Windows..." -ForegroundColor Cyan
flutter run -d windows
