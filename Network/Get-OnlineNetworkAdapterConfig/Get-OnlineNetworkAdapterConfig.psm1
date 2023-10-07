<##>

function Get-OnlineNetworkAdapterConfig {

    #region INITIAL VAVRIABLES

        $NAC       = Get-WmiObject win32_networkadapterconfiguration
        $NetConfig = [System.Collections.ArrayList]::New()

    #endregion

    #region SCRIPT

        foreach($nic in $NAC){
            
            $networkAdapters += "$($nic.description); "
            
            if ($nic.DefaultIPGateway){
            
                $IPv4 = $nic.IPAddress[0]
                $IPv6 = $nic.IPAddress[1]
                $NetAdptName = $nic.description
                $NetMac = $nic.MACAddress
            
                $NICObject = [PSCustomObject]@{
                    
                    HostName = $env:COMPUTERNAME
                    Adapter  = $NetAdptName
                    IPv4     = $IPv4
                    IPv6     = $IPv6
                    MAC      = $NetMac
                }

                $NetConfig.Add($NICObject)
            }
        }

        $NetConfig | Format-Table -AutoSize

    #endregion
}