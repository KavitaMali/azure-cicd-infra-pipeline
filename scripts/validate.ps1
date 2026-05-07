# ============================================
# Local validation script - run before pushing
# Usage: .\scripts\validate.ps1
# ============================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Azure Bicep Local Validation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Check Azure CLI is installed
Write-Host "`n[1/4] Checking Azure CLI..." -ForegroundColor Yellow
$azVersion = az --version 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "Azure CLI found!" -ForegroundColor Green
} else {
    Write-Host "Azure CLI not found. Please install it first." -ForegroundColor Red
    exit 1
}

# Check logged in
Write-Host "`n[2/4] Checking Azure login..." -ForegroundColor Yellow
$account = az account show 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "Logged in to Azure!" -ForegroundColor Green
} else {
    Write-Host "Not logged in. Running az login..." -ForegroundColor Yellow
    az login
}

# Lint Bicep
Write-Host "`n[3/4] Running Bicep lint..." -ForegroundColor Yellow
az bicep lint --file infra/main.bicep
if ($LASTEXITCODE -eq 0) {
    Write-Host "Bicep lint passed!" -ForegroundColor Green
} else {
    Write-Host "Bicep lint failed. Fix errors above." -ForegroundColor Red
    exit 1
}

# Build Bicep
Write-Host "`n[4/4] Building Bicep (compile to ARM)..." -ForegroundColor Yellow
az bicep build --file infra/main.bicep
if ($LASTEXITCODE -eq 0) {
    Write-Host "Bicep build successful!" -ForegroundColor Green
} else {
    Write-Host "Bicep build failed. Fix errors above." -ForegroundColor Red
    exit 1
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host " All checks passed! Safe to push." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan