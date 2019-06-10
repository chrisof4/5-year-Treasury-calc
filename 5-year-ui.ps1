# File: 5-year-UI.ps1
# Author: Chris Phillips
# Creation Date: 2019-06-07
# Description: User interface allowing access to all of the 5 year tools.
function Main-menu
    {
    [CmdletBinding()]
    param()
    
    Clear-Host
    Write-Host "5 Year Treasury Tools`n"
    Write-Host "1. Convert fractional price to decimal."
    Write-Host "2. Convert decimal price to fractional."
    Write-Host "3. Trade calculator."
    Write-Host "4. Exit."

	try 
		{
			[ValidateRange(1,4)]$Choice = Read-Host "`nPlease type the number for your choice:"
        }
	catch
		{
			$x = Read-host "That is not a valid entry. Press any key to continue"
		    continue
		}
	return $Choice

  
    }

$v = $false
do
{
$MenuChoice = Main-menu
if (($MenuChoice -ge 1) -and ($MenuChoice -le 4))
    {
    Write-Host "$MenuChoice was chosen"
    $v = $true
    }
}
while ($v -eq $false)