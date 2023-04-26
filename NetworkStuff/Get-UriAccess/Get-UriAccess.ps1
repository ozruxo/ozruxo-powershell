$Websites = @(
'wikipedia.org'
'instagram.com'
'facebook.com'
'whatsapp.com'
'discord.com'
'youtube.com'
'google.com'
'office.com'
'reddit.com'
'yahoo.com'
'live.com'
'bing.com'
)

foreach ($Website in $Websites){

    $Error.Clear()
    $StatusCode = $null
    try {
    
        $StatusCode = (Invoke-WebRequest -Uri $Website -UseBasicParsing -ErrorAction SilentlyContinue).StatusCode 
    }
    catch {
    
        if ($Error.ErrorDetails -match 'Permanent RedirectRedirecting'){
        
            Write-Host -ForegroundColor Red "No Access to $Website. Re-direction error"
        }
    }

    if ($StatusCode -eq 200){
    
        Write-Host -ForegroundColor Green "Access to $Website"
    }
}