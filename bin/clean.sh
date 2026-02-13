# clean.sh:  clean and prepare for build


# current context


# ensure symlinks in the gitbash shell
export MSYS="winsymlinks:nativestrict"


# local mirrors for terraform plugins, providers, and modules
export APP_DATA=`echo $APPDATA | tr '\\\' '/'`

# local provider plugins and modules cache
export TF_PLUGIN_CACHE_DIR="$APP_DATA/terraform.d/plugin-cache"
export TF_PLUGIN_LOCAL_DIR="$APP_DATA/terraform.d/plugins"
export TF_MODULE_LOCAL_DIR="$APP_DATA/terraform.d/modules"


# determine git repo git_root and relative sub_path from root/data/ 
git_root=`git rev-parse --show-toplevel | sed -e 's/.://'`
dir_path=`realpath . | sed -e 's/\/[a-z]\//\//g'`
sub_path=`echo $dir_path | sed -e 's/.*\/data\//\//g'`



# helper functions


# delete one symlink
function deleteLink () {
    link=$1
    [ -z "$link" ]     &&    return
    [ -L "$link" ]     &&    unlink $link   2>&1
}

# delete all symlinks
function deleteDataLinks () {
    pushd data > /dev/null 2>&1

    for path in `cat ../.symlinks`; do 
        #echo "unlink: $path"
        deleteLink $path
    done

    popd > /dev/null 2>&1
}



# main script


pushd $git_root > /dev/null 2>&1


# find data symlinks

find data/ -type l -print | grep -v .terraform | sed -e 's/^data\///g' > .symlinks
echo "deleting symlinks:"
cat .symlinks
echo " "


# remove data symlinks

deleteDataLinks


# remove temp files

#rm .symlinks
#rm .taxonomy


popd > /dev/null 2>&1
 