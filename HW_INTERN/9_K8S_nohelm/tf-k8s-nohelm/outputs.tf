output "Resource-Group-Name-prod" {
  value = module.prod_cluster.Resource-Group-Name
}

output "AKS-cluster-FQDN-prod" {
  value = module.prod_cluster.AKS-cluster-FQDN
}

output "ACR-ID-prod" {
  value = module.prod_cluster.ACR-ID
}

######################################################################

#output "Resource-Group-Name-dev" {
#  value = module.dev_cluster.Resource-Group-Name
#}

#output "AKS-cluster-FQDN-dev" {
#  value = module.dev_cluster.AKS-cluster-FQDN
#}

#output "ACR-ID-dev" {
#  value = module.dev_cluster.ACR-ID
#}



