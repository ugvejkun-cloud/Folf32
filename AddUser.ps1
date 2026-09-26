# FOUF32 WHITELIST MANAGER
param(
    [string]$Username
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "           FOUF32 CLIENT -- WHITELIST MANAGER                " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (-not $Username) {
    $Username = Read-Host "Enter Roblox Username"
}

$Username = $Username.Trim()

if ([string]::IsNullOrWhiteSpace($Username)) {
    Write-Host ""
    Write-Host "[ERROR] Username cannot be empty!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

$file = Join-Path $PSScriptRoot "whitelist.json"
$list = [System.Collections.ArrayList]@()

if (Test-Path $file) {
    try {
        $raw = Get-Content $file -Raw -Encoding UTF8
        $parsed = $raw | ConvertFrom-Json
        if ($parsed) {
            foreach ($item in $parsed) {
                [void]$list.Add([string]$item)
            }
        }
    } catch {
        $list = [System.Collections.ArrayList]@()
    }
}

if (-not ($list.Contains($Username))) {
    [void]$list.Add($Username)
    $json = $list | ConvertTo-Json -Depth 5
    [System.IO.File]::WriteAllText($file, $json, [System.Text.Encoding]::UTF8)
    Write-Host ""
    Write-Host "[SUCCESS] User '$Username' added to whitelist.json!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[INFO] User '$Username' is already in whitelist.json!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
$ans = Read-Host "Upload changes to GitHub now? (git add, commit, push) [Y/N]"
if ($ans -eq "Y" -or $ans -eq "y") {
    Write-Host ""
    Write-Host "Uploading to GitHub..." -ForegroundColor Yellow
    git add whitelist.json
    git commit -m "Add user $Username to whitelist"
    git push
    Write-Host ""
    Write-Host "[SUCCESS] Changes pushed to GitHub!" -ForegroundColor Green
}

Write-Host ""
Write-Host "All done! Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
