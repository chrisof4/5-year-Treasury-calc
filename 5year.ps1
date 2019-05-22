# File: 5year.ps1
# Author: Chris Phillips
# Creation Date: 2019-05-17

#

Clear-Host

# Define delimeters
$delim = "'","."
$entry_arr = @()

# Define functions
function user_input

       {
		   [CmdletBinding()]
				$script:entry = Read-Host "What is the entry price? Enter this in the format 999'99.99"
				$script:exit = Read-Host "What is the exit price? Enter this in the format 999'99.99"
              }

#Begin script execution
user_input
[decimal[]]$entry_arr = $entry -split {$delim -contains $_}
[decimal[]]$exit_arr = $exit -split {$delim -contains $_}
# Write-Host "The value of $entry_arr[2] after the split is", $entry_arr[2]

# Data validation section
if ($entry_arr[1] -lt 0 -or $entry_arr[1] -gt 31) {
			throw "Enter a valid price"
			}
		elseif( $entry_arr[2] -eq 0) { 
			$quarters_entry = 0
			# write-host "if 0",$entry_arr[2]
			}
		elseif ( $entry_arr[2] -eq 2 ) { 
			$quarters_entry = .0078125 
			# write-host "if 2",$entry_arr[2]
			}
		elseif ( $entry_arr[2] -eq 5 ) { 
			$quarters_entry = (.0078125 * 2) 
			# write-host "if 5",$entry_arr[2]
			}
		elseif ( $entry_arr[2] -eq 7 ) { 
			$quarters_entry = (.0078125 * 3) 
			# write-host "if 7",$entry_arr[2]
			}
		else { throw "Enter a valid price" }
if ($exit_arr[1] -lt 0 -or $exit_arr[1] -gt 31) {
			throw "Enter a valid price"
			}
		elseif( $exit_arr[2] -eq 0) { 
			$quarters_exit = 0
			# write-host "if 0",$exit_arr[2]
			}
		elseif ( $exit_arr[2] -eq 2 ) { 
			$quarters_exit = .0078125 
			# write-host "if 2",$exit_arr[2]
			}
		elseif ( $exit_arr[2] -eq 5 ) { 
			$quarters_exit = (.0078125 * 2) 
			# write-host "if 5",$exit_arr[2]
			}
		elseif ( $exit_arr[2] -eq 7 ) { 
			$quarters_exit = (.0078125 * 3) 
			# write-host "if 7",$exit_arr[2]
			}
		else { throw "Enter a valid price" }

$entry_dec = $entry_arr[0] + ($entry_arr[1] * .03125) + $quarters_entry
$exit_dec = $exit_arr[0] + ($exit_arr[1] * .03125) + $quarters_exit
$zone = $entry_dec - $exit_dec
if ($zone -lt 0) {
			Write-Host "`nThis is a short trade`n"
				}
		else {
			Write-Host "`nThis is a long trade`n"
			}

$x = 1
DO
{
	New-Variable -name "target$x" -value ($entry_dec + ($zone * $x))
	
	$target = ($entry_dec + ($zone * $x))
	$target_arr = ($target -split {$delim -contains $_})
	$target_32_arr = ($target_arr[1]/312500) -split {$delim -contains $_}
	if ($target_32_arr -eq 25) {
		$target_quarter = 2
		}
		elseif ($target_32_arr -eq 50) {
		$target_quarter = 5
		}
		elseif ($target_32_arr -eq 75) {
		$target_quarter = 7
		}
		else {$target_quarter = 0}
	New-Variable -name "target_fraction$x" -value ($target_arr[0] + "'" + $target_32_arr[0] + "." + $target_quarter)
	$x++
	} While ($x -le 5)
$x--

write-host "The entry $entry is",$entry_dec
write-host "The exit $exit is",$exit_dec
Write-Host "`nTarget 1x is", $target_fraction1, $target1
Write-Host "Target 2x is", $target_fraction2, $target2
Write-Host "Target 3x is", $target_fraction3, $target3
Write-Host "Target 4x is", $target_fraction4, $target4
Write-Host "Target 5x is", $target_fraction5, $target5

$pause = Read-Host "`nPress any key to continue"
DO
	{
		Remove-Variable "target$x"
		Remove-Variable "target_fraction$x"
		$x--
	} While ($x -ge 1)
