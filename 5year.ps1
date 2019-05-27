# File: 5year.ps1
# Author: Chris Phillips
# Creation Date: 2019-05-17

#

Clear-Host
Write-Output "Welcome To The Price Calculator For 5 Year Treasury Notes`n"
# Define delimeters
$delim = "'","."
$Entry_arr = @()
$TickMin = .0078125
$TickValue = 7.8125
$Fee = 4.30


# Create objects
$EntryObj = New-Object -TypeName psobject
$ExitObj = New-Object -TypeName psobject
$ConfirmationObj = New-Object -TypeName psobject
$TargetObj1 = New-Object -TypeName psobject
$TargetObj2 = New-Object -TypeName psobject
$TargetObj3 = New-Object -TypeName psobject
$TargetObj4 = New-Object -TypeName psobject
$TargetObj5 = New-Object -TypeName psobject

# Define functions
function user_input
       {
		   [CmdletBinding()]
		   $script:Entry = Read-Host "What is the entry price? Enter this in the format 999'99.99"
		   $script:Exit = Read-Host "What is the exit price? Enter this in the format 999'99.99"
		   [int]$script:Contracts = Read-Host "How many contracts?"
		   }

#Begin script execution
user_input
[decimal[]]$Entry_arr = $Entry -split {$delim -contains $_}
[decimal[]]$Exit_arr = $Exit -split {$delim -contains $_}

# Data validation section
if ($Entry_arr[1] -lt 0 -or $Entry_arr[1] -gt 31) {
			throw "Enter a valid price"
			}
		elseif( $Entry_arr[2] -eq 0) { 
			$quarters_entry = 0
			# write-host "if 0",$Entry_arr[2]
			}
		elseif ( $Entry_arr[2] -eq 2 ) { 
			$quarters_entry = .0078125 
			# write-host "if 2",$Entry_arr[2]
			}
		elseif ( $Entry_arr[2] -eq 5 ) { 
			$quarters_entry = (.0078125 * 2) 
			# write-host "if 5",$Entry_arr[2]
			}
		elseif ( $Entry_arr[2] -eq 7 ) { 
			$quarters_entry = (.0078125 * 3) 
			# write-host "if 7",$Entry_arr[2]
			}
		else { throw "Enter a valid price" }
if ($Exit_arr[1] -lt 0 -or $Exit_arr[1] -gt 31) {
			throw "Enter a valid price"
			}
		elseif( $Exit_arr[2] -eq 0) { 
			$quarters_exit = 0
			# write-host "if 0",$Exit_arr[2]
			}
		elseif ( $Exit_arr[2] -eq 2 ) { 
			$quarters_exit = .0078125 
			# write-host "if 2",$Exit_arr[2]
			}
		elseif ( $Exit_arr[2] -eq 5 ) { 
			$quarters_exit = (.0078125 * 2) 
			# write-host "if 5",$Exit_arr[2]
			}
		elseif ( $Exit_arr[2] -eq 7 ) { 
			$quarters_exit = (.0078125 * 3) 
			# write-host "if 7",$Exit_arr[2]
			}
		else { throw "Enter a valid price" }

$Entry_dec = $Entry_arr[0] + ($Entry_arr[1] * .03125) + $quarters_entry
$Exit_dec = $Exit_arr[0] + ($Exit_arr[1] * .03125) + $quarters_exit
$Zone = $Entry_dec - $Exit_dec
$Risk = ($Zone/$TickMin*$TickValue*$Contracts) + ($Fee * $Contracts)
$Reward = ($Zone/$TickMin * $TickValue * $Contracts) - ($Fee * $Contracts)
 
# -- Calculate the confirmation entry price, also known as the activation price. --
# The confirmation price is roughly halfway between the entry and the exit.
# However, this has to end in a quarter of a 32nd. This section generates an 
# estimate, modifies the number so it properly ends in a quarter of a 32nd,
# calculates the price as a fraction and then recalculates the fraction 
# price into a decimal price.
$Confirmation_estimate = $Entry_dec - ($Zone/2)
[decimal[]]$Confirmation_est_arr = $Confirmation_estimate -split {$delim -contains $_}
$Confirmation_32_arr = ($Confirmation_est_arr[1]/3125000) -split {$delim -contains $_}
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
$Confirmation_fraction =  ([string]$Confirmation_est_arr[0] + "'" + [string]$Confirmation_32_arr[0] + "." + [string]$Confirmation_quarter)
$Confirmation_arr = $Confirmation_fraction -split {$delim -contains $_}
if ($Confirmation_arr[2] -eq 0) { 
			$Quarters_confirmation = 0
			}
		elseif ( $Confirmation_arr[2] -eq 2 ) { 
			$Quarters_confirmation = .0078125 
			}
		elseif ( $Confirmation_arr[2] -eq 5 ) { 
			$Quarters_confirmation = (.0078125 * 2) 
			}
		elseif ( $Confirmation_arr[2] -eq 7 ) { 
			$Quarters_confirmation = (.0078125 * 3) 
			}
$Confirmation_dec = [decimal]$Confirmation_arr[0] + ([decimal]$Confirmation_arr[1] * .03125) + [decimal]$Quarters_Confirmation

if ($Zone -lt 0) {
			Write-Host "`nThis is a short trade"
				}
		else {
			Write-Host "`nThis is a long trade"
			}
Write-Host "`nThe risk for this trade is `$$Risk"

$x = 1
DO
{
	New-Variable -name "target$x" -value ($Entry_dec + ($Zone * $x))
	
	$Target = ($Entry_dec + ($Zone * $x))
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
	New-Variable -name "target_fraction$x" -value ($Target_arr[0] + "'" + $Target_32_arr[0] + "." + $Target_quarter)
	$x++
	} While ($x -le 5)
$x--



$EntryObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Entry
$EntryObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Entry
$EntryObj | Add-Member -MemberType NoteProperty -Name Decimal -Value $Entry_dec
$EntryObj | Add-Member -MemberType NoteProperty -Name Reward -Value "-"

$ExitObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Exit
$ExitObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Exit
$ExitObj | Add-Member -MemberType NoteProperty -Name Decimal -Value $Exit_dec
$ExitObj | Add-Member -MemberType NoteProperty -Name Reward -Value "-"

$ConfirmationObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Confirmation
$ConfirmationObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Confirmation_fraction
$ConfirmationObj | Add-Member -MemberType NoteProperty -Name Decimal -Value $Confirmation_dec
$ConfirmationObj | Add-Member -MemberType NoteProperty -Name Reward -Value "-"

$TargetObj1 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 1x"
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction1
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target1
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Reward -Value $Reward

$TargetObj2 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 2x"
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction2
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target2
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Reward -Value ($Reward *2)

$TargetObj3 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 3x"
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction3
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target3
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Reward -Value ($Reward * 3)

$TargetObj4 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 4x"
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction4
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target4
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Reward -Value ($Reward * 4)

$TargetObj5 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 5x"
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction5
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target5
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Reward -Value ($Reward * 5)

Write-Output $EntryObj, $ExitObj, $ConfirmationObj, $TargetObj1, $TargetObj2, $TargetObj3, $TargetObj4, $TargetObj5 

DO
	{
		Remove-Variable "target$x"
		Remove-Variable "target_fraction$x"
		$x--
	} While ($x -ge 1)

# Read-Host -Prompt "Press Enter to exit"