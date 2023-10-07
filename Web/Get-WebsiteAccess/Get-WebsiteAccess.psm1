function Get-WebSiteAccess {

    #region INITIAL VARIABLES
    
        $Websites = @(
            'wikipedia.org'
            'instagram.com'
            'facebook.com'
            'pintrest.com'
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

    #endregion

    #region SCRIPT

        # Make some space for print to terminal
        Write-Output "`0"
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
        # Make some space for end of script
        Write-Output "`0"

    #endregion

}