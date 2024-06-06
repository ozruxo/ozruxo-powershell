function Fix-MyMistakes {

    param(
    [Switch]$Faster
    )

    if($Faster){
    
        $Miliseconds = 500
    }
    else{
    
        $Miliseconds = 1000
    }

    Write-Host "I am trying..."
    Start-Sleep -Milliseconds $Miliseconds
        
    Write-Host "I am trying..."
    Start-Sleep -Milliseconds $Miliseconds

    Write-Host "I am trying..."
    Start-Sleep -Milliseconds $Miliseconds

    Write-Host "Giving up"
    Start-Sleep -Milliseconds $Miliseconds

    Write-Host "Deleting C:\"

    Start-Sleep -Seconds 2
}
