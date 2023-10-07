<#
.SYNOPSIS
    Get the status of virtural machines with some hypervisor information.

.DESCRIPTION
    Get the status of the virutal machines with some hypervisor information.

.PARAMETER HostName
    Specify the name of the computer that you would like to get information from.

.PARAMETER DoNotRecord
    This parameter doesn't allow for a csv file to be created. Just display to terminal.

.EXAMPLE
    Get-QuickVMInfo -HostName <computername>

.EXAMPLE
    Get-QuickVMInfo -HostName <computername> -DoNotRecord

.NOTES
    Any improvements welcome.

#>

function Get-QuickVMInfo {

    param(
        [String]$HostName,
        [Switch]$DoNotRecord
    )

    #region INITIAL VARIABLES

        $LogDirectory = "$env:USERPROFILE\Desktop"
        $LogfileName  = "$(Get-Date -Format yyyy-MM-dd_hh-mm-ss)-$HostName-`VMs.csv"
        $LogPath      = "$LogDirectory\$LogFileName"

    #endregion

    #region FUNCTIONS
    
        function Get-HypervisorAndVMs {

            # Get virtual machine details
            $VirtualMachines = Get-VM
            $VMsObject       = [System.Collections.ArrayList]::new()

            foreach ($VM in $VirtualMachines){

                $DataDiskPath = [System.Collections.ArrayList]::new()
                $DataDiskSize = [System.Collections.ArrayList]::new()
                $DataDiskType = [System.Collections.ArrayList]::new()
                $IP           = [System.Collections.ArrayList]::new()
                $MAC          = [System.Collections.ArrayList]::new()

                $VMName   = $VM.VMName
                $VMRAM    = "$($VM.MemoryAssigned/1GB)GB"
                $VMCPU    = $VM.ProcessorCount
                $VMState  = $VM.State
                $VMUptime = "$($VM.UpTime.Days) Days $($VM.UpTime.Hours) Hours $($VM.UpTime.Minutes) Minutes"

                # NIC
                foreach ($NIC in $VM.NetworkAdapters){

                    $MAC.Add($NIC.MacAddress) | Out-Null
                    $IP.Add($NIC.IPAddresses[0]) | Out-Null
                }

                # Disks 
                $VMDisks = Get-VMHardDiskDrive -VMName $VM.VMName
                foreach ($Disk in $VMDisks){

                    if ($Disk.ControllerLocation -eq 0){
                
                        #Path
                        $OSDiskPath = $Disk.Path
                
                        #size
                        $OSDiskSize = "$([Math]::Round((Get-ChildItem $OSDiskPath).Length/1GB,2))GB"

                        #Type
                        $OSDiskType = (Get-VHD -Path $OSDiskPath).VhdType

                    }
                    if ($Disk.ControllerLocation -ge 1){

                        # Path
                        $DataDiskPath.Add($Disk.Path) | Out-Null
                        
                        if ($Disk.Path -match 'Bus' -and $Disk.Path -match 'Lun' -and $Disk.Path -match 'Target'){

                            continue
                        }
                        else{
                            
                            #Size
                            $DataDiskSize.Add("$([Math]::Round((Get-ChildItem $DataDiskPath).Length/1GB,2))GB") | Out-Null

                            #Type
                            $DataDiskType.Add((Get-VHD -Path $DataDiskPath).VhdType) | Out-Null
                        }
                    }
                }

                $CustomObject = [PSCustomObject]@{

                    Name         = $VMName
                    RAM          = $VMRAM
                    CoreCount    = $VMCPU
                    State        = $VMState
                    UpTime       = $VMUptime
                    IP           = $IP
                    MAC          = $MAC
                    OSDiskPath   = $OSDiskPath
                    OSDiskSize   = $OSDiskSize
                    OSDiskType   = $OSDiskType
                    DataDiskPath = $DataDiskPath
                    DataDiskSize = $DataDiskSize
                    DataDiskType = $DataDiskType
                }

                $VMsObject.Add($CustomObject) | Out-Null 
            }
            
            # Get hypervisor details
            # Get Logical core count for each cpu
            $HostCPUs      = (Get-CimInstance -ClassName Cim_Processor).NumberOfLogicalProcessors
            $HostCoreCount = $HostCPUs[0] + $HostCPUs[1]

            # Is the hypervisor over provisioned
            for($i=0; $i -le ($VMsObject.Count) ;$i++){

                $VMTotalCoreCount = $VMTotalCoreCount + $VMsObject.CoreCount[$i]
            }
            $AvailableVCPU = $HostCoreCount - $VMTotalCoreCount

            # Get available RAM
            $RAMAvail = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
            $RAMinGB  = "$([math]::Round($RAMAvail/1024,2))GB"

            # Create object for hypervisor
            $HypervisorObject = [PSCustomObject]@{
                
                CPUCoresAvail = $AvailableVCPU
                AvailRAM      = $RAMinGB 
            }

            return $VMsObject, $HypervisorObject
        }

        function Get-Space {
            param(
                [String]$MeasureLenghtof,
                [int32]$MaxLength
            )

            $MeasuredLength = $MeasureLenghtof.Length
            $Spacing        = $MaxLength - $MeasuredLength
            $Space          = " " * $Spacing

            return $Space
        }

    #endregion

    #region SCRIPT

        $VMSObject, $HypervisorObject = Invoke-Command -ComputerName $HostName -ScriptBlock ${Function:Get-HypervisorAndVMs} -ErrorVariable NoConnection

        If (!($DoNotRecord)){
        
            Add-Content -Value ("Name,RAM,CoreCount,State,UpTime,Network,OSDiskPath,OSDiskSize,OSDiskType,DataDisks") -Path $LogPath
        }

        # Print
        if ($Noconnection){

            break
        }
        else{

            Write-Host "`0"
            Write-Host -ForegroundColor Cyan "$HostName"
            Write-Host "Available vCPU: $($HypervisorObject.CPUCoresAvail)"
            Write-Host "Available RAM : $($HypervisorObject.AvailRAM)"
            Write-Host "`0"
            foreach ($VMO in $VMsObject){

                # Determine spacing
                $HostSpace   = Get-Space -MeasureLenghtof $VMO.Name -MaxLength 18
                $StateSpace  = Get-Space -MeasureLenghtof $VMO.State -MaxLength 8
                $CPUSpace    = Get-Space -MeasureLenghtof $VMO.CoreCount -MaxLength 3
                $RAMSpace    = Get-Space -MeasureLenghtof $VMO.RAM -MaxLength 5
                $OSDiskSpace = Get-Space -MeasureLenghtof $VMO.OSDiskType -MaxLength 9
                
                # Edit IPs
                if ([string]::IsNullOrWhiteSpace($VMO.IP)){

                    $IP1 = ""
                    $IP2 = ""
                    $IP1SPace = " " * 15
                    $IP2Space = " " * 15
                }
                else{
                
                    $IP1 = $VMO.IP[0]
                    $IP2 = $VMO.IP[1]
                    $IP1Space    = Get-Space -MeasureLenghtof $VMO.IP[0] -MaxLength 15
                    $IP2Space    = Get-Space -MeasureLenghtof $VMO.IP[1] -MaxLength 15
                }

                # Modify VMName if longer than 15 characters
                if ($VMO.Name.Length -gt 15){

                    $VMName = "$($VMO.Name.Substring(0,15))..."
                }
                else{

                    $VMName = $VMO.Name
                }

                # Print to screen
                "$($VMName) $HostSpace| $($VMO.State.Value) $StateSpace| CPU: $($VMO.CoreCount)$CPUSpace| RAM: $($VMO.RAM)$RAMSpace| OSDisk: $($VMO.OSDiskType.Value)$OSDiskSpace| IP: $IP1 $IP1Space| IP: $IP2 $IP2Space"

                # Create string for IPs for CSV file
                if ($VMO.IP.count -gt 1){
                
                    $RecordNetwork  = "$($VMO.IP[0]) $($VMO.MAC[0]); $($VMO.IP[1]) $($VMO.MAC[1])"
                }
                else{

                    $RecordNetwork  = "$($VMO.IP) $($VMO.MAC)"
                }

                # Create String for DataDisk for CSV file
                $RecordDataDisk = $null
                if ($VMO.DataDiskPath){
                    
                    $DatadiskCount = $VMO.DataDiskPath.Count
                    for($i=0; $i -lt $DatadiskCount; $i++){
                        $RecordDataDisk += $RecordDataDisk + "$($VMO.DataDiskType[$i].Value) $($VMO.DataDiskSize[$i]) $($VMO.DataDiskPath[$i]); "
                    }
                }
                If (!($DoNotRecord)){

                    # Save properties to CSV file
                    Add-Content -Value ("$($VMO.Name),$($VMO.RAM),$($VMO.CoreCount),$($VMO.State.Value),$($VMO.UpTime),$RecordNetwork,$($VMO.OSDiskPath),$($VMO.OSDiskSize),$($VMO.OSDiskType.Value),$RecordDataDisk") -Path $LogPath
                }
            }
            Write-Host "`0"
        }

    #endregion
}