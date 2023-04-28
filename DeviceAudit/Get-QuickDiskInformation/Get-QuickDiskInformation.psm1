<#

.SYNOPSIS
    Formated basic hard drive information from Win32_LogicalDisk.

.DESCRIPTION
    Formated basic hard drive information from Win32_LogicalDisk. Purpose of build: allows for running against multiple computers.

    PARAMETER(s)
    -ComputerName
        Add the name of the computer(s).

.EXAMPLE
    Get-QucikDiskInformation -ComputerName <NameOfComputer>

.NOTES

#>

function Get-QuickDiskInformation {
    
    param (
    [Parameter(Mandatory=$true)]
    [string[]]$ComputerName

    )
    Begin{
    
        Function PrintDiskInfo {

            Write-Host -ForegroundColor Cyan "Computer Name       : $($Computer.ToUpper())"
            Write-Host "`n"
            Write-Host "Disks"
            Write-Host "-----------------------"
            foreach ($MD in $MoreDrives){
                Write-Host "DeviceID: $($MD.DeviceID), Partitions: $($MD.Partitions), Model: $($MD.Model)"
            }
            Write-Host "`n"
            Write-Host "Partitions"
            Write-Host "-----------------------"
            foreach ($Dri in $Drives){
                Write-host "Volume Name  : $($Dri.VolumeName)"
                Write-Host "Drive Letter : $($Dri.DeviceID)"
                Write-Host "Free Space   : $([math]::Round($Dri.FreeSpace / 1GB)) GB"
                Write-Host "Total Size   : $([math]::Round($Dri.Size / 1GB)) GB"
                Write-Host "`n"
            }
        }
    }

    Process{

        foreach ($Computer in $ComputerName){
            
            if ($computer -match $env:COMPUTERNAME){
                
                $Drives = Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3}
                $MoreDrives = Get-WmiObject -Class win32_diskdrive
                PrintDiskInfo
            }
            else {
                
                $TC = Test-Connection -Count 1 -ComputerName $Computer -ErrorAction SilentlyContinue
            
                if ($TC){ 
                    
                    $Drives = Invoke-command -ComputerName $Computer -ScriptBlock {Get-WmiObject Win32_LogicalDisk | ? {$_.DriveType -eq 3}}
                    $MoreDrives = Invoke-Command -ComputerName $Computer -ScriptBlock {Get-WmiObject -Class win32_diskdrive}
                
                    "`n"
                    PrintDiskInfo
                    }
                else{
                
                    Write-Host -ForegroundColor Yellow "Could not connect to $Computer"
                    "`n"
                }
            }

        }
    }
}