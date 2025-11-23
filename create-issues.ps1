<#
PowerShell script to create GitHub issues for tasks.

Usage examples:
  Dry-run (prints JSON payloads):
  powershell -NoProfile -ExecutionPolicy Bypass -File .\create-issues.ps1 -DryRun

  Create issues (requires PAT in env var `GITHUB_TOKEN`):
  $env:GITHUB_TOKEN = 'ghp_...'
  powershell -NoProfile -ExecutionPolicy Bypass -File .\create-issues.ps1

Parameters:
  -Owner: GitHub repo owner (default: pranol042-bgh)
  -Repo: GitHub repository name (default: speckitworkshop)
  -TokenEnv: environment variable name that contains the PAT (default: GITHUB_TOKEN)
  -DryRun: switch; when present the script prints payloads instead of posting
  -PayloadFile: optional path to a local JSON file with an array of payload objects to override built-in list
#>

[CmdletBinding()]
param (
  [string]$Owner = 'pranol042-bgh',
  [string]$Repo = 'speckitworkshop',
  [string]$TokenEnv = 'GITHUB_TOKEN',
  [switch]$DryRun,
  [string]$PayloadFile = ''
)

function Get-TokenFromEnv($name) {
  try { return (Get-Item env:$name).Value } catch { return $null }
}

$token = Get-TokenFromEnv $TokenEnv

if (-not $DryRun) {
  if (-not $token -or $token.Trim() -eq '') {
    Write-Error "Environment variable `$${TokenEnv} not set. Set `$env:$TokenEnv to a personal access token with repo scope.";
    exit 1
  }
}

$apiBase = "https://api.github.com/repos/$Owner/$Repo/issues"

$headers = @{
  Accept = "application/vnd.github+json"
  'User-Agent' = "$Owner/$Repo - speckit-agent"
}
if ($token) { $headers.Authorization = "token $token" }

# Built-in issue list (ASCII hyphens, here-strings for multi-line bodies)
$issues = @(
  @{ title = 'T001 - Create project structure per implementation plan'; body = @'
Phase: Phase 1 - Setup

Description: Create canonical project directories and skeleton files per specs/001-init-specs/plan.md (e.g., src/, tests/, top-level README, manifest).

Acceptance: Directories exist and README/manifest placeholders created.
'@; labels = @('task','setup','speckit-auto') },

  @{ title = 'T002 - Initialize project with framework dependencies'; body = @'
Phase: Phase 1 - Setup

Description: Initialize language/project manifest (e.g., package.json, pyproject.toml) and add initial dependencies per the plan.

Acceptance: Project manifest present and dependency install works locally.
'@; labels = @('task','setup','speckit-auto') },

  @{ title = 'T003 - Configure linting and formatting tools'; body = @'
Phase: Phase 1 - Setup

Description: Add and configure linters/formatters (e.g., ESLint/Prettier or flake8/black) and provide sample config files.

Acceptance: lint and format commands run against sample files.
'@; labels = @('task','setup','speckit-auto') },

  @{ title = 'T004 - Setup database schema and migrations framework'; body = @'
Phase: Phase 2 - Foundational

Description: Add DB connection config and migrations tooling; create initial migration skeleton.

Acceptance: Migration tooling can create/apply an initial migration locally.
'@; labels = @('task','foundational','speckit-auto') },

  @{ title = 'T005 - Implement authentication/authorization framework'; body = @'
Phase: Phase 2 - Foundational

Description: Scaffold auth components (middleware, token/session handling) per plan.

Acceptance: Protected endpoint returns 401 if unauthenticated; mock auth flow works.
'@; labels = @('task','security','speckit-auto') },

  @{ title = 'T006 - Setup API routing and middleware structure'; body = @'
Phase: Phase 2 - Foundational

Description: Create API routing skeleton and middleware pipeline (health endpoint, routing conventions).

Acceptance: Health route responds 200; middleware ordering validated.
'@; labels = @('task','foundational','speckit-auto') },

  @{ title = 'T007 - Create base models/entities that all stories depend on'; body = @'
Phase: Phase 2 - Foundational

Description: Implement shared data models/entities and add to schema/data-model.md if present.

Acceptance: Base entities exist and migrations/schema reflect them.
'@; labels = @('task','data-model','speckit-auto') },

  @{ title = 'T008 - Configure error handling and logging infrastructure'; body = @'
Phase: Phase 2 - Foundational

Description: Add app-wide error handling and structured logging configuration.

Acceptance: Errors return consistent payloads and logs written per config.
'@; labels = @('task','infra','speckit-auto') },

  @{ title = 'T009 - Setup environment configuration management'; body = @'
Phase: Phase 2 - Foundational

Description: Implement config loading (env vars, .env) and document dev usage.

Acceptance: App reads config from env/local .env and documents it.
'@; labels = @('task','infra','speckit-auto') },

  @{ title = 'T010 - Contract test scaffold for example endpoint (US1)'; body = @'
Phase: Phase 3 - User Story 1 (optional tests)

Description: Add a contract test template in tests/contract/test_[name].py (update endpoint names based on contracts/).

Acceptance: Contract test template present and runnable (expected to fail until implementation).
'@; labels = @('task','test','speckit-auto') },

  @{ title = 'T011 - Integration test scaffold for user journey (US1)'; body = @'
Phase: Phase 3 - User Story 1 (optional tests)

Description: Add integration test template in tests/integration/test_[name].py to validate the user story flow.

Acceptance: Integration test template present and runnable (expected to fail).
'@; labels = @('task','test','speckit-auto') },

  @{ title = 'T012 - Create [Entity1] model (US1)'; body = @'
Phase: Phase 3 - User Story 1

Description: Implement model Entity1 in src/models/[entity1].py per data-model/spec.

Acceptance: Model defined and included in migrations/schema.
'@; labels = @('task','us1','speckit-auto') },

  @{ title = 'T013 - Create [Entity2] model (US1)'; body = @'
Phase: Phase 3 - User Story 1

Description: Implement model Entity2 in src/models/[entity2].py per data-model/spec.

Acceptance: Model defined and included in migrations/schema.
'@; labels = @('task','us1','speckit-auto') },

  @{ title = 'T014 - Implement [Service] for US1'; body = @'
Phase: Phase 3 - User Story 1

Description: Implement service layer functionality (e.g., src/services/[service].py) that uses Entity models.

Acceptance: Service unit behavior validated by basic unit tests/mock.
'@; labels = @('task','us1','speckit-auto') },

  @{ title = 'T015 - Implement endpoint/feature for US1'; body = @'
Phase: Phase 3 - User Story 1

Description: Add REST/HTTP endpoint(s) or CLI entrypoints to expose User Story 1 functionality.

Acceptance: Endpoint responds correctly to sample requests (status codes and JSON).
'@; labels = @('task','us1','speckit-auto') },

  @{ title = 'T016 - Add validation and error handling for US1'; body = @'
Phase: Phase 3 - User Story 1

Description: Add input validation and error mapping for the US1 endpoints/services.

Acceptance: Invalid inputs return standardized error responses.
'@; labels = @('task','us1','speckit-auto') },

  @{ title = 'T017 - Add logging for User Story 1 operations'; body = @'
Phase: Phase 3 - User Story 1

Description: Add operation-level structured logs for key US1 flows (info/error).

Acceptance: Logs created for success/failure paths per logging config.
'@; labels = @('task','us1','speckit-auto') },

  @{ title = 'T018 - Contract test scaffold for example endpoint (US2)'; body = @'
Phase: Phase 4 - User Story 2 (optional tests)

Description: Add contract test template for User Story 2 endpoints in tests/contract/.
'@; labels = @('task','test','us2','speckit-auto') },

  @{ title = 'T019 - Integration test scaffold for user journey (US2)'; body = @'
Phase: Phase 4 - User Story 2 (optional tests)

Description: Add integration test template to exercise the US2 flow in tests/integration/.
'@; labels = @('task','test','us2','speckit-auto') },

  @{ title = 'T020 - Create [Entity] model (US2)'; body = @'
Phase: Phase 4 - User Story 2

Description: Implement the model required by User Story 2 in src/models/[entity].py.

Acceptance: Model included in migrations/schema.
'@; labels = @('task','us2','speckit-auto') },

  @{ title = 'T021 - Implement [Service] for US2'; body = @'
Phase: Phase 4 - User Story 2

Description: Implement service layer logic for US2 in src/services/[service].py.

Acceptance: Service behavior validated by unit tests/mocks.
'@; labels = @('task','us2','speckit-auto') },

  @{ title = 'T022 - Implement endpoint/feature for US2'; body = @'
Phase: Phase 4 - User Story 2

Description: Add routing/endpoint(s) to deliver US2 functionality.

Acceptance: Endpoint responds with expected payloads/status.
'@; labels = @('task','us2','speckit-auto') },

  @{ title = 'T023 - Integrate US2 with US1 components (if needed)'; body = @'
Phase: Phase 4 - User Story 2

Description: Ensure cross-story interactions are implemented (calls, shared models).

Acceptance: Integration tests demonstrate US2 working alongside US1.
'@; labels = @('task','us2','speckit-auto') },

  @{ title = 'T024 - Contract test scaffold for example endpoint (US3)'; body = @'
Phase: Phase 5 - User Story 3 (optional tests)

Description: Add contract test template for US3 in tests/contract/.
'@; labels = @('task','test','us3','speckit-auto') },

  @{ title = 'T025 - Integration test scaffold for user journey (US3)'; body = @'
Phase: Phase 5 - User Story 3 (optional tests)

Description: Add integration test template for US3 in tests/integration/.
'@; labels = @('task','test','us3','speckit-auto') },

  @{ title = 'T026 - Create [Entity] model (US3)'; body = @'
Phase: Phase 5 - User Story 3

Description: Implement the model required by User Story 3 in src/models/[entity].py.

Acceptance: Model included in migrations/schema.
'@; labels = @('task','us3','speckit-auto') },

  @{ title = 'T027 - Implement [Service] for US3'; body = @'
Phase: Phase 5 - User Story 3

Description: Implement service layer logic for US3 in src/services/[service].py.

Acceptance: Service behavior validated by unit tests/mocks.
'@; labels = @('task','us3','speckit-auto') },

  @{ title = 'T028 - Implement endpoint/feature for US3'; body = @'
Phase: Phase 5 - User Story 3

Description: Add routing/endpoint(s) to deliver US3 functionality and ensure it integrates with other stories as needed.

Acceptance: Endpoint responds with expected payloads/status; integration tests exist.
'@; labels = @('task','us3','speckit-auto') }
)

if ($PayloadFile -and (Test-Path $PayloadFile)) {
  try {
    $fileData = Get-Content -Raw -Path $PayloadFile | ConvertFrom-Json
    if ($fileData -is [System.Array]) { $issues = $fileData }
  } catch {
    Write-Warning "Failed to read or parse payload file '$PayloadFile' - ignoring. $_"
  }
}

function Invoke-PostIssue {
  param($payloadJson)
  $maxAttempts = 5
  $attempt = 0
  while ($attempt -lt $maxAttempts) {
    $attempt++
    try {
      # use a fresh copy of headers to avoid accidental mutation
      $callHeaders = @{}
      foreach ($k in $headers.Keys) { $callHeaders[$k] = $headers[$k] }
      $resp = Invoke-RestMethod -Uri $apiBase -Method Post -Headers $callHeaders -Body $payloadJson -ContentType 'application/json' -ErrorAction Stop
      return @{ success = $true; resp = $resp }
    } catch {
      $err = $_
      $webResp = $err.Exception.Response -as [System.Net.HttpWebResponse]
      $body = ''
      if ($webResp) {
        try {
          $sr = New-Object System.IO.StreamReader($webResp.GetResponseStream())
          $body = $sr.ReadToEnd(); $sr.Close()
        } catch {}
      }

      $parsedMessage = $null
      try { $parsedMessage = ($body | ConvertFrom-Json).message } catch { $parsedMessage = $body }

      # If rate limited (429) or headers indicate limit, respect reset
      if ($webResp) {
        $status = [int]$webResp.StatusCode
        $rateRemaining = $webResp.Headers['X-RateLimit-Remaining']
        if ($rateRemaining -eq '0' -or $status -eq 429) {
          $reset = $webResp.Headers['X-RateLimit-Reset'] -as [string]
          if ($reset) {
            $resetEpoch = [int]$reset
            $nowEpoch = [int][double]::Parse((Get-Date -UFormat %s))
            $wait = [math]::Max(5, $resetEpoch - $nowEpoch + 5)
            Write-Warning "Rate limit reached (status ${status}). Sleeping $wait seconds before retrying."
            Start-Sleep -Seconds $wait
            continue
          }
        }

        # For client errors (4xx) other than 429, do not retry
        if ($status -ge 400 -and $status -lt 500 -and $status -ne 429) {
          Write-Warning "Client error status ${status}: ${parsedMessage}"
          return @{ success = $false; error = 'client-error'; status = $status; details = $parsedMessage }
        }
      }

      # exponential backoff for retryable failures
      $sleep = [math]::Min(30, [math]::Pow(2, $attempt))
      Write-Warning "Attempt ${attempt} failed: ${parsedMessage}. Retrying in ${sleep} seconds..."
      Start-Sleep -Seconds $sleep
    }
  }
  return @{ success = $false; error = 'max attempts reached' }
}

if ($DryRun) {
  $idx = 0
  foreach ($issue in $issues) {
    $idx++
    Write-Host "--- Issue #$idx ---" -ForegroundColor Cyan
    Write-Host "Title: $($issue.title)" -ForegroundColor Yellow
    Write-Host "Labels: $((($issue.labels) -join ', '))"
    Write-Host "Body:`n$($issue.body)`n"
    $payload = @{ title = $issue.title; body = $issue.body; labels = $issue.labels }
    $payloadJson = $payload | ConvertTo-Json -Depth 6
    Write-Host "JSON Payload:`n$payloadJson`n"
    Start-Sleep -Milliseconds 120
  }
  Write-Host "Dry-run complete. No network requests were made." -ForegroundColor Green
  return
}

foreach ($issue in $issues) {
  $payloadObj = @{ title = $issue.title; body = $issue.body; labels = $issue.labels }
  $payloadJson = $payloadObj | ConvertTo-Json -Depth 6
  $result = Invoke-PostIssue -payloadJson $payloadJson
  if ($result.success) {
    Write-Host "Created: $($result.resp.html_url)" -ForegroundColor Green
  } else {
    Write-Error "Failed to create issue '$($issue.title)': $($result.error)"
  }
  Start-Sleep -Milliseconds 200
}
