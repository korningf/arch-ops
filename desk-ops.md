

# Desk-Ops



# Dev Tools


# Installation


##  Admin on Desktop or Laptop

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



# GNU POSIX and a bash shell

POSIX is many things; it's an OS architecture and specification,
describing systems APIs, structures, IO, memory, routines, signals,
file systems, input and output streams, and a shell specification;
it's a source compilation and linkage toolchain to produce portable
binary executables; it's an OS filesystem layout specification; and
lastly it's a stack of universal tools including common networking
and security on which UNIX, ArpaNet, and the internet was built.

. 

These tools include shell GNU core-utils like sed, awk, grep, find,
but they also include the network stack underpinning the internet.
Things like routing, DNS, DHCP, OpenSSL, and OpenSSH Secure-Shell.
All of these are derived from POSIX code and work best within POSIX.

.

Modern Cloud and Cluster deployment via IaC uses containerisation.
The process of containeisation often includes cross-compilation.
We need an environment that is powerful enough to cross-compile.
That's what POSIX was designed for.  

.

CloudOps and DevOps tools also require many interpreted languages.
Tools like Vagrant, Docker, Puppet, Kubernetes, Terraform, AWS-cli
require tools like perl, python, ruby, go, php, and a POSIX shell.

.

On Windows the only real full POSIX native environment is Cygwin.
Everything else derives from it. SysGit and Msys derive from it.
GitBash derives in turn from MSys.  Only cygwin has a full stack.

Failing this we can manage with GitBash, but it is incomplete.



##  0.  Chocolatey

* install Chocolatey in 'c:\chocolatey'
  
```shell
  # see https://docs.chocolatey.org/en-us/choco/setup/

  set ChocolateyInstall=c:\chocolatey
  setx ChocolateyInstall c:\chocolatey
  setx /s CHOCOLATEY c:\chocolatey  
  winget install --id=Chocolatey.Chocolatey -e --location c:\chocolatey

  # Disabled:  we favour cygwin over choco in the path
  # setx PATH %PATH%;C:\chocolatey;C:\chocolatey\bin
```


##  1.  Windows SysInternals

* install SysInternals in 'c:\sywin\bin'
  
*Choose: 1a (Choco) or 1b (winget)*

a) install via choco
```shell
  choco install sysinternals --params "/InstallDir:C:\syswin\bin"
```

b) install via winget
  
```shell
  # see https://winget.ragerworks.com/package/Microsoft.Sysinternals.Suite

  setx SYSWIN "c:\syswin" /m
  setx PATH "%PATH%;%SYSWIN%;%SYSWIN%\bin" /m
  winget install --id=Microsoft.Sysinternals.Suite -e  --location c:\sywin\bin
```


##  2.  POSIX Bash

Ideally we run a full Cygwin POSIX.  Check with cybersecurity.

Failing this use GitBash POSIX, and probably Windows Python too.

.

Gitbash, Python, PyEnv, and the Pip package manager are temperamental.
For it to work properly, PIP needs to use Windows auth TLS/SSL certs.

The Python needs to mirror the Git setup for user-space vs all-users,
so if Git is installed for machine-scope all-users, so should Python,
or vice-versa.



*Choose: 2a (Cygwin-Choco) or 2b (Gitbash-Choco) or 2c (Gitbash-winget)*

###  2a.  Cygwin POSIX

* install Cygwin POSIX in 'c:\cygwin'
  
```shell   
   # see https://community.chocolatey.org/packages/Cygwin

   setx CYGWIN C:\cygwin\bin winsymlinks:native
   choco install cygwin --params "/InstallDir:C:\cygwin"

   setx PATH %PATH%;C:\cygwin;C:\cygwin\bin;C:\cygwin\sbin;C:\cygwin\usr\bin;C:\cygwin\usr\sbin
```

###  2b.  GitBash via Choco

*NOTE use Python for Windows with GitBash*

* install GitBash via Choco

```shell
   # see https://github.com/korningf/cso-git#Python
   # see https://community.chocolatey.org/packages/git

   choco install git.install --params "'/SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf /PseudoConsoleSupport'"
```

###  2c.  GitBash via Winget

*NOTE use Python for Windows with GitBash*

* install GitBash via Winget
 
```shell   
   # see https://github.com/korningf/cso-git#Python
   # see https://gitforwindows.org/silent-or-unattended-installation.html

   setx GIT %USERPROFILE%\AppData\Local\Git
   setx PIP %USERPROFILE%\AppData\Local\pip

   #winget install -e --id Git.Git -source winget /ALLUSERS /SILENT /NORESTART /NOCANCEL /EnableSymlinks=Enabled /EnablePseudoConsoleSupport=Enabled
   winget install -e --id Git.Git -source winget  /SILENT /NORESTART /NOCANCEL /EnableSymlinks=Enabled /EnablePseudoConsoleSupport=Enabled

   setx PATH=%PATH%;%USERPROFILE%\AppData\Local\Git
   setx PATH=%PATH%;%USERPROFILE%\AppData\Local\Pip
   setx PATH=%PATH%;%USERPROFILE%\AppData\Local\Programs\Git
   setx PATH=%PATH%;%USERPROFILE%\AppData\Local\Programs\pip
```


##  3.  Python

*NOTE use Python for Windows with GitBash*

Gitbash, Python, PyEnv, and the Pip package manager are temperamental.
For it to work properly, PIP needs to use Windows auth TLS/SSL certs.

The Python needs to mirror the Git setup for user-space vs all-users,
so if Git is installed for machine-scope all-users, so should Python,
or vice-versa.



```shell
   # see https://github.com/korningf/cso-git#Python

   #choco install python --version 3.10.0 --params "/InstallDir:C:\Program Files\Python\Python310".
   choco install python --version 3.10.0
```


```shell   
  # see https://github.com/korningf/cso-git#Python
  # see https://community.chocolatey.org/packages/python

  setx PYTHON c:\windows\py.exe

  #winget install -e --id Python.Python.3.10 --scope machine  /ALLUSERS --location C:\Program Files\Python\Python310
  winget install -e --id Python.Python.3.10 --scope machine

  setx PATH %PATH%;%USERPROFILE%\AppData\Roaming\Python\Python310\Scripts
  setx PATH %PATH%;%USERPROFILE%\AppData\Roaming\Python\Python310\Site-packages
```


##  4.  Dot.NET SDK

_TODO_ which .NET runtime version are we using?  8.0, 9.0 ?

* install the .NET core SDK

```shell  
   winget install Microsoft.DotNet.SDK.9
```

  
##  5.  ASP.NET core

* install the ASP.NET core runtime

```shell  
   winget install Microsoft.DotNet.AspNetCore.9
```


##  6.  VisualStudio Code

_TODO_ (do we need VisualStudio, either Community or Licensed?)

* install VSCode via winget 

```shell
   # see https://winget.ragerworks.com/package/Microsoft.VisualStudioCode

   winget install --id=Microsoft.VisualStudioCode -e
```


##  7.  Java OpenJDK

* install OpenJDK

```shell
   # see https://community.chocolatey.org/packages/openjdk

   choco install openjdk
```


##  8.  Apache Maven

* install Maven

```shell
   # see https://community.chocolatey.org/packages/maven

   choco install maven
```


##  9.  Eclipse IDE

* install Eclipse IDE

```shell
   # see https://community.chocolatey.org/packages/eclipse-java-oxygen
  
   choco install eclipse-java-oxygen
```


##  10.  stream processors (JSON, YAML, XML)

* install stream processors (JQ, YQ, XQ)

```shell
   # see https://community.chocolatey.org/packages/jq
   # see https://community.chocolatey.org/packages/yq

   choco install jq
   choco install yq
```


##  11.  Azure-cli

* install the Azure-cli command-line tools

```shell
   choco install azure-cli --params "/InstallDir:C:\Azure\bin".

   setx PATH %PATH%;C:\Azure\bin
```

  
```shell
   setx AZURE=C:\azure
   winget install --exact --id Microsoft.AzureCLI --location c:\Azure\bin

   setx PATH %PATH%;C:\Azure\bin
```

##  12.  AWS-cli

* install the AWS-cli command-line tools

  ```shell
   choco install awscli --params "/InstallDir:C:\AWS\bin".

   setx PATH %PATH%;C:\AWS\bin
```

```shell
   setx AWS C:\AWS
   winget install --id "Amazon.AWSCLI" --location c:\AWS\bin
  
   setx PATH %PATH%;C:\AWS\bin
```

##  13.  Terraform Cloud-Former

* install Terraform

```shell
   # see https://community.chocolatey.org/packages/terraform
  
   choco install terraform --pre
```


##  14.  Docker Desktop

* install Docker Desktop

```shell
  # see https://community.chocolatey.org/packages/docker-desktop
  
  choco install docker-desktop
```


##  15.  Kubernetes Cluster (Minikube)

* install Minikube Cluster

```shell
   # see https://community.chocolatey.org/packages/Minikube
  
   choco install minikube
```


##  16.  Kubernetes Helm (Navigator)

* install Kubernetes Helm (Navigator)

```shell
   # see https://community.chocolatey.org/packages/kubernetes-helm
  
   choco install kubernetes-helm
```


##  17.  Kubernetes Operations (Kops)

* install Kubernetes Operations (Kops)

```shell
   # see https://community.chocolatey.org/packages/kubernetes-kops
  
   choco install kubernetes-kops
```


##  18.  Azure AKS-CTL (aksctl) 

*TODO check this*

* install AKS-ctl (aksctl)

```shell
   # see https://community.chocolatey.org/packages/aksctl
   # seew https://github.com/adfolks/aksctl

   choco install aksctl
```


##  19.  AWS EKS-CTL (eksctl)

* install EKS-ctl (eksctl)

```shell
   # see https://community.chocolatey.org/packages/eksctl

   choco install aksctl
```


##  20.  AWS ECS-CTL (ecsctl)

* install EKS-ctl (eksctl)

*TODO check this - only a PIP package for now*

```shell
   # see https://ecsctl.readthedocs.io/en/latest/

   pip install git+https://github.com/witold-gren/ecsctl.git
```


##  21.  Azure ACI-CTL ?

*TODO is there an equivalent for Azure ACI/ACA adhoc containers ?*


# Appendix

## Choco and Winget parameters

Both Choco and Winget packages may have configurable parameters.

But they can also make use of msiexec .msi parameters underneath.


    # see https://docs.chocolatey.org/en-us/licensed-extension/release-notes/#improvements-25

    # see https://jrsoftware.org/ishelp/index.php?topic=setupcmdline

    
