# Installation

A working Winsys installation requires Windows WSL, Powershell, Sysinternals, WinGet and Chocolatey.

We use Chocolatey as the main package manager (it will use winget, msiexec, or even cygwin underneath).

We then integrate multiple POSIX environments and File systems, notably Cygwin and GitBash (Msys variant).

* baseline tools
  
```shell
    choco install -y wsl2
    choco install -y powershell
    choco install -y powershell-core --pre
```

* Windows SysInternals

```shell
   mkdir -p c:/sygwin/bin
   choco install -y sysinternals  --params '/InstallDir:c:\syswin\bin'
   setx SYSWIN "c:/syswin"
```


* Cygwin POSIX

```shell
   mkdir -p c:/cygwin/bin
   choco install -y --force --pre cygwin  --params='/InstallDir:c:\cygwin /SymlinkType:native /LocalPackageDir:c:\users\public\downloads' 
   setx CYGWIN "c:/cygwin  winsymlinks:native"
```


  
* Gitbash POSIX

```shell
   mkdir -p c:/gitwin/bin
   choco install -y git.install --force --params '/InstallDir:c:\gitwin /SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /PseudoConsoleSupport'
   setx MSYS "c:/gitwin  winsymlinks:native"
```


* Configuration

  
* Configure Git (the SCM part) to use Symlinks

```shell
   git config --global core.symlinks true
```

* Configure VSCode for Symlinks

```text
    File -> Preferences -> Settings
    
    Search for "symlinks" - enable checkboxes
```




* Development

* dev ops
  
```shell
    choco install -y virtualbox
    #choco install -y virtualbox-extensions
    choco install -y virtualbox-guest-additions-guest.install

    choco install -y --force vagrant
    choco install -y --force packer
    choco install -y --force puppet
```


* kube ops

```shell
    #choco install -y docker-cli
    choco install -y docker-desktop
    choco install -y docker-compose

    #choco install -y kubernetes-cli
    choco install -y kubernetes-helm
    choco install -y minikube    
```
  

* cloud ops
  
```shell
    choco install -y virtualbox
    #choco install -y virtualbox-extensions
    choco install -y virtualbox-guest-additions-guest.install

    choco install -y consul
    choco install -y --pre terraform
```


* cloud providers
  
```shell
    choco install -y gcloudsdk
    choco install -y azure-cli
    choco install -y awscli
```

* dotnet devel
 
  
```shell
    choco install -y dotnetcore
    choco install -y --force dotnet-8.0-aspnetruntime
    #choco install -y --force dotnet-8.0-desktopruntime

    choco install -y 'Microsoft.NETCore.App'

    choco install -y --force azure-pipelines-agent
    choco install -y --force azure-functions-core-tools

    choco install -y vscode
```

* java devel
  
```shell
    choco install -y openjdk
    choco install -y maven

    choco install -y eclipse
```

