# clean.ps1:  clean and prepare for build


# current context


# ensure symlinks in the gitbash shell
$env:MSYS="winsymlinks:nativestrict"


# local mirrors for terraform plugins, providers, and modules
$env:APP_DATA=$(echo $env:APPDATA | sed -e 's/\\/\//g')

# local provider plugins and modules cache
$env:TF_PLUGIN_CACHE_DIR="$env:APP_DATA/terraform.d/plugin-cache"
$env:TF_PLUGIN_LOCAL_DIR="$env:APP_DATA/terraform.d/plugins"
$env:TF_MODULE_LOCAL_DIR="$env:APP_DATA/terraform.d/modules"

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


# delete one symlink
Function deleteLink ($Path) {
    if (-not $Path) {return}
    if (IsLink -Path $Path)     { unlink  $Path *> $null }
}


# delete all symlinks
function DeleteDataLinks () {
    pushd data *> $null

    Get-Content ..\.symlinks | ForEach-Object {
        $path = $_.Trim()
        #echo "unlink: $path"
        deleteLink -Path "$path"
    }

    popd *> $null
}

# main script



pushd $git_root *> $null


# find data symlinks

.\bin\find.exe data/ -type l -print | grep -v .terraform | sed -e 's/^data\///g' > .symlinks
echo "deleting symlinks:"
cat .symlinks
echo " "


# remove data symlinks

DeleteDataLinks


# remove temp files

#rm -f .symlinks
#rm -f .taxonomy


popd *> $null