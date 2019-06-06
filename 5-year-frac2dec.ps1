# File: 5-year-frac2dec.ps1
# Author: Chris Phillips
# Creation Date: 2019-06-06
# Description: Converts 5 year treasury price from fraction to decimal
function Calculate-Decimal {
    [CmdletBinding()]
    param($Fraction)
	$delim = "'","."
	[decimal[]]$Fraction_arr = $Fraction -split {$delim -contains $_}

	if ($Fraction_arr[1] -lt 0 -or $Fraction_arr[1] -gt 31) {
				Write-Host "The middle number must be between 1 and 32"
				return
				}
			elseif( $Fraction_arr[2] -eq 0) { 
				$Quarters_entry = 0
				}
			elseif ( $Fraction_arr[2] -eq 2 ) { 
				$Quarters_entry = .0078125 
				}
			elseif ( $Fraction_arr[2] -eq 5 ) { 
				$Quarters_entry = (.0078125 * 2) 
				}
			elseif ( $Fraction_arr[2] -eq 7 ) { 
				$Quarters_entry = (.0078125 * 3) 
				}
			else {
				Write-Host "Enter a valid price"
				return
				}
	$Decimal = $Fraction_arr[0] + ($Fraction_arr[1] * .03125) + $Quarters_entry
	 return $Decimal
}
Clear-Host
Write-Host "Welcome To The Price Convertor For 5 Year Treasury Notes"
Write-Host "This will convert a fractional price to a decimal price`n"
$FracPrice = Get-Input "What is the entry price? (###'##.##)"
$DecPrice = Calculate-Decimal $FracPrice
Write-Host "`n$FracPrice converts to $DecPrice"