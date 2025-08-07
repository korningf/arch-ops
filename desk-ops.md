

# Desk-Ops




# Dev Tools


##  0.  Admin on Desktop or Laptop

Ideally get admin privilege on the box in a permanent fashion. 

This a vast tools list and they require custom configurations,
some of which will no doubt be done in an adhoc interactive way.

Failing this, aquire temporary admin privilege for a day or so,
in order to attempt to configure the entire tool stack at once.

  
##  1.  Windows SysInternals

* install SysInternals in 'c:\sywin\bin'
  
```shell
  # see https://winget.ragerworks.com/package/Microsoft.Sysinternals.Suite

  setx SYSWIN "c:\syswin" /m
  setx PATH "%PATH%;%SYSWIN%;%SYSWIN%\bin" /m
  winget install --id=Microsoft.Sysinternals.Suite -e  --location c:\sywin\bin
```

##  2.  Chocolatey

* install Chocolatey in 'c:\chocolatey'
  
```shell
  # see https://docs.chocolatey.org/en-us/choco/setup/

  set ChocolateyInstall=c:\chocolatey
  setx CHOCOLATEY=c:\chocolatey  
  winget install --id=Chocolatey.Chocolatey -e --location c:\chocolatey

  # Disabled:  we favour cygwin over choco in the path
  # setx PATH=%PATH%;C:\chocolatey;C:\chocolatey\bin
```

##  3.  Cygwin POSIX

* install Cygwin POSIX in 'c:\cygwin'
  
```shell   
  # see https://community.chocolatey.org/packages/Cygwin

  setx CYGWIN=C:\cygwin\bin winsymlinks:native
  choco install cygwin --params "/InstallDir:C:\cygwin"

  setx PATH=%PATH%;C:\cygwin;C:\cygwin\bin;C:\cygwin\sbin;C:\cygwin\usr\bin;C:\cygwin\usr\sbin
```
   
##  4.  Azure-cli

* install the Azure-cli command-line tools
  
```shell
  setx AZURE=C:\azure
  winget install --exact --id Microsoft.AzureCLI --location c:\Azure\bin

  setx PATH=%PATH%;C:\Azure\bin
```

##  5.  AWS-cli

* install the AWS-cli command-line tools
  
```shell
  setx AWS=C:\AWS
  winget install --id "Amazon.AWSCLI" --location c:\AWS\bin
  
  setx PATH=%PATH%;C:\AWS\bin
```


##  6.  Dot.NET core

_TODO_ which .NET runtime version are we using?  8.0, 9.0 ?

* (developers): install the .NET SDK to develop .NET apps

```shell  
  winget install Microsoft.DotNet.SDK.8
```

* (all others): install the .NET runtime to run .NET apps
  
```shell  
  winget install Microsoft.DotNet.SDK.8
```

  
##  7.  ASP.NET core

* install the ASP.NET core runtime to run ASP.NET webapps

```shell  
  winget install Microsoft.DotNet.AspNetCore.8
```

