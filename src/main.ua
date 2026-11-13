# uiua-rows — numeric column statistics for one-number-per-line files.
# Usage: uiua-rows <file>
# Prints count / sum / mean / min / max. Blank lines are ignored;
# spaces, tabs and carriage returns are stripped before parsing.

Args ← &args
⍤ "usage: uiua-rows <file>" ≥2 ⧻Args
Path ← ⊡1 Args
Text ← &fras Path

# Strip spaces, tabs and CR so blank lines, indentation and CRLF are harmless.
M ← ≠@ Text
NoSp ← ▽ M Text
M ← ≠@\t NoSp
NoTab ← ▽ M NoSp
M ← ≠@\r NoTab
Clean ← ▽ M NoTab

# Split into lines (mask must be a separate stack item).
Mask ← ≠@\n Clean
Lines ← ⊜□ Mask Clean

# Drop empty lines, parse the rest as numbers.
Lens ← ≡⧻ Lines
Nums ← ≡parse ▽>0 Lens Lines
⍤ "no numbers in file" >0 ⧻Nums

Count ← ⧻Nums
Sum ← /+ Nums
Mean ← ÷ Count Sum
&p $"count _" Count
&p $"sum _" Sum
&p $"mean _" Mean
&p $"min _" /↧ Nums
&p $"max _" /↥ Nums