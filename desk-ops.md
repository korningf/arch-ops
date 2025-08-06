

# Desk-Ops




# Dev Tools


0. Admin on Desktop or Laptop

  
1. Windows SysInternals

  # see https://winget.ragerworks.com/package/Microsoft.Sysinternals.Suite

  setx SYSWIN "c:\syswin" /m
  setx PATH "%PATH%;%SYSWIN%;%SYSWIN%\bin" /m
  winget install --id=Microsoft.Sysinternals.Suite -e  --location c:\sywin\bin


2. Chocolatey

  # see https://docs.chocolatey.org/en-us/choco/setup/

  set ChocolateyInstall=c:\chocolatey
  setx CHOCOLATEY=c:\chocolatey  
  winget install --id=Chocolatey.Chocolatey -e --location c:\chocolatey

  # Disabled:  we favour cygwin over choco in the path
  # setx PATH=%PATH%;C:\chocolatey;C:\chocolatey\bin


3. Cygwin POSIX
   
  # see https://community.chocolatey.org/packages/Cygwin

  setx CYGWIN=C:\cygwin\bin winsymlinks:native
  choco install cygwin --params "/InstallDir:C:\cygwin"

  setx PATH=%PATH%;C:\cygwin;C:\cygwin\bin;C:\cygwin\sbin;C:\cygwin\usr\bin;C:\cygwin\usr\sbin

   
4.   ## Azure-cli

  setx AZURE=C:\azure
  winget install --exact --id Microsoft.AzureCLI --location c:\Azure\bin

  setx PATH=%PATH%;C:\Azure\bin


5.   ## AWS-cli

  setx AWS=C:\AWS
  winget install --id "Amazon.AWSCLI" --location c:\AWS\bin
  
  setx PATH=%PATH%;C:\AWS\bin

  

