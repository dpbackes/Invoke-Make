<#PSScriptInfo
.VERSION 1.0

.GUID 32f9efa8-be81-4ac5-8f07-e1f57d528147

.AUTHOR Dan Backes

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI https://github.com/dpbackes/Invoke-Make

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
#>

<#
.SYNOPSIS
  A PowerShell wrapper around Gnu Make
.DESCRIPTION
  Invoke-Make as a Powershell wrapper around Gnu Make for Windows. On first use, the script will automatically download the necessary binaries. Once the binaries are downloaded, can be use just like make on a *nix system.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Dan Backes
  Creation Date:  8-May-2017
.EXAMPLE
  Invoke-Make build
  Runs the "build" target in your makefile
.EXAMPLE
  Invoke-Make tests
  Runs the "tests" target inyour makefile
.Link
  https://github.com/dpbackes/Invoke-Make
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false,ValueFromRemainingArguments=$true)]
    [string[]] $ScriptArgs
)

$folder = Join-Path $PSScriptRoot "Make"
$unzipPath = $(Join-Path $folder "files")
$pathToBin = $(Join-Path $unzipPath "bin\make.exe")

$makeZip = "https://downloads.sourceforge.net/project/gnuwin32/make/3.81/make-3.81-bin.zip"
$depsZip = "https://downloads.sourceforge.net/project/gnuwin32/make/3.81/make-3.81-dep.zip"

$makeZipDest = Join-Path $folder "make.zip"
$depZipDest  = Join-Path $folder "deps.zip"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip([string]$zipfile, [string]$outpath)
{
    Write-Output "Unzipping $zipFile to $outpath"

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function DownloadIfMissing([string]$source, [string]$dest)
{
    if ($(Test-Path $dest))
    {
        Write-Output "$dest already exists, skipping download"
        return
    }

    Write-Output "Downloading $source to $dest"
    Start-BitsTransfer -Source $source -Destination $dest
}

if (!$(Test-Path $pathToBin))
{
    Write-Output "Make executable not detected. Downloading..."

    if(!$(Test-Path $folder ))
    {
        New-Item $folder -Type Directory | Out-Null
    }

    DownloadIfMissing $makeZip $makeZipDest
    DownloadIfMissing $depsZip $depZipDest

    Unzip $makeZipDest $unzipPath
    Unzip $depZipDest $unzipPath
}

& $pathToBin @ScriptArgs