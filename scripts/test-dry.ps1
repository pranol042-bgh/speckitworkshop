#!/usr/bin/env pwsh
# Simple test to run the create-issues script in dry-run mode with example payloads.

Write-Host "Running dry-run with example payload file..."

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$repoRoot = Resolve-Path (Join-Path $scriptDir '..')
$createScript = Join-Path $repoRoot 'create-issues.ps1'
$payloadFile = Join-Path $repoRoot 'examples\my-issues.json'

if (-not (Test-Path $createScript)) { Write-Error "create-issues.ps1 not found at $createScript"; exit 1 }
if (-not (Test-Path $payloadFile)) { Write-Error "payload file not found at $payloadFile"; exit 1 }

& powershell -NoProfile -ExecutionPolicy Bypass -File $createScript -DryRun -PayloadFile $payloadFile

if ($LASTEXITCODE -eq 0) { Write-Host "Test completed." -ForegroundColor Green } else { Write-Error "Test failed (exit $LASTEXITCODE)" }
