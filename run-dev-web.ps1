$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot
try {
    if (Get-NetTCPConnection -LocalPort 7357 -State Listen -ErrorAction SilentlyContinue) {
        throw 'Port 7357 sedang digunakan. Tutup preview Pantoo sebelumnya lalu jalankan kembali; port Google tidak diganti otomatis.'
    }
    & flutter run -d chrome --flavor development --target lib/main_development.dart --web-port 7357
    if ($LASTEXITCODE -ne 0) { throw "Flutter berhenti dengan kode $LASTEXITCODE." }
}
finally {
    Pop-Location
}
