<#

.SYNOPSIS
	Summarize the 

.DESCRIPTION
    The intention of this script was to assist with finding lines in a script I know I used, but don't exactly remember what script I was working in and what was typed.

.NOTES
    Intended for PowerShell 5.1
#>

#region VARIABLES

    $Count = 20
    $LogPath = 'C:\logs\Summary'
    $Addresses = @{

        Bing = "bing.com"
        VisualStudio = "dc.service.visualstudio.com"
        SharePoint = "microsofteur-my.sharepoint.com"
    }

    if(-not (Test-Path $LogPath)){

        New-Item -Path $LogPath -ItemType Directory
    }

#endregion

#region GET traceroute

    foreach ($Address in $Addresses.Keys){

        $Destination = $Addresses.$Address
        Start-Job -Name "$Destination" -ArgumentList $Destination,$LogPath,$Count -ScriptBlock {

            # Variables
            $Destination = $args[0]
            $LogPath = $args[1]
            $Count = $args[2]
            $TheTimes = Get-Date
            
            # Print
            Add-Content -Value "-----------------------------------------------------------" -Path "$LogPath\$Destination.log"
            Add-Content -Value $Destination -Path "$LogPath\$Destination.log"
            Add-Content -Value "" -Path "$LogPath\$Destination.log"
            Add-Content -Value ("UTC Time     : $($TheTimes.ToUniversalTime())") -Path "$LogPath\$Destination.log"
            Add-Content -Value ("Local Time   : $($TheTimes.AddHours(9))") -Path "$LogPath\$Destination.log"
            Add-Content -Value ("PST Time     : $($TheTimes.GetDateTimeFormats()[-19])") -Path "$LogPath\$Destination.log"
            Add-Content -Value "" -Path "$LogPath\$Destination.log"
            
            # Variables
            $Ping = Ping -n $Count $Destination
            $PingCountLines = $Ping.Count
            $ping[($PingCountLines-4)..$PingCountLines] | Add-Content -Path "$LogPath\$Destination.log"
            
            $MinLine = $ping | Where-Object {$PSItem -match 'Minimum'}
            $MinSplit1 = ($MinLine -split '=')[1]
            $Min = ($MinSplit1 -split ',')[0].replace(' ','')
            if([String]::IsNullOrEmpty($Min)){$Min = "0"}

            $MaxLine = $ping | Where-Object {$PSItem -match 'Maximum'}
            $MaxSplit1 = ($Maxline -split '=')[2]
            $Max = ($MaxSplit1 -split ',')[0].replace(' ','')
            if([String]::IsNullOrEmpty($Max)){$Max = "0"}

            $AvgLine = $ping | Where-Object {$PSItem -match 'Average'}
            $Avg = ($AvgLine -split '=')[3].replace(' ','')
            if([String]::IsNullOrEmpty($Avg)){$Avg = "0"}
            
            $Lossline = $ping | Where-Object {$_ -match "loss"}
            $LossSplit1 = ($Lossline -split '%')[0]
            $PercLoss = ($LossSplit1 -split '\(')[1]

            # Print
            Add-Content -Value "" -Path "$LogPath\$Destination.log"
            Add-Content -Value "Summary: $((Get-Date).AddHours(9).GetDateTimeFormats()[45]) :: Min:$Min :: Max:$Max :: Avg:$Avg :: $PercLoss% loss" -Path "$LogPath\$Destination.log"
            Add-Content -Value "" -Path "$LogPath\$Destination.log"
        }
    }

    do{

        $Jobs = Get-Job
        foreach ($Job in $Jobs){

            if ($Job.State -eq "Completed"){
            
                Remove-Job -InstanceId $Job.InstanceId
            }
            Start-Sleep -Seconds 2
        }
    }until($null -eq $Jobs)

#endregion