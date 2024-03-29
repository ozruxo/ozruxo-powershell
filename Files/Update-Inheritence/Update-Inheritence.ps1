<#
.SYNOPSIS
Add inheritance to a file or folder.
.DESCRIPTION
Add inheritance to a file or folder.
.PARAMETER Path
Indicate what the parent path of all effected files or folders that need to be modified.
.PARAMETER LogDirectory
Indicate the directory path for the file to be logged.
.PARAMETER File
Specify if the change should be made to a file.
.PARAMETER Directory
Specify ig the change shoul dbe made to a folder.
.EXAMPLE
Add-Inheritence -Path "C:\tmp" -File
.NOTES
Link to reference: https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.objectsecurity.setaccessruleprotection?view=dotnet-plat-ext-3.1
Two problems:
    1. When inheritance is added. Previous objects without inheritance do not get removed.
    2. If you run the script multiple times over the same file. Additional objects get added to the file.
There are potential solutions for correcting this.
#>

function Update-Inheritence {

    [CmdletBinding()]
    param(
        [String]$Path,
        [Switch]$All,
        [Switch]$File,
        [Switch]$Directory,
        [String]$LogDirectory="$env:USERPROFILE\Desktop"
    )

    #region INITIAL VARIABLES

        if(!([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))){

            Write-Warning 'Please run as administrator'
            break
        }
    
        If (([bool]$File + [bool]$Directory + [bool]$All) -gt 1 ){

            Write-Error "Please specify only: All, File or Directory for the parameter"
            break
        }

        # Display banner
        $Banner

        $DateTime         = Get-Date -Format yyyy-MM-dd-hh-mm-ss
        $ChangeFileName   = "$DateTime-Change-FileInheritance.csv"
        $NoChangeFileName = "$DateTime-NoChange-FileInheritance.csv"

        If($File){

            # Get non folders/directories
            $Files = Get-ChildItem -Path $Path -File -Recurse
            Write-Verbose 'Setting variable for non folders/directories'
        }
        elseif($Directory){

            # Get files that are not folders/directories
            $Files = Get-ChildItem -Path $Path -Directory -Recurse
            Write-Verbose 'Setting variable for files that are not folders/directories'
        }
        elseif($All){

            # Get all files
            $Files = Get-ChildItem -Path $Path -Recurse
            Write-Verbose 'Setting variables for all files'
        }
        else{

            Write-Error "No option selected"
        }

    #endregion

    #region function

        function Set-LogData {

            param(
                [Object]$InputData,
                [Switch]$Change,
                [Switch]$NoChange
            )

            if ($Change){
            
                # Print indicating change
                [PSCustomObject]$InputData | Export-Csv -Path "$LogDirectory\$ChangeFileName" -NoClobber -Append -NoTypeInformation
                Write-Verbose 'Writting to Change file'
            }
            if($NoChange){

                #Print indicating no change
                [PSCustomObject]$InputData | Export-Csv -Path "$LogDirectory\$NoChangeFileName" -NoClobber -Append -NoTypeInformation
                Write-Verbose 'Writting to NoChange file'
            }
        }

    #endregion

    #region SCRIPT
        
        Foreach($IndividualFile in $Files){

            Write-Verbose "Getting ACL for file: $($IndividualFile.Name)"
            # Get ACL
            $Permission = Get-ACL -Path $IndividualFile.FullName

            # Reset variable
            $NeedToAddInheritance = $false

            # Since there are mutiple object with ACLs on a file, loop to find any $false
            foreach ($Perm in $Permission.Access){

                if($Perm.IsInherited -eq $false){

                    # Mark variable as true for next if statement
                    $NeedToAddInheritance = $true
                    Write-Verbose "Found file to be updated: $($IndividualFile.Name)"
                    break
                }
                else{

                    # Do nothing in this loop
                }
            }

            if($NeedToAddInheritance -eq $true){

                Write-Verbose "Updating File: $($IndividualFile.Name)"
                # Set inheritance (isProtected,preserveInheritance)
                $Permission.SetAccessRuleProtection($false,$true)
                
                # Apply setting to file
                Set-Acl -Path $IndividualFile.FullName -AclObject $Permission

                # Custom object for printing
                $PSObject = @{
                    PSTypeName  = 'SaveObject'
                    FileName    = $IndividualFile.name
                    Inheritance = $Perm.IsInherited
                    Modified    = 'True'
                }

                # Print indicating change
                Set-LogData -InputData $PSObject -Change
                Write-Verbose 'Logging change'

                # Null variable
                $PSObject = $null
            }
            else{

                # Custom object for printing
                $PSObject = @{
                    PSTypeName  = 'SaveObject'
                    FileName    = $IndividualFile.name
                    Inheritance = $Perm.IsInherited
                    Modified    = 'False'
                }

                # Print indicating change
                Set-LogData -InputData $PSObject -NoChange
                Write-Verbose 'Logging nochange'
            }
        }

    #endregion
}
