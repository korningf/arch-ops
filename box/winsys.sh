# WinSys - Windows multi-POSIX system

# GNU POSIX is much more than a set of unix-like utilities, 
# it's an operating system kernal and library module layout, 
# a gcc/glibc compilation toolchain and system library spec,
# an os filesystem, stream, signal and shell specification,
# and finally a set of network and system command utilities.

# All Windows POSIX emulators are all derived from Cygwin,
# and all use a chroot mapping a virtual root filesystem.

# Typically, though low-level gnu-posix binaries work great,
# porting more complex systems often break only due to paths,
# specifically mapping paths like `/usr/bin` or `/var/tmp`.

# WinSys aims to make Windows behave like a real GNU POSIX.
# WinSys also supports Cygwin and GitBash (Msys) in tandem.

# WinSys has 1 core idea: to maintain POSIX symbolic links,
# either as NTFS Junctions or Windows MKLINK native symlinks,
# in order to make both Cygwin and GitBash into a REAL POSIX.

# A 2nd core idea of Winsys is we use Cygwin as a toolchain.
# Anything that requires native compilation will use Cygwin,
# as its gcc glibc can cross-compile for both MSys and MingW.

# As cygwin requires expert knowledge, we also use Gitbash.
# Gitbash, coupled with a real package manager, works great
# for most purposes.

# Cygwin uses its own package management, apt-cyg or cyg-get.
# We have ported the Msys pacman package manager fot Gitbash.
# And finally, we use Chocolatey as sWindows package manager.

# - choco   - packages for windows, gitbash, and cygwin
# - pacman  - packages for gitbash only
# - cyg-get - packages for cygwin (or apt-cyg)



# First install Chocolatey


# Note: Chocolatey uses Window-style option switches and paths,
# Use the backslash '\' file separator for '/InstallDir' paths.


#```shell
# this fails: 
#   choco install ...  --params '/InstallDir:c:/syswin/bin'

# this works:
#  choco install ...  --params '/InstallDir:c:\syswin\bin'
#```



#```shell
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   winget install -e --id=Chocolatey.Chocolatey    
#```




 
#```shell

# Microsoft sysinternals

mkdir -p c:/syswin/bin
choco install -y --force sysinternals --params '/InstallDir:c:\syswin\bin'
setx SYSWIN "c:/syswin"


# Microsoft WSL - Windows Service for Linux

choco install -y --force wsl2


# Microsoft Powershell-core
choco install -y --force --pre powershell
choco install -y --force --pre powershell-core



# Cygwin POSIX (complete GNU POSIX environment emulator and toolchain)
mkdir -p c:/cygwin/bin
choco install -y --force --pre cygwin  --params='/InstallDir:c:\cygwin /SymlinkType:native' 
setx CYGWIN "c:/cygwin  winsymlinks:native"


# GitBash POSIX emulator (MSYS2 variant, itself derived from cygwin)
mkdir -p c:/gitwin/bin
choco install -y git.install --force --params '/InstallDir:c:\gitwin /SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /PseudoConsoleSupport'
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



#```
