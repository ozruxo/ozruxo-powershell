function Get-LatestAzCopy {

    param(
        [String]$Directory="$env:USERPROFILE\Downloads"
    )

    $GetAZCopyVer = Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows"
    $CurrentAzCopyVer = ($GetAZCopyVer.BaseResponse.RequestMessage.RequestUri.LocalPath).Split('/')[2]
    $OnWeb = $CurrentAzCopyVer.Split("-",2)[1]

    $GetAzCopyInBin = (& $Directory\azcopy.exe --help)
    $InFolder = $GetAzCopyInBin.split(" ")[1]

    if ($OnWeb -match $InFolder){

        #skip download
        Write-Host "`0"
        Write-Host "Version does not need to be updated"
        Write-Host "`0"
    }
    else{

        Write-Host "`0"
        Write-Host "Updating AzCopy"
        Write-Host "`0"

        #download
        Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" `
                -OutFile "$Directory\AzCopy.zip" `
                -UseBasicParsing
        
        if(Test-Path "$Directory\AzCopy.zip" ){

            #remove current AzCopy
            Remove-Item -Path $Directory\azcopy.exe

            #expand archive of downloaded file
            Expand-Archive $Directory\AzCopy.zip $Directory\AzCopy -Force
        
            # move to correct location
            Get-ChildItem $Directory\AzCopy\*\azcopy.exe | Move-Item -Destination "$Directory\AzCopy.exe"
        
            # clean up
            Remove-Item -Path $Directory\AzCopy.zip -Force
            Remove-Item -Path $Directory\AzCopy -Recurse -Force
        }
        else{
        
            Write-Output "Could not download AzCopy. Did not remove current version"
        }
    }
}