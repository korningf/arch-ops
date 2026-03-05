# bootstrap.ps1:  bind library dirs for terraform provider plugins and modules


# current context


# ensure symlinks in the gitbash shell
$env:MSYS="winsymlinks:nativestrict"



# local mirrors for terraform plugins, providers, and modules
#$env:APP_DATA=$(echo $env:APPDATA | sed -e 's/\\/\//g')
$env:TF_HOME="c:/work/terraform.d"
setx TF_HOME "c:/work/terraform.d" 

# local provider plugins and modules cache
$env:TF_PLUGIN_CACHE_DIR="$env:TF_HOME/plugin-cache"
$env:TF_PLUGIN_LOCAL_DIR="$env:TF_HOME/plugins"
$env:TF_MODULE_LOCAL_DIR="$env:TF_HOME/modules"
setx TF_PLUGIN_CACHE_DIR "$env:TF_HOME/plugin-cache"
setx TF_PLUGIN_LOCAL_DIR "$env:TF_HOME/plugins"
setx TF_MODULE_LOCAL_DIR "$env:TF_HOME/modules"


# determine git repo git_root and relative sub_path from root/data/ 
$git_root=$(git rev-parse --show-toplevel | sed -e 's/.://')
$git_path=$(realpath . | sed -e 's/\\/[a-z]\\//\\//g')
$sub_path=$(echo $git_path | sed -e 's/.*\\/data\\//\\//g')


# helper functions



# test if file is a link
Function IsLink ($Path) {
    if (-not $Path) {return}
    ((Get-Item -Path $Path).Attributes.ToString() -match "ReparsePoint")
}

# test if file exists
Function IsFile ($Path) {
    if (-not $Path) {return}
    (Test-Path -Path $Path -PathType Leaf)
}

# test if directory exists
Function IsDir ($Path) {
    if (-not $Path) {return}
    (Test-Path -Path $Path -PathType Container)
}




# main script


pushd $git_root *> $null


# create windows share for terraform.d
if (-not (IsDir  -Path $env:TF_HOME ))                     { mkdir -p   $env:TF_HOME }
#net use T: '\\LOCALHOST\c$\work\terraform.d' /persistent:yes


# create lib dirs for plugins and modules
if (-not (IsDir  -Path $env:TF_PLUGIN_CACHE_DIR ))          { mkdir -p   $env:TF_PLUGIN_CACHE_DIR }
if (-not (IsDir  -Path $env:TF_PLUGIN_LOCAL_DIR ))          { mkdir -s   $env:TF_PLUGIN_LOCAL_DIR }
if (-not (IsDir  -Path $env:TF_MODULE_LOCAL_DIR ))          { mkdir -p   $env:TF_MODULE_LOCAL_DIR }


# create symlinks to local plugins and modules
if (-not (IsLink -Path .plugins ))                          { ln -s   $env:TF_PLUGIN_LOCAL_DIR          .plugins }
if (-not (IsLink -Path .modules ))                          { ln -s   $env:TF_MODULE_LOCAL_DIR          .modules }


popd *> $null


