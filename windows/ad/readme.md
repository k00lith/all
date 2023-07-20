### Export to csv last login users

```powershell
#
# Export AD Users into CSV with lastlogon date
#
Import-Module ActiveDirectory

Get-ADUser -Filter * -Properties lastLogon | Select samaccountname, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}} |

Export-Csv "c:\Export\LastLoginUsers.csv" -Encoding UTF8 -NoTypeInformation
```


### Export to csv no login users past than some days

```powershell
#
# Export AD Users into CSV with lastlogon date more than 180 days
#
Import-Module ActiveDirectory  
  
$DaysInactive = 180  
$Time = (Get-Date).Adddays( - ($DaysInactive))  
  
Get-ADUser -Filter { LastLogonTimeStamp -lt $Time -and enabled -eq $true } -Properties * |  
Select-Object Name, LastLogonDate |  
  
Export-Csv "c:\Export\InactiveUsers.csv" -Encoding UTF8 -NoTypeInformation
```
