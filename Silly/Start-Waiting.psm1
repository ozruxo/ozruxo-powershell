<#
.SYNOPSIS
	Display progress in ASCII.

.DESCRIPTION
    Display progress in ASCII.

.PARAMETER LoopCount
    Specify how many times the function should loop. Default is 4 just to sample the script.

.PARAMETER Option
    Specify what progress bar you want. There are 15 options.

.PARAMETER Speed
    Specify how fast the progress bar should run in milliseconds. Options are 100ms, 200ms, 300ms, 400ms, 500ms.

.PARAMETER StatusMessage
    Display a message while the progress bar is running.

.EXAMPLE
    Start-Waiting -Option 1

.EXAMPLE
    Start-Waiting -LoopCount 100 -Speed 100 -StatusMessage "Percentage Complete $Percent" -Option 5
    
.NOTES
    Any improvements welcome.
#>

function Start-Waiting {

    param(
        [String]$LoopCount=4,
        [ValidateRange(1,15)]
        [Parameter(Mandatory=$true)]
        [String]$Option,
        [ValidateSet(100,200,300,400,500)]
        [String]$Speed=200,
        [String]$StatusMessage
    )

    #region INITIAL VARIABLES

        switch($Option){
            1  {$Progress  = "' ","⠁ ","⠂ ","⠄ ","⡀ ","⢀ ","⠠ ","⠐ ","⠈ ","' "}
            2  {$Progress  = "- ","\ ","| ","/ "}
            3  {$Progress  = "▁▂▃▄▅▆▇█▇▆▅▄▃▂▁","▂▃▄▅▆▇█▇▆▅▄▃▂▁▁","▃▄▅▆▇█▇▆▅▄▃▂▁▁▂","▄▅▆▇█▇▆▅▄▃▂▁▁▂▃","▅▆▇█▇▆▅▄▃▂▁▁▂▃▄","▆▇█▇▆▅▄▃▂▁▁▂▃▄▅","▇█▇▆▅▄▃▂▁▁▂▃▄▅▆","█▇▆▅▄▃▂▁▁▂▃▄▅▆▇","▇▆▅▄▃▂▁▁▂▃▄▅▆▇█","▆▅▄▃▂▁▁▂▃▄▅▆▇█▇","▅▄▃▂▁▁▂▃▄▅▆▇█▇▆","▄▃▂▁▁▂▃▄▅▆▇█▇▆▅","▃▂▁▁▂▃▄▅▆▇█▇▆▅▄","▂▁▁▂▃▄▅▆▇█▇▆▅▄▃","▁▁▂▃▄▅▆▇█▇▆▅▄▃▂"}
            4  {$Progress  = "▉▊▋▌▍▎▏▎▍▌▋▊▉","▊▋▌▍▎▏▎▍▌▋▊▉▉","▋▌▍▎▏▎▍▌▋▊▉▉▊","▌▍▎▏▎▍▌▋▊▉▉▊▋","▍▎▏▎▍▌▋▊▉▉▊▋▌","▎▏▎▍▌▋▊▉▉▊▋▌▍","▏▎▍▌▋▊▉▉▊▋▌▍▎","▎▍▌▋▊▉▉▊▋▌▍▎▏","▍▌▋▊▉▉▊▋▌▍▎▏▎","▌▋▊▉▉▊▋▌▍▎▏▎▍","▋▊▉▉▊▋▌▍▎▏▎▍▌","▊▉▉▊▋▌▍▎▏▎▍▌▋","▉▉▊▋▌▍▎▏▎▍▌▋▊"}
            5  {$Progress  = "← ","↖ ","↑ ","↗ ","→ ","↘ ","↓ ","↙ "}
            6  {$Progress  = "▖ ","▘ ","▝ ","▗ "}
            7  {$Progress  = "┤ ","┘ ","┴ ","└ ","├ ","┌┬┐ "}
            8  {$Progress  = "◢ ","◣ ","◤ ","◥ "}
            9  {$Progress  = "◰ ","◳ ","◲ ","◱ "}
            10 {$Progress = "◴ ","◷ ","◶ ","◵ "}
            11 {$Progress = "◐ ","◓ ","◑ ","◒ "}
            12 {$Progress = "⣾ ","⣽ ","⣻ ","⢿ ","⡿ ","⣟ ","⣯ ","⣷ "}
            13 {$Progress = "(•_•)     ","(•_•)     ","(•_•)     ","(•_•)     ","(•_•)     ","(•_•)     ","(•_•)     ","(•_•)     ","( •_•)>⌐■-■","( •_•)>⌐■-■","(⌐■_■)     ","(⌐■_■)     ","(⌐■_■)     ","(⌐■_■)     "}
            14 {$Progress = "＼(ﾟｰﾟ＼)","( ﾉ ﾟｰﾟ)ﾉ"}
            15 {$Progress = "`n88`n  88`n    88`n      88`n        88","`n    88`n    88`n    88`n    88`n    88","`n        88`n      88`n    88`n  88`n88`n","`n`n8888888888`n`n"}
        }

    #endregion

    #region FUNCTIONS

        function Start-ProcessingStrings {

            param(
                [string[]]$Array
            )

            $ProgressCount = $Array.Count
            for($i=0; $i -le $ProgressCount; $i++){

                if($Option -eq 15){

                    $StatusMessage
                    $Array[$i]
                    Clear-Host
                }

                    Write-host -NoNewline "`r $StatusMessage $($Array[$i])"
                    Start-Sleep -Milliseconds $Speed
            }
        }

    #endregion

    #region SCRIPT

        $i =1
        do {    
        
            Start-ProcessingStrings -Array $Progress
            
            if($LoopCount -eq 1){ 
                $i = 1
            }
            else {
            
                $i++
            }
        }until($i -eq $LoopCount)

    #endregion
}