#

# 5Year.ps1

# Author: Chris Phillips

# Description: Converts 5 year treasury prices from fraction to decimal

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
$entry_arr = $entry -split {$delim -contains $_}
if ( $entry_arr[2] = 0) { 
        $entry_arr[2] = 0 
        }
      elseif ( $entry_arr[2] = 2 ) { 
        $entry_arr[2] = .0078125 
        }
      elseif ( $entry_arr[2] = 5 ) { 
        $entry_arr[2] = (.0078125 * 2) 
        }
      elseif ( $entry_arr[2] = 7 ) { 
        $entry_arr[2] = (.0078125 * 3) 
        }
      else { $entry_arr[2] = 9 }

if ( $entry_arr[2] = 9 ) {
		entry_price
		}

$entry_dec = [int]$entry_arr[0] + ([int]$entry_arr[1] * .03125) + [int]$entry_arr[2]

$entry_dec