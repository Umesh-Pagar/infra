
locals {
  cluster_name        = var.cluster_name
  key_vault_name      = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location != null ? var.location : data.azurerm_resource_group.rg.location
  vnet_link_name      = "kv-dns-vnet-link"

  tags = {
    Project     = "TECH-MOBILE"
    Environment = "dev"
  }
}
