# File: 5-year-UI.ps1
# Author: Chris Phillips
# Creation Date: 2019-06-07
# Description: User interface allowing access to all of the 5 year tools.
function Main-menu
    {
    [CmdletBinding()]
    param()
    $v = $false

    while ($v -eq $false)
        {
        Clear-Host
        Write-Host "5 Year Treasury Tools`n"
        Write-Host "1. Convert fractional price to decimal."
        Write-Host "2. Convert decimal price to fractional."
        Write-Host "3. Trade calculator."
        Write-Host "4. Exit."
        $Choice = Read-Host "`nPlease type the number for your choice:"
        if (
            ([string]$Choice -eq 1) -or
            ([string]$Choice -eq 2) -or
            ([string]$Choice -eq 3) -or
            ([string]$Choice -eq 4)
            )
            {
            return $Choice
            $v = $true
            }
        else
            {
            Read-Host "Selection not valid. Press any key to continue"
            }
    
        }
    }

$MenuChoice = Main-menu
Write-Host "$MenuChoice was chosen"
#    $i = True
#    Do 
#    {
#    } while ($i -is $True)
#
#.\5-year-dec2frac.ps1