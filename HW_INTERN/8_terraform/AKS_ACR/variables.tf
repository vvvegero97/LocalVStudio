variable "resource_group_name" {
  type        = string
  default     = "TerraformAKSrg"
  description = "Name of the resource group."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Select a location."
}

variable "acrName" {
  type        = string
  default     = "vegeromyacr1"
  description = "Name of Azure Container Registry."
}

variable "clusterName" {
  type        = string
  default     = "vegero-aks1"
  description = "Name of AKS cluster."
}

variable "clusterDNSprefix" {
  type        = string
  default     = "vegeroaks1"
  description = "AKS cluster DNS prefix."
}