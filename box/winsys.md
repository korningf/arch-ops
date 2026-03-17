# Installation

A working Winsys installation requires Windows WSL, Powershell, Sysinternals, WinGet and Chocolatey.

We use Chocolatey as the main package manager (it will use winget, msiexec, or even cygwin underneath).

We then integrate multiple POSIX environments and File systems, notably Cygwin and GitBash (Msys variant).

* baseline tools
  
```shell
    choco install -y wsl2
    choco install -y sysinternals
    choco install -y powershell
    choco install -y powershell-core --pre
```

* cloud tools
  
```shell
    choco install -y azure-cli
    choco install -y awscli
    choco install -y yq
    choco install -y jq
    choco install -y terraform --pre
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
  
* Install Gitbash with SChannel and Symlinks

```shell
   choco install -y git.install --force --params '/SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /PseudoConsoleSupport'
```

* Configure Gitbash (the shell part) for Symlinks

bash:

```bash
   export MSYS="winsymlinks:nativestrict"
   setx   MSYS "winsymlinks:nativestrict"
```

pwsh:

```pwsh
   $env:MSYS="winsymlinks:nativestrict"
   setx MSYS "winsymlinks:nativestrict"
````

* Configure Git (the SCM part) to sue Symlinks

```shell
   git config --global core.symlinks true
```

* Configure VSCode for Symlinks

```text
    File -> Preferences -> Settings
    
    Search for "symlinks" - enable checkboxes
```


    File -> Preferences -> Settings
    
    Search for "symlinks" - enable checkboxes
