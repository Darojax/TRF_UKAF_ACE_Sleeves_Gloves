param(
    [string]$ModRoot = (Join-Path $PSScriptRoot "..\@TRF_UKAF_ACE_Sleeves_Gloves"),
    [string]$KeyName = "Darojax",
    [string]$PrivateKeyDir = (Join-Path $PSScriptRoot "..\_private\signing"),
    [string]$DSCreateKeyPath = "",
    [string]$DSSignFilePath = "",
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

$resolvedModRoot = (Resolve-Path -LiteralPath $ModRoot).Path
$resolvedPrivateKeyDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($PrivateKeyDir)
$dsCreateKey = Resolve-ArmaTool -ProvidedPath $DSCreateKeyPath -ExecutableName "DSCreateKey.exe"
$dsSignFile = Resolve-ArmaTool -ProvidedPath $DSSignFilePath -ExecutableName "DSSignFile.exe"

New-Item -ItemType Directory -Force -Path $resolvedPrivateKeyDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $resolvedModRoot "keys") | Out-Null

$privateKeyPath = Join-Path $resolvedPrivateKeyDir "$KeyName.biprivatekey"
$publicKeyPath = Join-Path $resolvedPrivateKeyDir "$KeyName.bikey"

if ((-not (Test-Path -LiteralPath $privateKeyPath)) -or (-not (Test-Path -LiteralPath $publicKeyPath))) {
    if (-not $GenerateKey) {
        throw "Signing keys not found. Re-run with -GenerateKey or provide an existing key path."
    }

    Push-Location -LiteralPath $resolvedPrivateKeyDir
    try {
        & $dsCreateKey $KeyName
    } finally {
        Pop-Location
    }
}

$pboFiles = Get-ChildItem -LiteralPath (Join-Path $resolvedModRoot "addons") -Filter "*.pbo"
if ($pboFiles.Count -eq 0) {
    throw "No PBO files found in $resolvedModRoot\addons"
}

Copy-Item -LiteralPath $publicKeyPath -Destination (Join-Path $resolvedModRoot "keys\$KeyName.bikey") -Force

foreach ($pboFile in $pboFiles) {
    Get-ChildItem -LiteralPath $pboFile.DirectoryName -Filter "$($pboFile.Name).*.bisign" -ErrorAction SilentlyContinue | Remove-Item -Force
    & $dsSignFile $privateKeyPath $pboFile.FullName
}

Write-Output "Signed $($pboFiles.Count) PBO file(s)."
Write-Output "Public key copied to $(Join-Path $resolvedModRoot "keys\$KeyName.bikey")"
