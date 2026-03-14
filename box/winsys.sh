
# First install Chocolatey



```shell
Set-ExecutionPolicy Bypass -Scope Process -Force
winget install -e --id=Chocolatey.Chocolatey    
```


 
```shell

# Microsoft sysinternals

mkdir -p c:/syswin/bin
choco install -y --force sysinternals --params "/InstallDir:c:/syswin/bin"
setx SYSWIN "c:/syswin"


# Microsoft WSL - Windows Service for Linux

choco install -y --force wsl2


# Microsoft Powershell-core
choco install -y --force --pre powershell
choco install -y --force --pre powershell-core



# Cygwin POSIX (complete GNU POSIX environment emulator and toolchain)
mkdir -p c:/cygwin/bin
choco install -y --force --pre cygwin  --params="/InstallDir:c:/cygwin /SymlinkType:native"
setx CYGWIN "c:/cygwin  winsymlinks:native"


# GitBash POSIX emulator (MSYS2 variant, itself derived from cygwin)
mkdir -p c:/gitwin/bin
choco install -y git.install --force --params '/InstallDir:c:/gitwin /SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /PseudoConsoleSupport'
setx MSYS "c:/gitwin  winsymlinks:native"






# Oracle VirtualBox hypervisor

choco install -y --force --pre virtualbox

choco install -y --force --pre virtualbox-guest-additions-guest.install

# as of 7.2.6 oracle moved most of the extensions into the main virtualbox package
# the extensions are now mainly oracle-cloud integration and use a separate licene,
# consequently the choco install is broken and these have to be installed by hand.

#choco install -y --force --pre virtualbox-extensions


# Puppet, jq, yq (and xq)

choco install -y --force puppet
choco install -y --force jq
choco install -y --force yq


# Hashicorp Vagrant 
choco install -y --force --pre vagrant

# Hashicorp Packer
choco install -y --force --pre packer

# Hashicorp Terraform
choco install -y --force --pre terraform



```
