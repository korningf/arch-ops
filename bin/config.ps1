# config.ps1:  configure paths, parse taxonomy, and propagate variables


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



# TODO: hack: for now do we this the long iterative way. 
# we will probably want a fancy recursive function here?


# create one symlink
function createLink ($Path) {
    $Link = $(basename $Path)
    if (-not (Test-Path -Path $Link -PathType Leaf ) )  {  ln -s $Path  ./  }
}


# create symlink to git repo root directory
function RootLinks ($Path) {

    pushd $Path *> $null

    # link. root
    if (-not (Test-Path -Path .root -PathType Container) )  {  ln -s $git_root  .root  }

    popd *> $null
}

# create symlinks to inherit parent auto.tfvars
function VariableLinks ($Path) {

    pushd $Path *> $null

    # link. root
    if (-not (Test-Path -Path .root -PathType Container) )  {  ln -s $git_root  .root  }

    # all *_.auto.tfvars from parent dir
    #foreach ($file in $( ls.exe -1q ../_*.auto.tfvars 2>$null ) ) {
    #    echo "link: $Path $file"
    #    #createLink -Path $file
    #}
    createLink -Path ../_deployment.auto.tfvars
    createLink -Path ../_deployment.vars.tf
    createLink -Path ../../_component.auto.tfvars
    createLink -Path ../../_component.vars.tf
    createLink -Path ../../../_backbone.auto.tfvars
    createLink -Path ../../../_backbone.vars.tf
    createLink -Path ../../../../_architecture.auto.tfvars
    createLink -Path ../../../../_architecture.vars.tf
    createLink -Path ../../../../../_universal.auto.tfvars
    createLink -Path ../../../../../_universal.vars.tf

    popd *> $null
}


# traverse the taxonomy and create parent links.
# assumes the taxonomy is populated and is sorted.
function DataLinks () {
    pushd data *> $null

    Get-Content ../.taxonomy | ForEach-Object {
        # Skip empty lines or comments
        #if (-not $_ -or $_ -eq '' -or $_ -match '^\\s*#') { return }
        $dir = $_.Trim()
        #echo "taxon: $dir"
        RootLinks -Path $dir
    }
    

    Get-Content ../.runtimes | ForEach-Object {
        # Skip empty lines or comments
        #if (-not $_ -or $_ -eq '' -or $_ -match '^\\s*#') { return }
        $dir = $_.Trim()
        #echo "runtime: $dir"
        VariableLinks -Path $dir
    }
    
    popd *> $null
}



# main script


pushd $git_root *> $null


# build data taxonomy (always sort traversal)
.\bin\find.exe data/ -type d -print | grep -v .terraform | grep -v .root | sed -e 's/^data\///g' | sort > .taxonomy
echo "scanned taxonomy:"
cat .taxonomy
echo " "


# build data runtimes (execution environments)
.\bin\find.exe data/ -mindepth 5 -maxdepth 5 -type d -print | grep -v .terraform | grep -v .root | sed -e 's/^data\///g' | sort > .runtimes
echo "scanned runtimes:"
cat .runtimes
echo " "


# traverse the taxonomy and link parent variables
DataLinks


# find data symlinks (no need to sort links)
.\bin\find.exe data/ -type l -name _*.auto.tfvars -print | grep -v .terraform | sed -e 's/^data\///g' | sort > .symlinks
echo "created symlinks:"
cat .symlinks
echo " "


popd *> $null