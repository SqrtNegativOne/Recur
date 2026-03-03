# run_android.ps1 - Start Android emulator (if needed) and launch the app

$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$emulator = "$sdkPath\emulator\emulator.exe"
$adb      = "$sdkPath\platform-tools\adb.exe"

# --- Find AVDs ---
$avds = & $emulator -list-avds 2>$null
if (-not $avds) {
    Write-Host "No Android Virtual Devices found." -ForegroundColor Red
    Write-Host "Open Android Studio -> Device Manager -> Create Device, then re-run this script." -ForegroundColor Yellow
    exit 1
}
$avd = ($avds -split "`n")[0].Trim()
Write-Host "Using AVD: $avd" -ForegroundColor Cyan

# --- Check if emulator is already running ---
$running = & $adb devices 2>$null | Select-String "emulator"
if ($running) {
    Write-Host "Emulator already running." -ForegroundColor Green
} else {
    Write-Host "Starting emulator..." -ForegroundColor Cyan
    Start-Process -FilePath $emulator -ArgumentList "-avd `"$avd`"" -WindowStyle Normal

    Write-Host "Waiting for emulator to boot (this can take a minute)..." -ForegroundColor Yellow
    & $adb wait-for-device | Out-Null

    # Wait until fully booted (boot_completed = 1)
    $booted = ""
    while ($booted -ne "1") {
        Start-Sleep -Seconds 3
        $booted = (& $adb shell getprop sys.boot_completed 2>$null).Trim()
        Write-Host "  Boot status: $booted" -ForegroundColor DarkGray
    }
    Write-Host "Emulator ready." -ForegroundColor Green
}

# --- Run the Flutter app ---
Write-Host "Launching Flutter app on Android..." -ForegroundColor Cyan
flutter run -d android
