<#
.SYNOPSIS
	Script to allow for logging file extension and removing any file extensions that are logged.

.DESCRIPTION
    Script to allow for logging file extension and removing any file extensions that are logged.
    
.PARAMETER Delete
    This switch will delete any file(s) being logged.

.PARAMETER LoggingPath
    This string logs defaultly to the desktop in a folder names ExtensionLogs. This parameter allows for specifying a different directory.

.PARAMETER SourceFolderPath
    This sting parameter allow for setting a default directory location or specifying what directory to log.

.EXAMPLE
    Get-FileExtension -FileExtension txt -SourceFolderPath \\files\here

.EXAMPLE
    Get-FileExtension -FileExtension txt -SourceFolderPath \\files\here -Delete

.NOTES
    Any improvements welcome.
#>

function Get-FileExtension {

    param(
        [Switch]$Delete,
        [String]$LoggingPath="$env:USERPROFILE\Desktop\ExtensionLogs\",
        [String]$FileExtension,
        [String]$SourceFolderPath
    )

    #region INITIAL VARIABLES AND CHECKS

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
        $Date = Get-Date -Format yyyy-MM-dd_hh-mm-ss

    #endregion
    
    #region CREATE LOGGING DIRECTORY
    
        # Check for directory
        if(!(Test-Path $LoggingPath)){

            New-Item -Path $LoggingPath -ItemType Directory
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
        $AllFiles = Get-ChildItem $SourceFolderPath -Recurse `
        | Where-Object {$PSItem.mode -eq '-----'} `
        | Where-object {$PSItem.Extension -eq $FileExtension}

        Write-Host "ROBOT: Files acquired"
        if ($Delete){
        
            Write-Host "ROBOT: Checking files to make logs and deleting what I find"
        }
        else{
        
            Write-Host "ROBOT: Checking files to make logs"
        }

        foreach ($File in $AllFiles){
            
            # Log Everything
            Set-LogFile

            # If parameter Delete is specified, delete everything
            if($Delete -eq $true){
                
                Remove-File
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
        
            Write-Host "ROBOT: Oh, by the way. I deleted your files"
        }
    #endregion
}