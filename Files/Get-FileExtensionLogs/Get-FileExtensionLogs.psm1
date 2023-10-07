<#
.SYNOPSIS
	Script to allow for logging file extension and removing any file extensions that are logged.

.DESCRIPTION
    Script to allow for logging file extension and removing any file extensions that are logged.

.PARAMETER DefaultLogging
    This switch will allow for logging all files that do not match the defualt files to ignore. This cannot be used with parameter LogAllFiles.
    
.PARAMETER Delete
    This switch will delete any file(s) that are being logged.
        
.PARAMETER IgnoreDefaultFiles
    This switch is to allow for referencing the deault ignore list in the script. This option can be paired with parameter IgnoreSpecificFileExtension which will be added to the list of file extensions to ignore.

.PARAMETER IgnoreSpecificFileExtensions
    This string array allows for specifying additional files extensions to ignore.

.PARAMETER LogAllFiles
    This switch is to allow for logging all files extensions.

.PARAMETER LoggingPath
    This string logs defaultly to the desktop in a folder names ExtensionLogs. This parameter allows for specifying a different directory.

.PARAMETER LogSpecificFileExtensions
    This sting array allows for logging file extension specified only.

.PARAMETER SourceFolderPath
    This sting parameter allow for setting a default directory location or specifying what directory to log.

.EXAMPLE
    Get-FileExtensionLogs -DefaultLogging

.EXAMPLE
    Get-FileExtensionLogs -LogAllFiles

.EXAMPLE
    Get-FileExtensionLogs -LogSpecificFileExtenstions -Delete

.NOTES
    Any improvements welcome.
#>

function Get-FileExtensionLogs {

    param(
    
        [switch]$DefaultLogging,
        [switch]$Delete,
        [switch]$IgnoreDefaultFiles,
        [string[]]$IgnoreSpecificFileExtensions,
        [switch]$LogAllFiles,
        [string]$LoggingPath="$env:USERPROFILE\Desktop\ExtensionLogs\",
        [string[]]$LogSpecificFileExtentions,
        [string]$SourceFolderPath="\\<Path to>\<Share>"
    )

    #region INITIAL VARIABLES AND CHECKS

        if ($DefaultLogging -and $LogAllFiles){
        
            Write-Host "ROBOT: Uh..."
            Start-Sleep -Seconds 2
            Write-Host "ROBOT: No"
            Start-Sleep -Seconds 1
            exit
        }

        if ($Delete){
        
            $UserInput = Read-Host "ROBOT: Are you sure you want me to delete what I log?"
            Do {
            switch ($Input) {

                Y       {
                        Write-Host "ROBOT: Okay, your loss"
                        $Delete = $true
                        }
                N       {
                        Write-Host "ROBOT: Phew, you scared me for a second"
                        $Delete = $false
                        }
                Yes     {
                        Write-Host "ROBOT: Your funeral"
                        $Delete = $true
                        }
                No      {
                        Write-Host "ROBOT: What were you thinking?"
                        $Delete = $false
                        }
                Default {
                        $UserInput = Read-Host "ROBOT: wut?"
                        }
            }
            }until ($UserInput -eq 'Y' -or $UserInput -eq 'N' -or $UserInput -eq 'Yes' -or $UserInput -eq 'No')

        }
    
        $AllFiles = @()
        $Date = Get-Date -Format yyyyMMdd-hh-mm-ss
    
        if (-not $LogAllFiles -and $DefaultLogging){

            $DefaultFiles = @(
                "mp3"
                "wav"
                "flac"
                "m4a"
                "ogg"
                "wma"
                "mp4"
                "m3u"
                "jpeg"
                "jpg"
                "bmp"
                "png"
                "mpeg"
                "nfo"
                )

            if ($IgnoreDefaultFiles -and (-not $IgnoreSpecificFileExtensions)){
        
                $FilesToIgnore = $DefaultFiles  
            }
            if ($IgnoreDefaultFiles -and $IgnoreSpecificFileExtensions){
            
                [System.Collections.ArrayList]$FilesToIgnore = $DefaultFiles
                $FilesToIgnore.Add($IgnoreSpecificFileExtensions)
            }
            if ($IgnoreSpecificFileExtensions -and (-not $IgnoreDefaultFiles)){
            
                $FilesToIgnore = $IgnoreSpecificFileExtensions
            }
            if (-not $IgnoreDefaultFiles -and (-not $IgnoreSpecificFileExtensions)){
            
                $FilesToIgnore = $DefaultFiles
            }
            $FilesToIgnoreCount = $FilesToIgnore.Count
        }

    #endregion
    
    #region CREATE LOGGING DIRECTORY
    
        if($DefaultLogging -or $LogAllFiles -or $LogSpecificFileExtentions){
    
            # Check for directory
            if(!(Test-Path $LoggingPath)){

                New-Item -Path $LoggingPath -ItemType Directory
            }
        }

    #endregion

    #region FUNCTION
    
    function Remove-File {
    
        Remove-Item -Path $File.FullName -Force
    }

    function Set-LogFile {
    
        Add-Content -Value "$($File.FullName)" -Path "$LoggingPath\$Date-$FileExtension.log"
    }
    
    #endregion

    #region SCRIPT

        Write-Host "`0"
        Write-Host "ROBOT: Getting files..."

        # Get all files from audio path (ignore folders)
        $AllFiles = Get-ChildItem $SourceAudioPath -Recurse | Where-Object {$PSItem.mode -eq '------'}

        Write-Host "ROBOT: Files acquired"
        if ($Delete){
        
            Write-Host "ROBOT: Checking files to make logs and deleting what I find"
        }
        else{
        
            Write-Host "ROBOT: Checking files to make logs"
        }

        foreach ($File in $AllFiles){

            $FileBreak      = $File.Name.split('.')
            $FileBreakCount = $FileBreak.Count
            $FileExtension  = $FileBreak[$FileBreakCount - 1]

            #Check all files and print/log what is not on the files to ignorelist
            if ($DefaultLogging){

                $Integer = 0

                # Do not log the following files as no action will be taken on FilesToIgnore
                foreach($IgnoredFile in $FilesToIgnore){

                    if ($FileExtension -eq $IgnoredFile){
                
                        Continue
                    }
                    else{

                        $Integer++
                    }
                    # If file extension is not on the list, log it
                    if($Integer -eq $FilesToIgnoreCount){

                        Set-LogFile

                        # If parameter Delete is specified, delete
                        if($Delete -eq $true){
                    
                            Remove-File
                        }
                    }
                }
            }
            if ($LogAllFiles){
        
                # Log Everything
                Set-LogFile

                # If parameter Delete is specified, delete everything
                if($Delete -eq $true){
                    
                    Remove-File
                }
            }
            if ($LogSpecificFileExtentions){
        
                # Log only what is specified
                if ($FileExtension -eq $LogSpecificFileExtentions){
                
                    Set-LogFile
                }

                # If Delete parameter is specified, delete what is being logged
                if ($Delete -eq $true){
                
                    Remove-File
                }
            }
        }

        Write-Host "ROBOT: Aight. Logs should be on Desktop"
        Write-Host "ROBOT: Unless..."
        Start-Sleep -Seconds 2 
        Write-Host "ROBOT: You changed the path..."
        Start-sleep -Seconds 2
        Write-Host "ROBOT: I mean, why would you do that?"
        Start-Sleep -Seconds 1
        Write-Host "ROBOT: Silly"
        if($Delete -eq $true){
        
            Write-Host "ROBOT: Oh, by the way. I deleted your shitty files"
        }
    #endregion
}