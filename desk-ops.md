

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

.

_Update: We shall have to make do with GitBash_

.

Gitbash, Python, PyEnv, and the Pip package manager are temperamental.
For it to work properly, PIP needs to use Windows auth TLS/SSL certs.

The Python needs to mirror the Git setup for user-space vs all-users,
so if Git is installed for machine-scope all-users, so should Python,
or vice-versa.



##  0.  Chocolatey

* install Chocolatey
  
```shell
  # see https://docs.chocolatey.org/en-us/choco/setup/

  winget install --id=Chocolatey.Chocolatey
```


##  1.  Windows SysInternals

SysInternals are standard MSDN Developer utils from Miscrosoft.

* install SysInternals

```shell
  choco install -y sysinternals --ignore-cheksum --force
```



##  2.  GitBash POSIX

GitBash provides a minimal POSIX bash environment with base core-utils. 

*NOTE use Python for Windows with GitBash*

* install GitBash

```shell
   # see https://community.chocolatey.org/packages/git

   choco install -y git.install --force --params '/SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /NoAutoCrlf /PseudoConsoleSupport'
```


##  3.  Python

Python is absolutely necessary for aws-cli, Cloud-Ops and Dev-Ops.

*NOTE use Python for Windows with GitBash*


```shell
   # see https://github.com/korningf/cso-git#Python

   choco install -y python --version 3.13.7 --force
```




##  4.  Dot.NET SDK

_TODO_ which .NET runtime version are we using?  8.0, 9.0, 10.0 ?

* install the .NET core SDK

```shell
   # see https://community.chocolatey.org/packages/dotnet-9.0-sdk

   choco install -y dotnet-9.0-sdk
```

  
##  5.  ASP.NET core

* install the ASP.NET core runtime

```shell
   # see https://community.chocolatey.org/packages/dotnet-9.0-aspnetruntime

   choco install -y dotnet-9.0-aspnetruntime
```


##  6.  VisualStudio Code

* install VSCode via winget 

```shell
   # see https://community.chocolatey.org/packages/vscode

   choco install -y vscode
```


##  7.  Java OpenJDK

We will need Java to run Jenkins CI, Sonar, and a host of other systems.

* install OpenJDK

```shell
   # see https://community.chocolatey.org/packages/openjdk

   choco install -y openjdk
```


##  8.  Apache Maven

Maven is the build toolchain for Java.

* install Maven

```shell
   # see https://community.chocolatey.org/packages/maven

   choco install -y maven
```


##  9.  Eclipse IDE

Eclipse is the IDE for Java.

* install Eclipse IDE

```shell
   # see https://community.chocolatey.org/packages/eclipse-java-oxygen
  
   choco install -y eclipse-java-oxygen
```


##  10.  stream processors (JSON, YAML, XML)

We will need these stream processors to parse JSON, YAML, XML.


* install stream processors (JQ, YQ, XQ)

```shell
   # see https://community.chocolatey.org/packages/jq
   # see https://community.chocolatey.org/packages/yq

   choco install -y jq
   choco install -y yq
```


##  11.  Azure-cli

Azure-Cli is the Azure Cloud command-line.

* install Azure-cli (AZ cloud)

```shell
   # see https://community.chocolatey.org/packages/azure-cli

   choco install -y azure-cli
```


##  12.  AWS-cli

AWS-Cli is the Amazon AWS Cloud command-line.

* install AWS-cli (AWS cloud)

```shell
     # see https://community.chocolatey.org/packages/awscli
  
     choco install -y awscli
```


##  13.  Terraform Cloud-Former

Terraform is the leading cloud-neutral IaC cloud-provisioning command-line cli.

* install Terraform (cloud cli)

```shell
   # see https://community.chocolatey.org/packages/terraform
  
   choco install -y terraform --pre
```


##  14.  Docker Desktop

Docker-Desktop provides a local Docker runtime as well as the command-line cli.

* install Docker Desktop (docker-cli + runtime)

```shell
  # see https://community.chocolatey.org/packages/docker-desktop
  
  choco install -y docker-desktop
```


##  15.  Kubernetes Cluster

Minikube-Cluster provides a local Kubernetes cluster as well as the command-line cli.

* install Minikube Cluster (kube-cli + runtime)

```shell
   # see https://community.chocolatey.org/packages/Minikube
  
   choco install -y minikube
```


##  16.  Kubernetes Helm

Kubernetes Helm (aka Navigator Charts) is like Composer for Kube.

It simplifies the process of deploying pods of related services.

* install Kubernetes Helm

```shell
   # see https://community.chocolatey.org/packages/kubernetes-helm
  
   choco install -y kubernetes-helm
```


##  17.  Kubernetes Operations

Kubernetes Operations (Kops) builds Kubernetes clusters from scratch.

This would be used to build a custom cluster from a raw compute cloud.

* install Kubernetes Operations (kops)

```shell
   # see https://community.chocolatey.org/packages/kubernetes-kops
  
   choco install -y kubernetes-kops
```


##  18.  Azure AKS-CTL

Command-line cli to drive Managed Azure AKS Clusters.

*TODO check this*

* install AKS-ctl (aksctl)

```shell
   # see https://community.chocolatey.org/packages/aksctl
   # seew https://github.com/adfolks/aksctl

   choco install -y aksctl
```


##  19.  AWS EKS-CTL

Command-line cli to drive Managed Amazon EKS Clusters.

* install EKS-ctl (eksctl)

```shell
   # see https://community.chocolatey.org/packages/eksctl

   choco install -y eksctl
```


##  20.  AWS ECS-CTL

Command-line cli to drive Managed Amazon ECS Containers.

* install ECS-ctl (ecsctl)

*TODO check this - only a PIP package for now*

```shell
   # see https://ecsctl.readthedocs.io/en/latest/

   pip install git+https://github.com/witold-gren/ecsctl.git
```


##  21.  Azure ACI-CTL ?

*TODO is there an equivalent for Azure ACI/ACA containers ?*






# Appendix

## Choco and Winget parameters

Both Choco and Winget packages may have configurable parameters.

But they can also make use of msiexec .msi parameters underneath.


    # see https://docs.chocolatey.org/en-us/licensed-extension/release-notes/#improvements-25

    # see https://jrsoftware.org/ishelp/index.php?topic=setupcmdline

    
