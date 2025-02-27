module "network" {
  source              = "Azure/network/azurerm"
  version             = "5.3.0"
  resource_group_name = local.resource_group_name
  use_for_each        = var.use_for_each
  vnet_name           = var.vnet_name
  address_spaces      = var.address_spaces
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  tags                = local.tags
}

module "aks" {
  source                               = "Azure/aks/azurerm"
  version                              = "9.4.1"
  resource_group_name                  = local.resource_group_name
  location                             = local.location
  cluster_name                         = local.cluster_name
  prefix                               = var.prefix
  sku_tier                             = var.sku_tier
  kubernetes_version                   = var.kubernetes_version
  network_plugin                       = var.network_plugin
  network_policy                       = var.network_policy
  network_plugin_mode                  = var.network_plugin_mode
  vnet_subnet_id                       = module.network.vnet_subnets[0]
  os_disk_size_gb                      = var.os_disk_size_gb
  private_cluster_enabled              = var.private_cluster_enabled
  oidc_issuer_enabled                  = var.oidc_issuer_enabled
  workload_identity_enabled            = var.workload_identity_enabled
  key_vault_secrets_provider_enabled   = var.key_vault_secrets_provider_enabled
  secret_rotation_enabled              = var.secret_rotation_enabled
  secret_rotation_interval             = var.secret_rotation_interval
  kms_enabled                          = var.kms_enabled
  enable_auto_scaling                  = var.enable_auto_scaling
  agents_min_count                     = var.agents_min_count
  agents_max_count                     = var.agents_max_count
  agents_count                         = var.agents_count
  agents_max_pods                      = var.agents_max_pods
  agents_pool_name                     = var.agents_pool_name
  agents_availability_zones            = var.agents_availability_zones
  agents_type                          = var.agents_type
  node_pools                           = { for k, v in var.node_pools : k => merge(v, { vnet_subnet_id = module.network.vnet_subnets[0] }) }
  rbac_aad                             = var.rbac_aad
  rbac_aad_managed                     = var.rbac_aad_managed
  role_based_access_control_enabled    = var.role_based_access_control_enabled
  rbac_aad_azure_rbac_enabled          = var.rbac_aad_azure_rbac_enabled
  identity_type                        = var.identity_type
  identity_ids                         = [azurerm_user_assigned_identity.uami.id]
  agents_size                          = var.agents_size
  agents_labels                        = var.agents_labels
  agents_tags                          = merge(local.tags, var.agents_tags)
  net_profile_dns_service_ip           = var.net_profile_dns_service_ip
  net_profile_service_cidr             = var.net_profile_service_cidr
  cluster_log_analytics_workspace_name = var.cluster_log_analytics_workspace_name
  depends_on                           = [module.network]
  tags                                 = local.tags
}

resource "azurerm_user_assigned_identity" "uami" {
  resource_group_name = local.resource_group_name
  location            = local.location
  name                = "uami-${var.cluster_name}"
}

module "key_vault" {
  source                        = "Azure/avm-res-keyvault-vault/azurerm"
  name                          = local.key_vault_name
  location                      = local.location
  resource_group_name           = local.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  public_network_access_enabled = var.key_vault_public_network_access_enabled
  purge_protection_enabled      = var.key_vault_purge_protection_enabled
  sku_name                      = var.key_vault_sku_name
  secrets                       = var.key_vault_secrets
  keys                          = var.key_vault_keys
  enable_telemetry              = var.key_vault_enable_telemetry
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.kv_dns.id]
      subnet_resource_id            = module.network.vnet_subnets[1]
    }
  }
  tags = local.tags
}

resource "azurerm_private_dns_zone" "kv_dns" {
  name                = var.key_vault_private_dns_zone_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = local.vnet_link_name
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns.name
  virtual_network_id    = module.network.vnet_id
  registration_enabled  = true
  depends_on            = [module.network]
}

resource "azurerm_role_assignment" "key_vault" {
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
  scope                = module.key_vault.resource_id
}

# resource "azurerm_federated_identity_credential" "federated_credential" {
#   name                = "fe-${local.key_vault_name}"
#   resource_group_name = local.resource_group_name
#   parent_id           = azurerm_user_assigned_identity.uami.id
#   audience            = var.audience
#   issuer              = module.aks.oidc_issuer_url
#   subject             = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
# }

# resource "helm_release" "argocd" {
#   name             = "argocd"
#   repository       = "https://argoproj.github.io/argo-helm"
#   chart            = "argo-cd"
#   namespace        = "argocd"
#   version          = var.argocd_chart_version
#   create_namespace = true
#   set {
#     name  = "server.service.type"
#     value = "LoadBalancer"
#   }
#   depends_on = [module.aks]
# }