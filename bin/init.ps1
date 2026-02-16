# init.bash:  read inherited variables, logon to provider, and initialise backend


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




# Read and parse plain env var file (name="value")
# terraform .tfvars files are like unix env vars.
# todo: do we need a hack to handle booleans ?
Function ReadEnv ($Path) {

    # Validate file existence
    if (-not (Test-Path $Path)) {
        Write-Error "File '$Path' not found."
        exit 1
    }

    Get-Content $Path | ForEach-Object {
        # Skip empty lines and comments
        $_ = $_.Trim()
        if (-not $_ -or $_ -match '^\s*#') { return }

        # Match key=value format
        if ($_ -match '^\s*([^=]+?)\s*=\s*(.*)\s*$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()

            # Remove surrounding quotes if present
            #if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") {
            #    $value = $matches[1]
            #}

            # Set env variable
            # $env:$key = $value
            Set-Variable -Name $key -Value "$value"-Scope Global
        }
    }
}


# Load current terraform context variables from symlinks
# we load the current context into shell environment vars.
# This allows us to inject values in terraform operations.
function LoadVars () {
    foreach ($file in $( ls.exe -q1 *.auto.tfvars 2>$null ) ) {
        echo "tfvars: $file"
        ReadEnv $file
    }
}


# main script



# Load current terraform context variables from symlinks
LoadVars


#$env:architecture=az
#$env:backbone=wc
#$env:component=iac
#$env:deployment=avm
#$env:environment=box
echo "architecture=$architecture"
echo "backbone=$backbone"
echo "component=$component"
echo "deployment=$deployment"
echo "environment=$environment"

echo " "
echo "client_id=$client_id"
echo "tenant_id=$tenant_id"
echo "subscription_id=$subscription_id"

#exit 0


#$env:ARM_USE_CLI = $true
#$env:ARM_USE_AZUREAD = $true
#$env:ARM_TENANT_ID = "8f7cec2f-be32-44bc-8611-9ff05a2583f6"
#$env:ARM_SUBSCRIPTION_ID = "6747da70-f3b6-421d-9e93-bda13a7475b2"
$env:ARM_USE_CLI=$true
$env:ARM_USE_AZUREAD=$true
$env:ARM_TENANT_ID="$tenant_id"
$env:ARM_SUBSCRIPTION_ID="$subscription_id"


# logon to azure
az login
#az account set -s "6747da70-f3b6-421d-9e93-bda13a7475b2"
az account set -s "$subscription_id"


# initialise the backend
#terraform init -backend-config="key=${var.environment}.tfstate"
#terraform init -backend-config="subscription_id=$env:subscription_id" -backend-config="key=$env:environment.tfstate" 

terraform init -plugin-dir $env:TF_PLUGIN_LOCAL_DIR -var="module_dir=$env:TF_MODULE_LOCAL_DIR" -backend-config="key=$environment.tfstate" 
