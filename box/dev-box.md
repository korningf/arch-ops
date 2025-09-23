
# Dev-Box  

*a windows box for Clodu Develeoprs, Integrators, and Operators*



# Background

The following provides a canonical generic windows development machine,

with the tools for Cloud Operators, Systems Integrator, and Developers.

As much as possible, it relies on the excellent Chocolatey package manager.




## GNU POSIX and a bash shell

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
The process of containerisation often includes cross-compilation.
We need an environment that is powerful enough to cross-compile.
That's what POSIX was designed for (TODO: gcc / glibc toolchain ?)

.

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

At minimum we want a chroot BASH shell with a POSIX filesystem,

which requires symlinks (either native symlinks or Junctions).



## An email identity for Git, SSH, GPG

You should have an email identity fonfigured with a Git Account.

The same identity will be used for your SSH key and GPG keyring.




## Firewall Whitelist


Some corporate environments may use a scanning firewall proxy.

Add the following sites to your external firewall whitelist.


```text
  Microsoft stack:
    microsoft.com 
    msdn.com

  .NET stack:
    winget.org  
    nuget.org

  Win Ops:
    chocolatey.org
    cygwin.com
    msys2.org    
    packagist.org 
    git-scm.com
    gitforwindows.org    

  Cloud infra:
    azure.com
    amazonaws.com    
    googleapis.com
    googlesource.com

  Cloud Ops:
    passwordstore.org
    docker.io
    docker.com
    kubernetes.io
    k8s.io
    helm.sh
    terraform.io
    hashicorp.com

  Dev Ops:
    cpan.org
    anaconda.com
    anaconda.org
    python.org
    pypi.org
    ruby-lang.org
    rubygems.org
    rubyonrails.org
    go.dev
    oracle.com
    apache.org
    maven.org
    jenkins.io
    eclipse.org
    sonatype.org

  OSS Code:
    github.com
    gitlab.com
    bitbucket.org
    sourceforge.net
```
  


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

*Cloud Integrators* should install section A and B.

*Cloud Developers* should install sections A, B, and C.




#  A.  Cloud Operators, Integrator, Developers


Cloud Operators, Integrators, and Developers should all install the following:




##  0.  Chocolatey ([!] mandatory)

Everything starts with Chocolatey.

Best to install Chocolatey via winget.  

Refer to docs when behind a corporate firewall.

    # see https://docs.chocolatey.org/en-us/choco/setup/
    # see https://docs.chocolatey.org/en-us/choco/setup/#install-using-winget    
    # see https://winstall.app/apps/Chocolatey.Chocolatey


###  Install Chocolatey

Open a new elevated powershell (run as administrator):


```shell
    winget install -e --id=Chocolatey.Chocolatey    
```



##  1.  Windows SysInternals  ([*] provided)

SysInternals are standard MSDN Developer utils from Miscrosoft.

###  Install SysInternals

```shell
  choco install -y sysinternals --ignore-checksum --force
```



##  1.  WSL - Windows Subsystem for Linux  ([*] provided) 

WSL (windows Subsystem for Linux) provides a native linux hypervisor VM.
    
Our IaC test clouds, clusters, and docker containers will all run on WSL.

The simplest way is to use Choco.

    see https://community.chocolatey.org/packages/wsl2


###  Install WSL (Windows Subsystem for Linux)  

The current WSL-2 linux version is Ubuntu-22-lts aka Jammy-JellyFish.


```shell
    choco install wsl2
```



##  2.  GitBash POSIX ([!] mandatory)

_Gitbash is already included, but we need to force a reinstall_

GitBash provides a minimal POSIX bash environment with base core-utils. 

We need a custom install to enable symlinks and a proper TTY terminal.

*NOTE use Python for Windows with GitBash*

    see https://community.chocolatey.org/packages/git


###  Install GitBash 

```shell

   choco install -y git.install --force --params '/SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf /PseudoConsoleSupport'
```

###  Configure your Git login

```shell
    git config --global user.name   JohnDoe
    git config --global user.email  JohnDoe@email.com
```



##  3.  SSH and PGP Keys ([*] provided)


### Memorable Passphrase

Pick a [https://strongphrase.net/](https://strongphrase.net/ Memorable Passphrase)


###  Generate your SSH keys

If you don't have an SSH keypair already, generate one now.


```shell
    ssh-keygen -t rsa
```

###  Generate your GPG keyring


If you don't have an SSH keypair already, generate one now.

```shell
    gpg --gen-key
```

Use the following parameters:

```text
key kind:      1 (RSA)
key size:      4096
validity:      0 (never expires)
```



##  4.  Install Git-Pass

We will use the POSIX ``pass`` command (password-store) as a secrets vault.

I have ported this for a minimal corporate gitbash in the Git-Pass project.

    see [git-pass](https://github.com/korningf/git-pass/ git-pass)


###   Install Git-Pass (POSIX pass command)

```shell
    pushd /tmp/
    git clone https://github.com/korningf/git-pass
    cd git-pass
    ./install.sh
    popd
```


###   Configure Git-Pass

Create the password-store dir as a git repo.

```shell
    git init ~/.password-store
```

Initialize the password-store dir as a pass database.

```shell
    pass init JohnDoe@email.com
```


##  5.  Keepass  ([*] provided)

We Use Keepass for a local developer secure secret and password store.

I prefer the POSIX pass cmd (password-store), but keepass will do.


###  Install Keepass

```shell
    choco install keepass -y
```



##  6.  Stream Processors (JQ, YQ, XQ)  ([*] provided)

We will need stream processors to parse JSON, YAML, XML.

###  Install stream processors (JQ, YQ, XQ)


```shell
   # see https://community.chocolatey.org/packages/jq
   # see https://community.chocolatey.org/packages/yq

   choco install -y jq
   choco install -y yq
```



##  7.  Hashicorp Terraform  ([+] upgrade)

Hashicorp Terraform is the leading agnostic cloud infra provisioner.

###  Install Terraform (cloud cli)

```shell
   # see https://community.chocolatey.org/packages/terraform
  
   choco install -y terraform --pre
```



##  8.  Azure-cli  ([+] upgrade)

Azure-Cli is the Azure Cloud command-line.

###  Install Azure-cli (AZ cloud)

```shell
   # see https://community.chocolatey.org/packages/azure-cli

   choco install -y azure-cli
```



##  9.  AWS-cli  ([!] mandatory and missing !)

AWS-Cli is the Amazon AWS Cloud command-line.

###  Install AWS-cli (AWS cloud)

```shell
     # see https://community.chocolatey.org/packages/awscli
  
     choco install -y awscli
```





#  B. Integrators, Developers 


Cloud Integrators and Developers should also install the following:


##  10.  Docker Desktop  ([!] mandatory)

Docker-Desktop provides a local Docker runtime as well as the command-line cli.

The current DevEng standard runs Docker inside a WSL ubuntu VM on containerd.


###  Install docker on the WSL machine:

```shell
    choco install docker-desktop
```




##  11.  Kubernetes Minikube ([?] evaluate)

The default standard devpc dev tools script already install kubernetes-cli (aka kubetl).

Minikube-Cluster provides a local Kubernetes cluster as well as the command-line cli.

###  Install Minikube Cluster (kube-cli + runtime)

```shell
   # see https://community.chocolatey.org/packages/Minikube
  
   choco install -y minikube
```



##  12.  Kubernetes Helm ([!] default)

Kubernetes Helm (aka Navigator Charts) is a chart composer for Kube.

It simplifies and groups deployment of related services into charts.

###  Install Kubernetes Helm

```shell
   # see https://community.chocolatey.org/packages/kubernetes-helm
  
   choco install -y kubernetes-helm
```


##  13. Kubernetes Operations ([-] missing)

Kubernetes Operations (Kops) builds Kubernetes clusters from scratch.

This would be used to build a custom cluster from a raw compute cloud.

###  install Kubernetes Operations (kops)

```shell
   # see https://community.chocolatey.org/packages/kubernetes-kops
  
   choco install -y kubernetes-kops
```


##  14.  Azure AKS-CTL

Command-line cli to drive Managed Azure AKS Clusters.

*TODO check this*

###  Install AKS-ctl (aksctl)

```shell
   # see https://community.chocolatey.org/packages/aksctl
   # seew https://github.com/adfolks/aksctl

   choco install -y aksctl
```


##  15.  AWS EKS-CTL

Command-line cli to drive Managed Amazon EKS Clusters.

###  Install EKS-ctl (eksctl)

```shell
   # see https://community.chocolatey.org/packages/eksctl

   choco install -y eksctl
```


##  16.  AWS ECS-CTL

Command-line cli to drive Managed Amazon ECS Containers.

###  Install ECS-ctl (ecsctl)

*TODO check this - only a PIP package for now*

```shell
   # see https://ecsctl.readthedocs.io/en/latest/

   pip install git+https://github.com/witold-gren/ecsctl.git
```



##  17.  Azure ACI-CTL ?  ([?] investigate)

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




# Developers

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
   # see https://dotnet.microsoft.com/en-us/download/dotnet/9.0

   choco install -y dotnet-9.0-sdk
```

  
##  25.  ASP.NET core  ([?] _which version?_)

_TODO_ which .NET runtime version are we using?  8.0, 9.0, 10.0 ?

### install the ASP.NET core runtime

```shell
   # see https://community.chocolatey.org/packages/dotnet-9.0-aspnetruntime
   # see https://dotnet.microsoft.com/en-us/download/dotnet/9.0

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



# Extensions

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

    
