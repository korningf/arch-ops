#

# see https://superuser.com/questions/1935570/on-windows-10-how-to-allow-regular-user-to-create-symbolic-links-via-the-comman


secedit /export /cfg "%TEMP%\secpol.txt"

type "%TEMP%\secpol.txt" | findstr /i link

powershell -NoProfile -Command "$u=whoami;$p=$env:TEMP+'\secpol.txt';$c=Get-Content $p;$c=$c|%{if($_ -match '^SeCreateSymbolicLinkPrivilege\s*=' -and $_ -notmatch [regex]::Escape($u)){$_+','+$u}else{$_}};Set-Content $p $c"

type "%TEMP%\secpol.txt" | findstr /i link

secedit /configure /db C:\Windows\Security\Local.sdb /cfg "%TEMP%\secpol.txt" /areas USER_RIGHTS