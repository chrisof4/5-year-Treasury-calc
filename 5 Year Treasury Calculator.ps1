# Creation Date: 2019-05-17

#

Clear-Host

# Define delimeters
$delim = "'","."
$entry_arr = @()
$entry_arr

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
			Write-Host "This is a short trade"
				}
		else {
			Write-Host "This is a long trade"
			}
$target1x = $entry_dec + $zone
$target2x = $entry_dec + ($zone * 2)
$target3x = $entry_dec + ($zone * 3)
$target4x = $entry_dec + ($zone * 4)
$target5x = $entry_dec + ($zone * 5)
write-host "The entry $entry is",$entry_dec
write-host "The exit $exit is",$exit_dec
Write-Host "Target 1x is", $target1x
Write-Host "Target 1x is", $target2x
Write-Host "Target 1x is", $target3x
Write-Host "Target 1x is", $target4x
Write-Host "Target 1x is", $target5x