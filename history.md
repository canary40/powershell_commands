Hi, there it is how to **_delete_ PowerShell history**: 

Clear-History

Remove-Item $env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt


If you want to **_suspend_ command history**: 

Remove-Module PSReadLine


Finally, if you want to **_restore_ command history**:

Import-Module PSReadLine

