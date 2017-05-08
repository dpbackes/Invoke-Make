# Invoke-Make

## Description
Invoke-Make as a Powershell wrapper around [Gnu Make for Windows](http://gnuwin32.sourceforge.net/packages/make.htm). On first use, the script will automatically download the necessary binaries. Once the binaries are downloaded, `Invoke-Make` can be used just like `make` on a *nix system.

## Installation
### PSGallery
Install from PSGallery with the following command

`Install-Script Invoke-Make`

### Manual
You can install manually by placing `Invoke-Make.ps1` anywhere in your `$Path`. The first run will download some files, so make sure to put it in a place that you have permission to write to from PowerShell.

## Tips
Use `Set-Alias -Name make -Value Invoke-Make` to get that *nix feeling.

## Examples
To run a target in your makefile, just execute

`Invoke-Make <TargetName>`