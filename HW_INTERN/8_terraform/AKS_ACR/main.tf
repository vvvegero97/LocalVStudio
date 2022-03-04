# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# set up resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = "Terraform AKS with container registry"
    Team        = "DevOps"
  }
}

# create azure container registry
resource "azurerm_container_registry" "acr" {
  name                = var.acrName
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku = "Standard"
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# create k8s cluster with 1 node and max 2 pods
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.clusterName
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.clusterDNSprefix # optional
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    # max_pods   = 10 # optional, minimum (10 max_pods * node_count) count
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Environment = "Production"
  }
  depends_on = [
    azurerm_resource_group.rg
  ]
}

# role for system assigned identity for k8s to access ACR
resource "azurerm_role_assignment" "rbac" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_kubernetes_cluster.aks,
    azurerm_container_registry.acr
  ]
}