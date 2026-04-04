# Cloud-Ops


# Introduction 

This is an IAC CAF solution to create a lightweight framework making use of Azure Verified Modules.

It is much simpler than *Aztfmod* and most importantly is *cloud-agnostic* and will run on *Amazon AWS*.

The framework relies on a data directory structure, symbolic links, and inherited environment vars.

It works equally on Powershell or GitBash POSIX, on Azure DevOps, Jenkins or any other IAC pipeline.





#  Screenshots


* bootstrap

![avm-solution-terraform-bootstrap.png](avm-solution-terraform-bootstrap.png)

* clean
  
![avm-solution-terraform-clean.png](avm-solution-terraform-clean.png)


* config

![avm-solution-terraform-config.png](avm-solution-terraform-config.png)


* init

![avm-solution-terraform-init.png](avm-solution-terraform-init.png)


* plan
  
![avm-solution-terraform-plan.png](avm-solution-terraform-plan.png)


* apply

![avm-solution-terraform-apply.png](avm-solution-terraform-apply.png)




# Getting Started

1.	Installation
2.	Configuration
3.	Initialisation
4.	Execution
5.  Operation
6.  Extension


## 1. Installation


The installation presumes you have a POSIX or Windows PC in Developer-mode with Administrator access.

It assumes you have Internet access, with the required institutional firewall, proxy, and cert settings.

It assumes you have admin access and install quasi-everything via the Chocolatey package-manager.


```shell
    choco install -y powershell
    choco install -y powershell-core --pre
    choco install -y sysinternals
    choco install -y azure-cli
    choco install -y awscli
    choco install -y yq
    choco install -y jq
    choco install -y terraform --pre
```


* Symbolic Links

On free (Windows Home Edition) distributions, real native windows symbolic links can only be created

by Administrators or by setting the machine to Developer Mode (which also requires Adminstrator access).

The following assumes you run a Windows Pro Edition, or have Developer mode ON, or are Administrator.

.

Ensure anyTFS / Azure Devops pipeline agent runs on Windows Pro and/or on a Developer Mode machine. 

You may have to use SCEDIT.EXE to set Service Control policies, either Local and/or Group Policies,

in order to enable `SeCreateSymbolicLinkPrivilege` if it's not already active in the agent user account.


```pwsh
    ./bin/sc-enable-symkinks.ps1 
```    

.

Failing this, we recommend using NTFS Junctions via `mklink /j` or via Sysinternals `junction.exe`

for directories, and to use `mklink /h` hard links for regular files.  Adapt the scripts as needed.



* Install Gitbash with SChannel and Symlinks

```shell
   choco install -y git.install --force --params '/SChannel /Symlinks /GitAndUnixToolsOnPath /WindowsTerminal /PseudoConsoleSupport'
```


* Configure Gitbash for Symlinks

bash:

```bash
export MSYS="winsymlinks:nativestrict"
setx   MSYS "winsymlinks:nativestrict"
```

pwsh:

```pwsh
$env:MSYS="winsymlinks:nativestrict"
setx MSYS "winsymlinks:nativestrict"
```


* Configure Git for Symlinks

```shell
   git config --global core.symlinks true

```

* Configure VSCode for Symlinks

```shell
    File -> Preferences -> Settings
    
    Search for "symlinks" - enable checkboxes
```



## 2. Configuration


The new framework maintains symbolic links from parent variables in a runtime execution folder.

Everytime you clone the repo, pull, or make structural taxonomy changes, you must re-configure.


* Clone this repo  (1 time)
   
Start by cloning this IAC repo from the Azure Devops / TFS Git server.



* Bootstrap local libs (1 time)

Run `bootstrap.sh` or `bootstrap.ps1` to bind local `terraform.d` plugins and modules repos.

Your plugins and modules will go in:

    TF_HOME=C:/work/terraformd.d
    TF_PLUGIN_LOCAL_DIR=C:/work/terraformd.d/plugins
    TF_MODULE_LOCAL_DIR=C:/work/terraformd.d/modules




* Populate the local libs (TODO)

_TODO_ copy the plugins and modules from master repo (_TODO_ Nexus repo or shared drive ?).

Consult the Solution Design below for the strcuture of the local repositories.


* Clean the taxonomy (on taxonomy changes)

Every time you change the data structure you should re-configure it (clean + config).

Run `clean.sh` or `clean.ps1` to clean the old taxonomy and remove old symlinks.


* Configure the taxonomy (on taxonomy changes)

Every time you change the data structure or do a git pull you will have to re-configure.

```bash
$ ./bin/clean.sh
deleting symlinks:
az/wc/iac/avm/box/.root
az/wc/iac/avm/box/_architecture.auto.tfvars
az/wc/iac/avm/box/_architecture.vars.tf
az/wc/iac/avm/box/_backbone.auto.tfvars
az/wc/iac/avm/box/_backbone.vars.tf
az/wc/iac/avm/box/_component.auto.tfvars
az/wc/iac/avm/box/_component.vars.tf
az/wc/iac/avm/box/_deployment.auto.tfvars
az/wc/iac/avm/box/_deployment.vars.tf
az/wc/iac/avm/box/_universal.auto.tfvars
az/wc/iac/avm/box/_universal.vars.tf
az/wc/iac/avm/dev/.root
az/wc/iac/avm/dev/_architecture.auto.tfvars
az/wc/iac/avm/dev/_architecture.vars.tf
az/wc/iac/avm/dev/_backbone.auto.tfvars
az/wc/iac/avm/dev/_backbone.vars.tf
az/wc/iac/avm/dev/_component.auto.tfvars
az/wc/iac/avm/dev/_component.vars.tf
az/wc/iac/avm/dev/_deployment.auto.tfvars
az/wc/iac/avm/dev/_deployment.vars.tf
az/wc/iac/avm/dev/_universal.auto.tfvars
az/wc/iac/avm/dev/_universal.vars.tf
az/wc/iac/avm/int/.root
az/wc/iac/avm/int/_architecture.auto.tfvars
az/wc/iac/avm/int/_architecture.vars.tf
az/wc/iac/avm/int/_backbone.auto.tfvars
az/wc/iac/avm/int/_backbone.vars.tf
az/wc/iac/avm/int/_component.auto.tfvars
az/wc/iac/avm/int/_component.vars.tf
az/wc/iac/avm/int/_deployment.auto.tfvars
az/wc/iac/avm/int/_deployment.vars.tf
az/wc/iac/avm/int/_universal.auto.tfvars
az/wc/iac/avm/int/_universal.vars.tf
az/wc/iac/avm/mnt/.root
az/wc/iac/avm/mnt/_architecture.auto.tfvars
az/wc/iac/avm/mnt/_architecture.vars.tf
az/wc/iac/avm/mnt/_backbone.auto.tfvars
az/wc/iac/avm/mnt/_backbone.vars.tf
az/wc/iac/avm/mnt/_component.auto.tfvars
az/wc/iac/avm/mnt/_component.vars.tf
az/wc/iac/avm/mnt/_deployment.auto.tfvars
az/wc/iac/avm/mnt/_deployment.vars.tf
az/wc/iac/avm/mnt/_universal.auto.tfvars
az/wc/iac/avm/mnt/_universal.vars.tf
az/wc/iac/avm/prd/.root
az/wc/iac/avm/prd/_architecture.auto.tfvars
az/wc/iac/avm/prd/_architecture.vars.tf
az/wc/iac/avm/prd/_backbone.auto.tfvars
az/wc/iac/avm/prd/_backbone.vars.tf
az/wc/iac/avm/prd/_component.auto.tfvars
az/wc/iac/avm/prd/_component.vars.tf
az/wc/iac/avm/prd/_deployment.auto.tfvars
az/wc/iac/avm/prd/_deployment.vars.tf
az/wc/iac/avm/prd/_universal.auto.tfvars
az/wc/iac/avm/prd/_universal.vars.tf

```


Run `config.sh` or `config.ps1` to scan the taxonomy and propagate environment symlinks.


```bash
$ ./bin/config.sh
scanned taxonomy:

az
az/wc
az/wc/iac
az/wc/iac/avm
az/wc/iac/avm/box
az/wc/iac/avm/box/app
az/wc/iac/avm/box/app/hosting
az/wc/iac/avm/box/app/network
az/wc/iac/avm/box/app/network/agw
az/wc/iac/avm/box/app/network/agw/agw0
az/wc/iac/avm/box/app/network/agw/agw1
az/wc/iac/avm/box/app/network/apim
az/wc/iac/avm/box/app/network/apim/apim0
az/wc/iac/avm/box/app/network/apim/apim0/public
az/wc/iac/avm/box/app/network/apim/apim1
az/wc/iac/avm/box/app/network/apim/apim1/private
az/wc/iac/avm/box/app/network/apim/apim1/public
az/wc/iac/avm/dev
az/wc/iac/avm/dev/app
az/wc/iac/avm/dev/app/hosting
az/wc/iac/avm/dev/app/network
az/wc/iac/avm/dev/app/network/apim
az/wc/iac/avm/dev/app/network/apim/apim0
az/wc/iac/avm/int
az/wc/iac/avm/mnt
az/wc/iac/avm/prd

scanned runtimes:
az/wc/iac/avm/box
az/wc/iac/avm/dev
az/wc/iac/avm/int
az/wc/iac/avm/mnt
az/wc/iac/avm/prd

created symlinks:
az/wc/iac/avm/box/_architecture.auto.tfvars
az/wc/iac/avm/box/_backbone.auto.tfvars
az/wc/iac/avm/box/_component.auto.tfvars
az/wc/iac/avm/box/_deployment.auto.tfvars
az/wc/iac/avm/box/_universal.auto.tfvars
az/wc/iac/avm/dev/_architecture.auto.tfvars
az/wc/iac/avm/dev/_backbone.auto.tfvars
az/wc/iac/avm/dev/_component.auto.tfvars
az/wc/iac/avm/dev/_deployment.auto.tfvars
az/wc/iac/avm/dev/_universal.auto.tfvars
az/wc/iac/avm/int/_architecture.auto.tfvars
az/wc/iac/avm/int/_backbone.auto.tfvars
az/wc/iac/avm/int/_component.auto.tfvars
az/wc/iac/avm/int/_deployment.auto.tfvars
az/wc/iac/avm/int/_universal.auto.tfvars
az/wc/iac/avm/mnt/_architecture.auto.tfvars
az/wc/iac/avm/mnt/_backbone.auto.tfvars
az/wc/iac/avm/mnt/_component.auto.tfvars
az/wc/iac/avm/mnt/_deployment.auto.tfvars
az/wc/iac/avm/mnt/_universal.auto.tfvars
az/wc/iac/avm/prd/_architecture.auto.tfvars
az/wc/iac/avm/prd/_backbone.auto.tfvars
az/wc/iac/avm/prd/_component.auto.tfvars
az/wc/iac/avm/prd/_deployment.auto.tfvars
az/wc/iac/avm/prd/_universal.auto.tfvars

```


## 3. Initialisation


* PIM Elevation

Before you run Init, you will have to do a Privileged Identity Management (PIM) elevation,

and select and activate all the necessary Privileged Access Group (PAG) policy permissions.

These vary depending on the subscription and stack. Ask around for your particular project.

Succinctly, in sandbox you need the following:

    SG-PAG-SBX-Administrator
    SG-PAG-DEV-Developer
    SG-PAG-INT-Operator
    SG-PAG-MNT-Tester
    SG-PAG-PRD-Reader
    SG-PAG-ALL-RemoteDeviceAuth
    



* Init Script


We want a Generic Framework that does not depend on Azure DevOps / TFS pipeline scripts.

We want an Agnostic Framework that will work on any Cloud Provider, say for Amazon AWS.

Our solution makes it possible to run nigh-everything locally in native Terraform.

.

Instead of tracking and injecting maps of variables, we rely on sourcing POSIX variables.

It turns out Terraform `.tfvars` use the exact same syntax as POSIX shell env variables.

Terraform also plays nicely with POSIX symbolic links, which we can use for `.auto.tfvars`.

Instead of tracking subscription variables, we can just inherit vars from parent taxons.

.


We still rely on an init script `init.ps1` or `init.sh`, but the logic is simplified.

The Init parameters select a runtime execution environment folder (taxon 5).


.

The init process navigates to the desired execution folder and reads its variables.

It selects the desired subscription and configures the state storage backend.

.

It calls `az login` and `terraform init` with the configured parameters.


```shell
$ pushd data/az/wc/iac/avm/box/
/work/workspace/nst/cloud/iac/iac.avm/data/az/wc/iac/avm/box

$ .root/bin/init.sh
tfvars: _architecture.auto.tfvars
tfvars: _backbone.auto.tfvars
tfvars: _component.auto.tfvars
tfvars: _deployment.auto.tfvars
tfvars: _environment.auto.tfvars
tfvars: _universal.auto.tfvars
architecture=az
backbone=wc
component=iac
deployment=avm
environment=box
A web browser has been opened at https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize. Please continue the login in the web browser. If no web browser is available or if the web browser fails to open, use device code flow with `az login --use-device-code`.

  ...

Initializing the backend...
Initializing modules...
Initializing provider plugins...
- Reusing previous version of hashicorp/random from the dependency lock file
- Reusing previous version of azure/azapi from the dependency lock file
- Reusing previous version of azure/modtm from the dependency lock file
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed azure/azapi v2.8.0
- Using previously-installed azure/modtm v0.3.5
- Using previously-installed hashicorp/azurerm v4.57.0
- Using previously-installed hashicorp/random v3.8.0

Terraform has been successfully initialized!


``` 


## 4. Operation

From here on, all operations are done locally in the same execution folder.

Sub-modules in subfolders can be invoked but they must be called from here.

.

Additional Script parameters can taregt a specific WorkGroup and Workload.

The next 2 taxons pick a WorkGroup (aka Service Facility and Service Group).

.

This can be followed by up to 3 additional Taxons for specific Workload Jobs.

.

This can be followed by up to 3 additional Taxons for granular Layout Modules.


* Backends

_TODO_  

Initialise state backend for a given WorkGroup (`environment`, `facility`, and `group`).

    terraform init -plugin-dir="$TF_PLUGIN_LOCAL_DIR" -backend-config="key=box.tfstate"
    terraform init -plugin-dir="$TF_PLUGIN_LOCAL_DIR" -backend-config="key=box-app.tfstate"
    terraform init -plugin-dir="$TF_PLUGIN_LOCAL_DIR" -backend-config="key=box-app-network.tfstate"
 
 Optional : more granular backends ? (hopefully not necessary)

_TODO_  do we use workspaces here ?


* Targets

Invoke mid-level Terraform targets for a specific Workload (`handle`, `item`, or `job`) .

    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box 
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim

Optional : more granular workgroups (depending on complexity).

    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0_public
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0_public_akv        
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0_public_agw
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0_public_nsg
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0_public_asg
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0_public_vnet
    terraform plan -var="module_dir=$TF_MODULE_LOCAL_DIR" -target=box_app_network_apim_apim0_public_apim


Optional : more granular workloads via Module Layouts (`kind`, `layout`, and `module`).


## 5. Execution


_TODO_  Pipeline Execution.



## 6. Extension


_TODO_





#  Solution

General Solution Structure (root filesystem):


![architecture-solution-structure.png](architecture-solution-structure.png)



Auto Symlink Structure (environment execution context):


![auto-symlink-structure.png](auto-symlink-structure.png)


# Philosophy

The `aztfmod` CAF framework has a lot of good ideas, but the implementation is complex.

We aim to keep some of the elements of its methodology, but with a little more coherence.

.

A main goal is to keep a separation of hub and spoke workloads by service facility and group.

Another main goal is to get rid of the reliance on powershell scripts such as `executor.ps1`.

.

We want something similar, but without any fuzziness, without injecting parameters in scripts.

Right now we have too many levels of indirections: we pass around maps of maps of references

which we then inject downstream.  What if we could instead just inherit upstream variables?

.

The postulate: Everything starts with a strong hierarchical ontology or taxonomy structure.

If our structure is well-modelled, we ought to be able to do everything in 100% terraform.

We want to replace the old executor.ps1 and the plethora of ancillary .ps1 helper scripts.

.

The old scripts also used to enforce access groups, rules, and policies notably for security.

These are clever, but terraform already has plugins that can do all of this in a simpler way.

We could for example use `tflint` or `checkov` to do a lot of the validation and enforcement.

.

Finally the old scripts also manage the login context and configure the state storage backend.

We want a middle taxon for an isolated execution environment that configures all state storage.

Each environment has a provider, a tenant, a subscription, a resouce group and a storage acount.

.

The philosophy: 

Do everything in Terraform, using the unix/posix pattern of symlinks and `*.auto.tfvars`.

Use a strong Structure that isolates a single subscription runtime execution environment.

Run all modules from that execution context, with subfolders for workgroups and workloads.








# Dependencies

## Terraform Plugins and Providers

Right now the Firewall HTTPS rules block downloads from Terraform Providers and Plugins.

This blocks, notably, Azure AVM modules, and Azurerm and Hashicorp providers and plugins.

A solution could be to configure Nexus Firewall repository proxies for plugins and modules.

* desired Nexus Repository Firewall proxies or hosted repos (tentative list):
  
```text
    https://registry.terraform.io/
    https://releases.hashicorp.com/
    https://azure.github.io/
    https://github.com/azure/
    https://github.com/hashicorp/
```


## Git Submodules

Originally I thought I would use Git submodules to pull-in source-code for the AVM module source.

This is probably way too complicated and overkill, instead we're going to use a local modules.

This is the same strategy used for Terraform local plugins, but for modules instead of providers.


## AVM submodules

Unlike Terraform provider plugins, which are GoLang source and packaged as zipped .exe executables,

AVM modules are just TF source in a git repo. Versioned releases are all tags of the main branch.

Like local plugins we keep local module sources in terraform.d/; we clone them, by tag if desired.



https://github.com/Azure/terraform-azurerm-avm-res-apimanagement-service

https://github.com/Azure/terraform-azurerm-avm-res-apimanagement-service/releases/tag/v0.0.6



## Terraform Mirrors (Plugins and Modules)

Our framework relies on custom provider plugins and avm modules in a local `terraform.d` directory.

I tried using Terraform variables including built-ins like `${path.root}` for these, but in vain,

as tt turns out Terraform doe snot allow to interpolate variables inside a provider source string

or inside a module source string.

.

Because we have a nested module structure where our AVM sub-modules can live at different depths,

if we were to use relative paths for avm module sources, it would be a pain to maintain these.

So best would be to use aan absolute fixed directory, a shared drive, or perhaps a single root.

.

I first tried doing this using a project terraform.rc file but it wasn't working - no matter.

Another approch is to use `$APPDATA` but it's better to share one single cache for all users.

I also tried maintaing symbolic links to point to .root - but that exploded workspace complexity.

.


The best alternative is therefore to use either an absolute directory or a windows Shared drive.

The approach shosen by the ohter POCs is to map a windopws drive (say a T: drive for Terraform).

For performance, I think a local absolute directory is best, feel free to map a T: drive to it.



```bash
    TF_HOME="C:/work/terraform.d"
    TF_PLUGIN_CACHE_DIR="C:/work/terraform.d/plugin-cache"
    TF_PLUGIN_LOCAL_DIR="C:/work/terraform.d/plugins"
    TF_MODULE_LOCAL_DIR="C:/work/terraform.d/modules"
```

We pass the local plugin path on the `terraform init -plugin-dir $TF_PLUGIN_LOCAL_DIR`.




Structure
```text

    terraform.d/

        plugins/
            registry.terraform.io/
                hashicorp/
                    azurem/
                        terraform-provider-azurerm_4.57.0_windows_386.zip       # archived  zip
                        4.5.70/
                            windows_amd64/
                                LICENSE.txt
                                terraform-provider-azurerm_v4.57.0_x5.exe       # exploded .exe 

        modules/
            registry.terraform.io/
                azure/
                    avm
                        azurerm/
                            avm-res-apimanagement-service_0.0.6.zip             # git zip (by tag) 
                            avm-res-apimanagement-service/
                                latest/                                         # git src (main head)
                                    LICENSE
                                    main.tf
                                    ...

                                0.0.6/                                          # git src (-b tag)
                                    LICENSE
                                    main.tf
                                    ...
                                    
                            avm-res-network-virtualnetwork_0.9.2.zip
                            avm-res-network-virtualnetwork/
                                latest/
                                0.9.2/

                            avm-res-network-virtualnetwork_0.4.0.zip
                            avm-res-network-privatednszone/                        
                                latest/                                
                                0.4.0/
``` 


## TerraForm Provider

By default terraform plugins, ie providers, want to register themselves in the main registry.

When passing a local plugins directory in terraform init, we must disable auto registrations.

.

Azure providers operate at the subscription level which for us maps to an execution environment.

Terraform does not allow variable interpolation inside provider blocks, so we hardcode values.

.

Now Terraform allows provider aliases, which in theory we ought to be able to use use here.

_TODO_  investigate how to wire a provider alias such that it works with downstream modules.



# Design


# Inherited Vars


Our Solution Design calls for the possibility of running nigh-everything locally in native Terraform.

We want something that is portable and does not depend tightly on Azure DevOps / TFS pipeline scripts.

We want a Generic Framework that is agnostic and will work on any Cloud Provider, say for Amazon AWS.

.

To that end, instead of injecting variables via scripts, we rely on sourcing POSIX-style env var files.

It turns out that Terraform `.tfvars` and `.auto.tfvars` use the same syntax. (a name=value per line).

It also turns out that terraform plays nicely with symbolic links, and we can link `auto.tfvars` files.

Instead of calculating which vars are injected where, we just inherit the vars from the parent taxons.

.

So our init Script, then, just navigates to a given execution environment folder (the 5th or "e" taxon),

reads all inherited `_*.auto.tfvars` environment variables, and then calls terraform `login` and `init`.



# Symlinks

A Strategy inspired from UNIX / POSIX ops, SymLinks allow to share config across folders.

This is particularly useful to inherit config tfvars from parent folders in higer levels.

It is also useful for pointing to abstract module implementations and managing versions.

.

We want to run terraform from several runtime root execution folders (the environment taxon).

In the previous framework, we used to track and inject nested maps of objects or references.

We simplify this by using symlinks to inherit context variables instead of tracking references.

.

The new framework maintains symbolic links to parent variables in a runtime execution folder.

We try to keep variables as an almost flat structure with fully-qualified ontology names.

.

In Windows this can be done with Gitbash or Native Symlinks via `mklink` or NTFS `junction`.

Note Gitbash should be installed with /Symlinks and have it configured in global .gitconfig.

.

## Symlink naming strategy


By default, terraform inludes `*.tf` files in the current folder, as well as a `terraform.auto.tfvars`.

Now it will also auto-include `*.auto.tfvars`.  We reserve these for symlinks:  `_*.auto.tfvars`. 

.


Originally I thought we could use hidden symlinks `.deployment.tf`, but terraform will not see nor

include hidden files that start with a period.  It loads `*.tf` files starting with a visible char.

.

However, upon more research, it looks like Terraform allows underscore even as the first character.

We can use this to better organise our sourcecode and make the structure easier to visually grok.

.

Crucially, Terraform allows and ignores any `auto.tfvars` values that are not declared variables.

For our inheritance model, we inherit values, if you need the variable, include its definition.

.


```bash
    # execution environment links (ex: in data/az/wc/iac/avm/box/)

    .root               -> ../../../../../../

    _u.auto.tfvars      -> ../../../../../_u.auto.tfvars
    _a.auto.tfvars      -> ../../../../_a.auto.tfvars
    _b.auto.tfvars      -> ../../../_b.auto.tfvars
    _c.auto.tfvars      -> ../../_c.auto.tfvars
    _d.auto.tfvars      -> ../_d.auto.tfvars
    _e.auto.tfvars      -> _e.auto.tfvars

    _e.vars.tf          # environment variable definitions 

    main.tf             # terraform environment entry point (main targets)

```




# Organisation

An Azure Tenant can manage subscriptions in up to 6 levels of ManagementGroups (OrgUnits).

Azure Resources can only belong to once single ResourceGroup and these cannot be nested.

Instead Azure Service Groups allow nested slicing of Resources across Resources Groups.

We're going to adapt these constraints in our structure, specifically for Service Groups.


.

Terraform Azure provider operations are done on a subscription, an organisation sub-account.

Now the way we have organised our Azure management group and subscriptions varies immensely.

Some subscriptions hold only a hub for a given environment, or even just a single spoke app.

Others like bcp hold many environments for many components consisting of both hubs and spokes.

.

The way we make sense of this is to virtualise our subscriptions, we group them symbolically

under a more homogenous naming structure, in our case via a directory hierarchy or taxonomy.

.

# Ontology

These names were picked to sort alphabetically by tier, but the terms are plastic and unimportant.

We can adapt this later.  What's important is to have structure that allows to reach any runtime,

ie a virtual subscription for a specific component and deployment in a given runtime environment.

.

Everything starts with a cloud provider (Azure or Amazon), and a root client account.

The top 2 levels are Cloud Architecture and Backbone, ie a Client Account and a Tenant.

.

The next 3 levels are a tuplet that utimately select a management group and a subscription.

We virtualise our subscriptions, splitting them by component, deployment, and environment.

This is out runtime execution context, from which main Terraform commands shall be invoked.

.

From this level-on, top-level pipeline targets are defined, which may include sub-folders.


A terraform provider operates on this level, ie on one component + deployment + environment.

.

The next 2 levels select an abstract Service facility and a Service Group (ie: a WorkGroup).

This is analogous to the aztfmod CAF framework's workloads and service layers and levels.

These folders allow mid-level pipeline targets, for example az-wc-iac-avm-box-app-network.

Workspaces are used for multiple state backends, split by Service facility and Service Group.

.

Levels below this point to Abstract Job Workloads, which map to abstract Module invocations.

Workload are grouped by a handle (apim), an item (apim0), and a job name (apim_gateway.tf).

The job can either call a module directly or be an abstract call to nested layout module.



```text

Ontology:

    example                                                       taxon           notes                       tier
    ============================================================  ==============  =========================   ============
    az/                                                           architecture
    ------------------------------------------------------------  --------------  --------------------------  cloud
        wc/                                                       backbone  
            iac/                                                  component   
                avm/                                              deployment
                    box/                                          environment
    ------------------------------------------------------------  --------------  --------------------------  subscription
                        app/                                      facility   
                            network/                              grouping 
    ------------------------------------------------------------  --------------  --------------------------  workgroup
                                vnet/                             handle          abstract workload handle
                                    vnet1/                        item            abstract workload item
                                        zone1/                    job             abstract workload job             
    ------------------------------------------------------------  --------------  --------------------------  workload
                                            snet/                 kind            module kind
                                                snet0/            layout          module layout
                                                    public/       module          module    
                                                        main.tf                   * -> calls avm module
    ------------------------------------------------------------  --------------  -------------------------   module
```


# Module Layouts

Optionally 3 more levels can be used for module with multiple variants or layouts.

These modules are organised by kind, layout, and a final real module implementation.

The layout is a pre-defined topology,  this will depend on the module resource type.



```text

VNet Layouts:

    example                                                       taxon           notes                     
    ============================================================  ==============  ========================================
                                vnet/                             kind            vnet
                                    vnet0/                        layout          public external zone
                                    vnet1/                        layout          pub zone, 1 private zone
                                    vnet2/                        layout          pub zone, 2 private zones
                                    vnet3/                        layout          pub zone, 3 cluster zones
                                    vnet4/                        layout          pub zone, 3 HA zones, 1 db zone
                                    vnet5/                        layout          pub zone, 3 HA zones, 1 db zone, 1 dmz
    ------------------------------------------------------------  --------------  ----------------------------------------
```



# Simple Module Layout


The simplest layout is just to place the module invocation directly below the service group.

In the example below the workload job itself does the invocaton of the low-level avm module.

This is ideal when we do not have a need for service sets of deeply-nested module invocations.


```text
Simple Layout :

    example                                                       taxon           notes                       tier
    ============================================================  ==============  =========================   ============
    az/                                                           architecture
    ------------------------------------------------------------  --------------  --------------------------  cloud
        wc/                                                       backbone        regional backend
            iac/                                                  component       logical component
                avm/                                              deployment      local deployment
                    box/                                          environment     execution environment
    ------------------------------------------------------------  --------------  --------------------------  subscription
                        app/                                      facility        service facility
                            network/                              grouping        service grouping
    ------------------------------------------------------------  --------------  --------------------------  workgroup
                                vnet/                             handle          workload handle
                                    vnet0/                        item            workload item
                                        public.tf                 job             workload job 
                                                                                    -> calls avm module
    ------------------------------------------------------------  --------------  --------------------------  workload
```

# Multiple Module Layout

For a richer composition, it might be necessary to share workgroup variables between related modules.


```text
Multiple Module Layout :

    example                                                       taxon           notes                       tier
    ============================================================  ==============  =========================   ============
    az/                                                           architecture
    ------------------------------------------------------------  --------------  --------------------------  cloud
        wc/                                                       backbone        regional backend
            iac/                                                  component       logical component
                avm/                                              deployment      local deployment
                    box/                                          environment     execution environment
    ------------------------------------------------------------  --------------  --------------------------  subscription
                        app/                                      facility        service facility
                            network/                              grouping        service grouping
    ------------------------------------------------------------  --------------  --------------------------  workgroup
                                vnet/                             handle          workload handle
                                    vnet0/                        item            workload item
                                        snet0/                    job             workload job    
                                            public.tf                               -> calls avm module
                                        snet1/                    job             workload job
                                            private.tf                              -> calls avm module    
    ------------------------------------------------------------  --------------  --------------------------  workload
```


# Nested Module Layout

Finally for the richest composition, additional levels can be added, up to the full 3-level module taxons.

This is useful for stacks grouping multiple service sets, for example availability-sets or scalability-sets.


```text
Nested Module Layout:

    example                                                       taxon           notes                       tier
    ============================================================  ==============  =========================   ============
    az/                                                           architecture
    ------------------------------------------------------------  --------------  --------------------------  cloud
        wc/                                                       backbone  
            iac/                                                  component   
                avm/                                              deployment
                    box/                                          environment
    ------------------------------------------------------------  --------------  --------------------------  subscription
                        app/                                      facility   
                            network/                              grouping 
    ------------------------------------------------------------  --------------  --------------------------  workgroup
                                vnet/                             handle          abstract workload handle
                                    vnet0                         item            abstract workload item
                                        snet0/                    job             abstract workload job             
    ------------------------------------------------------------  --------------  --------------------------  workload
                                            sset/                 kind            module kind
                                                sset0/            layout          module layout
                                                    scaler/       module          module      
                                                        main.tf                     -> calls avm module
    ------------------------------------------------------------  --------------  --------------------------   module
```




# APIM Example:

Here is a tentative example showing possible APIM layouts and their hypothetical implementations.

Actual workload and module taxons will be adjusted dependending on how much granularity is needed.


```text

APIM Layouts:

    example                                                       taxon           notes                     
    ============================================================  ==============  ========================================
                                apim/                             kind            apim
                                    apim0/                        layout          public endusers only
                                    apim1/                        layout          pub, private api developers
                                    apim2/                        layout          pub, priavte api producers, consumers
                                    apim3/                        layout          pub, producers, consumers, subscribers
    ------------------------------------------------------------  --------------  ----------------------------------------
```


Here is an example with two workloads, the first creates an apim public gateway, 

and the second workload psushes and manages the bomi public apis on that gateway.


```text

APIM Example:

    example                                                       taxon           notes                       tier
    ============================================================  ==============  ==========================  ============
    ------------------------------------------------------------  --------------  --------------------------  cloud       
    az/                                                           architecture
        wc/                                                       backbone  
            iac/                                                  component   
                avm/                                              deployment
                    box/                                          environment
    ------------------------------------------------------------  --------------  --------------------------  subscription
                        app/                                      facility   
                            network/                              grouping 
    ------------------------------------------------------------  --------------  --------------------------  workgroup
                                    apim/                         handle          
                                        apim0/                    item           
                                            apim0_public.tf       job             * creates apim gateway
    ------------------------------------------------------------  --------------  --------------------------  workload
                                    apis/                         handle          
                                        api0/                     item          
                                            api0_bomi.tf          job             * manages bomi apis
    ------------------------------------------------------------  --------------  --------------------------  workload
```                    



# Structure

The Structure takes inspiration from the CAF framework, but applies the Ontology or Taxonomy above.

There should be no ambiguities, Azure Pipeline Parameters should map to this clear folder structure.


Structure:

```text

# binary scripts
bin/
    clean.sh
    clean.ps1
    config.sh
    config.ps1
    init.sh
    init.ps1

# low-level terraform modules
modules/                                                        ->      $TF_MODULE_LOCAL_DIR
plugins/                                                        ->      $TF_PLUGIN_LOCAL_DIR

# mid-level terraform targets
data/                                                                                           # [/] multi-cloud universe
    _universal.auto.tfvars                                                                           
    _universal.vars.tf                            

    az/                                                                                         # [az] cloud architecture 
        _architecture.auto.tfvars                                
        _architecture.vars.tf                            

        wc/                                                                                     # [wc] regional backbone 
            _backbone.auto.tfvars                                
            _backbone.vars.tf                                
            
            iac/                                                                                # [iac] logical component 
                _component.auto.tfvars                           
                _component.vars.tf                           

                avm/                                                                            # [avm] local deployment 
                    _deployment.auto.tfvars                      
                    _deployment.vars.tf                      

                    #=== [BOX] ================================================================ [BOX] sanbox environment #

                    box/                                                                        # [box] environment 
                        .root/                                  ->      ../../../../../../
                        
                        _universal.auto.tfvars                  ->      ../../../../../_universal.auto.tfvars
                        _universal.vars.tf                      ->      ../../../../../_universal.vars.tf
                        _architecture.auto.tfvars               ->      ../../../../_architecture.auto.tfvars
                        _architecture.vars.tf                   ->      ../../../../_architecture.vars.tf
                        _backbone.auto.tfvars                   ->      ../../../_backbone.auto.tfvars
                        _backbone.vars.tf                       ->      ../../../_backbone.vars.tf
                        _component.auto.tfvars                  ->      ../../_component.auto.tfvars
                        _component.vars.tf                      ->      ../../_component.vars.tf
                        _deployment.auto.tfvars                 ->      ../_deployment.auto.tfvars
                        _deployment.vars.tf                     ->      ../_deployment.vars.tf
                        _environment.auto.tfvars                 
                        _environment.vars.tf                                     

                        e_main.tf                                       # <-- [box] environment main

                        provider.tf                              
                        resource_group.tf                        
                        storage_account.tf                       
                        state_backend.tf                         


                        #--- [network]-------------------------------------------------------------- [network] workgroup #

                        app/                                                                    # service facility [app]
                            _facility.auto.tfvars            
                            _facility.vars.tf
                            
                            f_main.tf                                   # <- [app] facility main

                            network/                                                            # service group [network]
                                _group.auto.tfvars
                                _group.vars.tf

                                g_main.tf                               # <- [network] group main

                                #... [apim] ............................................................ [apim] workload #

                                apim/                                                             # workload handle [apim]
                                    _h.auto.tfvars
                                    _h_vars.tf

                                    apim0/                                                         # workload item [apim0]
                                        _i.auto.tfvars
                                        _i_vars.tf

                                        public/                                                     # workload job [public]
                                            _m.auto.tfvars
                                            _m_vars.tf

                                            main_apim0_public.tf       # <- avm module  (avm-res-apimanagement-service)


                                #... [apim] ............................................................ [apim] workload #

                        #--- [network]-------------------------------------------------------------- [network] workgroup #

                            storage/

                            compute/

                    #=== [BOX] ================================================================ [BOX] sanbox environment #


                                           
# top-level azure-devops pipelines

pipeline/
    az/
        wc/
            iac/
                avm/
                    box/
                        e_box_.json                             ->      /data/az/wc/iac/avm/box/ e_main.tf
                        app/
                            f_app.json                          ->      /data/az/wc/iac/avm/box/app/ f_main.tf
                            network/
                                g_network.json                  ->      /data/az/wc/iac/avm/box/app/network/ g_main.tf
                                

```


In the example above, the tiers below the workgroup or service group point to the workload tuplet.

The workload is our mid-level terraform target and terraform abstract wrapper module invocation.

The 3 levels are used to logically group our modules and resources and then invoke avm modules.

# State files


At its heart Terraform is a transient dependency calculation engine. The bigger the shared state is,

the more work terraform must do to calculate which recursive dependencies also need to be invoked.

The aztfmod CAF framework splits state to try to limit computation costs and limit the blast radius, 

but the trade-off is increased maintenance complexity, and we're hitting speed bottlenecks anyway.

.


It is very time-consuming to retrace which actual state files are needed, to then request PIM access

rights elevation, to load them in an editor, and then to hunt down the many variable indirections.

And that's just for developers; the Terraform engine must do the same and contend for a mutex lock.

.

Having to consult state files dynamically is huge cost. It would be faster to simply use Data blocks,

but even then that would mean dynamic queries. The best would be to simply pass-in variables and avoid

dynamic lookups, as much as possible. This is the goal of the inherited `auto.tfvars ` Symlinks Strategy.

Variables that need to be shared across the tree are inherited, rather than calculated and passed around.

.

We're going to want to use remote-state backends in static storage accounts, possibly multiple backends.

Azure static storage account names are short alphanums; container names use DNS naming (like s3 buckets).

.

The aztfmod CAF framework splits state in an extremely granular fashion, with state not just by environment,

but also by app or spoke workgroup, by workload underneath, by service type, service layer and resource type.

The service type and levels integrate with our PAG Access Groups and the PIM privilege access for security.

.

Perhaps what we need is to limit state to the service group. This preserves compatibility with PIM access,

and makes sense in terms of collaboration and blast radius, but performance may suffer (*TODO: check this*)


_TODO_  (+) do we use backend overrides ? 



# State Backends

Like the aztfmod CAF framework, we split the state in multiple backends.

All state in an environment uses the same storage account and container.

What changes is the key name (ie bucket file-path).

_TODO_ - do we use workspaces instead of keys here ?



```text

Sample State Backends:

account     stwciacavmbox
container   wc-iac-avm-box

statekeys:  
            box.tfstate          
            box-app.tfstate          
            box-app-storage.tfstate
            box-app-network.tfstate
            box-app-compute.tfstate
            box-app-hosting.tfstate
            box-app-manage.tfstate
```



# Exec Pipelines


Pipelines follow the same ontology, and typically start with an entire subscription tuplet,

that to say for a specific component, deployment, and environment (ie: az-wc-iac-avm-box.json).

This will include taksk for sub-folders (ie: a Work Group az-wc-iac-avm-box-app-network.json).


```text
# top-level azure-devops pipelines
exec/
    az/
        wc/
            iac/
                avm/
                    box/
                        e_box.json                          ->      /data/az/wc/iac/avm/box/ e_main.tf
                        app/
                            f_app.json                      ->      /data/az/wc/iac/avm/box/app/ f_main.tf
                            network/
                                g_network.json              ->      /data/az/wc/iac/avm/box/app/network/ g_main.tf
```


* top-level azure-devops pipeline

Azure devops pipeline Parameters should map to a precise execution environment in the data tree.

The scripts navigate to that environment and run all further commands from that execution context.

.

Additional parameters can select a Service (Facility or Group) and Workload (Handle, Item, and Job).

Depending on these, differnt state backends may be initialised. Any subtargets imply subfolders.



```json
TODO
```


# Data Targets

* mid-Level Data targets are run from the execution environment or tiers below.

```text
# mid-level intermediate targets
data/
    az/                                                         <- architecture [az]
        wc/                                                     <- backbone [wc]
            iac/                                                <- component [iac]
                avm/                                            <- deployment [avm]

                    box/                                        <- environment [box]
                        e_main.tf                               <- environment [box] main target

                        app/                                    <- facility [app]
                            f_main.tf                           <- facility [app] main target
                            
                            network/                            <- group [network]
                                g_main.tf                       <- group [network] main target

                                apim/                           <- handle [apim]
                                    apim0/                      <- item [apim0]
                                        public/                 <- job [public]

                                            j_apim0_public.tf     -> avm module (avm-res-apimanagement-service)
           
```


# Code Modules

* From these we invoke low-level AVM module invocation targets are passing-in variables.

Terraform does not allow any variable interpolation in a module source path declaration.

.

It does however allow the use of relative paths, so we can use symlinks to `.root/.modules`.

We could also use a windows share, ie map a network drive, or even use `\\LOCALHOST\c$\work`.

But for now we might as well just hardcode an dir on the C: drive  `c:\work\terraform.d`.



```terraform
# apim0_public.tf
# public external apim gateway: public endpoint, public dns only

module "apim0" {
  #version = "0.0.6"  
  #source  = "Azure/avm-res-apimanagement-service/azurerm"
  # note terraform insists atht relative paths start with ./
  source = "c:/work/terraform.d/modules/registry.terraform.io/azure/avm/azurerm/avm-res-apimanagement-service/0.0.6"

  # api input variables
  
  location = var.location
  resource_group_name = var.resource_group_name


  name = "wc-iac-avm-box-apim"
  publisher_email = "admin@acme.com"
}
```




# Variants

## Taxonomy: names, acronyms, or initials ?

_TODO_ consider using underscores and shortening names in order to better grok the structure.

Should we use full long names, short 3-letter acronyms, or even initials (a/b/c/d/e/f/g/h/i/j) ?



* long names: 

```text

# cloud

_architecture.auto.tfvars
_architecture_vars.tf       
 architecture_main.tf       cloud, client account


# tenant

_backend.auto.tfvars
_backend_vars.tf
 backend_main.tf            region, root tenant


# subscription

_component.auto.tfvars
_component_vars.tf
 component_main.tf           management_group, roles

_deployment.auto.tfvars
_deployment_vars.tf
 deployment_main.tf         subscription, provider

_environment.auto.tfvars
_environment_vars.tf       
 environment_main.tf        execution_group, rights


# workgroup

_facility.auto.tfvars
_facility_vars.tf
 facility_main.tf           service_family, state

_group.auto.tfvars
_group_vars.tf
 group_main.tf              service_group, state 


# workload

_handle.auto.tfvars
_handle_vars.tf
_handle_main.tf             workload handle, resource_group

_item.auto.tfvars
_item_vars.tf
_item_main.tf               workload item, resource_set

_job.auto.tfvars
_job_vars.tf
_job_main.tf                workload job, resource (module)



# module (optional) 

_kind.auto.tfvars
_kind_vars.tf
_kind_main.tf               module kind

_layout.auto.tfvars
_layout_vars.tf
_layout_main                module layout

_module.auto.tfvars
_module_vars.tf
 module_main.tf             module invocation

```

* short acronyms

```text

# cloud

_arc.auto.tfvars
_arc_vars.tf
_arc_main.tf            cloud, client account


# tenant

_bse.auto.tfvars
_bse_vars.tf
 bse_main.tf           region, tenant account


# subscription

_cmp.auto.tfvars
_cmp_vars.tf
 cmp_main.tf           management_group, roles

_dep.auto.tfvars
_dep_vars.tf
 dep_main.tf           subscription, provider

_env.auto.tfvars
_env_vars.tf       
 env_main.tf           execution_group, rights


# workgroup

_fcl.auto.tfvars
_fcl_vars.tf
 fcl_main.tf            service_family, state

_grp.auto.tfvars
_grp_vars.tf
 grp_main.tf            service_group, state 


# workload

_hnd.auto.tfvars
_hnd_vars.tf
 hnd_main.tf            workload handle, resource_group

_itm.auto.tfvars
_itm_vars.tf
 itm_main.tf            workload item, resource_set

_job.auto.tfvars
_job_vars.tf
 job_main.tf            workload job, resource (module)


# module (optional) 

_knd.auto.tfvars
_knd_vars.tf
 knd_main.tf            module kind

_lay.auto.tfvars
_lay_vars.tf
 lay_main               module layout

_mod.auto.tfvars
_mod_vars.tf
 mod_main.tf            module invocation


```


* Initials only


```text

# cloud

_a.auto.tfvars
_a_vars.tf
_a_main.tf            cloud, client account


# tenant

_b.auto.tfvars
_b_vars.tf
 b_main.tf           region, tenant account


# subscription

_c.auto.tfvars
_c_vars.tf
 c_main.tf           management_group, roles

_d.auto.tfvars
_d_vars.tf
 d_main.tf           subscription, provider

_e.auto.tfvars
_e_vars.tf       
 e_main.tf           execution_group, rights


# workgroup

_f.auto.tfvars
_f_vars.tf
 f_main.tf            service_group_, state

_g.auto.tfvars
_g_vars.tf
 g_main.tf            resource_group, state 


# workload

_h.auto.tfvars
_h_vars.tf
 h_main.tf            workload handle

_i.auto.tfvars
_i_vars.tf
 i_main.tf            workload item       (resource_set)

_j.auto.tfvars
_j_vars.tf
 j_main.tf            workload job        (module)


# module (optional) 

_k.auto.tfvars
_k_vars.tf
 k_main.tf            module kind

_l.auto.tfvars
_l_vars.tf
 l_main               module layout

_m.auto.tfvars
_m_vars.tf
 m_main.tf            module invocation


```


# Reference


## Git Submodules

Originally I thought I would use Git submodules to pull-in source-code for the AVM module source.

This is probably way too complicated and overkill, instead we're going to use a local modules.

This is the same strategy used for Terraform local plugins, but for modules instead of providers.


## AVM Modules

Unlike Terraform provider plugins, which are GoLang source and packaged as bundle .exe executables,

AVM submodules are just TF sources in public git. Version releases are all tags of the main branch.

Pulling the source can be done by checking out by tag.  We will use a similar layout as plugins.


https://github.com/Azure/terraform-azurerm-avm-res-apimanagement-service

https://github.com/Azure/terraform-azurerm-avm-res-apimanagement-service/releases/tag/v0.0.6




## Terraform Mirrors (Plugins and Modules)


https://developer.hashicorp.com/terraform/cli/config/config-file

https://developer.hashicorp.com/terraform/cli/config/config-file#provider_installation

https://developer.hashicorp.com/terraform/cli/config/config-file#implied-local-mirror-directories

https://servian.dev/terraform-local-providers-and-registry-mirror-configuration-b963117dfffa





## Terraform tfvars


Originally I though we could use hidden symlinks `.deployment.tf`, but terraform will not include

hidden config files that start with a period.  It assume visible `.tf` that start with a letter.

.

By default, terraform inludes `*.tf` files in its current folder plus a `terraform.auto.tfvars` config.

Additionally configuration files matching `*.tfvars` files have to be passed-in during invocation.

Terraform can also auto-include `*.auto.tfvars`.  We extend this for symlinks:  `_*.auto.tfvars`. 

This is the stratetgy we will use for our inherited taxonomic configuration using Symbolic Links.


https://spacelift.io/blog/terraform-tfvars


## Terraform Symbolic links

A Strategy inspired from UNIX / POSIX ops, SymLinks allow to share config across folders.

This is particularly useful to inherit config tfvars from parent folders in higer levels.

It is also useful for pointing to abstract module implementations and managing versions.


https://medium.com/datamindedbe/avoiding-copy-paste-in-terraform-two-approaches-for-multi-environment-infra-as-code-setups-b26b7251cb11



## Terraform states

This highlights different strategies for splitting up multiple terraform state files.

https://wintelguy.com/2025/handling-terraform-state-in-multi-environment-deployments.html



## Backend configuration

Currently Terraform backends does not support variables in the backend configuration.

It would be fantastic to be able to use variables for the backend container and keys.

So we can't do it in code, however, we can override it via the terraform init command.

_TODO_ should we use workspaces here?


## Backend overrides

Backend parameters can be overriden at the terraform init command-line.

``` terraform
#terraform {
#  backend "azurerm" {
#    use_cli              = true                                    # Can also be set via `ARM_USE_CLI` environment variable.
#    use_azuread_auth     = true                                    # Can also be set via `ARM_USE_AZUREAD` environment variable.
#    tenant_id            = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_TENANT_ID` environment variable.  Defaults to Azure CLI connected tenant ID.
#    subscription_id      = "00000000-0000-0000-0000-000000000000"  # Can also be set via `ARM_SUBSCRIPTION_ID` environment variable. Optional.
#    storage_account_name = "abcd1234"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
#    container_name       = "tfstate"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
#    key                  = "prod.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
#  }
#}
```

_TODO_ not sure this works: can we interpolate in a command-line?

```terraform
terraform init -backend-config="key=${var.environment}.tfstate"
```



## Terraform Tracing

Terraform is pretty opaque when it runs plan or apply, typically only outputting that it i sstill busy.

Underneath it walks through its connected graph and transient depenencies and manipulates state files,


* TF_LOG env var:

None of the progress is shown unless logs are enabled, which can be done by setting the TF_LOG env var.

    TF_LOG=ERROR
    TF_LOG=WARN
    TF_LOG=INFO
    TF_LOG=DEBUG
    TF_LOG=TRACE

* TF_LOG JSON

A special level of JSON sets the log-level to TRACE but outputs it as JSON for strcutured logging analytics.

    TF_LOG=JSON


* TF_LOG_CORE

The above are for the output of a normally runinng terraform engine and its operations and modules.

The terraform framework itself has its own internal logging for terraform core and provider plugins.

The following outputs and isolate terraform core and terraform plugin logs (same levels as TF_LOG).

    TF_LOG_CORE=INFO
    TF_LOG_PROVIDER=INFO


https://developer.hashicorp.com/terraform/internals/debugging



## Terraform Checking


A number of Lint and Checkstyle static analysis plugins and tools can be used to both check syntax

and crucially enforce rules, partcularly udeful for applying azure cloud governance security policies.

Chief among ththem are `tflint`, a linting tool, and `checkov`, which also checks kubernetes clusters.

.


* TFLint rules for TF azurerm modules:

https://github.com/Azure/tflint-ruleset-azurerm-ext


* TFLint rules for AVM verified modules:

https://github.com/Azure/tflint-ruleset-avm



