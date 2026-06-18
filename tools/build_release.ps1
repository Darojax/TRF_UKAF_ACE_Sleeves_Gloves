param(
    [string]$SourceAddonDir = (Join-Path $PSScriptRoot "..\addons\main"),
    [string]$ModRoot = (Join-Path $PSScriptRoot "..\@TRF_UKAF_ACE_Sleeves_Gloves"),
    [string]$AddonName = "trf_ukaf_ace_sleeves_gloves_main",
    [string]$KeyName = "Darojax",
    [string]$PrivateKeyDir = (Join-Path $PSScriptRoot "..\_private\signing"),
    [string]$AddonBuilderPath = "",
    [string]$DSCreateKeyPath = "",
    [switch]$GenerateKey
)

function Resolve-ArmaTool {
    param(
        [string]$ProvidedPath,
        [string]$ExecutableName
    )

    if ($ProvidedPath -ne "") {
        return (Resolve-Path -LiteralPath $ProvidedPath).Path
    }

    $roots = New-Object System.Collections.Generic.List[string]

    foreach ($path in @(
        "C:\Program Files (x86)\Steam\steamapps\common",
        "C:\Program Files\Steam\steamapps\common"
    )) {
        if (Test-Path -LiteralPath $path) {
            [void]$roots.Add($path)
        }
    }

    $libraryVdf = "C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf"
    if (Test-Path -LiteralPath $libraryVdf) {
        $matches = Select-String -Path $libraryVdf -Pattern '"path"\s+"([^"]+)"' -AllMatches
        foreach ($matchGroup in $matches.Matches) {
            $steamLibrary = $matchGroup.Groups[1].Value -replace '\\\\', '\'
            $commonPath = Join-Path $steamLibrary "steamapps\common"
            if ((Test-Path -LiteralPath $commonPath) -and -not $roots.Contains($commonPath)) {
                [void]$roots.Add($commonPath)
            }
        }
    }

    foreach ($root in $roots) {
        $match = Get-ChildItem -LiteralPath $root -Recurse -Filter $ExecutableName -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -ne $match) {
            return $match.FullName
        }
    }

    throw "Could not find $ExecutableName. Install Arma 3 Tools or pass the path explicitly."
}

$resolvedSourceAddonDir = (Resolve-Path -LiteralPath $SourceAddonDir).Path
$resolvedModRoot = (Resolve-Path -LiteralPath $ModRoot).Path
$resolvedPrivateKeyDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($PrivateKeyDir)

$addonBuilder = Resolve-ArmaTool -ProvidedPath $AddonBuilderPath -ExecutableName "AddonBuilder.exe"
$dsCreateKey = Resolve-ArmaTool -ProvidedPath $DSCreateKeyPath -ExecutableName "DSCreateKey.exe"
$prefixFile = Join-Path $resolvedSourceAddonDir '$PBOPREFIX$'
$prefix = (Get-Content -LiteralPath $prefixFile -Raw).Trim()

$outputAddonsDir = Join-Path $resolvedModRoot "addons"
$outputKeysDir = Join-Path $resolvedModRoot "keys"
$safeWorkspace = Join-Path $env:TEMP "trf_ukaf_ace_sleeves_gloves_release"
$stagingRoot = Join-Path $safeWorkspace "src"
$builderOutputDir = Join-Path $safeWorkspace "out"
$safeKeyDir = Join-Path $safeWorkspace "keys"
$stagingAddonDir = Join-Path $stagingRoot $AddonName

New-Item -ItemType Directory -Force -Path $resolvedPrivateKeyDir | Out-Null
New-Item -ItemType Directory -Force -Path $outputAddonsDir | Out-Null
New-Item -ItemType Directory -Force -Path $outputKeysDir | Out-Null
New-Item -ItemType Directory -Force -Path $stagingRoot | Out-Null
New-Item -ItemType Directory -Force -Path $builderOutputDir | Out-Null
New-Item -ItemType Directory -Force -Path $safeKeyDir | Out-Null

$privateKeyPath = Join-Path $resolvedPrivateKeyDir "$KeyName.biprivatekey"
$publicKeyPath = Join-Path $resolvedPrivateKeyDir "$KeyName.bikey"

if ((-not (Test-Path -LiteralPath $privateKeyPath)) -or (-not (Test-Path -LiteralPath $publicKeyPath))) {
    if (-not $GenerateKey) {
        throw "Signing keys not found. Re-run with -GenerateKey or provide an existing key path."
    }

    Push-Location -LiteralPath $resolvedPrivateKeyDir
    try {
        & $dsCreateKey $KeyName
        if ($LASTEXITCODE -ne 0) {
            throw "DSCreateKey failed with exit code $LASTEXITCODE."
        }
    } finally {
        Pop-Location
    }
}

if (Test-Path -LiteralPath $stagingAddonDir) {
    Remove-Item -LiteralPath $stagingAddonDir -Recurse -Force
}
New-Item -ItemType Directory -Force -Path $stagingAddonDir | Out-Null

Get-ChildItem -LiteralPath $resolvedSourceAddonDir -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $stagingAddonDir -Recurse -Force
}

$safePrivateKeyPath = Join-Path $safeKeyDir "$KeyName.biprivatekey"
$safePublicKeyPath = Join-Path $safeKeyDir "$KeyName.bikey"
Copy-Item -LiteralPath $privateKeyPath -Destination $safePrivateKeyPath -Force
Copy-Item -LiteralPath $publicKeyPath -Destination $safePublicKeyPath -Force

$outputPboPath = Join-Path $outputAddonsDir "$AddonName.pbo"
if (Test-Path -LiteralPath $outputPboPath) {
    Remove-Item -LiteralPath $outputPboPath -Force
}
Get-ChildItem -LiteralPath $outputAddonsDir -Filter "$AddonName.pbo.*.bisign" -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem -LiteralPath $builderOutputDir -Filter "*.pbo" -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem -LiteralPath $builderOutputDir -Filter "*.bisign" -ErrorAction SilentlyContinue | Remove-Item -Force

$builderArgLine = ('"{0}" "{1}" -packonly -sign={2} -prefix={3}' -f $stagingAddonDir, $builderOutputDir, $safePrivateKeyPath, $prefix)
$builderProcess = Start-Process -FilePath $addonBuilder -ArgumentList $builderArgLine -Wait -PassThru -NoNewWindow
if ($builderProcess.ExitCode -ne 0) {
    throw "AddonBuilder failed with exit code $($builderProcess.ExitCode)."
}

$builtPboPath = Join-Path $builderOutputDir "$AddonName.pbo"
[System.IO.File]::Copy($builtPboPath, $outputPboPath, $true)
$signedFiles = Get-ChildItem -LiteralPath $builderOutputDir -Filter "$AddonName.pbo.*.bisign" -ErrorAction SilentlyContinue
foreach ($signedFile in $signedFiles) {
    [System.IO.File]::Copy($signedFile.FullName, (Join-Path $outputAddonsDir $signedFile.Name), $true)
}

[System.IO.File]::Copy($publicKeyPath, (Join-Path $outputKeysDir "$KeyName.bikey"), $true)
if (-not (Test-Path -LiteralPath $outputPboPath)) {
    throw "Expected output PBO was not created: $outputPboPath"
}

Write-Output "Built $outputPboPath"
if ($signedFiles.Count -gt 0) {
    $signedFiles | ForEach-Object { Write-Output ("Signed " + $_.FullName) }
} else {
    Write-Output "No .bisign file was produced."
}
Write-Output "Public key copied to $(Join-Path $outputKeysDir "$KeyName.bikey")"
