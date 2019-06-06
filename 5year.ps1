# File: 5year.ps1
# Author: Chris Phillips
# Creation Date: 2019-05-17

# Function definition
function Get-Input {
     [CmdletBinding()]
     param($RequestInput)

     
     $Valid = $true
	if ($RequestInput -eq "How many contracts?"){
			while ($Valid -eq $true) {
				[int]$UserInt = Read-Host $RequestInput
				if ($UserInt -eq "") {
					Write-Host "You did not enter anything."
					}
				elseif ($UserInt -is [int]) {
					$Valid = $false
				}
				else {
					Write-Host "Enter a valid number"
				}
			}
            return $UserInt
		}
    else {
			while ($Valid -eq $true) {
				$UserString = Read-Host $RequestInput
				if ($UserString -eq "") {
					Write-Host "You did not enter anything."
					}
				else {
					$Valid = $false
				}
			}
            return $UserString
		}
 }

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

function Calculate-Targets-FR () {
	[CmdletBinding()]
    param($E, $Z)
	$tempArray = @()
	
	for ($x = 0; $x -lt 5; $x++) {
		$Target = ($E + ($Z * ($x+1)))
		$Target_arr = ($Target -split {$delim -contains $_})
		$Target_32_arr = ($Target_arr[1]/312500) -split {$delim -contains $_}
		if ($Target_32_arr[1] -eq 25) {
			$Target_quarter = 2
			}
			elseif ($Target_32_arr[1] -eq 5) {
			$Target_quarter = 5
			}
			elseif ($Target_32_arr[1] -eq 75) {
			$Target_quarter = 7
			}
			else {$Target_quarter = 0}
		$tempArray += ($Target_arr[0] + "'" + $Target_32_arr[0] + "." + $Target_quarter)
		}
	return, $TempArray
}

function Calculate-Targets-Dec () {
	[CmdletBinding()]
    param($E, $Z)
	$tempArray = @()
	
	for ($x = 0; $x -lt 5; $x++) {
		$Target = ($E + ($Z * ($x+1)))
		$tempArray += ($Target)
		}
	return, $TempArray
}

Clear-Host
Write-Host "Welcome To The Price Calculator For 5 Year Treasury Notes`n"
$Entry = Get-Input "What is the entry price? (###'##.##)"
$Distal = Get-Input "What is the distal price? (###'##.##)"
$Exit = Get-Input "What is the exit price? (###'##.##)"
[int]$Contracts = Get-Input "How many contracts?"

# Define delimeters
$delim = "'","."
$Entry_arr = @()
$Target_Fraction = @()
$Target_Dec = @()
$TickMin = .0078125
$TickValue = 7.8125
$Fee = 4.30
$Fees = ($Fee * $Contracts)
$FeesString = "{0:n2}" -f $Fees

# Create objects
$EntryObj = New-Object -TypeName psobject
$DistalObj = New-Object -TypeName psobject
$ExitObj = New-Object -TypeName psobject
$ConfirmationObj = New-Object -TypeName psobject
$TargetObj1 = New-Object -TypeName psobject
$TargetObj2 = New-Object -TypeName psobject
$TargetObj3 = New-Object -TypeName psobject
$TargetObj4 = New-Object -TypeName psobject
$TargetObj5 = New-Object -TypeName psobject
#
$Entry_dec = Calculate-Decimal $Entry
$Exit_dec = Calculate-Decimal $Exit
$Distal_dec = Calculate-Decimal $Distal
$Zone = $Entry_dec - $Exit_dec
$Risk = ([math]::round((($Zone/$TickMin*$TickValue*$Contracts) + ($Fee * $Contracts)),2))
$Reward = ($Zone/$TickMin * $TickValue * $Contracts)
 
# -- Calculate the confirmation entry price, also known as the activation price. --
# The confirmation price is roughly halfway between the entry and the exit.
# However, this has to end in a quarter of a 32nd. This section generates an 
# estimate, modifies the number so it properly ends in a quarter of a 32nd,
# calculates the price as a fraction and then recalculates the fraction 
# price into a decimal price.
$Confirmation_dec = $Entry_dec - ($TickMin *([math]::round((($Entry_dec - $Distal_dec) / $TickMin)/2)))
[decimal[]]$Confirmation_dec_arr = $Confirmation_dec -split {$delim -contains $_}
$Confirmation_32_arr = ($Confirmation_dec_arr[1]/312500) -split {$delim -contains $_}
	if ($Confirmation_32_arr[1] -le 25) {
		$Confirmation_quarter = 2
		}
		elseif ($Confirmation_32_arr[1] -le 50) {
		$Confirmation_quarter = 5
		}
		elseif ($Confirmation_32_arr[1] -le 75) {
		$Confirmation_quarter = 7
		}
		else {$Confirmation_quarter = 0}
$Confirmation_fraction =  ([string]$Confirmation_dec_arr[0] + "'" + [string]$Confirmation_32_arr[0] + "." + [string]$Confirmation_quarter)

# Is trade long or short?
if ($Zone -lt 0) {
			Write-Host "`nThis is a short trade"
				}
		else {
			Write-Host "`nThis is a long trade"
			}
Write-Host "`nThe risk for this trade is `$$Risk"
Write-Host "`nThe total fees are `$$FeesString"

# Calculate target prices
$Target_Fraction = Calculate-Targets-FR $Entry_dec $Zone
$Target_Dec = Calculate-Targets-Dec $Entry_dec $Zone

$EntryObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Entry
$EntryObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Entry
$EntryObj | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Entry_dec)
$EntryObj | Add-Member -MemberType NoteProperty -Name Reward -Value "-"

$DistalObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Distal
$DistalObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Distal
$DistalObj | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Distal_dec)
$DistalObj | Add-Member -MemberType NoteProperty -Name Reward -Value "-"

$ExitObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Exit
$ExitObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Exit
$ExitObj | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Exit_dec)
$ExitObj | Add-Member -MemberType NoteProperty -Name Reward -Value "-"

$ConfirmationObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Confirmation
$ConfirmationObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Confirmation_fraction
$ConfirmationObj | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Confirmation_dec)
$ConfirmationObj | Add-Member -MemberType NoteProperty -Name Reward -Value "-"

$TargetObj1 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 1x"
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction[0]
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Target_Dec[0])
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Reward -Value ("{0:n2}" -f ($Reward - $Fees))

$TargetObj2 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 2x"
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction[1]
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Target_Dec[1])
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Reward -Value ("{0:n2}" -f (($Reward *2)-$Fees))

$TargetObj3 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 3x"
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction[2]
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Target_Dec[2])
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Reward -Value ("{0:n2}" -f (($Reward * 3) - $Fees))

$TargetObj4 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 4x"
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction[3]
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Target_Dec[3])
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Reward -Value ("{0:n2}" -f (($Reward * 4) - $Fees))

$TargetObj5 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 5x"
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction[4]
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Decimal -Value ("{0:n7}" -f $Target_Dec[4])
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Reward -Value ("{0:n2}" -f (($Reward * 5) - $Fees))

Write-Output $EntryObj, $DistalObj, $ExitObj, $ConfirmationObj, $TargetObj1, $TargetObj2, $TargetObj3, $TargetObj4, $TargetObj5 