[CmdletBinding()]
param(
    [ValidateSet('apk', 'aab', 'all')][string]$Artifact = 'aab',
    [string]$FlutterExecutable = 'flutter'
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$backupRoot = Join-Path ([IO.Path]::GetTempPath()) ('pantoo-web-' + [guid]::NewGuid())
$webReady = $false
function Invoke-Flutter([string[]]$FlutterArgs) {
    & $FlutterExecutable @FlutterArgs
    if ($LASTEXITCODE -ne 0) { throw "Flutter gagal: $($FlutterArgs -join ' ')" }
}
Push-Location $projectRoot
try {
    # Keep the deployable web build recoverable even if clean/build fails.
    if (Test-Path 'build/web/index.html') {
        New-Item -ItemType Directory -Path $backupRoot | Out-Null
        Copy-Item -LiteralPath 'build/web' -Destination $backupRoot -Recurse
    }
    Invoke-Flutter -FlutterArgs @('clean')
    Invoke-Flutter -FlutterArgs @('pub', 'get')
    # Web first: an Android build failure must not leave the live deployment empty.
    Invoke-Flutter -FlutterArgs @('build', 'web', '--release', '--target', 'lib/main_production.dart')
    foreach ($required in @('index.html', 'main.dart.js', 'flutter_bootstrap.js', 'assets/AssetManifest.bin.json', 'version.json')) {
        if (-not (Test-Path "build/web/$required")) { throw "Build web tidak lengkap: $required" }
    }
    $expectedVersion = [regex]::Match((Get-Content 'pubspec.yaml' -Raw), '(?m)^version:\s*(\S+)').Groups[1].Value
    $builtVersion = Get-Content 'build/web/version.json' -Raw | ConvertFrom-Json
    if ("$($builtVersion.version)+$($builtVersion.build_number)" -ne $expectedVersion) {
        throw 'Versi build web tidak sesuai pubspec.yaml.'
    }
    $webReady = $true
    if ($Artifact -in @('apk', 'all')) {
        Invoke-Flutter -FlutterArgs @('build', 'apk', '--release', '--flavor', 'production', '--target', 'lib/main_production.dart', '--no-pub')
    }
    if ($Artifact -in @('aab', 'all')) {
        Invoke-Flutter -FlutterArgs @('build', 'appbundle', '--release', '--flavor', 'production', '--target', 'lib/main_production.dart', '--no-pub')
    }
    Write-Host "Build $Artifact dan web production selesai ($expectedVersion). Sertakan build/web saat commit deployment."
}
finally {
    if (-not $webReady -and (Test-Path "$backupRoot/web/index.html")) {
        New-Item -ItemType Directory -Force 'build' | Out-Null
        Copy-Item -LiteralPath "$backupRoot/web" -Destination 'build' -Recurse -Force
        Write-Warning 'Build web belum berhasil. Cadangan web sebelumnya dipulihkan; jangan deploy sebagai versi baru.'
    }
    Pop-Location
    # Retain the temporary backup for recovery; never remove user build files here.
}
