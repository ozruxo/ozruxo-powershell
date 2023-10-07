<#

.SYNOPSIS
	Print the size of a folder

.DESCRIPTION
    Print the size of a folder in measurements.

.PARAMETER Path
    Enter the path in which you would like to have measured.

.PARAMETER TB
    Specify this switch to get the specified measurement.
    
.PARAMETER GB
    Specify this switch to get the specified measurement.
    
.PARAMETER MB
    Specify this switch to get the specified measurement.
    
.PARAMETER KB
    Specify this switch to get the specified measurement.
    
.PARAMETER Bytes
    Specify this switch to get the specified measurement.
    
.PARAMETER Bits
    Specify this switch to get the specified measurement.

.EXAMPLE
    Get-FolderSize .\

.EXAMPLE
    Get-FolderSize -Path C:\test -KB

.NOTES
    Any improvements welcome.
#>

Function Get-FolderSize {
    
    Param(
        [Parameter(Mandatory=$true)]
        [String]$path,
        [switch]$TB,
        [switch]$GB,
        [switch]$MB,
        [switch]$KB,
        [switch]$Bytes,
        [switch]$Bits
    )

    $NewObject = @{
        TB   = "{0:n2}" -f ((Get-ChildItem -Path $path -Recurse | Measure-Object -Property length -Sum).sum /1TB)+"TB" 
        GB   = "{0:n2}" -f ((Get-ChildItem -Path $path -Recurse | Measure-Object -Property length -Sum).sum /1GB)+"GB"
        MB   = "{0:n2}" -f ((Get-ChildItem -Path $path -Recurse | Measure-Object -Property length -Sum).sum /1MB)+"MB"
        KB   = "{0:n2}" -f ((Get-ChildItem -Path $path -Recurse | Measure-Object -Property length -Sum).sum /1KB)+"KB"
        Byte = "{0:n2}" -f ((Get-ChildItem -Path $path -Recurse | Measure-Object -Property length -Sum).sum)+"Bytes"
        Bits = "{0:n2}" -f ((Get-ChildItem -Path $path -Recurse | Measure-Object -Property length -Sum).sum * 8)+"Bits"
    }
    "`n"
    Write-Host -ForegroundColor Cyan $path
    If ($TB){
    
        $NewObject.TB
    }
    If ($GB){
    
        $NewObject.GB
    }
    If ($MB){
    
        $NewObject.MB
    }
    If ($KB){
    
        $NewObject.KB
    }
    If ($Bytes){
    
        $NewObject.Bytes
    }
    If ($Bits){
    
        $NewObject.Bits
    }
    if (!($TB) -and !($GB) -and !($MB) -and !($KB) -and !($Bytes) -and !($Bits)) {
    
        $NewObject
    }
}
