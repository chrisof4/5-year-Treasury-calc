# File: 5-year-dec2frac.ps1
# Author: Chris Phillips
# Creation Date: 2019-06-06
# Description: Converts 5 year treasury price from decimal to fraction
function decimal-input 
	{
     [CmdletBinding()]
     param()
  
	Clear-Host
	Write-Host "Welcome To The Price Convertor For 5 Year Treasury Notes"
	Write-Host "This will convert a decimal price to a fractional price`n"
	try 
	  {
		  [decimal]$Price = Read-Host "What is the decimal price? (###.#######)"
		  }
	catch
		{
			$x = Read-host "That is not a valid entry. Press any key to continue"
		    continue
		}
	return $Price
	}

function Calculate-Fractional 
	{
	[CmdletBinding()]
    param($Decimal)
    $delim = "'","."
	
		$Decimal_arr = ($Decimal -split {$delim -contains $_})
        $Dec32 = "." + $Decimal_arr[1]
		$Decimal_32_arr = [math]::Round(([decimal]($Dec32)*32),2) -split {$delim -contains $_}
        
		if ($Decimal_32_arr[1] -eq 25) {
			$Decimal_quarter = 2
			}
		elseif ($Decimal_32_arr[1] -eq 50) {
		$Decimal_quarter = 5
		    }
		elseif ($Decimal_32_arr[1] -eq 75) {
		$Decimal_quarter = 7
		    }
		else {$Decimal_quarter = 0}
		$Fraction = ($Decimal_arr[0] + "'" + $Decimal_32_arr[0] + "." + $Decimal_quarter)
		return $Fraction
}

$EndLoop = $false

do
	{
	$DecPrice = decimal-input
	if ($DecPrice -gt 0)
		{
			$EndLoop = $True
		}
	}
while ($EndLoop -eq $false)

$FracPrice = Calculate-Fractional $DecPrice
Write-Host "`n$DecPrice converts to $FracPrice"