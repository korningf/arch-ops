# config.sh:  configure paths, parse taxonomy, and propagate variables


# current context


# ensure symlinks in the gitbash shell
export MSYS="winsymlinks:nativestrict"


# local mirrors for terraform plugins, providers, and modules
export APP_DATA=`echo $APPDATA | sed -e 's/\//\//g'`

# local provider plugins and modules cache
export TF_PLUGIN_CACHE_DIR="$APP_DATA/terraform.d/plugin-cache"
export TF_PLUGIN_LOCAL_DIR="$APP_DATA/terraform.d/plugins"
export TF_MODULE_LOCAL_DIR="$APP_DATA/terraform.d/modules"


# determine git repo git_root and relative sub_path from root/data/ 
git_root=`git rev-parse --show-toplevel | sed -e 's/.://'`
dir_path=`realpath . | sed -e 's/\/[a-z]\//\//g'`
sub_path=`echo $dir_path | sed -e 's/.*\/data\//\//g'`



# helper functions


# TODO: hack: for now do we this the long iterative way. 
# we will probably want a fancy recursive function here?


# create one symlink
function createLink () {
    path=$1
    link=`basename $path`
    [ ! -L $link ]     &&      ln -s $path   ./
}


# create symlink to git repo root directory
function rootLinks () {
    path=$1

    pushd $path > /dev/null 2>&1

    # link. root
    [ ! -L .root ]     &&      ln -s $git_root   .root

    popd > /dev/null 2>&1
}


# create symlinks to inherit parent auto.tfvars
function variableLinks () {
    path=$1

    pushd $path > /dev/null 2>&1

    # link. root
    [ ! -L .root ]     &&      ln -s $git_root   .root

    # all *_.auto.tfvars from parent dir
    #for file in `\ls -1q ../_*.auto.tfvars 2>/dev/null`; do 
    #    #echo "link: $path $file"
    #    createLink $file
    #done
    createLink ../_deployment.auto.tfvars
    createLink ../_deployment.vars.tf
    createLink ../../_component.auto.tfvars
    createLink ../../_component.vars.tf
    createLink ../../../_backbone.auto.tfvars
    createLink ../../../_backbone.vars.tf
    createLink ../../../../_architecture.auto.tfvars
    createLink ../../../../_architecture.vars.tf
    createLink ../../../../../_universal.auto.tfvars
    createLink ../../../../../_universal.vars.tf


    popd > /dev/null 2>&1
}

# traverse the taxonomy and create parent links.
# assumes the taxonomy is populated and is sorted.
function dataLinks () {
    pushd data > /dev/null 2>&1

    #for dir in `cat ../.taxonomy`; do 
    #    #echo "taxon: $dir"
    #    rootLinks $dir
    #done

    for dir in `cat ../.runtimes`; do 
        #echo "runtime: $dir"
        rootLinks $dir
        variableLinks $dir
    done

    popd > /dev/null 2>&1
}




# main script


pushd $git_root > /dev/null 2>&1


# build data taxonomy (always sort traversal)
find data/ -type d -print | grep -v .terraform | grep -v .root | sed -e 's/^data\///g'| sort > .taxonomy
echo "scanned taxonomy:"
cat .taxonomy
echo " "

# build data runtimes (execution environments)
find data/ -mindepth 5 -maxdepth 5 -type d -print | grep -v .terraform | grep -v .root | sed -e 's/^data\///g'| sort > .runtimes
echo "scanned runtimes:"
cat .runtimes
echo " "


# traverse the taxonomy and link parent variables
dataLinks


# find data symlinks (no need to sort links)
find data/ -type l -name _\*.auto.tfvars -print | grep -v .terraform | sed -e 's/^data\///g' | sort > .symlinks
echo "created symlinks:"
cat .symlinks
echo " "


popd > /dev/null 2>&1