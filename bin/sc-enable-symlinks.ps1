# sc-enable-symlinks.ps1

# see https://superuser.com/questions/1935570/on-windows-10-how-to-allow-regular-user-to-create-symbolic-links-via-the-comman

# 0. By default, Windows 10 Home does not support symbolic links for non-admin users.
# It does not a Local Security Policy Editor (secpol.msc) and Group Policy Editor (gpedit.msc).
# but you can still enable the "Create symbolic links" privilege for a regular developer user.


# 1. Set Windows 10 Home to Developer Mode
#   Settings |  Update & Security | For developers | toggle Developer mode to "On"

# 2. Create a Local security Policy db and set the SC Service Control policy

secedit /export /cfg $env:temp\secpol.cfg

(gc $env:temp\secpol.cfg) -replace "SeCreateSymbolicLinkPrivilege = \*S-1-5-32-544", "SeCreateSymbolicLinkPrivilege = \*S-1-5-32-544,YourUsername" | Out-File C:\secpol.cfg

secedit /configure /db $env:windir\security\local.sdb /cfg $env:temp\secpol.cfg /areas USER_RIGHTS

#del $env:temp\secpol.cfg

