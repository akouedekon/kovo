param()
# PowerShell version to generate a Flutter app skeleton in mobile/ if android/ is missing
$mobileDir = Join-Path (Get-Location) 'mobile'
if (-not (Test-Path $mobileDir)) {
    Write-Error "Mobile directory not found at $mobileDir"
    exit 1
}
Set-Location $mobileDir
if (-not (Test-Path './android')) {
    Write-Output "Android folder missing — running: flutter create -t app ."
    flutter create -t app .
} else {
    Write-Output "Android folder exists — skipping"
}
