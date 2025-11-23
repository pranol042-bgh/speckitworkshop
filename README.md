# speckitworkshop
testing speckit

## Issue creation scripts

This repository includes helper PowerShell scripts to turn feature `tasks.md` entries into GitHub issues.

- `create-issues-dry.ps1` — prints JSON payloads for each issue (safe preview; no network calls).
- `create-issues.ps1` — posts issues to the GitHub REST API (requires a PAT in an environment variable).

Usage examples (PowerShell on Windows):

Dry-run (preview payloads):
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\create-issues.ps1 -DryRun
```

Dry-run using the explicit dry script:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\create-issues-dry.ps1
```

Create issues (REAL):
1. Create a personal access token (PAT) with `repo` scope on GitHub.
2. In your PowerShell session set the token in the environment and run the script:
```powershell
$env:GITHUB_TOKEN = 'ghp_...'
powershell -NoProfile -ExecutionPolicy Bypass -File .\create-issues.ps1
```

Optional:
- Provide a custom JSON payload file (array of objects with `title`, `body`, `labels`) to override built-in drafts:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\create-issues.ps1 -DryRun -PayloadFile .\my-issues.json
```

Notes:
- The scripts were designed to be run locally where outbound network access and environment variables are available.
- Review dry-run output before using the real creation script to avoid accidental postings.
