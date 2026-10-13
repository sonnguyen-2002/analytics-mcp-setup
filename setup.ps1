<#
.SYNOPSIS
  Connects Claude Code to Google Analytics 4 through Google's analytics-mcp, in one command.

.DESCRIPTION
  Installs what is missing (Python, pipx, Google Cloud CLI), opens the browser once for you to
  sign in to Google, keeps that sign-in in its own file, and registers the MCP for every Claude
  Code project. Run it again with another -Name to add a second Google account side by side.

  Nothing secret is stored in this repository: each Google sign-in stays on the machine, in
  %APPDATA%\analytics-mcp\<Name>.json.

.EXAMPLE
  .\setup.ps1
  .\setup.ps1 -Name analytics-client -Project my-other-project
  .\setup.ps1 -Name analytics-client -Remove
#>
param(
  # The MCP's name in Claude Code; one name per Google account.
  [string]$Name = "analytics-mcp",
  # Google Cloud project billed for the API calls. The account must be allowed to use it, and the
  # Google Analytics Data API and Admin API must be enabled in it.
  [string]$Project = "sona-511503",
  # Take this MCP (and its saved sign-in) off the machine instead.
  [switch]$Remove
)

$ErrorActionPreference = "Stop"
$Store = Join-Path $env:APPDATA "analytics-mcp"
$Credentials = Join-Path $Store "$Name.json"

function Refresh-Path {
  $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
}
function Step($text) { Write-Host "`n== $text" -ForegroundColor Cyan }
function Find-Claude {
  $found = (Get-Command claude -ErrorAction SilentlyContinue).Source
  if ($found) { return $found }
  # The Claude desktop app ships its own copy of Claude Code; take the newest.
  return Get-ChildItem (Join-Path $env:APPDATA "Claude\claude-code") -Recurse -Filter claude.exe -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
}

$Claude = Find-Claude
if (-not $Claude) { throw "Claude Code was not found. Install the Claude desktop app or Claude Code first." }

if ($Remove) {
  & $Claude mcp remove $Name -s user
  if (Test-Path $Credentials) { Remove-Item $Credentials }
  Write-Host "Removed $Name." -ForegroundColor Green
  return
}

Step "1/5 Python"
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
  winget install --id Python.Python.3.12 -e --accept-source-agreements --accept-package-agreements
  Refresh-Path
}
$Python = (Get-Command python).Source
& $Python --version

Step "2/5 pipx"
& $Python -m pip install --user --quiet --upgrade pipx

Step "3/5 Google Cloud CLI"
if (-not (Get-Command gcloud -ErrorAction SilentlyContinue)) {
  winget install --id Google.CloudSDK -e --accept-source-agreements --accept-package-agreements
  Refresh-Path
}

Step "4/5 Sign in to Google for '$Name' (a browser window opens - pick the account)"
gcloud auth application-default login --scopes="https://www.googleapis.com/auth/analytics.readonly,https://www.googleapis.com/auth/cloud-platform"
gcloud auth application-default set-quota-project $Project
$Default = Join-Path $env:APPDATA "gcloud\application_default_credentials.json"
if (-not (Test-Path $Default)) { throw "Google sign-in did not finish: $Default is missing." }
# Each account keeps its own copy, so signing in to another one later leaves this one working.
New-Item -ItemType Directory -Force $Store | Out-Null
Copy-Item $Default $Credentials -Force

Step "5/5 Register '$Name' in Claude Code"
& $Claude mcp remove $Name -s user 2>$null | Out-Null
# '--' is quoted so PowerShell passes it on instead of swallowing it.
& $Claude mcp add --scope user $Name --env "GOOGLE_APPLICATION_CREDENTIALS=$Credentials" --env "GOOGLE_PROJECT_ID=$Project" '--' $Python -m pipx run analytics-mcp
& $Claude mcp get $Name

Write-Host "`nDone. Open a new Claude Code session and ask, for example:" -ForegroundColor Green
Write-Host "  Use $Name to show the last 7 days of my Google Analytics property."
