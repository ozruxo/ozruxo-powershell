<#

.SYNOPSIS
	Find the commandlet you forgot you used in previous scripts

.DESCRIPTION
    The intention of this script was to assist with finding lines in a script I know I used, but don't exactly remember what script I was working in and what was typed.

    PARAMETER(S)
    -String
        Type the string that you are looking for. Note, this module is using match and not equal or like.
    
    -Path
        Enter in the path to the directory in which you want to search for a string in files that can be opened with Get-Content. Or leave it to the default you have set.

.EXAMPLE
    Find-String -String Computers

.EXAMPLE
    Find-String -String Computers -Path "C:\scripts"

.NOTES

#>

function Find-String {

    param(
    [string]$String,
    [string]$Path='c:\<Path>\<of>\<directory>'
    )

    begin{
        
        $Items = Get-ChildItem $Path -Recurse
    }

    process {
    
        foreach($Item in $Items){

            if($Item.mode -eq '-a---l'){
    
                $Contents = Get-Content $Item.Fullname
                foreach($Line in $Contents) {
        
                     if ($Line -match $String){
         
                        Write-Host "`0"
                        Write-host -ForegroundColor Yellow "$($Item.FullName)"
                        $Line
                     }
                }
            }
        }
    }
}