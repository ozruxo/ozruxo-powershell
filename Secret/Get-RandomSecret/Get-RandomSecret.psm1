<#
.SYNOPSIS
	Generate a random string of characters within a secret length of 4 and 32.

.DESCRIPTION
    Generate a random string of characters within a secret length of 4 and 32.

.PARAMETER RandomString
    (Set 1) Specify this switch to generate a string of random characters.

.PARAMETER SecretLength
    (Set 1) Specify the number of characters you would like returned. Must be between 4 and 32.

.PARAMETER ObjectCount
    (Set 2) Specify the number of random objects to return. Please note, some object may be more than one string.

.PARAMETER RandomObjects
    (Set 2) Specify this switch to gernerate a string of random objects.

.PARAMETER Spaces
    (Set 2) Specify if spaces should be included in the output of the string.

.PARAMETER Easy
    Combine both sets to make a complex password.

.EXAMPLE
    Get-RandomSecret -RandomString

.EXAMPLE
    Get-RandomSecret -RandomString -SecretLength 8

.EXAMPLE
    Get-RandomSecret -RandomObjects

.EXAMPLE
    Get-RandomSecret -RandomObjects -ObjectCount 5 -Spaces No

.EXAMPLE
    Get-RandomSecret -RandomObjects -Verbose

.EXAMPLE
    Get-RandomSecret -Easy

.NOTES
    Any improvements welcome.
#>

function Get-RandomSecret {
    param (
        [Parameter(ParameterSetName='Random')]
        [Switch]$RandomString,
        [Parameter(ParameterSetName='Random')]
        [ValidateRange(4,[int]::MaxValue)]
        [Int32]$SecretLength=12,
        
        [Parameter(ParameterSetName='Words')]
        [ValidateRange(1,[int]::MaxValue)]
        [Int32]$ObjectCount=4,
        [Parameter(ParameterSetName='Words')]
        [Switch]$RandomObjects,
        [Parameter(ParameterSetName='Words')]
        [ValidateSet("Yes","No")]
        [String]$Spaces="Yes",

        [Parameter(ParameterSetName='Easy')]
        [Switch]$Easy
    )

    #region INITIAL VARIABLES
    
        $JSONPath   = "https://<Link>" #or C:\SuperSecretFolder\
        $SourceJSON = "URI" #or Folder

    #endregion

    #region FUNCTIONS

        function Get-RandomCharacters {

            do {
                # Set the character map to generate a secret from
                $Secret = -join ((48..122) | Get-Random -Count $SecretLength | ForEach-Object {[char]$_})
        
                # Validate secret
                Write-Verbose "Validating Secret"
                $valid = $false; $U = $false; $L = $false; $N = $false; $S = $false
                $TestSecret = $Secret.ToCharArray()
                foreach ($character in $TestSecret){
        
                    if($character -cmatch "[A-Z]"){$U = $True}
                    if($character -cmatch "[a-z]"){$L = $True}
                    if($character -match "[0-9]"){$N = $True}
                    if($character -match '^.*[\!\@\#\$\%\^\&\*\(\)\`_\+\-\=\[\]\{\}\;\''\:\"\\\|\,\.\<\>\/\?].*$'){$S = $True;}
                }
                if ($U -eq $true -and $L -eq $true -and $N -eq $true -and $S -eq $true){
        
                    Start-Sleep -Milliseconds 100
                    $valid = $true
                }
                else{
        
                    $valid = $false
                }
            }until($valid -eq $true)
        
            Write-Verbose "Created secret"
            
            #return the value
            return $Secret
        }

        function Get-Objects {

            #region INITIAL VARIABLES

                # Set Array
                $CallAPI = [System.Collections.ArrayList]::New()

                # List of APIs
                $APIs = 'adjective','adverb','anime','color','conjunction','month','noun','number','space','verb','strangedictionary','instrument'

                # Determine number of APIs to call
                Switch ($ObjectCount) {
                    {$PSItem -eq 1}                       {$NumberofAPIs = 1}
                    {$PSItem -eq 2}                       {$NumberofAPIs = 2}
                    {$PSItem -eq 3}                       {$NumberofAPIs = 3}
                    {$PSItem -eq 4}                       {$NumberofAPIs = 4}
                    {$PSItem -ge 5 -and $PSItem -le 9}    {$NumberofAPIs = 5}
                    {$PsItem -ge 10 -and $PSItem -lt 100} {$NumberofAPIs = 10}
                    default {Write-Host "What are you doing?"; break}
                }
                
                #Determine what APIs to call
                for ($i = 0; $i -lt $NumberofAPIs; $i++){

                    $CallAPI.Add(($APIs | Get-Random)) | Out-Null
                }

            #endregion
            
            #region SCRIPT

                # Loop array until object count reached
                $LoopInt = 0
                do{
                    foreach ($API in $CallAPI){
                        
                        Write-Verbose "API: $API"
                        # Break loop once equal to $ObjectCount
                        if ($LoopInt -eq $ObjectCount){

                            Write-Verbose "Break"
                            break
                        }

                        # Get from directory or URI
                        if ($SourceJSON -eq 'URI'){
                        
                            if (Get-Variable -Name $API -ErrorAction SilentlyContinue){

                                Write-Verbose "Already Set: $API"
                            }
                            else {
                            
                                # Create new variable and add to array
                                New-Variable -Name $API -Value (Invoke-RestMethod -Uri "$JSONPath/$API.json")
                                Write-Verbose "New Var: $API"
                            }
                        }
                        if ($SourceJSON -eq 'Folder'){

                            if (Get-Variable -Name $API -ErrorAction SilentlyContinue){

                                Write-Verbose "Already Set: $API"
                            }
                            else {

                                # Create new variable
                                New-Variable -Name $API -Value (Get-Content "$JSONPath\$API.json" | ConvertFrom-Json)
                                Write-Verbose "New Var: $API"
                            }
                        }

                        # Define variable
                        $GetJSON = (Get-Variable $API).Value

                        # Determmine the properties for dot notation
                        $PropertiesNames = ($GetJSON | Get-Member | Where-Object {$PSItem.MemberType -eq 'NoteProperty'}).Name

                        # Randomly select objects from API
                        $GetObjects = $GetJSON.($PropertiesNames | Get-Random)

                        # Put string together
                        $Secret = "$Secret " + ($GetObjects | Get-Random)
                        Write-Verbose "$LoopInt : $Secret"

                        if($Spaces -eq 'No'){

                            $Secret = $Secret.Replace(' ','')
                        }

                        $LoopInt++
                    }

                }until($LoopInt -eq $ObjectCount)

            #endregion

            return $Secret
        }

    #endregion

    #region SCRIPT

        If($RandomString){

            Get-RandomCharacters
        }
        if($RandomObjects){

            Get-Objects
        }
        if ($Easy){

            $SecretLength = 4
            $ObjectCount = 2
            $Spaces = 'No'
            $One = Get-RandomCharacters
            $Two = Get-Objects
            Write-Output "`0"
            $One + $Two
            Write-Output "`0"
        }

    #endregion
    
}