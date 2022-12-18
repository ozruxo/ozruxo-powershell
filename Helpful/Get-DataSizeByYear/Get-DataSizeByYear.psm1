# Get-AccumulatedShareSizeByYear

function Get-DataSizeByYear{

    param(
    [Parameter(Mandatory=$True)]
    [string]$Path,
    [Parameter(Mandatory=$True)]
    [string]$Year
    )

    Begin{
    
        # Set variables
        $TotalMB = 0
        $TotalGB = 0
    }
    
    Process{

        Write-Host "Plesae wait"
        Write-Host "Watch the RAM usage"

        # Find files by year
        $Files = Get-ChildItem -Path $Path -Recurse | Where-Object {

                $PSItem.LastWriteTime -match "$Year"
            }

        # Get file lenght conver to MB
        foreach ($File in $Files){
        
            $MBSize = ($File.Length / 1MB)
            $GBSize = ($file.Length / 1GB)

            # Add files sizes
            $TotalMB = $TotalMB + $MBSize
            $TotalGB = $TotalGB + $GBSize

            #Create check to  kill process if PowerShell uses too much RAM

        }

        #$TotalGB = $TotalMB / 1GB

        #Print size of files for the year
        Write-Host "`0"
        Write-Host "$Year had $([Math]::round($TotalMB,2)) MB of Data"
        Write-Host "$Year had $([Math]::round($TotalGB, 2)) GB of Data"
    }
    
    End{
    
        #End
    }
}