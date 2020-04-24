<#
  .SYNOPSIS
  Copy files for an activity from the lessons repo to an in-class working
  folder.

  .DESCRIPTION
  Looks for a set of working files under a specified lesson and activity
  number and, if found, copies them under an in-class folder with today's
  date.

  Use the "-Code" switch to automatically open VS Code.

  Use the "-Node" switch to automatically set up Node dependencies. If a
  packages.json does not exit, it will be created with default values. If
  it does, dependent packages will be downloaded.
 #>
Param(
    [Parameter(Mandatory)]
    [int] $LessonNumber
,
    [Parameter(Mandatory)]
    [int] $ActivityNumber
,
    [switch] $Code
,
    [switch] $Node
)

[string] $LessonNumber = "$LessonNumber".PadLeft(2,'0')
[string] $ActivityNumber = "$ActivityNumber".PadLeft(2,'0')

function Get-TodayDirectory {
    [OutputType([string])]
    Param()

    (Get-Date -Format "MM-dd")
}

[string] $GwRootDirectory = (Get-Item $PSScriptRoot).Parent.FullName;
[string] $SourceDirectory = "$GwRootDirectory/Lessons/$LessonNumber*/01-Activities/$ActivityNumber*"
[string] $DestinationDirectory = "$GwRootDirectory/in-class/$(Get-TodayDirectory)/"
[string] $CodeDirectory = Join-Path -Path $DestinationDirectory -ChildPath (Get-Item $SourceDirectory).BaseName

if (-not (Resolve-Path $SourceDirectory)) {
    Write-Error "No path found under that lesson or activity number."
}

if (Test-Path $CodeDirectory) {
    Write-Warning "Folder '$CodeDirectory' already exists. Overwrite?"
    [string] $overwrite = Read-Host -Prompt "'yes' to continue."

    if ($overwrite -ne 'yes') {
        exit
    }
}

$UnsolvedDirectory = Join-Path -Path $CodeDirectory -ChildPath 'Unsolved'

if (Test-Path $UnsolvedDirectory) {
    $CodeDirectory = $UnsolvedDirectory
}

Copy-Item -Path $SourceDirectory -Destination $DestinationDirectory -Recurse -Force

if ($Node) {
    Push-Location $CodeDirectory
    if (Test-Path (Join-Path -Path $CodeDirectory -ChildPath "packages.json")) {
        & npm install
    } else {
        & npm init -y
    }
    Pop-Location
}

if ($Code) {
    & code $CodeDirectory
}
