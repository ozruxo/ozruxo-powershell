<#
.SYNOPSIS
    Try your chance at some numbers.
    
.DESCRIPTION
    Try your chance at some numbers.

.PARAMETER SourceFiles
    Specify the dirtory location of the files needed for this script.
    
.EXAMPLE
    AmIFeelingLucky -SourceFiles C:\tmp\SourceFiles
    
.NOTES
    Any improvements welcome.
#>

function AmIFeelingLucky {

    param(
        [String]$SourceFiles='.\AIFLSourceFiles'
    )

    #region FUNCTIONS

        # Determine numbers to display
        function Get-Numbers {

            param(
                [Switch]$Numbers,
                [Switch]$PowerBall
            )

            if ($Numbers){

                $Stop = 5
            }
            else {

                $Stop = 1
            }
            
            $Int = 0
            $Winners = [System.Collections.ArrayList]::New()
            
            if ($PowerBall){

                [System.Collections.ArrayList]$AllPossibilities = (Get-ChildItem $SourceFiles -Exclude 'rotate*' | Where-object{[int]$PSItem.Name.split('.')[0] -le 26}).Name
            }
            else{
            
                [System.Collections.ArrayList]$AllPossibilities = (Get-ChildItem $SourceFiles -Exclude 'rotate*').Name
            }

            do {
            
                # Get random number
                $Number = $AllPossibilities | Get-Random
                $Winners.Add($Number) | Out-Null

                # Remove random number from list
                $AllPossibilities.Remove($Number)

                # Increment int
                $Int++

            }until($Int -eq $Stop)

            return $Winners
        }

        function Show-Numbers {

            param(
                [Array]$Winners
            )

            # Get needed files
            $FindOne   = Get-ChildItem $SourceFiles | Where-Object {$PSItem.Name -eq 'rotate_one.txt'}
            $RotateOne = Get-Content $FindOne.FullName
            $FindTwo   = Get-ChildItem $SourceFiles | Where-Object {$PSItem.Name -eq 'rotate_two.txt'}
            $RotateTwo = Get-Content $FindTwo.FullName

            foreach ($Winner in $Winners){
            
                # Alternate the printout
                $Int = 0
                do{

                    Clear-Host
                    $RotateOne
                    Start-Sleep -Milliseconds 100
                    Clear-Host
                    $RotateTwo
                    Start-Sleep -Milliseconds 100
                    $Int++

                }until($Int -eq 4)

                # Print selected number
                $LocatedFile = Get-ChildItem $SourceFiles | Where-Object {$PSItem.Name -eq $Winner}
                Clear-Host
                Get-Content $LocatedFile.FullName
                Start-Sleep -Seconds 2
            }
        }

        function Show-PowerBall {

            param(
                [Array]$Winners
            )

            # Get needed files
            $FindOne   = Get-ChildItem $SourceFiles | Where-Object {$PSItem.Name -eq 'rotate_one.txt'}
            $RotateOne = Get-Content $FindOne.FullName
            $FindTwo   = Get-ChildItem $SourceFiles | Where-Object {$PSItem.Name -eq 'rotate_two.txt'}
            $RotateTwo = Get-Content $FindTwo.FullName

            foreach ($Winner in $Winners){
            
                # Alternate the printout
                $Int = 0
                do{

                    Clear-Host
                    $PSStyle.Foreground.BrightRed 
                    $RotateOne
                    Start-Sleep -Milliseconds 100
                    Clear-Host
                    $RotateTwo
                    Start-Sleep -Milliseconds 100
                    $Int++

                }until($Int -eq 4)

                # Print selected number
                $LocatedFile = Get-ChildItem $SourceFiles | Where-Object {$PSItem.Name -eq $Winner}
                Clear-Host
                Get-Content $LocatedFile.FullName
                Start-Sleep -Seconds 2
                $PSStyle.Reset
            }
        }

    #endregion

    #region SCRIPT

        $MyLuckyNumbers = Get-Numbers -Numbers
        $ThisIsTheDay  = Get-Numbers -PowerBall
        Show-Numbers -Winners $MyLuckyNumbers
        Show-PowerBall -Winners $ThisIsTheDay
        Clear-Host
        Write-Host -ForegroundColor Green -NoNewline "`rROBOT: Since I am a contributor to your winnings"
        Start-Sleep -Seconds 3
        Write-Host -ForegroundColor Blue -NoNewline "`rROBOT: I get a portion of your winnings, right? "
        Start-Sleep -Seconds 3
        Write-Host -ForegroundColor Blue -NoNewline "`rBoop boop Beep Bop                              "
        Write-Host -NoNewline "`rYour numbers madam/sir:                              "
        Write-Host "`n"
        Write-Host "$($MyLuckyNumbers[0].Split('.')[0]) $($MyLuckyNumbers[1].Split('.')[0]) $($MyLuckyNumbers[2].Split('.')[0]) $($MyLuckyNumbers[3].Split('.')[0]) $($MyLuckyNumbers[4].Split('.')[0]) $($PSStyle.Foreground.BrightRed)$($thisIsTheDay.Split('.')[0]) $($PSStyle.Reset)"
        Write-Host "`0"

    #endregion

}