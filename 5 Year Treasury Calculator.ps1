# Creation Date: 2019-05-17

#

Clear-Host

# Define delimeters
$delim = "'","."

# Define functions
function entry_price

       {
		   [CmdletBinding()]
              $script:entry = Read-Host "Entry"

              }

#Begin script execution
entry_price
[decimal[]]$entry_arr = $entry -split {$delim -contains $_}
Write-Host "The value of $entry_arr[2] after the split is", $entry_arr[2]
if ( $entry_arr[2] -eq 0) { 
        $quarters = 0
		write-host "if 0",$entry_arr[2]
        }
      elseif ( $entry_arr[2] -eq 2 ) { 
        $quarters = .0078125 
		write-host "if 2",$entry_arr[2]
        }
      elseif ( $entry_arr[2] -eq 5 ) { 
        $quarters = (.0078125 * 2) 
        write-host "if 5",$entry_arr[2]
		}
      elseif ( $entry_arr[2] -eq 7 ) { 
        $quarters = (.0078125 * 3) 
        write-host "if 7",$entry_arr[2]
		}
      else { throw "Enter a valid price" }

$entry_dec = $entry_arr[0] + ($entry_arr[1] * .03125) + $quarters

$entry_dec