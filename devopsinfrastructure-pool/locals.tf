locals {
  azure_devops_organization_name = "devopsinfra-${var.location}-demo"
  dev_center_name                = "devc-devops-${var.location}-demo"
  dev_center_project_name        = "devcp-devopsinfra-${var.location}-demo"
  managed_devops_pool_name       = "mdp-${var.location}-demo"
  resource_group_name            = "rg-devopsinfra-${var.location}-demo"
  subnet_name                    = "snet-devopsinfra-${var.location}-demo"
  virtual_network_name           = "vnet-devopsinfra-${var.location}-demo"
}