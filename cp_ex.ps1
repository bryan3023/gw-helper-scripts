<#
  .SYNOPSIS
  Copy files for an activity from the lessons repo to an in-class working
  folder.

  .DESCRIPTION
  Looks for a set of working files under a specified lesson and activity
  number and, if found, copies them under an in-class folder with today's
  date.

  Use the "-Code" switch to automatically open VS Code.
 #>
Param(
    [Parameter(Mandatory)]
    [int] $LessonNumber
,
    [Parameter(Mandatory)]
    [int] $ActivityNumber
,
    [switch] $Code
)

[string] $LessonNumber = "$LessonNumber".PadLeft(2,'0')
[string] $ActivityNumber = "$ActivityNumber".PadLeft(2,'0')

function Get-TodayDirectory {
    (Get-Date -Format "MM-dd")
}

$GwRootDirectory = (Get-Item $PSScriptRoot).Parent.FullName;

$SourceDirectory = "$GwRootDirectory/Lessons/$LessonNumber*/01-Activities/$ActivityNumber*"
$DestinationDirectory = "$GwRootDirectory/in-class/$(Get-TodayDirectory)/"

if (-not (Resolve-Path $SourceDirectory)) {
    Write-Error "No path found under that lesson or activity number."
}

Copy-Item -Path $SourceDirectory -Destination $DestinationDirectory -Recurse -Force

if ($Code) {
    $CodeDirectory = (Get-Item $SourceDirectory).BaseName
    & code $CodeDirectory
}