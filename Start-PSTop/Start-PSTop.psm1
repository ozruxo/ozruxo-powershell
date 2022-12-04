# Get-Counter -ListSet

function Start-PSTop {

    param(
    [int]$Processes=10
    )

    #region FUNCTION

        Function GetProcProgress ($Global:InProcSwitch, $Global:sytle){
        
            if ($PSVersionTable.PSVersion.Major -ge 7){

                switch ($InProcSwitch)
                {
                       {$_ -ge 0 -and $_ -le 5} {(($style.fg.rgb -f 0,190,100), '|                   ', $Style.default)}
                      {$_ -ge 6 -and $_ -le 10} {(($style.fg.rgb -f 0,190,100), '||                  ', $Style.default)}
                     {$_ -ge 11 -and $_ -le 15} {(($style.fg.rgb -f 0,190,100), '|||                 ', $Style.default)}
                     {$_ -ge 16 -and $_ -le 20} {(($style.fg.rgb -f 0,190,100), '||||                ', $Style.default)}
                     {$_ -ge 21 -and $_ -le 25} {(($style.fg.rgb -f 0,190,100), '|||||               ', $Style.default)}
                     {$_ -ge 26 -and $_ -le 30} {(($style.fg.rgb -f 0,190,100), '||||||              ', $Style.default)}
                     {$_ -ge 31 -and $_ -le 35} {(($style.fg.rgb -f 0,190,100), '|||||||             ', $Style.default)}
                     {$_ -ge 36 -and $_ -le 40} {(($style.fg.rgb -f 0,190,100), '||||||||            ', $Style.default)}
                     {$_ -ge 41 -and $_ -le 45} {(($style.fg.rgb -f 0,190,100), '|||||||||           ', $Style.default)}
                     {$_ -ge 46 -and $_ -le 50} {(($style.fg.rgb -f 0,190,100), '||||||||||          ', $Style.default)} #10
                     {$_ -ge 51 -and $_ -le 55} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|         ', $Style.default -join "")}
                     {$_ -ge 56 -and $_ -le 60} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '||        ', $Style.default -join "")}
                     {$_ -ge 61 -and $_ -le 65} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|||       ', $Style.default -join "")}
                     {$_ -ge 66 -and $_ -le 70} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '||||      ', $Style.default -join "")}
                     {$_ -ge 71 -and $_ -le 75} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|||||     ', $Style.default -join "")}
                     {$_ -ge 76 -and $_ -le 80} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|||||', ($style.fg.rgb -f 255,70,85),'|    ', $Style.default -join "")}
                     {$_ -ge 81 -and $_ -le 85} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|||||', ($style.fg.rgb -f 255,70,85),'||   ', $Style.default -join "")}
                     {$_ -ge 86 -and $_ -le 90} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|||||', ($style.fg.rgb -f 255,70,85),'|||  ', $Style.default -join "")}
                     {$_ -ge 91 -and $_ -le 95} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|||||', ($style.fg.rgb -f 255,70,85),'|||| ', $Style.default -join "")}
                    {$_ -ge 96 -and $_ -le 100} {(($style.fg.rgb -f 0,190,100), '||||||||||', ($style.fg.rgb -f 255,234,127), '|||||', ($style.fg.rgb -f 255,70,85),'|||||', $Style.default -join "")} #20
                    Default {'Error'}
                }
            }
            else{
        
                switch ($InProcSwitch)
                {
                       {$_ -ge 0 -and $_ -le 5} {'|                    '}
                      {$_ -ge 6 -and $_ -le 10} {'||                   '}
                     {$_ -ge 11 -and $_ -le 15} {'|||                  '}
                     {$_ -ge 16 -and $_ -le 20} {'||||                 '}
                     {$_ -ge 21 -and $_ -le 25} {'|||||                '}
                     {$_ -ge 26 -and $_ -le 30} {'||||||               '}
                     {$_ -ge 31 -and $_ -le 35} {'|||||||              '}
                     {$_ -ge 36 -and $_ -le 40} {'||||||||             '}
                     {$_ -ge 41 -and $_ -le 45} {'|||||||||            '}
                     {$_ -ge 46 -and $_ -le 50} {'||||||||||           '} #10
                     {$_ -ge 51 -and $_ -le 55} {'|||||||||||          '}
                     {$_ -ge 56 -and $_ -le 60} {'||||||||||||         '}
                     {$_ -ge 61 -and $_ -le 65} {'|||||||||||||        '}
                     {$_ -ge 66 -and $_ -le 70} {'||||||||||||||       '}
                     {$_ -ge 71 -and $_ -le 75} {'|||||||||||||||      '}
                     {$_ -ge 76 -and $_ -le 80} {'||||||||||||||||     '}
                     {$_ -ge 81 -and $_ -le 85} {'||||||||||||||||||   '}
                     {$_ -ge 86 -and $_ -le 90} {'|||||||||||||||||||  '}
                     {$_ -ge 91 -and $_ -le 95} {'|||||||||||||||||||| '}
                    {$_ -ge 96 -and $_ -le 100} {'|||||||||||||||||||||'} #20
                    Default {'Error'}
                }
            }
        }

        Function GetMemProgress ($Global:InMemSwitch, $Global:sytle){
        
            if ($PSVersionTable.PSVersion.Major -ge 7){

                switch ($InMemSwitch)
                {
                       {$_ -ge 0 -and $_ -le 5} {(($style.fg.rgb -f 45, 160, 230), '|', $Style.default, '....................' -join "")}
                      {$_ -ge 6 -and $_ -le 10} {(($style.fg.rgb -f 45, 160, 230), '||', $Style.default, '...................' -join "")}
                     {$_ -ge 11 -and $_ -le 15} {(($style.fg.rgb -f 45, 160, 230), '|||', $Style.default, '..................' -join "")}
                     {$_ -ge 16 -and $_ -le 20} {(($style.fg.rgb -f 45, 160, 230), '||||', $Style.default, '.................' -join "")}
                     {$_ -ge 21 -and $_ -le 25} {(($style.fg.rgb -f 45, 160, 230), '|||||', $Style.default, '................' -join "")}
                     {$_ -ge 26 -and $_ -le 30} {(($style.fg.rgb -f 45, 160, 230), '||||||', $Style.default, '...............' -join "")}
                     {$_ -ge 31 -and $_ -le 35} {(($style.fg.rgb -f 45, 160, 230), '|||||||', $Style.default, '..............' -join "")}
                     {$_ -ge 36 -and $_ -le 40} {(($style.fg.rgb -f 45, 160, 230), '||||||||', $Style.default, '.............' -join "")}
                     {$_ -ge 41 -and $_ -le 45} {(($style.fg.rgb -f 45, 160, 230), '|||||||||', $Style.default, '............' -join "")}
                     {$_ -ge 46 -and $_ -le 50} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', $Style.default, '...........' -join "")} #10
                     {$_ -ge 51 -and $_ -le 55} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|', $Style.default,'..........' -join "")}
                     {$_ -ge 56 -and $_ -le 60} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'||', $Style.default,'.........' -join "")}
                     {$_ -ge 61 -and $_ -le 65} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|||', $Style.default,'........' -join "")}
                     {$_ -ge 66 -and $_ -le 70} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'||||', $Style.default,'.......' -join "")}
                     {$_ -ge 71 -and $_ -le 75} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|||||', $Style.default,'......' -join "")}
                     {$_ -ge 76 -and $_ -le 80} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|||||', ($style.fg.rgb -f 255,70,85),'|', $sytle.default, '....' -join "")}
                     {$_ -ge 81 -and $_ -le 85} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|||||', ($style.fg.rgb -f 255,70,85),'||', $sytle.default, '...' -join "")}
                     {$_ -ge 86 -and $_ -le 90} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|||||', ($style.fg.rgb -f 255,70,85),'|||', $sytle.default, '..' -join "")}
                     {$_ -ge 91 -and $_ -le 95} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|||||', ($style.fg.rgb -f 255,70,85),'||||', $sytle.default, '.' -join "")}
                    {$_ -ge 96 -and $_ -le 100} {(($style.fg.rgb -f 45, 160, 230), '||||||||||', ($style.fg.rgb -f 255,234,127),'|||||', ($style.fg.rgb -f 255,70,85),'|||||', $sytle.default -join "")} #20
                    Default {'Error'}
                }
            }
            else{
                switch ($InMemSwitch)
                {
                       {$_ -ge 0 -and $_ -le 5} {'|....................'}
                      {$_ -ge 6 -and $_ -le 10} {'||...................'}
                     {$_ -ge 11 -and $_ -le 15} {'|||..................'}
                     {$_ -ge 16 -and $_ -le 20} {'||||.................'}
                     {$_ -ge 21 -and $_ -le 25} {'|||||................'}
                     {$_ -ge 26 -and $_ -le 30} {'||||||...............'}
                     {$_ -ge 31 -and $_ -le 35} {'|||||||..............'}
                     {$_ -ge 36 -and $_ -le 40} {'||||||||.............'}
                     {$_ -ge 41 -and $_ -le 45} {'|||||||||............'}
                     {$_ -ge 46 -and $_ -le 50} {'||||||||||...........'} #10
                     {$_ -ge 51 -and $_ -le 55} {'|||||||||||..........'}
                     {$_ -ge 56 -and $_ -le 60} {'||||||||||||.........'}
                     {$_ -ge 61 -and $_ -le 65} {'|||||||||||||........'}
                     {$_ -ge 66 -and $_ -le 70} {'||||||||||||||.......'}
                     {$_ -ge 71 -and $_ -le 75} {'|||||||||||||||......'}
                     {$_ -ge 76 -and $_ -le 80} {'||||||||||||||||.....'}
                     {$_ -ge 81 -and $_ -le 85} {'||||||||||||||||||...'}
                     {$_ -ge 86 -and $_ -le 90} {'|||||||||||||||||||..'}
                     {$_ -ge 91 -and $_ -le 95} {'||||||||||||||||||||.'}
                    {$_ -ge 96 -and $_ -le 100} {'|||||||||||||||||||||'} #20
                    Default {'Error'}
                }
            }
        }

    #endregion

    #region SCRIPT

    while(1){

        #region SET VARIABLES

            #region ADD COLOR (This is not my code. Found it in the inter-webs)
        
                    $style=@(
                        0, 'default', 'bold',
                        4, 'underline',
                        24, 'nounderline',
                        7, 'negative',
                        27, 'positive',
                        '_fg',
                            30, 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white',
                            39, 'default',
                        '_bg',
                            'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white',
                            49, 'default',
                        '_bf', 90, 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white',
                        '_bb', 100, 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white'
                    ) `
                    | &{
                        Begin {
                            $sequence="$([char]27)[{0}m"
                            $style=@{
                                fg=@{
                                    rgb=$sequence -f '38;2;{0};{1};{2}'
                                    x=$sequence -f '38;5;{0}'
                                };
                                bg=@{
                                    rgb=$sequence -f '48;2;{0};{1};{2}'
                                    x=$sequence -f '48;5;{0}'
                                };
                                bf=@{};
                                bb=@{};
                            }
                            $current=$style
                            $index=$null
                        }
                        Process {
                            Switch -regex ($_) {
                                '\d' { $index=$_ }
                                '^_' { $current=$style[$_ -replace '^.',''] }
                                Default {
                                    $current[$_]=$sequence -f $index++
                                }
                            }
                        }
                        End {
                            $style
                        }
                    }

            #endregion

            # Get default variables for cleanup at the end
            $DefaultVariables = $(Get-Variable).Name 
            
            #Network Activity
            #$Net = Get-Counter -ListSet 'Network Interface'
            
            $NetReceived = Get-Counter '\Network Interface(*)\Bytes Received/sec'
            $NetSent = Get-Counter '\Network Interface(*)\Bytes Sent/sec'
            $NetCount = $NetReceived.CounterSamples.cookedvalue.Count

            # If there are multiple NIC's
            if ($NetCount -ge 2){

                # Received
                $AddNR = $NetReceived.CounterSamples.CookedValue
                $NR = $AddNR[0]

                for($i=1;$i-lt$NetCount;$i++){
                
                    $NR = $NR + $AddNR[$i]
                }
                $NReceived = [int]$NR*1024/1KB

                # Sent
                $AddNS = $NetSent.CounterSamples.CookedValue
                $NS = $AddNS[0]

                for($i=1;$i-lt$NetCount;$i++){
                
                    $NS = $NS + $AddNS[$i]
                }
                $NSent = [int]$NS*1024/1KB

            }
            else{
            
                $NR = $NetReceived.CounterSamples.cookedvalue | Where-Object {$_ -gt 0}
                $NS = $NetSent.CounterSamples.cookedvalue | Where-Object {$_ -gt 0}
            }            

            if($NetReceived){
                
                $NReceived = [int]$NR*1024/1KB
                $NSent     = [int]$NS*1024/1KB
            }
    
            # Idividual Processor information
            #$ProcessorSample = Get-Counter -ListSet Processor #| ? {$_.countersetname -match "^Processor$"}
            $ProcPercent = Get-Counter '\Processor(*)\% Processor Time'
            $ProcCount   = ($ProcPercent.CounterSamples.Count)-1

            #create a variable for each processor
            for ($i=0;$i -lt $ProcCount;$i++){
            
                New-Variable -Name "proc$i" -Value (($ProcPercent.CounterSamples | Where-Object {$_.path -match "processor\($i\)"}).cookedValue)
                $InProcSwitch = [Math]::Round((Get-Variable -Name "proc$i" -ValueOnly))
                
                New-Variable -Name "BarProc$i" -Value (GetProcProgress)
            }

            # Memory information
            # $MemSample      = Get-Counter -ListSet Memory #| ? {$_.countersetname -match "^memory$"}
            $MemAvail       = Get-Counter '\Memory\Available MBytes'
            #$MemCommit      = Get-Counter '\Memory\Committed Bytes'
            $MemPercent     = Get-Counter '\Memory\% Committed Bytes In Use'
            $MemCommitLimit = Get-Counter '\memory\commit limit'

            if($MemAvail){
                $AvailableMemory = $MemAvail.CounterSamples.CookedValue
                $MemLimit  = [Math]::Round($MemCommitLimit.CounterSamples.CookedValue / 1GB)

                $InMemSwitch = [Math]::Round($MemPercent.CounterSamples.cookedvalue)
                $BarMem = GetMemProgress
            }

            # C:\ drive stats
            $FreeSpace  = [Math]::Round(((Get-PSDrive C).Free)/1GB,2)
            $TotalSpace = [Math]::Round(((Get-PSDrive C).Free)/1GB+((Get-PSDrive c).Used)/1GB,2)
            $CDriveFriendlyName = (Get-PhysicalDisk | Where-Object {$_.DeviceID -eq 0}).FriendlyName

            # Task Information sort by CPU Process
            $tasks = Get-Process | Sort-Object -Descending CPU | Select-Object -First $Processes

        #endregion
    
        # Needed to "refresh" shell 
        Clear-Host

        #region PRINT
           
           Write-Host "PSTop 1.0  PSVersion: $($PSVersionTable.PSVersion)  User: $env:USERNAME"
           Write-Host "`0"

           if($ProcCount -le 8){
            
                
                for($P=0; $P -lt $ProcCount; $P++){

                    Write-Host "Proc $P    : $(Get-Variable -Name "BarProc$P" -ValueOnly)"
                }
            }

            if(($ProcCount -ge 9) -and ($ProcCount -le 12)){
            
                Write-Host "Proc 0    : $BarProc0`tProc 6    : $BarProc6"
                Write-Host "Proc 1    : $BarProc1`tProc 7    : $BarProc7"
                Write-Host "Proc 2    : $BarProc2`tProc 8    : $BarProc8"
                Write-Host "Proc 3    : $BarProc3`tProc 9    : $BarProc9"
                Write-Host "Proc 4    : $BarProc4`tProc 10   : $BarProc10"
                Write-Host "Proc 5    : $BarProc5`tProc 11   : $BarProc11"
            }

            if(($ProcCount -ge 13) -and ($ProcCount -le 16)){
            
                Write-Host "Proc 0    : $BarProc0`tProc 8    : $BarProc8"
                Write-Host "Proc 1    : $BarProc1`tProc 9    : $BarProc9"
                Write-Host "Proc 2    : $BarProc2`tProc 10   : $BarProc10"
                Write-Host "Proc 3    : $BarProc3`tProc 11   : $BarProc11"
                Write-Host "Proc 4    : $BarProc4`tProc 12   : $BarProc12"
                Write-Host "Proc 5    : $BarProc5`tProc 13   : $BarProc13"
                Write-Host "Proc 6    : $BarProc6`tProc 14   : $BarProc14"
                Write-Host "Proc 7    : $BarProc7`tProc 15   : $BarProc15"
            }

            if(($ProcCount -ge 17) -and ($ProcCount -le 24)){
            
                Write-Host "Proc 0    : $BarProc0`tProc 12  : $BarProc12"
                Write-Host "Proc 1    : $BarProc1`tProc 13  : $BarProc13"
                Write-Host "Proc 2    : $BarProc2`tProc 14  : $BarProc14"
                Write-Host "Proc 3    : $BarProc3`tProc 15  : $BarProc15"
                Write-Host "Proc 4    : $BarProc4`tProc 16  : $BarProc16"
                Write-Host "Proc 5    : $BarProc5`tProc 17  : $BarProc17"
                Write-Host "Proc 6    : $BarProc6`tProc 18  : $BarProc18"
                Write-Host "Proc 7    : $BarProc7`tProc 19  : $BarProc19"
                Write-Host "Proc 8    : $BarProc8`tProc 20  : $BarProc20"
                Write-Host "Proc 9    : $BarProc9`tProc 21  : $BarProc21"
                Write-Host "Proc 10   : $BarProc10`tProc 22  : $BarProc22"
                Write-Host "Proc 11   : $BarProc11`tProc 23  : $BarProc23"
            }

            if(($ProcCount -ge 25) -and ($ProcCount -le 32)){
            
                Write-Host "Proc 0    : $BarProc0`tProc 16  : $BarProc16"
                Write-Host "Proc 1    : $BarProc1`tProc 17  : $BarProc17"
                Write-Host "Proc 2    : $BarProc2`tProc 18  : $BarProc18"
                Write-Host "Proc 3    : $BarProc3`tProc 19  : $BarProc19"
                Write-Host "Proc 4    : $BarProc4`tProc 20  : $BarProc20"
                Write-Host "Proc 5    : $BarProc5`tProc 21  : $BarProc21"
                Write-Host "Proc 6    : $BarProc6`tProc 22  : $BarProc22"
                Write-Host "Proc 7    : $BarProc7`tProc 23  : $BarProc23"
                Write-Host "Proc 8    : $BarProc8`tProc 24  : $BarProc24"
                Write-Host "Proc 9    : $BarProc9`tProc 25  : $BarProc25"
                Write-Host "Proc 10   : $BarProc10`tProc 26  : $BarProc26"
                Write-Host "Proc 11   : $BarProc11`tProc 27  : $BarProc27"
                Write-Host "Proc 12   : $BarProc12`tProc 28  : $BarProc28"
                Write-Host "Proc 13   : $BarProc13`tProc 29  : $BarProc29"
                Write-Host "Proc 14   : $BarProc14`tProc 30  : $BarProc30"
                Write-Host "Proc 15   : $BarProc15`tProc 31  : $BarProc31"
            }

            if(($ProcCount -ge 33) -and ($ProcCount -le 40)){
            
                Write-Host "Proc 0    : $BarProc0`tProc 20  : $BarProc20"
                Write-Host "Proc 1    : $BarProc1`tProc 21  : $BarProc21"
                Write-Host "Proc 2    : $BarProc2`tProc 22  : $BarProc22"
                Write-Host "Proc 3    : $BarProc3`tProc 23  : $BarProc23"
                Write-Host "Proc 4    : $BarProc4`tProc 24  : $BarProc24"
                Write-Host "Proc 5    : $BarProc5`tProc 25  : $BarProc25"
                Write-Host "Proc 6    : $BarProc6`tProc 26  : $BarProc26"
                Write-Host "Proc 7    : $BarProc7`tProc 27  : $BarProc27"
                Write-Host "Proc 8    : $BarProc8`tProc 28  : $BarProc28"
                Write-Host "Proc 9    : $BarProc9`tProc 29  : $BarProc29"
                Write-Host "Proc 10   : $BarProc10`tProc 30  : $BarProc30"
                Write-Host "Proc 11   : $BarProc11`tProc 31  : $BarProc31"
                Write-Host "Proc 12   : $BarProc12`tProc 32  : $BarProc32"
                Write-Host "Proc 13   : $BarProc13`tProc 33  : $BarProc33"
                Write-Host "Proc 14   : $BarProc14`tProc 34  : $BarProc34"
                Write-Host "Proc 15   : $BarProc15`tProc 35  : $BarProc35"
                Write-Host "Proc 16   : $BarProc16`tProc 36  : $BarProc36"
                Write-Host "Proc 17   : $BarProc17`tProc 37  : $BarProc37"
                Write-Host "Proc 18   : $BarProc18`tProc 38  : $BarProc38"
                Write-Host "Proc 19   : $BarProc19`tProc 39  : $BarProc39"
            }

            Write-Host "`0"
            Write-Host "RAM Usage : $BarMem Percent: $InMemSwitch%"
            Write-Host "`0"
            
            if ($PSVersionTable.PSVersion.Major -ge 7){
            
                Write-Host ('Network S :',($style.fg.rgb -f 45, 160, 230)," $NSent", $style.default, ' KB' -join "")
                Write-Host ('Network R :',($style.fg.rgb -f 45, 160, 230)," $NReceived", $style.default, ' KB' -join "")
            }
            else{
            
                Write-Host "Network S : $NReceived KB"
                Write-Host "Network R : $NReceived KB"
            }

            Write-Host "Storage   : $CDriveFriendlyName"
            Write-Host "        C : $FreeSpace GB  \ $TotalSpace GB"
            Write-Host "Memory    : Available: $AvailableMemory MB Commit Limit: $MemLimit GB"
            Write-Host "`0"
            $tasks

        #endregion
    
        # Allows for recreating variables
        ((Compare-Object -ReferenceObject (Get-Variable).Name -DifferenceObject $DefaultVariables).InputObject).foreach{Remove-Variable -Name $_ -ErrorAction SilentlyContinue}

    }
    #endregion
}