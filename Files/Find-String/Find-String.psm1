<#

.SYNOPSIS
	Find a string of characters in a directory of files

.DESCRIPTION
    Find a string of characters in a directory of files. When you forget a cmdlet of something you did previously, but vaguely remember what is was you were working on.

.PARAMETER String
    Type the string you are looking for. That includes integers.

.PARAMETER Path
    Type the path of files you would like to search.

.EXAMPLE
    Find-String 'arraylist'

.EXAMPLE
    Find-VM -String "nullorwhitespace"

#>

function Find-String {

    param(
        [String]$String,
        [String]$Path="$env:USERPROFILE"
    )

    $items = Get-ChildItem $Path -Recurse

    foreach($Item in $Items){

        if($Item.Attributes -notlike "Directory*" -and $Item.Attributes -notmatch "\d"){

            if ($Item.Extension -eq '.zip'){
            
                continue
            }
            else{

                $contents = Get-Content $Item.Fullname
                foreach($Line in $Contents) {
    
                    if ($Line -match "$String"){
    
                    Write-Host "`0"
                    Write-host -ForegroundColor DarkGray "$($Item.FullName)"
                    Write-Host $PSStyle.Foreground.BrightWhite, $Line.Trim(), $PSStyle.Reset
                    }
                }
            }
        }
    }
    Write-Host "`0"
}
