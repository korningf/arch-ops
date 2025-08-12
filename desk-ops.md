

# Desk-Ops



# Dev Tools


# Installation


##  0.  Admin on Desktop or Laptop

Ideally get admin privilege on the box in a permanent fashion. 

This a vast tools list and they require custom configurations,
some of which will no doubt be done in an adhoc interactive way.

Failing this, aquire temporary admin privilege for a day or so,
in order to attempt to configure the entire tool stack at once.

.

Some of the distribution packages are installed via chocolatey,
but a number are installed manually in custom paths via winget.

At minimum we want a chroot BASH shell with a POSIX filesystem,
which requires symlinks (either native symlinks or Junctions).




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


##  6.  Dot.NET SDK

_TODO_ which .NET runtime version are we using?  8.0, 9.0 ?

* install the .NET core SDK

```shell  
  winget install Microsoft.DotNet.SDK.9
```

  
##  7.  ASP.NET core

* install the ASP.NET core runtime

```shell  
  winget install Microsoft.DotNet.AspNetCore.9
```


##  8.  VisualStudio Code

_TODO_ (do we need VisualStudio, either Community or Licensed?)

* install VSCode via winget 

```shell
  # see https://winget.ragerworks.com/package/Microsoft.VisualStudioCode

  winget install --id=Microsoft.VisualStudioCode -e
```


##  9.  Java OpenJDK

* install install the JDK

```shell
  # see https://community.chocolatey.org/packages/openjdk

  choco install openjdk
```


##  10.  Apache Maven

* install Maven

```shell
  # see https://community.chocolatey.org/packages/maven

  choco install maven
```


##  11.  Eclipse IDE

* install Eclipse IDE

```shell
  # see https://community.chocolatey.org/packages/eclipse-java-oxygen
  
  choco install eclipse-java-oxygen
```


##  12.  Docker Desktop

* install Docker Desktop

```shell
  # see https://community.chocolatey.org/packages/docker-desktop
  
  choco install docker-desktop
```


##  13.  Kubernetes Cluster (Minikube)

* install Minikube Cluster

```shell
  # see https://community.chocolatey.org/packages/Minikube
  
  choco install minikube
```


##  14.  Kubernetes Helm (Navigator)

* install Kubernetes Helm (Navigator)

```shell
  # see https://community.chocolatey.org/packages/kubernetes-helm
  
  choco install kubernetes-helm
```


##  15.  Kubernetes Operations (Kops)

* install Kubernetes Operations (Kops)

```shell
  # see https://community.chocolatey.org/packages/kubernetes-kops
  
  choco install kubernetes-kops
```


##  16.  Terraform Cloud-Former

* install Terraform

```shell
  # see https://community.chocolatey.org/packages/terraform
  
  choco install terraform --pre
```


##  17.  stream processors (JSON, YAML, XML)

* install stream processors (JQ, YQ, XQ)

```shell
  # see https://community.chocolatey.org/packages/jq
  # see https://community.chocolatey.org/packages/yq

  choco install jq
  choco install yq
```




