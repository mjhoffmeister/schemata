# Prerequisites

Before you use Managed DevOps Pools for the first time, you'll need to plan and
prepare your environment, considering:
* [Resource providers](#resource-providers)
* [Virtual machine quotas](#virtual-machine-quotas)
* [Dev center and dev center project](#dev-center-and-dev-center-project)

## Resource providers

The following resource providers must be registered in your Azure subscription
for Managed DevOps Pools.

* `Microsoft.DevOpsInfrastructure`
* `Microsoft.DevCenter`

Use the following steps to register them using the Azure CLI. Alternatively, you
can use the [Azure portal](https://learn.microsoft.com/en-us/azure/devops/managed-devops-pools/prerequisites?view=azure-devops&tabs=azure-portal#register-the-managed-devops-pools-resource-provider-in-your-azure-subscription)
or [PowerShell](https://learn.microsoft.com/en-us/azure/devops/managed-devops-pools/prerequisites?view=azure-devops&tabs=powershell#register-the-managed-devops-pools-resource-provider-in-your-azure-subscription).

> [!NOTE]
> You must have the Owner or Contributor role on your subscription to register
resource providers.

1. Log into Azure with `az login`. Select the subscription you want to configure
for Managed DevOps Pools. (See [az account set](https://learn.microsoft.com/en-us/cli/azure/account?view=azure-cli-latest#az-account-set) for more information.)
1. Run `az provider register --namespace 'Microsoft.DevOpsInfrastructure'` to
register the resource provider for Managed DevOps pools.
1. Run `az provider register --namespace 'Microsoft.DevCenter'` to register the
resource providers for dev center and dev center project, which are required
for Managed DevOps pools.

## Virtual machine quotas

The default virtual machine (VM) SKU for Managed DevOps pools is
**Standard D2ads v5**, which uses two cores per VM. The default quota for
that SKU in regions that support Managed DevOps Pools is five cores. So, if you
plan to create a pool with more than two agents (four cores), you'll need to 
[request a quota adjustment](https://learn.microsoft.com/en-us/azure/devops/managed-devops-pools/prerequisites?view=azure-devops&tabs=azure-cli#request-a-quota-adjustment). See
[Review Managed DevOps Pools quotas](https://learn.microsoft.com/en-us/azure/devops/managed-devops-pools/prerequisites?view=azure-devops&tabs=azure-cli#review-managed-devops-pools-quotas) for more information.

## Dev center and dev center project

Managed DevOps Pools require a dev center and dev center project. These will
be included in the Terraform configuration in this repo, but you can also
[create them manually](https://learn.microsoft.com/en-us/azure/devops/managed-devops-pools/prerequisites?view=azure-devops&tabs=azure-portal#create-a-dev-center-and-dev-center-project).

# Terraform Configuration

This repository contains Terraform configurations to demonstrate creating
Managed DevOps Pools. The main configuration file is `main.tf`, which defines
the resources and modules needed for the setup.

## Variables

The configuration uses several variables defined in `variables.tf`. You can
customize these variables by creating a `.tfvars` file, such as `demo.tfvars`,
and specifying the values.

Example `demo.tfvars`:
```hcl
azure_devops_organization_name    = "MyOrg"
azure_devops_project_names        = ["My Project"]
devopsinfrastructure_principal_id = "<Enter the object ID for the DevOpsInfrastructure principal in your Azure tenant>"
enable_network_creation           = true # Only recommended for demos
subscription_id                   = "<Enter your Azure subscription id>"
```

`locals.tf` is used to generate opinionated variable values incorporating
`location` when not explicitly specified. The required variables are below.

* `azure_devops_organization_name`
* `azure_devops_project_names`
* `devopsinfrastructure_principal_id`
* `subscription_id`

The values for all other variables will be automatically generated per
`locals.tf` if not specified.

## Execution

To apply the Terraform configuration, follow these steps:

1. Initialize the Terraform configuration:
    ```sh
    terraform init
    ```

2. Validate the configuration:
    ```sh
    terraform validate
    ```

3. Plan the deployment:
    ```sh
    terraform plan -var-file="demo.tfvars"
    ```

4. Apply the configuration:
    ```sh
    terraform apply -var-file="demo.tfvars"
    ```

This will create the necessary resources in your Azure subscription for
Managed DevOps Pools.

## Cleanup

To destroy the resources created by the Terraform configuration, run the following command:
```sh
terraform destroy -var-file="demo.tfvars"
```

This will remove all the resources created by the configuration from your Azure subscription.