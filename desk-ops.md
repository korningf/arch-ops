

# Desk-Ops



# Site Firewall Whitelist

Add the following sites to your etxrenal firewall whitelist.

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
  


# Dev Tools

☒  approved  [+]
☐  evaluate  [?]


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
The process of containerisation often includes cross-compilation.
We need an environment that is powerful enough to cross-compile.
That's what POSIX was designed for (TODO: gcc / glibc toolchain ?)

.

CloudOps and DevOps tools also require many interpreted languages.
Tools like Vagrant, Docker, Puppet, Kubernetes, Terraform, AWS-cli
require tools like perl, python, ruby, go, php, and a POSIX shell.

.

On Windows the only real full POSIX native environment is Cygwin.
Everything else derives from it. SysGit and Msys derive from it.
GitBash derives in turn from MSys.  Only cygwin has a full stack.

. 

Failing this we can manage with GitBash, but it is incomplete.

_Update: We shall have to make do with GitBash_

.

Gitbash, Python, PyEnv, and the Pip package manager are temperamental.
For it to work properly, PIP needs to use Windows auth TLS/SSL certs.

The Python needs to mirror the Git setup for user-space vs all-users,
so if Git is installed for machine-scope all-users, so should Python,
or vice-versa.




# Integrators


Cloud-Ops and Dev-Ops Systems Integrators should install the following.



##  0.  Chocolatey ([!] mandatory)

* install Chocolatey


We use a custom private chocoserver instead of the public one.

a custom powershell PS1 script sets up the choco environment.

* (skip this) _the usual way with the public chocolatey.org url_

```shell
  # see https://docs.chocolatey.org/en-us/choco/setup/

  winget install --id=Chocolatey.Chocolatey
```

* (use this) _our custom install with a private chocoserver script_

Open a new elevated powershell (run as administrator):

```shell
Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocoserver:8443/repository/bootstrap/ChocolateyInstall.ps1'))
```

Now this only does a one-time install of a  local Chocolatey 2.4.3.

Crucially we want a bootstrap to point to the private chocoserver.

And we also want to upgrade our local client to choco 2.5.1.

* run the bootstrap _(ignoring warnings)_
  
```shell
Set-ExecutionPolicy Bypass -Scope Process -Force

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocoserver:8443/repository/bootstrap/OnPremSetup.ps1'))
```

The policy defaults to the internal chocoserver for bandwidth and latency.

We need to set up our default shell environment and add devpc extensions.

* close the powershell and open another one.

```shell
  choco install standard_dsp_powershell_execpolicyunrestricted -y

  choco install standard_dsp_devpc_windowsconfig -y
  choco install standard_dsp_devpc_windowsfeatures -y
```

* Restart (reboot) the DevPC and open a new admin powershell.

```shell
  Restart-Computer -Force
```

A few licensed packages may live on the offical sources (python, aws-cli).

* (optional) temporarily activate licensed chocolatey sources.

In the shell, enable the repo sources.

```shell
  choco source enable -n chocolatey
  choco source enable -n chocolatey.licensed
```
  

## 1.  DevPC Tools ([!] mandatory)

DevTools install additional developer tools (most are ports of POSIX tools).

In addition it installs WSL (Windows Subsystem for Linux - aka Winterix) VMs.


* Install root certs to enable NT auth in TLS/SSL.

```shell
  choco install standard_dsp_root_ca -y
  choco install standard_dsp_pip_cert -y
```

* Install
  
We use a local Nexus Repository as a supply-chain proxy for common dev package managers.

This includes repos for java maven, NuGet .NET, Python pip, NodeJS npm, Docker hub, etc.

```shell
choco install standard_3rdparty_nuget_packageprovider
choco install ci_dsp_feeds -y
```


* Install Developer Tools

```shell
  choco install standard_dsp_devpc_tools -y
  choco install standard_dsp_devpc_sqltools -y
```

* Best to Restart the system, and re-open an admin shell.

```shell
  Restart-Computer -Force
```


##  2.  Windows SysInternals ([!] mandatory)

SysInternals are standard MSDN Developer utils from Miscrosoft.

* install SysInternals

```shell
  choco install -y sysinternals --ignore-checksum --force
```



##  3.  GitBash POSIX ([!] mandatory)

GitBash provides a minimal POSIX bash environment with base core-utils. 

*NOTE use Python for Windows with GitBash*

* install GitBash

```shell
   # see https://community.chocolatey.org/packages/git

   #choco install standard_dsp_enable_rsat -y
   #choco install standard_dsp_enable_windowsupdate -y

   choco install -y git.install --force --params '/SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf /PseudoConsoleSupport'
```

* Customise Gitbash

We use a custom .profile script for the GitBash POSIX environment.

Install the script, entering the GitBash root  ('C:\Program Files\Git')

```shell
    choco install standard_dsp_powershell_profile -y
```

* Edit your profile as needed.

 

* Configure Git

When prompted, enter your email address (eg joe.bloggs@welfare.ie).

```shell
    choco install standard_dsp_git_config
```
Verify that the Git global email and username are properly configured:

```shell
    git config --global user.name 
    git config --global user.email
```



## 4.  Python ([*] provided)

Python is required for Cloud-Ops and Dev-Ops tools (aws-cli, azure-cli ...)

*NOTE use Python for Windows with GitBash*

```shell
   # see https://github.com/korningf/cso-git#Python

   choco install -y python --force
```



##  5.  Keepass ([*] provided)

We Use Keepass for a local developer secure secret and password store.

I prefer the POSIX pass cmd (password-store), but keepass will do.


```shell
  	choco install keepass -y
```



##  6.  stream processors (JSON, YAML, XML) ([*] provided)

We will need these stream processors to parse JSON, YAML, XML.

* install stream processors (JQ, YQ, XQ)

```shell
   # see https://community.chocolatey.org/packages/jq
   # see https://community.chocolatey.org/packages/yq

   choco install -y jq
   choco install -y yq
```



##  7.  Vault Secrets-Manager ([-] missing)

Hashicorp Vault is the leading agnostic cloud secrets manager.

* install Vault (vault cli)

```shell
   # see https://community.chocolatey.org/packages/vault

   choco install -y vault
```



##  8.  Packer Packager-Provisioner ([-] missing)

Hashicorp Packer is the leading agnostic cloud image packager.

* install Packer (packer cli)

```shell
   # see https://community.chocolatey.org/packages/packer

   choco install -y packer
```



##  9.  Terraform Cloud-Former ([*] provided)

Hashicorp Terraform is the leading agnostic cloud infra provisioner.

* install Terraform (cloud cli)

```shell
   # see https://community.chocolatey.org/packages/terraform
  
   choco install -y terraform --pre
```


##  10.  Docker Desktop

Docker-Desktop provides a local Docker runtime as well as the command-line cli.

* install Docker Desktop (docker-cli + runtime)

```shell
  # see https://community.chocolatey.org/packages/docker-desktop
  
  choco install -y docker-desktop
```


##  11.  Kubernetes Cluster ([?] evaluate)

The default standard devpc dev tools script already install kubernetes-cli (aka kubetl).

Minikube-Cluster provides a local Kubernetes cluster as well as the command-line cli.

* install Minikube Cluster (kube-cli + runtime)

```shell
   # see https://community.chocolatey.org/packages/Minikube
  
   choco install -y minikube
```


##  12.  Kubernetes Helm ([!] default)

Kubernetes Helm (aka Navigator Charts) is a chart composer for Kube.

It simplifies and groups deployment of related services into charts.

* install Kubernetes Helm

```shell
   # see https://community.chocolatey.org/packages/kubernetes-helm
  
   choco install -y kubernetes-helm
```


##  13. Kubernetes Operations ([-] missing)

Kubernetes Operations (Kops) builds Kubernetes clusters from scratch.

This would be used to build a custom cluster from a raw compute cloud.

* install Kubernetes Operations (kops)

```shell
   # see https://community.chocolatey.org/packages/kubernetes-kops
  
   choco install -y kubernetes-kops
```


##  14.  Azure-cli ([+] provided)

Azure-Cli is the Azure Cloud command-line.

* install Azure-cli (AZ cloud)

```shell
   # see https://community.chocolatey.org/packages/azure-cli

   choco install -y azure-cli
```


##  15.  AWS-cli

AWS-Cli is the Amazon AWS Cloud command-line.

* install AWS-cli (AWS cloud)

```shell
     # see https://community.chocolatey.org/packages/awscli
  
     choco install -y awscli
```



##  16.  Azure AKS-CTL

Command-line cli to drive Managed Azure AKS Clusters.

*TODO check this*

* install AKS-ctl (aksctl)

```shell
   # see https://community.chocolatey.org/packages/aksctl
   # seew https://github.com/adfolks/aksctl

   choco install -y aksctl
```


##  17.  AWS EKS-CTL

Command-line cli to drive Managed Amazon EKS Clusters.

* install EKS-ctl (eksctl)

```shell
   # see https://community.chocolatey.org/packages/eksctl

   choco install -y eksctl
```


##  18.  AWS ECS-CTL

Command-line cli to drive Managed Amazon ECS Containers.

* install ECS-ctl (ecsctl)

*TODO check this - only a PIP package for now*

```shell
   # see https://ecsctl.readthedocs.io/en/latest/

   pip install git+https://github.com/witold-gren/ecsctl.git
```


##  19.  Azure ACI-CTL ?

*TODO is there an equivalent for Azure ACI/ACA containers ?*



# Developers

In addition Developers and Build-Masters should also install the following.



##  20.  Vagrant

Hashicorp Vagrant is the leading agnostic development machine provisioner.

```shell
   # see https://community.chocolatey.org/packages/vagrant

   choco install -y vagrant
```



##  21.  Dot.NET SDK

_TODO_ which .NET runtime version are we using?  8.0, 9.0, 10.0 ?

* install the .NET core SDK

```shell
   # see https://community.chocolatey.org/packages/dotnet-9.0-sdk

   choco install -y dotnet-9.0-sdk
```

  
##  22.  ASP.NET core

* install the ASP.NET core runtime

```shell
   # see https://community.chocolatey.org/packages/dotnet-9.0-aspnetruntime

   choco install -y dotnet-9.0-aspnetruntime
```


##  23.  VisualStudio Code

* install VSCode via winget 

```shell
   # see https://community.chocolatey.org/packages/vscode

   choco install -y vscode
```


##  24.  Java OpenJDK

We will need Java to run Jenkins CI, Sonar, and a host of other systems.

* install OpenJDK

```shell
   # see https://community.chocolatey.org/packages/openjdk

   choco install -y openjdk
```


##  25.  Apache Maven

Maven is the build toolchain for Java.

* install Maven

```shell
   # see https://community.chocolatey.org/packages/maven

   choco install -y maven
```


##  26.  Eclipse IDE

Eclipse is the IDE for Java.

* install Eclipse IDE

```shell
   # see https://community.chocolatey.org/packages/eclipse-java-oxygen
  
   choco install -y eclipse-java-oxygen
```


##  27.  GnuWin64 or MinGW

_TODO optional_

I usually use Cygwin64 to cross-compile from native Windows to POSIX Linux and back.

GnuWin64 or MinGW are POSIX GNU GCC/GLIBC C/C++ toolchains (GnuWin64 is preferred).

It include gcc, g++, glibc lib, binutils, GNU Autotools (automake, configure).

It's not clear yet if we have to cross-compile anything to/from POSIX and GLibc.

Investigate whether we need a complete cross-compilation toolchain for the future.

_TODO optional_


##  28.  Ruby ([?] evaluate)

Ruby is required for Cloud-Ops and Dev-Ops tools (vagrant, puppet ...)

```shell
   # see https://community.chocolatey.org/packages/ruby

   choco install -y ruby
```



##  29.  Go  ([?] evaluate)

Go-Lang is required for Cloud-Ops and Dev-Ops tools (docker, kubernetes ...)

```shell
   # see https://community.chocolatey.org/packages/golang

   choco install -y golang
```



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

    
