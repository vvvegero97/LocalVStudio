# set up resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.clusterName}-${var.env_name}"
  location = var.location
  tags     = {
    Environment = "Terraform AKS with container registry"
    Team        = "DevOps"
  }
}

# create azure container registry
resource "azurerm_container_registry" "acr" {
  name                = var.acrName
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.rg]
}

# create k8s cluster with 1 node
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.clusterName}-${var.env_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.clusterDNSprefix}-${var.env_name}" # optional
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.instance_type
    # max_pods   = 10 # optional, minimum (10 max_pods * node_count) count
  }
  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    http_application_routing {
        enabled = true
    }
  }
  tags = {
    Environment = var.env_tag
  }
  depends_on = [azurerm_resource_group.rg]
}

# role for system assigned identity for k8s to access ACR
resource "azurerm_role_assignment" "rbac" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
  depends_on                       = [azurerm_kubernetes_cluster.aks, azurerm_container_registry.acr]
}