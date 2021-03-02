csvde -m -n -f C:\Temp\users.csv -s dc1.organization.local -d "ou=factory, dc=organization, dc=local" -r objectClass=user 
-l "DN, sn, name, objectclass, givenName, memberOf, badPasswordTime, lastLogon, lastLogonTimestamp, logonCount, sAMAccountName, userAccountControl, whenChanged, whenCreated"
