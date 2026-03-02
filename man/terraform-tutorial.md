# CAF Terraform Primer



This is a primer on how to set up composable reusable terraform modules.

The key question is how to share output or share state between modules, 

either from sister modules in parallel and/or nested parent/child ones. 




# Terraform Path References

Terraform often needs to reference variant configuratiopn files - scripts, templates, certificates, etc. 

Hardcoding file paths breaks as soon as you move the module code or call it from a different module path. 

To solve this Terraform provides three built-in path references: path.module, path.root, and path.cwd.


```hcl
${path.module}
${path.root}
${path.cwd}
```

- path.module - The filesystem path of the module where the expression is defined
- path.root - The filesystem path of the root module (where you run terraform apply)
- path.cwd - The filesystem path of the current working directory (usually the same as path.root, but not always)



1. Local Module paths

Useful to load a file in the same directory as the current module.

The following loads a related Lambda python script into the module.

```hcl
# modules/lambda/main.tf
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/handler.py"  # file next to this .tf file
  output_path = "${path.module}/handler.zip"
}

resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
}
```


2. Root Module pathss
   
The Root module path is the location from which the tarreform plan or apply was called.

Typically this holds common files, scripts, or data to be shared with nested submodules.

The following uses the root module path for the TLS/SSL Certificate and private key.


```hcl
# modules/tls/main.tf

# Load a certificate from the root module's certs directory
resource "aws_iam_server_certificate" "this" {
  name             = "my-cert"
  certificate_body = file("${path.root}/certs/server.crt")
  private_key      = file("${path.root}/certs/server.key")
}
```


3.  Current Working Directory path
   
Finally the `path.cwd`path  returns the directory where you invoked the Terraform CLI. 

This is rarely used as most of the time this is the same as the `path.root` Root Module. 

Some utomation tools might force a working directory other than the config directroy.


```hcl
# In most cases, these are identical
output "root_vs_cwd" {
  value = {
    root = path.root
    cwd  = path.cwd
    same = path.root == path.cwd
  }
}
```

When would they differ? If you run:

```bash
# Run terraform from a different directory using -chdir
terraform -chdir=/path/to/config apply
```

In that case, path.root would be /path/to/config (where the configuration is), 

while path.cwd would be a different execution folder (to store local state).

Use path.cwd sparingly. In most cases, path.module or path.root is what you want.




4. Loading File Content
 
 
Terraform can also load Scripts and Config Files, reading the content as data.

The following loads and injects the AWS machine instance `user_data` bootstrap.


```hcl
# modules/ec2-instance/main.tf

# Read a shell script from the module's scripts directory
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  # Load user data script relative to the module
  user_data = file("${path.module}/scripts/bootstrap.sh")

  tags = {
    Name = var.instance_name
  }
}
```



5. Loading Templates Files
   
Terraform Templates filter and interpolate variables via a tmpmlate file.

The following loads and enriches an AWS ECS Task-Definition json template.

```hcl
# modules/ecs-service/main.tf
locals {
  task_definition = templatefile("${path.module}/templates/task-definition.json.tpl", {
    service_name   = var.service_name
    container_port = var.container_port
    image          = var.container_image
    cpu            = var.cpu
    memory         = var.memory
    log_group      = aws_cloudwatch_log_group.this.name
    region         = data.aws_region.current.name
  })
}

resource "aws_ecs_task_definition" "this" {
  family                = var.service_name
  container_definitions = local.task_definition
  # ... other configuration
}
``` 




# Terraform Import


The Terraform import command allows to load existing remote resources that were not created via terraform.

It allows to load and assign these objects into resource configurations you define, attempting to match them.

This is particularly useful for reconciling infrastrcuture drift, when things achange manually on the portal.

The other good reason for import is to allow complicated migrations, for exmaple when refactoring states.



1. Resource Definition

Before running the import command, manually create a resource block in your Terraform configuration file (.tf). 

For example, to import an AWS EC2 instance:

```hcl
resource "aws_instance" "example" {
ami = "unknown"
instance_type = "unknown"
}
```

2. Resource Import
  
Run the Import Command Use the terraform import command to map the existing resource to the Terraform state:

```bash
terraform import aws_instance.example <resource_id>
```

3. State Configuration

After importing, check the terraform.tfstate file that the resource is named and managed in the state file.

The resource is managed, buut it will have fully configured attributes, run a Terraform plan to reconcile it.

Any operations or deviations  shown by a plan are discrepancies that are not reflected in the configuration.

Run:

```
terraform plan
```


4. Manual Configuration
   
Interactively Adjust your .tf configuration file to match the actual attributes of the imported resource,

(ie, correct ami, instance_type, etc.) - Rinse and repeat until the terraform plan shows no changes.



5. Importing Multiple Resources

For multiple resources, use Terraform 1.5's import block:

```hcl
import {
id = "resource-id-1"
to = aws_s3_bucket.example1
}

import {
id = "resource-id-2"
to = aws_s3_bucket.example2
}
```


6. Generated Configuration 

Later Terraform versions can do an assisted Reconciliation by generating the missing configration.

This is done with the -generate-config-out paramater (we assume this works with low-level providers ?).

.

_TODO_ find out if this works for AVM Azure Verified Modules as well as the Hashicorp AzureRM ones.


Run:

```bash
terraform plan -generate-config-out=generated_resources.tf
```

This generates configuration for imported resources.



## Best Practices

- Always back up your state file before importing.

- Use version control for .tfstate and configuration files.

- Review and align configurations after importing to avoid unintended changes.

- By following these steps, you can seamlessly manage existing infrastructure with Terraform






# Sharing State

Terraform isolates each module execution, so how to have them work together ?

Terraform doesn’t allow modules to directly “pull” outputs from each other.

There are essentially 4 patterns for modules to talk to each other and share state.


- Via a Root Module
- Via a Remote State
- Via a Mixed Hybrid State
- Via a Hybrid Orchestration Module


# Via a Root module

This is the simple vanilla-case: wire one module's output to another's input.

Pass output back up to the root module, then pass it down as module inputs.


0. Folder Structure

```text
project/
├── network/
│   └── main.tf
├── compute/
│   └── main.tf
└── main.tf
```


1. In the network module – define an output

```hcl
# network/outputs.tf
output "subnet_ids" {
  value = aws_subnet.example[*].id
}
```


2. In the root main.tf – call both modules, passing the output

```hcl
# main.tf
module "network" {
  source = "./network"
}

module "compute" {
  source     = "./compute"
  subnet_ids = module.network.subnet_ids
}
```


3. In the compute module – accept the variable

```hcl
# compute/variables.tf
variable "subnet_ids" {
  type = list(string)
}
```


```hcl
# compute/main.tf
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_ids[0]
}
```


## Key Points

- Modules can’t directly reference each other unless they’re both called from the same root module.

- Outputs from one module become available to the root, which can then pass them to another module.

- Wiring dependent modules means they will share state;  If you want to keep them in separate statse, 

- you would instead need to use terraform_remote_state to fetch outputs from another state file.



# Via a Remote State 
 

A more sophisticated approach is to use terraform_remote_state to pull output from other modules,

even if the module source is in a separate folder or Terraform project with its own state file.

The remote state is referenced from a Teeraform Data block of type terraform_remote_state.


0. Context:

You have two separate Terraform projects:

```text
project/
├── network/   # Creates VPC, subnets, NSGs, and routing
└── compute/   # Creates EC2 instances on a given subnet
```


Each has its own terraform init and state file.

1. In the network project – define outputs


```hcl
# network/outputs.tf
output "subnet_ids" {
  value = aws_subnet.example[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
```

Run:

```bash
terraform init
terraform apply
```


This will store the outputs in the network state file.


2. In the compute project – use terraform_remote_state


```hcl
# compute/data.tf
data "terraform_remote_state" "network" {
  backend = "s3" # or "local", "gcs", etc.
  config = {
    bucket = "my-terraform-states"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}
```


3. Use the remote outputs in resources


```hcl
# compute/main.tf
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.subnet_ids[0]
}
```


4. If using local backend instead of S3

```hcl
data "terraform_remote_state" "network" {
  backend = "local"
  config = {
    path = "../network/terraform.tfstate"
  }
}
```



# When to use this approach

- Projects are managed independently.
- You need to share outputs across state boundaries.
- You don’t want a single root module controlling everything.
  

⚠️ Caution:

This creates a dependency between states — if the network state changes, you must refresh the compute state.

Make sure state storage is secure (especially with S3 + DynamoDB for locking).





# Via a Mixed Hybrid State

A Mixed hybrid setup where you can switch between local and remote state via a variable (ie dev, prod).

This approach lets you share outputs between modules in completely separate Terraform projects or states.



0. Context 


```text
project/
├── network/   # Creates VPC, subnets, etc.
│   └── main.tf
├── compute/   # Creates EC2 instances
│   └── main.tf
```

Here, network and compute are separate Terraform states (each has its own terraform init and terraform apply).

1. In the network project – define
    
```hcl
# network/outputs.tf
output "subnet_ids" {
  value = aws_subnet.example[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
```

When you run:

```bash
cd network
terraform apply
```

Terraform will store these outputs in the backend (local, S3, etc.).


2. In the compute project – fetch outputs via terraform_remote_state

```hcl
# compute/data.tf
data "terraform_remote_state" "network" {
  backend = "s3"  # or "local", "gcs", etc.
  config = {
    bucket = "my-terraform-states"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}

# compute/main.tf
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.subnet_ids[0]
}
```


3. Key Notes

- Read-only: terraform_remote_state is read-only — you can’t modify the other project’s resources from here.
- Backend must be shared: Both projects must use a backend that allows reading the state file (ie:, S3, GCS, Azure Blob, local).
- Versioning: If you change outputs in network, you’ll need to re-run terraform apply there before compute can see the updates.


💡 When to use which approach

- Same root module → Pass outputs directly as variables (simpler, faster).
- Separate states/projects → Use terraform_remote_state for decoupled deployments.



# Via a Hybrid Orchestration Module


A Hybrid orchestration pattern to keep modules separate but still orchestrate them from a single “orchestration” root module.

This approach lets you keep your modules separate and reusable, but still manage them from a single root orchestration project.


Folder Structure:

```text
project/
├── modules/
│   ├── network/
│   │   └── main.tf
│   └── compute/
│       └── main.tf
└── orchestration/
    └── main.tf
```

Here:

- modules/ contains reusable Terraform sub-modules (a network and a compute module).
- orchestration/ is the root project that calls the modules and wires them together.


1. Network Module
   
```hcl
# modules/network/main.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

output "subnet_ids" {
  value = [aws_subnet.example.id]
}

output "vpc_id" {
  value = aws_vpc.main.id
}
```


2. Compute Module
   
```hcl
# modules/compute/main.tf
variable "subnet_ids" {
  type = list(string)
}

resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_ids[0]
}
```


3. Orchestration Root
   
```hcl
# orchestration/main.tf
terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket = "my-terraform-states"
    key    = "orchestration/terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "network" {
  source = "../modules/network"
}

module "compute" {
  source     = "../modules/compute"
  subnet_ids = module.network.subnet_ids
}
```

## 💡 Benefits

- Separation of concerns: network and compute are independent modules, reusable in other projects.
- Single apply: The orchestration layer runs both modules in one terraform apply, passing outputs directly.
- No remote state complexity: Since both modules are in the same root state, you avoid terraform_remote_state overhead.




# Hybrid Local and Remote State 

Perfect — let’s build a hybrid terraform_remote_state setup so you can switch between local state (for dev/testing) and remote state (for shared/prod) without rewriting your Terraform code.

1. Folder Structure
   
```text
project/
├── network/   # Creates VPC, subnets, etc.
│   └── main.tf
├── compute/   # Creates EC2 instances
│   └── main.tf
```


2. Network Module Outputs
   
```hcl
# network/outputs.tf
output "subnet_ids" {
  value = aws_subnet.example[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
```


3. Network Backend Config

For production, store state in S3:

```hcl
# network/main.tf
terraform {
  backend "s3" {
    bucket = "my-terraform-states"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}
```

For development, you can skip the backend block and use local state.


4. Compute Module – Hybrid Remote State

We’ll use a variable to decide whether to pull from local or remote state.

```hcl
# compute/variables.tf
variable "use_remote_state" {
  type    = bool
  default = false
}

variable "local_network_state_path" {
  type    = string
  default = "../network/terraform.tfstate"
}
```


5. Data Source Logic

```hcl
# compute/data.tf
locals {
  network_state = var.use_remote_state ? {
    backend = "s3"
    config = {
      bucket = "my-terraform-states"
      key    = "network/terraform.tfstate"
      region = "eu-west-1"
    }
  } : {
    backend = "local"
    config = {
      path = var.local_network_state_path
    }
  }
}

data "terraform_remote_state" "network" {
  backend = local.network_state.backend
  config  = local.network_state.config
}
```

6. Use the Outputs

```hcl
# compute/main.tf
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.network.outputs.subnet_ids[0]
}
```

7. Switching Between Local & Remote

Local (dev):

```bash
terraform apply -var="use_remote_state=false"
```

Remote (prod):

```bash
terraform apply -var="use_remote_state=true"
```


💡 Benefits of this hybrid pattern

- Develop locally without touching shared infrastructure.
- Switch to remote state for production without changing code.
- Keeps environments isolated but code consistent.






## State Migration

💡  Pro Tip:

One advantage is that one can later migrate to separate remote states with relatively little code changes, 

just move the orchestration logic into a CI/CD pipeline and replace output passing with terraform_remote_state.

A migration plan would show how to go from this hybrid orchestration to fully separate states without downtime.




# State Import and Migration


Here is a step-by-step migration plan to go from the hybrid orchestration pattern (with a single root state) 

to fully separate Terraform staes into multiple remote states with minimal code changes and without downtime.

This is useful when your infrastructure grows and you want independent deployments for network and compute.


Goal

Before: One root orchestration project runs both modules together.
After:

- network has its own Terraform state.
- compute has its own Terraform state.
- compute reads network outputs via terraform_remote_state.




## Migration Steps


1. Prepare Separate State Backends

Decide where each state will live (ie:, S3, GCS, Azure Blob).
Example S3 backend config for network:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-states"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}
```


Do the same for compute with a different key.

2. Extract the Network Module
   
From orchestration/main.tf, copy the module "network" block into a new network/main.tf root project:

```hcl
module "network" {
  source = "../modules/network"
}
```

Run:

```bash
cd network
terraform init
terraform apply
```

This creates the network state without destroying anything.

1. Import Existing Resources (If Needed)

If Terraform tries to recreate resources, import them into the new state:

```bash
terraform import aws_vpc.main vpc-123456
terraform import aws_subnet.example subnet-abcdef
```

Repeat for all resources in the network module.

4. Update Compute to Use Remote State

In compute/data.tf:

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "my-terraform-states"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}
```

Then in compute/main.tf:

```hcl
module "compute" {
  source     = "../modules/compute"
  subnet_ids = data.terraform_remote_state.network.outputs.subnet_ids
}
```

5. Extract Compute Module

Move the module "compute" block from orchestration/main.tf into a new compute/main.tf root project.

Run:

```bash
cd compute
terraform init
terraform apply
```

It will now pull subnet_ids from the network state.

6. Decommission the Orchestration Layer
   
Once both network and compute run independently and produce the same infrastructure, you can safely delete the old orchestration root project.

Zero-Downtime Tips

- Run terraform plan after each migration step to ensure no resource destruction.
- Import before apply if Terraform thinks it needs to recreate resources.
- Lock state files (S3 + DynamoDB lock table) to avoid concurrent changes.


## ✅ End Result

- network and compute are fully decoupled.
- You can deploy them independently.
- Outputs are shared via terraform_remote_state.



# Migration Plan Diagram

Heres is a diagram showing the Migration from the hybrid orchestration pattern to fully separate Terraform states.


```text
Before: Hybrid Orchestration (Single State)

     ┌─────────────────────────────────┐
     │ orchestration/terraform.tfstate │
     └─────────────────────────────────┘
                     │
     ┌───────────────┴────────────────┐
     │                                │
┌───────────────┐              ┌───────────────┐
│  module:      │              │  module:      │
│   network     │              │   compute     │
│ (VPC, Subnet) │              │ (EC2, etc.)   │
└───────────────┘              └───────────────┘
     │                                ▲
     └────────── subnet_ids ──────────┘
```

- One state file manages both modules.
- Outputs are passed directly between modules.


```text
After: Fully Separate States with Remote State

┌───────────────────────────────┐
│ network/terraform.tfstate     │
│ (VPC, Subnet)                 │
└───────────────────────────────┘
             ▲
             │ outputs: subnet_ids, vpc_id
             │
     terraform_remote_state
             │
┌───────────────────────────────┐
│ compute/terraform.tfstate     │
│ (EC2, etc.)                   │
└───────────────────────────────┘

```

- Two independent state files (network and compute).
- compute reads network outputs via terraform_remote_state.
- Each can be deployed independently without affecting the other.


Benefits of the New Setup

- Isolation: Changes in compute won’t risk breaking network resources.
- Faster deployments: Only apply the part you need.
- Scalability: Easier to split into more states as infrastructure grows.




# Granular State Pipeline


One benefit of Granular Modular states is that layered deployments can be fully automated in Ci/CD pipelines.

Here is a step-by-step CI/CD pipeline flow where the network is deployed first and compute follows automatically.

CI/CD Pipeline Flow: Network → Compute

1. Pipeline Overview

```text
[ Stage 1: Network ]
    ↓
[ Stage 2: Compute ]
```

- Stage 1: Deploys network and stores remote state outputs.
- Stage 2: Reads network state outputs and deploys compute.


2. Example Git Branching Strategy

- main branch → Production deployments.
- dev branch → Development environment.
- Feature branches → Preview environments (optional).


3. Pipeline Steps


* Stage 1: Deploy Network

```yaml
stages:
  - network
  - compute

network:
  stage: network
  script:
    - cd network
    - terraform init -backend-config="bucket=my-terraform-states" \
                     -backend-config="key=network/terraform.tfstate" \
                     -backend-config="region=eu-west-1"
    - terraform plan -out=tfplan
    - terraform apply -auto-approve tfplan
  artifacts:
    expire_in: 1 hour
    paths:
      - network/terraform.tfstate
```

Purpose:

- Ensures the latest VPC, subnets, and outputs are in the remote state.
- Locks state during apply to prevent conflicts.


* Stage 2: Deploy Compute

```yaml
compute:
  stage: compute
  needs: [network]
  script:
    - cd compute
    - terraform init -backend-config="bucket=my-terraform-states" \
                     -backend-config="key=compute/terraform.tfstate" \
                     -backend-config="region=eu-west-1"
    - terraform plan -out=tfplan
    - terraform apply -auto-approve tfplan
```

Purpose:

- Reads network outputs via terraform_remote_state.
- Deploys EC2 instances or other dependent resources.


4. Key Best Practices

- State Locking: Use DynamoDB (AWS) or equivalent to prevent concurrent applies.
- Environment Variables: Store AWS credentials in CI/CD secrets, not in code.
- Validation Step: Add terraform validate and terraform fmt -check before apply.
- Approval Gates: For production, require manual approval before terraform apply.


5. Optional Enhancement: Parallel Environments

You can parameterize the pipeline to run:

```bash
ENV=dev
ENV=prod
```

And store states separately:

```text
network/dev/terraform.tfstate
network/prod/terraform.tfstate
compute/dev/terraform.tfstate
compute/prod/terraform.tfstate
```

This allows isolated environments with the same codebase.



# Terraform State Promotion


Terraform Workspace Promotion allows us to promote from a local state to a live remote one.

The idea is to test it out locally, so as to not corrupt live remote state before it's ready.

- Switch between local/remote backends.
- Promote state from local to remote production.
- Running applies for dev/prod.



1. Concept Overview


- Local backend for dev/testing.
- Remote backend (S3) for live production.
- terraform state push to promote local state to remote.


2. Local Development Setup

```hcl
# backend-local.tf
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

Run:
```bash
terraform init
terraform apply
```

This creates your infrastructure locally.


3. Remote Production Backend

```hcl
# backend-remote.tf
terraform {
  backend "s3" {
    bucket = "my-terraform-states"
    key    = "network/terraform.tfstate"
    region = "eu-west-1"
  }
}
```

⚠️ Do not keep both backend files active at the same time — switch between them when promoting.


4. Promotion Steps


Finish local testing

```bash
terraform apply
```

Verify everything works.


Switch backend to remote

Replace backend-local.tf with backend-remote.tf.


Push local state to remote

```bash
terraform init -migrate-state
```

Terraform will ask if you want to migrate your local state to the remote backend — say yes.


Verify remote state

```bash
terraform state list
```

You should see the same resources now stored in S3.



5. Terraform Workspaces

Terraform Workspaces manage separate Environment-Specific State Files.

If you want to keep dev and prod states separate but still share code:

```bash
terraform workspace new dev
terraform workspace new prod
```

Then configure your backend key dynamically:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-states"
    key    = "network/${terraform.workspace}/terraform.tfstate"
    region = "eu-west-1"
  }
}
```



6. Select a workspace

```bash
terraform workspace select dev
terraform workspace select prod
```


7. Benefits

- Safe testing — no risk to production while experimenting.
- Seamless promotion — no need to destroy/recreate resources.
- Versioned history — S3 + DynamoDB locking keeps state safe.



# Workspace Promotion Automation


Recall a Terraform state promotion workflow allows to :

- Avoid drift and keep environments consistent.
- Develop locally without touching shared infrastructure.
- Promote the same infrastructure to remote state for production.


We can enhance the workflow by automatring the process through frontend Scripts.

The following automate a promition process using one of three scripting modes:

- Makefile (Linux/macOS with make)
- Pure Bash (no make dependency)
- Pure PowerShell (Windows)

These scripts will handle:

- Selecting the correct workspace (dev or prod)
- Initializing Terraform
- Applying changes
- Promoting local state to remote



1. Makefile Version

```Makefile
# Makefile for Terraform Workspace & State Promotion

WORKSPACE ?= dev
BACKEND_FILE ?= backend-local.tf

dev:
	@echo "Switching to dev workspace..."
	terraform workspace select dev || terraform workspace new dev
	terraform init -backend-config=$(BACKEND_FILE)
	terraform apply -auto-approve

prod:
	@echo "Switching to prod workspace..."
	terraform workspace select prod || terraform workspace new prod
	terraform init -backend-config=$(BACKEND_FILE)
	terraform apply -auto-approve

promote:
	@echo "Promoting local state to remote..."
	cp backend-remote.tf backend.tf
	terraform init -migrate-state
```


Usage:

```bash
make dev
make prod
make promote
```



2. Pure Bash Version

```bash
#!/usr/bin/env bash
set -e

WORKSPACE=${1:-dev}
BACKEND_FILE=${2:-backend-local.tf}

case "$WORKSPACE" in
  dev|prod)
    echo "Switching to $WORKSPACE workspace..."
    terraform workspace select "$WORKSPACE" || terraform workspace new "$WORKSPACE"
    terraform init -backend-config="$BACKEND_FILE"
    terraform apply -auto-approve
    ;;
  promote)
    echo "Promoting local state to remote..."
    cp backend-remote.tf backend.tf
    terraform init -migrate-state
    ;;
  *)
    echo "Usage: $0 [dev|prod|promote] [backend-config-file]"
    exit 1
    ;;
esac
``

Usage:

```bash
chmod +x tf-workflow.sh
./tf-workflow.sh dev
./tf-workflow.sh prod
./tf-workflow.sh promote
```


3. Pure PowerShell Version

```Powershell
param(
    [string]$Workspace = "dev",
    [string]$BackendFile = "backend-local.tf"
)

switch ($Workspace) {
    "dev" {
        Write-Host "Switching to dev workspace..."
        terraform workspace select dev 2>$null
        if ($LASTEXITCODE -ne 0) { terraform workspace new dev }
        terraform init -backend-config=$BackendFile
        terraform apply -auto-approve
    }
    "prod" {
        Write-Host "Switching to prod workspace..."
        terraform workspace select prod 2>$null
        if ($LASTEXITCODE -ne 0) { terraform workspace new prod }
        terraform init -backend-config=$BackendFile
        terraform apply -auto-approve
    }
    "promote" {
        Write-Host "Promoting local state to remote..."
        Copy-Item backend-remote.tf backend.tf -Force
        terraform init -migrate-state
    }
    Default {
        Write-Host "Usage: .\tf-workflow.ps1 [dev|prod|promote] [backend-config-file]"
    }
}
```

Usage:
```Powershell
.\tf-workflow.ps1 -Workspace dev
.\tf-workflow.ps1 -Workspace prod
.\tf-workflow.ps1 -Workspace promote
```

💡 How this helps you

- You can run one command to switch environments and apply changes.
- Works across Linux, macOS, and Windows without changing Terraform code.
- Promotion is just a single step (promote) that migrates local state to remote.



#  Release Tagging

We can extend these scripts so that they also tag all resources with the environment name automatically.

That way, your AWS/GCP/Azure resources are always labeled correctly, whenever you promote an environment.

.


When you promote or apply in a workspace, Terraform tags all resources with the environment name (dev| prod).

The following enhances the Makefile, Bash, and PowerShell scripts so that: 

- Adding a var.environment variable to Terraform.
- Passing the workspace name into Terraform automatically.
- Ensuring tags are applied to all supported resources.


1. Terraform Code Changes (One-Time Setup)


```hcl
# variables.tf
variable "environment" {
  type        = string
  description = "Environment name (dev, prod, etc.)"
}

Example AWS Resource with Tagging

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-${var.environment}"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```


2. Updated Makefile

```Makefile
WORKSPACE ?= dev
BACKEND_FILE ?= backend-local.tf

dev:
	@echo "Switching to dev workspace..."
	terraform workspace select dev || terraform workspace new dev
	terraform init -backend-config=$(BACKEND_FILE)
	terraform apply -auto-approve -var="environment=dev"

prod:
	@echo "Switching to prod workspace..."
	terraform workspace select prod || terraform workspace new prod
	terraform init -backend-config=$(BACKEND_FILE)
	terraform apply -auto-approve -var="environment=prod"

promote:
	@echo "Promoting local state to remote..."
	cp backend-remote.tf backend.tf
	terraform init -migrate-state
	terraform apply -auto-approve -var="environment=$(WORKSPACE)"
```


3. Updated Pure Bash Script
   
```bash
#!/usr/bin/env bash
set -e

WORKSPACE=${1:-dev}
BACKEND_FILE=${2:-backend-local.tf}

case "$WORKSPACE" in
  dev|prod)
    echo "Switching to $WORKSPACE workspace..."
    terraform workspace select "$WORKSPACE" || terraform workspace new "$WORKSPACE"
    terraform init -backend-config="$BACKEND_FILE"
    terraform apply -auto-approve -var="environment=$WORKSPACE"
    ;;
  promote)
    echo "Promoting local state to remote..."
    cp backend-remote.tf backend.tf
    terraform init -migrate-state
    terraform apply -auto-approve -var="environment=$(terraform workspace show)"
    ;;
  *)
    echo "Usage: $0 [dev|prod|promote] [backend-config-file]"
    exit 1
    ;;
esac
```


4. Updated Pure PowerShell Script

```Powershell
param(
    [string]$Workspace = "dev",
    [string]$BackendFile = "backend-local.tf"
)

switch ($Workspace) {
    "dev" {
        Write-Host "Switching to dev workspace..."
        terraform workspace select dev 2>$null
        if ($LASTEXITCODE -ne 0) { terraform workspace new dev }
        terraform init -backend-config=$BackendFile
        terraform apply -auto-approve -var="environment=dev"
    }
    "prod" {
        Write-Host "Switching to prod workspace..."
        terraform workspace select prod 2>$null
        if ($LASTEXITCODE -ne 0) { terraform workspace new prod }
        terraform init -backend-config=$BackendFile
        terraform apply -auto-approve -var="environment=prod"
    }
    "promote" {
        Write-Host "Promoting local state to remote..."
        Copy-Item backend-remote.tf backend.tf -Force
        terraform init -migrate-state
        $currentWorkspace = terraform workspace show
        terraform apply -auto-approve -var="environment=$currentWorkspace"
    }
    Default {
        Write-Host "Usage: .\tf-workflow.ps1 [dev|prod|promote] [backend-config-file]"
    }
}
```

✅ What’s new with tagging automation

- Every apply now injects the workspace name into Terraform as var.environment.
- All resources can use this variable for tagging, naming, or labeling.
- Promotion keeps the correct environment tag without manual edits.




# Production Safety Prompt


Finally we can a production safety prompt so you can’t accidentally apply changes to production.


- If the workspace is prod, the script prompts for confirmation.
- You must type YES (in all caps) for the rollout to proceed.
- If you don’t confirm, the script aborst andd exits.


1. Updated Makefile

```Makefile
WORKSPACE ?= dev
BACKEND_FILE ?= backend-local.tf

confirm-prod:
	@if [ "$(WORKSPACE)" = "prod" ]; then \
		read -p "⚠️  You are about to apply changes to PRODUCTION. Type YES to continue: " ans; \
		if [ "$$ans" != "YES" ]; then \
			echo "❌ Aborted."; \
			exit 1; \
		fi; \
	fi

dev:
	@echo "Switching to dev workspace..."
	terraform workspace select dev || terraform workspace new dev
	terraform init -backend-config=$(BACKEND_FILE)
	terraform apply -auto-approve -var="environment=dev"

prod: confirm-prod
	@echo "Switching to prod workspace..."
	terraform workspace select prod || terraform workspace new prod
	terraform init -backend-config=$(BACKEND_FILE)
	terraform apply -auto-approve -var="environment=prod"

promote: confirm-prod
	@echo "Promoting local state to remote..."
	cp backend-remote.tf backend.tf
	terraform init -migrate-state
	terraform apply -auto-approve -var="environment=$(WORKSPACE)"
```


2. Updated Pure Bash Script

```bash
#!/usr/bin/env bash
set -e

WORKSPACE=${1:-dev}
BACKEND_FILE=${2:-backend-local.tf}

confirm_prod() {
  if [ "$WORKSPACE" = "prod" ]; then
    read -p "⚠️  You are about to apply changes to PRODUCTION. Type YES to continue: " ans
    if [ "$ans" != "YES" ]; then
      echo "❌ Aborted."
      exit 1
    fi
  fi
}

case "$WORKSPACE" in
  dev|prod)
    confirm_prod
    echo "Switching to $WORKSPACE workspace..."
    terraform workspace select "$WORKSPACE" || terraform workspace new "$WORKSPACE"
    terraform init -backend-config="$BACKEND_FILE"
    terraform apply -auto-approve -var="environment=$WORKSPACE"
    ;;
  promote)
    confirm_prod
    echo "Promoting local state to remote..."
    cp backend-remote.tf backend.tf
    terraform init -migrate-state
    terraform apply -auto-approve -var="environment=$(terraform workspace show)"
    ;;
  *)
    echo "Usage: $0 [dev|prod|promote] [backend-config-file]"
    exit 1
    ;;
esac
```

3. Updated Pure PowerShell Script

```Powershell
param(
    [string]$Workspace = "dev",
    [string]$BackendFile = "backend-local.tf"
)

function Confirm-Prod {
    if ($Workspace -eq "prod") {
        $ans = Read-Host "⚠️  You are about to apply changes to PRODUCTION. Type YES to continue"
        if ($ans -ne "YES") {
            Write-Host "❌ Aborted."
            exit 1
        }
    }
}

switch ($Workspace) {
    "dev" {
        Confirm-Prod
        Write-Host "Switching to dev workspace..."
        terraform workspace select dev 2>$null
        if ($LASTEXITCODE -ne 0) { terraform workspace new dev }
        terraform init -backend-config=$BackendFile
        terraform apply -auto-approve -var="environment=dev"
    }
    "prod" {
        Confirm-Prod
        Write-Host "Switching to prod workspace..."
        terraform workspace select prod 2>$null
        if ($LASTEXITCODE -ne 0) { terraform workspace new prod }
        terraform init -backend-config=$BackendFile
        terraform apply -auto-approve -var="environment=prod"
    }
    "promote" {
        Confirm-Prod
        Write-Host "Promoting local state to remote..."
        Copy-Item backend-remote.tf backend.tf -Force
        terraform init -migrate-state
        $currentWorkspace = terraform workspace show
        terraform apply -auto-approve -var="environment=$currentWorkspace"
    }
    Default {
        Write-Host "Usage: .\tf-workflow.ps1 [dev|prod|promote] [backend-config-file]"
```

