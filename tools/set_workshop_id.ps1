param(
    [Parameter(Mandatory = $true)]
    [string]$PublishedId,

    [string]$ModRoot = (Join-Path $PSScriptRoot "..\@TRF_UKAF_ACE_Sleeves_Gloves")
)

$resolvedModRoot = (Resolve-Path -LiteralPath $ModRoot).Path
$metaPath = Join-Path $resolvedModRoot "meta.cpp"

$content = @(
    "protocol = 1;"
    "publishedid = $PublishedId;"
)

Set-Content -LiteralPath $metaPath -Value $content -Encoding ascii
Write-Output "Wrote $metaPath"
