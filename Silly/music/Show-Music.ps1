function Show-Music {

    param(
        [Switch]$Genre,
        [Switch]$SubGenre,
        [Switch]$SubSubGenre,
        [Switch]$SubSubSubGenre,
        [String]$AllOf
    )

    #region INITIAL CHECK

        If (([bool]$Genre + [bool]$SubGenre + [bool]$SubSubGenre + [bool]$SubSubSubGenre) -gt 1 ){

            Write-Error "Please specify only: All, File or Directory for the parameter"
            break
        }

    #endregion

    #region Initial variables
    
        $PathToCSV = "$env:USERPROFILE\Desktop\music.csv"
        $Items = Import-Csv $PathToCSV

    #endregion

    #region SCRIPT
        
        if ($Genre){

            # List Random Genre
            Write-Host "`0"
            ($Items | Get-Random).Genre
            Write-Host "`0"
        }
        elseif($SubGenre){

            # List Random Sub Genre 
            $GetItem = $Items | Get-Random
            Write-Host "`0"
            Write-Host "$($PSStyle.Foreground.Cyan)$($GetItem.SubGenre)$($PSStyle.Reset) is sub Genre of $($PSStyle.Foreground.Yellow)$($GetItem.Genre)$($PSStyle.Reset)"
            Write-Host "`0"
        }
        elseif($SubSubGenre){

            # List Random SubSub Genre
            do {
                
                $GetItem = $Items | Get-Random
            }until(-not[string]::IsNullOrWhiteSpace($GetItem.SubSubGenre))
            Write-Host "`0"
            Write-Host "$($PSStyle.Foreground.BrightMagenta)$($GetItem.SubSubGenre)$($PSStyle.Reset) is a sub Genre of $($PSStyle.Foreground.Cyan)$($GetItem.SubGenre)$($PSStyle.Reset) which is sub Genre of $($PSStyle.Foreground.Yellow)$($GetItem.Genre)$($PSStyle.Reset)"
            Write-Host "`0"
        }
        elseif($SubSubSubGenre){

            # List Random SubSubSub Genre
            do {
                
                $GetItem = $Items | Get-Random
            }until(-not[string]::IsNullOrWhiteSpace($GetItem.SubSubSubGenre))
            Write-Host "`0"
            Write-Host "$($PSStyle.Foreground.BrightBlue)$($GetItem.SubSubSubGenre)$($PSStyle.Reset) is a sub Genre of $($PSStyle.Foreground.BrightMagenta)$($GetItem.SubSubGenre)$($PSStyle.Reset) which is a sub Genre of $($PSStyle.Foreground.Cyan)$($GetItem.SubGenre)$($PSStyle.Reset) which is sub Genre of $($PSStyle.Foreground.Yellow)$($GetItem.Genre)$($PSStyle.Reset)"               
            Write-Host "`0"
        }
        elseif($AllOf){

            # List all of specified Genre
            foreach($Item in $Items){

                if ($AllOf -eq $Item.Genre -or $AllOf -eq $Item.SubGenre -or $AllOf -eq $Item.SubSubGenre -or $AllOf -eq $SubSubSubGenre){


                }
            }
        }
        else{}

    #endregion
}
