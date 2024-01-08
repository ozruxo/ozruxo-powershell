<#
.SYNOPSIS
    Create some dummy data.

.DESCRIPTION
    Create some dummy data.

.PARAMETER DirectoryPath
    Specify the path you will like the dummy data to be generated.

.PARAMETER Extension
    Specify the extension you want to use.

.PARAMETER FileName
    Specify the name of the file.

.PARAMETER Integer
    Specify the number you would like to multiply the metric by.

.PARAMETER Metic
    Specify the metric. Valid set is KB, MB, and GB.

.EXAMPLE
    Set-DummyData -DirectoryPath C:\tmp\ -Extension txt -FileName Dummy -Integer 4 -Metric MB

.NOTES
    Any improvements welcome.
#>

function Set-DummyData {

    param(
        [Parameter(Mandatory=$true)]
        [String]$DirectoryPath,
        [Parameter(Mandatory=$true)]
        [String]$Extension,
        [Parameter(Mandatory=$true)]
        [String]$FileName,
        [Parameter(Mandatory=$true)]
        [Int]$Integer,
        [Parameter(Mandatory=$true)]
        [ValidateSet("KB","MB","GB")]
        [String]$Metric
    )

    #region INITIAL VARIABLES

        $DummyFile = "$DirectoryPath\$FileName.$Extension"

        Switch ($Metric) {
    
            'KB' {$Maths = $Integer * 1024}
            'MB' {$Maths = $Integer * 1048576}
            'GB' {$Maths = $Integer * 1073741824}
            default {Write-Host 'Error'}
        }

    #endregion

    #region INITIAL CHECKS

        if(!$DirectoryPath){
        
            New-Item $DirectoryPath -ItemType Directory
        }

    #endregion

    #region SCRIPT

        $Dummy = New-Object System.IO.FileStream $DummyFile, Create, ReadWrite
        $Dummy.SetLength($Maths)
        $Dummy.Close()

    #endregion
}
