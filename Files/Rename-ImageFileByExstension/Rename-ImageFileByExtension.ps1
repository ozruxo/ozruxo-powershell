<#

#>

function Rename-ImageFileByExtension {

    [CmdletBinding()]    
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet('.jpg','.png')]
        [String]$Extension,
        [Switch]$Log,
        [String]$LogPath='C:\logs\FileRename\',
        [Parameter(Mandatory=$true)]
        [String]$NewFileName,
        [Parameter(Mandatory=$true)]
        [String]$Path
    )

    #region INITIAL VARIABLES

        $LogFile = "$(Get-Date -Format yyyy-MM-dd_hh-mm-ss)_FileRename.log"

    #endregion

    #region FUNCTIONS

        function Set-Change {

            param(
                [Array[]]$InputArray,
                [String]$Ext
            )

            foreach ($Item in $InputArray){

                # if there is only one file,rename
                if ((Get-ChildItem $Item.Directory | Where-Object {$PSItem.Extension -eq $Ext}).Count -eq 1){

                    if ($Item.Name -ne $NewFileName){
                        
                        Write-Output "`0"
                        Write-Host -ForegroundColor Green "Attempting to Change $($Item.Name) to $NewFileName$($Item.Extension)"
                        Write-Output "`0"
                        Rename-Item -Path $Item.FullName -NewName '$NewFileName'+ "$($item.Extension)" -Force -ErrorVariable NoRename -ErrorAction SilentlyContinue
                        if($NoRename){
                        
                            Write-Warning "Unable to rename file: $($Item.FullName)"
                        }
                    }
                    else{
                    
                        Write-Host -ForegroundColor Yellow "No need to change name. Currently: $($Item.Name)"
                    }
                }
                else {
                
                    Write-Host -ForegroundColor Cyan "Skipping $($Item.Name) in Folder $($Item.Directory)"
                    Continue
                }
            }
        }

    #endregion

    #refion SCRIPT

       if ($Log){

            if(-not (Test-Path $LogPath)){
            
                New-Item -Path $LogPath -ItemType Directory
            }
            Start-Transcript -Path "$LogPath\$LogFile"
        }
        else{
        
            Write-Verbose "No logging"
        }

        Write-Output "`0"
        Write-Output "Please wait..."
        Write-Output "`0"
        $Files = Get-ChildItem "$Path\*" -Recurse | Where-Object {$PSItem.Extension -eq $Extension}

        Set-Change -InputArray $Files -Ext $Extension

        if ($Log){
        
            Stop-Transcript
        }

    #endregion
}