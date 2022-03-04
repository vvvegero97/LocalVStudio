output "Resource-Group-Name" {
  value       = azurerm_resource_group.rg.id
  description = "Name of created resource group"
}

output "Container-Registry-ID" {
  value       = azurerm_container_registry.acr.id
  description = "Container Registry ID."
}

output "Cluster-FQDN" {
  value       = azurerm_kubernetes_cluster.aks.fqdn
  description = "Cluster Fully Qualified Domain Name."
}