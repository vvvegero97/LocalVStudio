output "Resource-Group-Name" {
  value = azurerm_resource_group.rg.name
}

output "AKS-cluster-FQDN" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "ACR-ID" {
  value = azurerm_container_registry.acr.id
}

output "ACR-NAME" {
  value = azurerm_container_registry.acr.name
}

output "ACR-URL" {
  value = azurerm_container_registry.acr.login_server
}

resource "local_file" "kubeconfig" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  filename   = "${var.env_name}-kubeconfig"
  content    = azurerm_kubernetes_cluster.aks.kube_config_raw
}