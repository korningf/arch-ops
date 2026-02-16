# init.bash:  read inherited variables, logon to provider, and initialise backend

# NOTE init.bash is called from the desired execution environment context folder.
#
#   pushd /data/az/wc/iac/avm/box
#   git_root/bin/init.sh <workload> <plan>
#   popd


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


# Read and parse plain env var file (name="value")
# terraform .tfvars files are like unix env vars.
# todo: do we need a hack to handle booleans ?
function ReadEnv () {
    path=$1
    source <(sed -E 's/^[[:space:]]*#.*$//; s/[[:space:]]*=[[:space:]]*/=/; /^[[:space:]]*$/d' $path)
}



# Load current terraform context variables from symlinks
# we load the current context into shell environment vars.
# This allows us to inject values in terraform operations.
function LoadVars () {
    for file in `\ls -1q *.auto.tfvars 2>/dev/null`; do
        echo "tfvars: $file"
        ReadEnv $file
    done
}



# main script


# Load current terraform context variables from symlinks
LoadVars


#$architecture=az
#$backbone=wc
#$component=iac
#$deployment=avm
#$environment=box
echo "architecture=$architecture"
echo "backbone=$backbone"
echo "component=$component"
echo "deployment=$deployment"
echo "environment=$environment"

echo " "
echo "client_id=$client_id"
echo "tenant_id=$tenant_id"
echo "subscription_id=$subscription_id"


#export ARM_USE_CLI=true
#export ARM_USE_AZUREAD=true
#export ARM_TENANT_ID="8f7cec2f-be32-44bc-8611-9ff05a2583f6"
#export ARM_SUBSCRIPTION_ID="6747da70-f3b6-421d-9e93-bda13a7475b2"
export ARM_USE_CLI=true
export ARM_USE_AZUREAD=true
export ARM_TENANT_ID=$tenant_id
export ARM_SUBSCRIPTION_ID=$subscription_id

#exit 0


# logon to azure
az login
#az account set -s "6747da70-f3b6-421d-9e93-bda13a7475b2"
az account set -s "$subscription_id"


# initialise the backend
#terraform init -backend-config="key=${var.environment}.tfstate"
#terraform init -backend-config="subscription_id=$subscription_id" -backend-config="key=$environment.tfstate" 

terraform init -plugin-dir $TF_PLUGIN_LOCAL_DIR -var="module_dir=$TF_MODULE_LOCAL_DIR" -backend-config="key=$environment.tfstate" 