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

module "prod_cluster" {
    source        = "./modules/main"
    env_name      = "prod"
    clusterName   = "vegero-aks1"
    instance_type = "Standard_D11_v2"
    env_tag       = "Production"
    acrName       = "VegeroProdACR"
}

#module "dev_cluster" {
#    source        = "./modules/main"
#    env_name      = "dev"
#    clusterName   = "vegero-aks1"
#    instance_type = "Standard_D2_v2"
#    env_tag       = "Development"
#    acrName       = "DevACR"
#}