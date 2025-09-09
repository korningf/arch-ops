param(
    [switch]$Docker
)

# setup sources to read from on-prem repos
choco source add -n Prod -s "https://chocoserver:8443/repository/Prod/" --priority=5 --allow-self-service
choco install chocolatey-license      -y --source="'Prod'" --no-progress --version=2025.12.09.20241219
choco install chocolatey.extension -y --source="'Prod'" --no-progress --params="'/NoContextMenu'" --version=6.2.1

if (-not $Docker) {
    choco install chocolatey.extension    -y --source="'Prod'" --no-progress --version=6.2.1
    choco install chocolateygui           -y --source="'Prod'" --no-progress --version=2.1.1
    choco install chocolateygui.extension -y --source="'Prod'" --no-progress --version=2.0.0
    choco install chocolatey-agent        -y --source="'Prod'" --no-progress --version=2.1.3

    # Configure choco agent to talk back to CCM
    choco config set CentralManagementServiceUrl https://chocoserver:24020/ChocolateyManagementService
    choco feature enable --name="'useChocolateyCentralManagement'"
    choco feature enable --name="'useChocolateyCentralManagementDeployments'"
}

# no need hereafter for rank-n-file to have access to this repo
choco source disable -n chocolatey.licensed

# we'll disable CCR, because otherwise we have found that choco agent will cause a large network load.
# (at some point we will in any case be blocking access via the firewall).
choco source disable -n chocolatey
