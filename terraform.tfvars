subscription_id                      = "405b92ea-9996-4799-84aa-32efee0a5031"
resource_group_name                  = "rg-tech-mobile-dev"
location                             = "eastus"
prefix                               = "tech-mobile-dev"
cluster_name                         = "aks-tech-mobile-dev"
vnet_name                            = "vnet-tech-mobile-dev"
cluster_log_analytics_workspace_name = "law-tech-mobile-dev"
identity_type                        = "UserAssigned"
key_vault_secrets_provider_enabled   = true
secret_rotation_enabled              = true
private_cluster_enabled              = false
oidc_issuer_enabled                  = true
workload_identity_enabled            = true
enable_auto_scaling                  = true
agents_availability_zones            = ["1", "2", "3"]
agents_min_count                     = 2
agents_max_count                     = 10
agents_max_pods                      = 100
agents_pool_name                     = "default"
kubernetes_version                   = "1.30.9"
agents_labels = {
  "nodepool" : "defaultnodepool"
}
agents_tags = {
  "Agent" = "defaultnodepoolagent"
}

node_pools = {
  workload = {
    name                = "workload"
    vm_size             = "Standard_DS3_v2"
    os_disk_size_gb     = 128
    enable_auto_scaling = true
  }
}

argocd_chart_version       = "7.8.2"
net_profile_dns_service_ip = "10.0.0.10"
net_profile_service_cidr   = "10.0.0.0/16"
address_spaces             = ["10.52.0.0/16"]
subnet_prefixes            = ["10.52.0.0/24", "10.52.1.0/26"]
subnet_names               = ["aks", "pe"]

key_vault_name                          = "kv-tech-mobile-dev"
key_vault_sku_name                      = "standard"
audience                                = ["api://AzureADTokenExchange"]
key_vault_enable_telemetry              = false
key_vault_public_network_access_enabled = false
service_account_name                    = "external-secrets-sa"
service_account_namespace               = "external-secrets"
key_vault_purge_protection_enabled      = false
