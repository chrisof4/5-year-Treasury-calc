# 5-year-Treasury-calc
5 Year Treasury Calculator

The most basic goal of this project was to collect a fractional 5 year treasury price from the user and convert it into the decimal equivilent. (e.g. 115'16.0 = 115.5). The input needs to be validated that it conforms to traditional fractional pricing (whole number + <apostrophe> + 32nds + <decimal> + quarter of 32nds expressed as 0,2,5, or 7). The decimal version will be displayed for the user.

The current version of this project collects an entry price, an exit price, and the number of contracts. The script calculates the following:
  - The activation rule for confirmation entries (identified as the confirmation price in the script)
  - The risk in dollars (including fees)
  - The fees in dollars
  - Several price targets (1:1, 2:1, 3:1, 4:1, and 5:1)
  - The profit in dollars for each price target (net of fees)
  
The output is displayed in table format in both fractional and decimal pricing.

Future versions may include such things as:
  - Capital required to open this position on margin.

5 year treasury prices are the most complex. Now that this version is stable, I may create a new project to calculate 10 year and 30 year treasury prices also. The user would get a menu asking which they want to calculate.
