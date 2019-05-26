# File: 5year.ps1
# Author: Chris Phillips
# Creation Date: 2019-05-17

#

Clear-Host

# Define delimeters
$delim = "'","."
$Entry_arr = @()

# Create objects
$EntryObj = New-Object -TypeName psobject
$ExitObj = New-Object -TypeName psobject
$ActivationObj = New-Object -TypeName psobject
$TargetObj1 = New-Object -TypeName psobject
$TargetObj2 = New-Object -TypeName psobject
$TargetObj3 = New-Object -TypeName psobject
$TargetObj4 = New-Object -TypeName psobject
$TargetObj5 = New-Object -TypeName psobject

# Define functions
function user_input
       {
		   [CmdletBinding()]
				$script:entry = Read-Host "What is the entry price? Enter this in the format 999'99.99"
				$script:exit = Read-Host "What is the exit price? Enter this in the format 999'99.99"
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
$zone = $Entry_dec - $Exit_dec
if ($zone -lt 0) {
			Write-Host "`nThis is a short trade`n"
				}
		else {
			Write-Host "`nThis is a long trade`n"
			}

$x = 1
DO
{
	New-Variable -name "target$x" -value ($Entry_dec + ($zone * $x))
	
	$Target = ($Entry_dec + ($zone * $x))
	$Target_arr = ($Target -split {$delim -contains $_})
	$Target_32_arr = ($Target_arr[1]/312500) -split {$delim -contains $_}
	if ($Target_32_arr -eq 25) {
		$Target_quarter = 2
		}
		elseif ($Target_32_arr -eq 50) {
		$Target_quarter = 5
		}
		elseif ($Target_32_arr -eq 75) {
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

$ExitObj | Add-Member -MemberType NoteProperty -Name "Price Type" -Value Exit
$ExitObj | Add-Member -MemberType NoteProperty -Name Fraction -Value $Exit
$ExitObj | Add-Member -MemberType NoteProperty -Name Decimal -Value $Exit_dec

$TargetObj1 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 1x"
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction1
$TargetObj1 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target1

$TargetObj2 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 2x"
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction2
$TargetObj2 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target2

$TargetObj3 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 3x"
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction3
$TargetObj3 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target3

$TargetObj4 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 4x"
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction4
$TargetObj4 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target4

$TargetObj5 | Add-Member -MemberType NoteProperty -Name "Price Type" -Value "Target 5x"
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Fraction -Value $Target_fraction5
$TargetObj5 | Add-Member -MemberType NoteProperty -Name Decimal -Value $Target5

Write-Output $EntryObj, $ExitObj, $TargetObj1, $TargetObj2, $TargetObj3, $TargetObj4, $TargetObj5

DO
	{
		Remove-Variable "target$x"
		Remove-Variable "target_fraction$x"
		$x--
	} While ($x -ge 1)

# Read-Host -Prompt "Press Enter to exit"