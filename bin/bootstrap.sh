# bootstrap.sh:  bind library dirs for terraform provider plugins and modules


# current context


# ensure symlinks in the gitbash shell
export MSYS="winsymlinks:nativestrict"
setx   MSYS "winsymlinks:nativestrict"


# local mirrors for terraform plugins, providers, and modules
export APP_DATA=`echo $APPDATA | sed -e 's/\//\//g'`

# local provider plugins and modules cache
export TF_PLUGIN_CACHE_DIR="$APP_DATA/terraform.d/plugin-cache"
export TF_PLUGIN_LOCAL_DIR="$APP_DATA/terraform.d/plugins"
export TF_MODULE_LOCAL_DIR="$APP_DATA/terraform.d/modules"
setx TF_PLUGIN_LOCAL_DIR "$APP_DATA/terraform.d/plugins"
setx TF_PLUGIN_CACHE_DIR "$APP_DATA/terraform.d/plugin-cache"
setx TF_MODULE_LOCAL_DIR "$APP_DATA/terraform.d/modules"


# determine git repo git_root and relative sub_path from root/data/ 
git_root=`git rev-parse --show-toplevel | sed -e 's/.://'`
dir_path=`realpath . | sed -e 's/\/[a-z]\//\//g'`
sub_path=`echo $dir_path | sed -e 's/.*\/data\//\//g'`



# main script


pushd $git_root

# create lib dirs for  plugins and modules
[ ! -L $TF_PLUGIN_CACHE_DIR ]       &&    mkdir -p $TF_PLUGIN_CACHE_DIR
[ ! -L $TF_PLUGIN_LOCAL_DIR ]       &&    mkdir -p $TF_PLUGIN_LOCAL_DIR
[ ! -L $TF_MODULE_LOCAL_DIR ]       &&    mkdir -p $TF_MODULE_LOCAL_DIR

# create symlinks to local plugins and modules
[ ! -L .plugins ]                    &&   ln -s   $TF_PLUGIN_LOCAL_DIR                .plugins
[ ! -L .modules ]                    &&   ln -s   $TF_MODULE_LOCAL_DIR                .modules


createLinks

popd
