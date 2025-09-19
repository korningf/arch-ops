
# Dev-Box

*a windows box for Clodu Develeoprs, Integrators, and Operators*




# Background

The following provides a canonical generic windows development machine,

with the tools for Cloud Operators, Systems Integrator, and Developers.

As much as possible, it relies on the excellent Chocolatey package manager.




## GNU POSIX and a bash shell


Modern Cloud and Cluster deployment via IaC uses containerisation.
The process of containerisation often includes cross-compilation.
We need an environment that is powerful enough to cross-compile.
That's what POSIX was designed for (TODO: gcc / glibc toolchain ?)


CloudOps and DevOps tools also require many interpreted languages.
Tools like Vagrant, Docker, Puppet, Kubernetes, Terraform, AWS-cli
require tools like perl, python, ruby, go, php, and a POSIX shell.


## Cygwin POSIX

On Windows the only real full POSIX native environment is Cygwin.

Everything else derives from it. SysGit and Msys derive from it.
GitBash derives in turn from MSys.  Only cygwin has a full stack.


## GitBash POSIX

However, some corporate environments disallow a full Cygwin POSIX.

The following assumes this is the case and relies on GitBahs instead.




# Prerequisites


##  Admin on Desktop or Laptop

Ideally get admin privilege on the box in a permanent fashion. 

This a vast tools list and they require custom configurations,
some of which will no doubt be done in an adhoc interactive way.

Failing this, aquire temporary admin privilege for a day or so,
in order to attempt to configure the entire tool stack at once.




## Firewall Whitelist


Some corporate environments may use a scanning firewall proxy.

Add the following sites to your external firewall whitelist.


  


# Installation



## Legend

    [!]  mandatory
    [*]  provided
    [?]  evaluate  
    [+]  upgrade  
    [-]  missing


## Incremental Installations

    [A]  Cloud Operator     - deploy infrastructure (ie run terraform IAC)
    [B]  Cloud Integrator   - integrate services (ie package apps and services)
    [C]  Cloud Developer    - build appliances (ie build portable appliances)
    

*The next 3 sections list incremental installations for Cloud Operator, Integrators, and Developers.*


*Cloud Operators* need only install section A.

*Cloud Integrators* should install section B and C.

*Cloud Developers* should install sections A, B, and C.





#  A.  Cloud Operators, Integrators, Developers


Cloud Operators, Integrators, and Developers should all install the following:




##  0.  Chocolatey ([!] mandatory)

_TODO This is really complicated - a litany of manual commands and reboots_


    # see https://docs.chocolatey.org/en-us/choco/setup/
    # see https://docs.chocolatey.org/en-us/choco/setup/#install-using-winget    
    # see https://winstall.app/apps/Chocolatey.Chocolatey



We use a custom private chocoserver instead of the public one.

a custom powershell PS1 script sets up the choco environment.


###  Install Chocolatey

Open a new elevated powershell (run as administrator):

```shell
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocoserver:8443/repository/bootstrap/ChocolateyInstall.ps1'))
```

Now this only does a one-time install of a  local Chocolatey 2.4.3.

Crucially we want a bootstrap to point to the private chocoserver.

And we also want to upgrade our local client to choco 2.5.1.

###  Run the bootstrap _(ignore warnings)_
  
```shell
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocoserver:8443/repository/bootstrap/OnPremSetup.ps1'))
```

We need to set up our default shell environment and add devpc extensions.

###  Close the powershell and open another one.


```shell
    choco install standard_dsp_powershell_execpolicyunrestricted -y

    choco install standard_dsp_devpc_windowsconfig -y
    #choco install standard_dsp_devpc_windowsfeatures -y
```

_ignore errors and warnings, some features are currently broken_

_currently broken:_

    standard_dsp_devpc_windowsfeatures
    standard_dsp_devpc_windowsupdate
    standard_dsp_devpc_enable_rbac
    

###  Restart (reboot) the DevPC and open a new admin powershell.

```shell
    Restart-Computer -Force
```


##  1.  WSL ([!] mandatory) 

_TODO This is really complicated - a litany of manual commands and reboots_


Before installing other PcDev DevEng tools we should install WSL.

WSL (windows Subsystem for Linux) runs a native linux hypervisor VM.

Our Docker containers currently run on a WSL ubuntu linux machine.


_This is long litany of manual steps (we should provision devpc vms)_


###  Install WSL vms and container services


```shell
    choco install wsl_dsp_enable_wsl -y
    choco install wsl_dsp_enable_virtualmachineplatform -y
```

###  Restart (reboot) the DevPC and open a new admin powershell.

```shell
    Restart-Computer -Force
```


###  Update the WSL kernel:

We want to be able to use a specific linux version in WSL.

```shell
    choco install wsl_dsp_update_kernel -y
    choco install wsl_dsp_wsl2 -y
```

###  Install a specific Linux Distribution (ubuntu-22-lts aka jammy-jellyfish).

```shell
    choco install wsl_3rdparty_ubuntu2204 -y
```

This will have created a WSL Ubuntu-2204 launcher in your windows Start Menu.

On first launch, the WSL start menu icon runs the installer for the ubuntu VM.

The installer is interactive, we will have to configure a few options by hand.


_Pick English-UK and the following mount options_

```shell
    options=metadata,uid=1000,gid=1000,umask=022
```


### Configure sudo

The WSL command-line either runs as 'root' or 'ubuntu'.

Configure passwordless sudo and add yourself to sudoers.

```shell
    $WSL_USER=wsl -d Ubuntu-22.04 whoami
    $str="$WSL_USER ALL=(ALL) NOPASSWD:ALL"
    $tempFile=New-TemporaryFile
    wsl -d Ubuntu-22.04 sh -c "echo '$str' > /tmp/$tempFile.Name"
    wsl -d Ubuntu-22.04 sudo chown root /tmp/$tempFile.Name
```

if prompted enter your ubuntu password.

```shell
    wsl -d Ubuntu-22.04 sudo mv /tmp/$tempFile.Name /etc/sudoers.d/$WSL_USER
```

###  Install root ca certs and Nexus repository proxies.

We use a local Nexus Repository as a supply-chain proxy for common dev package managers.

This includes distros for for debian/ubuntu apt distrros, redhat/centos yum, and microsoft WSL.

```shell
    choco install wsl_dsp_ubuntu2204_root_ca -y
    choco install wsl_dsp_ubuntu2204_apt_proxy -y

    choco install wsl_3rdparty_ubuntu2204_ms_package_repo -y
    choco install wsl_3rdparty_ubuntu2204_distrod -y    
```




## 2.  DevPC Tools ([!] mandatory)

The DevTools scripts install a vast panoply of additional developer tools.

Some scripts are broken, so we decompose them, and run some steps by hand.




###  Install Developer Tools _(ignore warnings)_

Start with the base tools for geenral developers and database developers.

```shell
    choco install standard_dsp_devpc_tools -y
    choco install standard_dsp_devpc_sqltools -y
```

###  Restart the system, and re-open an admin shell.

```shell
    Restart-Computer -Force
```

###  Install root ca certs and Nexus repository proxies.

We use a local Nexus Repository as a supply-chain proxy for common dev package managers.

This includes repos for java maven, NuGet .NET, Python pip, NodeJS npm, Docker hub, etc.


```shell
    choco install standard_dsp_root_ca -y
    choco install standard_dsp_pip_cert -y

    choco install standard_3rdparty_nuget_packageprovider
    choco install ci_dsp_feeds -y
```

Before going any further, confirm that curl can resolve an https website without error:

```shell
    wsl -d Ubuntu-22.04 curl https://www.google.com
```



##  3.  GitBash POSIX ([!] mandatory)

_Gitbash is already included, but we need to force a reinstall_

GitBash provides a minimal POSIX bash environment with base core-utils. 

We need a custom install to enable symlinks and a proper TTY terminal.

*NOTE use Python for Windows with GitBash*


###  Install GitBash 

```shell
   # see https://community.chocolatey.org/packages/git

   choco install -y git.install --force --params '/SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf /PseudoConsoleSupport'
```

###  Customise Gitbash

We use a custom .profile script for the GitBash POSIX environment.

Install the script, entering the GitBash root  ('C:\Program Files\Git')

```shell
    choco install standard_dsp_powershell_profile -y
```

###  Edit your profile as needed.

 _TODO_

 

###  Configure Git _(broken)_

_TODO: The Git Config script is currently broken. configure it by hand_


```shell
    choco install standard_dsp_git_config
```


###  Configure Git by hand

```shell
    git config --global user.name   JohnDoe
    git config --global user.email  JohnDoe@email.com
```

###  Generate your SSH RSA 4096 keypair (USE a passphrase!)

_TODO: we should really standardise one of: POSIX Pass, KeePass, or Hashicorp Vault_

Use a passphrase for now (until we integrate KeePass, POSIX pass, or Vault).


```shell
    ssh-keygen -t rsa
```



##  4.  Windows SysInternals ([*] provided)

_this may already be included in the devtools_

SysInternals are standard MSDN Developer utils from Miscrosoft.

###  Install SysInternals

```shell
  choco install -y sysinternals --ignore-checksum --force
```



##  5.  Keepass ([*] provided)

_this may already be included in the devtools_

We Use Keepass for a local developer secure secret and password store.

I prefer the POSIX pass cmd (password-store), but keepass will do.

###  Install Keepass

```shell
  	choco install keepass -y
```



##  6.  stream processors (JSON, YAML, XML) ([*] provided)

_this may already be included in the devtools_

We will need these stream processors to parse JSON, YAML, XML.

###  Install stream processors (JQ, YQ, XQ)

```shell
   # see https://community.chocolatey.org/packages/jq
   # see https://community.chocolatey.org/packages/yq

   choco install -y jq
   choco install -y yq
```



##  7.  Terraform Cloud-Former ([!] mandatory)

_this may already be included in the devtools_

Hashicorp Terraform is the leading agnostic cloud infra provisioner.

###  Install Terraform (cloud cli)

```shell
   # see https://community.chocolatey.org/packages/terraform
  
   choco install -y terraform --pre
```


##  8.  Azure-cli ([+] provided)

Azure-Cli is the Azure Cloud command-line.

###  Install Azure-cli (AZ cloud)

```shell
   # see https://community.chocolatey.org/packages/azure-cli

   choco install -y azure-cli
```


##  9.  AWS-cli

AWS-Cli is the Amazon AWS Cloud command-line.

###  Install AWS-cli (AWS cloud)

```shell
     # see https://community.chocolatey.org/packages/awscli
  
     choco install -y awscli
```



#  B.  Backend Integrators, Developers 


Cloud Integrators and Developers should also install the following:



##  10.  Docker Desktop ([!] mandatory)

_TODO This is really complicated - we really should be runniong docker-desktop_

Docker-Desktop provides a local Docker runtime as well as the command-line cli.

The current DevEng standard runs Docker inside a WSL ubuntu VM on containerd.


###  Install docker on the WSL machine:

```shell
    choco install wsl_apt_ubuntu2204_docker -y
    choco install wsl_dsp_ubuntu2204_usermod_docker -y
```


###  We use a local Nexus Repository as a supply-chain firewall proxy for DockerHub images.

```shell
    choco install wsl_dsp_ubuntu2204_dockerhub_proxy -y
```

###  Start the docker daemon

```shell
    wsl systemctl status docker
    wsl systemctl restart docker
```

###  Test it by spinning up a hello-world docker appliance.

```shell
    wsl docker run hello-world
```

###  Test networking by installing a local nginx:

  ```shell
    wsl docker run -it --rm -d -p 8080:80 --name web nginx
  ```

###  Browse to localhost:8080

You should see the nginx page


###  Expose the WSL docker daemon on TCP:2375 ?

_TODO_




##  11.  Kubernetes Minikube  ([?] evaluate)

The default standard devpc dev tools script already install kubernetes-cli (aka kubetl).

Minikube-Cluster provides a local Kubernetes cluster as well as the command-line cli.

###  Install Minikube Cluster (kube-cli + runtime)

```shell
   # see https://community.chocolatey.org/packages/Minikube
  
   choco install -y minikube
```



##  12.  Kubernetes Helm  ([+] upgrade)

Kubernetes Helm (aka Navigator Charts) is a chart composer for Kube.

It simplifies and groups deployment of related services into charts.

###  Install Kubernetes Helm

```shell
   # see https://community.chocolatey.org/packages/kubernetes-helm
  
   choco install -y kubernetes-helm
```



##  13. Kubernetes Operations  ([?] evaluate)

Kubernetes Operations (Kops) builds Kubernetes clusters from scratch.

This would be used to build a custom cluster from a raw compute cloud.

###  install Kubernetes Operations (kops)

```shell
   # see https://community.chocolatey.org/packages/kubernetes-kops
  
   choco install -y kubernetes-kops
```



##  14.  Azure AKS-CTL   ([-] missing)

Command-line cli to drive Managed Azure AKS Clusters.

*TODO check this*

###  Install AKS-ctl (aksctl)

```shell
   # see https://community.chocolatey.org/packages/aksctl
   # seew https://github.com/adfolks/aksctl

   choco install -y aksctl
```


##  15.  AWS EKS-CTL   ([-] missing)

Command-line cli to drive Managed Amazon EKS Clusters.

###  Install EKS-ctl (eksctl)

```shell
   # see https://community.chocolatey.org/packages/eksctl

   choco install -y eksctl
```


##  16.  AWS ECS-CTL   ([-] missing)

Command-line cli to drive Managed Amazon ECS Containers.

###  Install ECS-ctl (ecsctl)

*TODO check this - only a PIP package for now*

```shell
   # see https://ecsctl.readthedocs.io/en/latest/

   pip install git+https://github.com/witold-gren/ecsctl.git
```



##  17.  Azure ACI-CTL  ([?] investigate)

*TODO is there an equivalent for Azure ACI/ACA containers ?*




##  18.  Hashicorp Packer  ([-] missing)

Hashicorp Packer is the leading agnostic cloud image packager.

###  Install Packer (packer cli)

```shell
   # see https://community.chocolatey.org/packages/packer

   choco install -y packer
```

### Nexus Repository for Packer (_TODO_)

_TODO_


##  19.  Hashicorp Vagrant  ([-] missing)

Hashicorp Vagrant is the leading agnostic development machine provisioner.

```shell
   # see https://community.chocolatey.org/packages/vagrant

   choco install -y vagrant
```

### Nexus Repository for Vgagrant (_TODO_)

_TODO_


##  20.  Hashicorp Vault  ([-] missing)

Hashicorp Vault is the leading agnostic cloud secrets manager.

###  Install Vault (vault cli)

```shell
   # see https://community.chocolatey.org/packages/vault

   choco install -y vault
```




#  C.  Coders and Developers

In addition Developers and Build-Masters should also install the following.



##  21.  Python ([*] provided)

Python is required for Cloud-Ops and Dev-Ops tools (aws-cli, azure-cli ...)

*NOTE use Python for Windows with GitBash*

###  Install Python

```shell
   # see https://github.com/korningf/cso-git#Python

   choco install -y python --force
```

###  Nexus Repository for Python (_TODO_)

_TODO_


##  22.  Ruby ([?] evaluate)

Ruby is required for Cloud-Ops and Dev-Ops tools (vagrant, puppet ...)

###  Install Ruby

```shell
   # see https://community.chocolatey.org/packages/ruby

   choco install -y ruby
```

###  Nexus Repository for Ruby (_TODO_)

_TODO_



##  23.  Go  ([?] evaluate)

Go-Lang is required for Cloud-Ops and Dev-Ops tools (docker, kubernetes ...)

###  Install Go-Lang

```shell
   # see https://community.chocolatey.org/packages/golang

   choco install -y golang
```

###  Nexus Repository for Go (_TODO_)

_TODO_



##  24.  Dot.NET SDK  ([?] _which version?_)

_TODO_ which .NET runtime version are we using?  8.0, 9.0, 10.0 ?

### Install the .NET core SDK

```shell
   # see https://community.chocolatey.org/packages/dotnet-9.0-sdk

   choco install -y dotnet-9.0-sdk
```

  
##  25.  ASP.NET core  ([?] _which version?_)

_TODO_ which .NET runtime version are we using?  8.0, 9.0, 10.0 ?

### install the ASP.NET core runtime

```shell
   # see https://community.chocolatey.org/packages/dotnet-9.0-aspnetruntime

   choco install -y dotnet-9.0-aspnetruntime
```


##  26.  VisualStudio Code ([*] provided)

_this may already be provided with devtools_

###  Install VSCode

```shell
   # see https://community.chocolatey.org/packages/vscode

   choco install -y vscode
```


##  27.  Java OpenJDK ([+] upgrade)

_Devtools installs a legacy openjdk-8, we need to upgrade it the latest_

We will need Java to run Jenkins CI, Sonar, and a host of other systems.

* install OpenJDK

```shell
   # see https://community.chocolatey.org/packages/openjdk

   choco install -y openjdk
```


##  28.  Apache Maven ([+] upgrade)

_devtools provides an older version, we need to upgrade to the latest_

Maven is the build toolchain for Java.

###  Install Maven

```shell
   # see https://community.chocolatey.org/packages/maven

   choco install -y maven
```


##  29.  Eclipse IDE  ([-] optional)

Eclipse is the IDE for Java.

###  Install Eclipse IDE

```shell
   # see https://community.chocolatey.org/packages/eclipse-java-oxygen
  
   choco install -y eclipse-java-oxygen
```


##  30.  GnuWin64 or MinGW  ([-] optional)

_TODO optional_

I usually use Cygwin64 to cross-compile from native Windows to POSIX Linux and back.

GnuWin64 or MinGW are POSIX GNU GCC/GLIBC C/C++ toolchains (GnuWin64 is preferred).

It include gcc, g++, glibc lib, binutils, GNU Autotools (automake, configure).

It's not clear yet if we have to cross-compile anything to/from POSIX and GLibc.

Investigate whether we need a complete cross-compilation toolchain for the future.

_TODO optional_



# Extension

_TODO Should we consider the following?_

## Docker-Compose ?

## Puppet ?

## Ansible

## Chef

## Salt

## Perl / CPAN

## Rust / Cargo





# Appendix

## Choco and Winget parameters

Both Choco and Winget packages may have configurable parameters.

But they can also make use of msiexec .msi parameters underneath.


    # see https://docs.chocolatey.org/en-us/licensed-extension/release-notes/#improvements-25

    # see https://jrsoftware.org/ishelp/index.php?topic=setupcmdline

    
