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

variable "clusterDNSprefix" {
  type        = string
  default     = "vegeroaks1"
  description = "AKS cluster DNS prefix."
}

############################################ variables for module

variable "env_name" {
  type        = string
  description = "The environment for the AKS cluster"
}

variable "clusterName" {
  type        = string
  default     = "vegero-aks1"
  description = "Name of AKS cluster."
}

variable "instance_type" {
  type        = string
  description = "Instance type for cluster nodes"
  default     = "Standard_DS2_v2"
}

variable "env_tag" {
  type        = string
  description = "Environment tag"
}

variable "acrName" {
  type        = string
  description = "Name of Azure Container Registry."
}