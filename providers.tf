provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.aks.admin_host
  client_certificate     = base64decode(module.aks.admin_client_certificate)
  client_key             = base64decode(module.aks.admin_client_key)
  cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.admin_client_certificate)
    client_key             = base64decode(module.aks.admin_client_key)
    cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
  }
}