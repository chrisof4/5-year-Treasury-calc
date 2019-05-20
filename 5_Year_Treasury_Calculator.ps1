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
$target1 = $entry_dec + $zone
$target2 = $entry_dec + ($zone * 2)
$target3 = $entry_dec + ($zone * 3)
$target4 = $entry_dec + ($zone * 4)
$target5 = $entry_dec + ($zone * 5)

$target1_arr = $target1 -split {$delim -contains $_}
$target1_32_arr = ($target1_arr[1]/312500) -split {$delim -contains $_}
if ($target1_32_arr -eq 25) {
    $target1_quarter = 2
    }
    elseif ($target1x_32_arr -eq 50) {
    $target1_quarter = 5
    }
    elseif ($target1x_32_arr -eq 75) {
    $target1_quarter = 7
    }
    else {$target1_quarter = 0}
$target1_fr =  $target1_arr[0] + "'" + $target1_32_arr[0] + "." + $target1_quarter

$target2_arr = $target2 -split {$delim -contains $_}
$target2_32_arr = ($target2_arr[1]/312500) -split {$delim -contains $_}
if ($target2_32_arr -eq 25) {
    $target2_quarter = 2
    }
    elseif ($target2x_32_arr -eq 50) {
    $target2_quarter = 5
    }
    elseif ($target2x_32_arr -eq 75) {
    $target2_quarter = 7
    }
    else {$target2_quarter = 0}
$target2_fr =  $target2_arr[0] + "'" + $target2_32_arr[0] + "." + $target2_quarter

$target3_arr = $target3 -split {$delim -contains $_}
$target3_32_arr = ($target3_arr[1]/312500) -split {$delim -contains $_}
if ($target3_32_arr -eq 25) {
    $target3_quarter = 2
    }
    elseif ($target3x_32_arr -eq 50) {
    $target3_quarter = 5
    }
    elseif ($target3x_32_arr -eq 75) {
    $target3_quarter = 7
    }
    else {$target3_quarter = 0}
$target3_fr =  $target3_arr[0] + "'" + $target3_32_arr[0] + "." + $target3_quarter

$target4_arr = $target4 -split {$delim -contains $_}
$target4_32_arr = ($target4_arr[1]/312500) -split {$delim -contains $_}
if ($target4_32_arr -eq 25) {
    $target4_quarter = 2
    }
    elseif ($target4x_32_arr -eq 50) {
    $target4_quarter = 5
    }
    elseif ($target4x_32_arr -eq 75) {
    $target4_quarter = 7
    }
    else {$target4_quarter = 0}
$target4_fr =  $target4_arr[0] + "'" + $target4_32_arr[0] + "." + $target4_quarter

$target5_arr = $target5 -split {$delim -contains $_}
$target5_32_arr = ($target5_arr[1]/312500) -split {$delim -contains $_}
if ($target5_32_arr -eq 25) {
    $target5_quarter = 2
    }
    elseif ($target5x_32_arr -eq 50) {
    $target5_quarter = 5
    }
    elseif ($target5x_32_arr -eq 75) {
    $target5_quarter = 7
    }
    else {$target5_quarter = 0}
$target5_fr =  $target5_arr[0] + "'" + $target5_32_arr[0] + "." + $target5_quarter

write-host "The entry $entry is",$entry_dec
write-host "The exit $exit is",$exit_dec
Write-Host "`nTarget 1x is", $target1_fr, $target1
Write-Host "Target 2x is", $target2_fr, $target2
Write-Host "Target 3x is", $target3_fr, $target3
Write-Host "Target 4x is", $target4_fr, $target4
Write-Host "Target 5x is", $target5_fr, $target5

$pause = Read-Host "`nPress any key to continue"