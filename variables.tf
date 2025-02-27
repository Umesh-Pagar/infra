variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
}

variable "location" {
  description = "The location in which to create the AKS cluster."
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID in which to create the AKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "prefix" {
  type        = string
  default     = ""
  description = "(Optional) The prefix for the resources created in the specified Azure Resource Group. Omitting this variable requires both `var.cluster_log_analytics_workspace_name` and `var.cluster_name` have been set."
  nullable    = false
}

variable "private_cluster_enabled" {
  type        = bool
  default     = false
  description = "If true cluster API server will be exposed only on internal IP address and available only in cluster vnet."
}

variable "net_profile_dns_service_ip" {
  type        = string
  default     = null
  description = "(Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Changing this forces a new resource to be created."
}

variable "net_profile_outbound_type" {
  type        = string
  default     = "loadBalancer"
  description = "(Optional) The outbound (egress) routing method which should be used for this Kubernetes Cluster. Possible values are loadBalancer and userDefinedRouting. Defaults to loadBalancer."
}

variable "net_profile_pod_cidr" {
  type        = string
  default     = null
  description = " (Optional) The CIDR to use for pod IP addresses. This field can only be set when network_plugin is set to kubenet or network_plugin is set to azure and network_plugin_mode is set to overlay. Changing this forces a new resource to be created."
}

variable "net_profile_service_cidr" {
  type        = string
  default     = null
  description = "(Optional) The Network Range used by the Kubernetes service. Changing this forces a new resource to be created."
}

variable "network_contributor_role_assigned_subnet_ids" {
  type        = map(string)
  default     = {}
  description = "Create role assignments for the AKS Service Principal to be a Network Contributor on the subnets used for the AKS Cluster, key should be static string, value should be subnet's id"
  nullable    = false
}

variable "network_plugin" {
  type        = string
  default     = "azure"
  description = "Network plugin to use for networking."
  nullable    = false
}

variable "network_plugin_mode" {
  type        = string
  default     = null
  description = "(Optional) Specifies the network plugin mode used for building the Kubernetes network. Possible value is `overlay`. Changing this forces a new resource to be created."
}

variable "network_policy" {
  type        = string
  default     = "azure"
  description = " (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
}

variable "oidc_issuer_enabled" {
  type        = bool
  default     = false
  description = "Enable or Disable the OIDC issuer URL. Defaults to false."
}

variable "workload_identity_enabled" {
  type        = bool
  default     = false
  description = "Enable or Disable Workload Identity. Defaults to false."
}

variable "enable_auto_scaling" {
  type        = bool
  default     = false
  description = "Enable node pool autoscaling"
}

variable "os_disk_size_gb" {
  type        = number
  default     = 50
  description = "Disk size of nodes in GBs."
}

variable "admin_username" {
  type        = string
  default     = null
  description = "The username of the local administrator to be created on the Kubernetes cluster. Set this variable to `null` to turn off the cluster's `linux_profile`. Changing this forces a new resource to be created."
}

variable "agents_availability_zones" {
  type        = list(string)
  default     = null
  description = "(Optional) A list of Availability Zones across which the Node Pool should be spread. Changing this forces a new resource to be created."
}

variable "node_pools" {
  type = map(object({
    name                          = string
    node_count                    = optional(number)
    tags                          = optional(map(string))
    vm_size                       = string
    host_group_id                 = optional(string)
    capacity_reservation_group_id = optional(string)
    custom_ca_trust_enabled       = optional(bool)
    enable_auto_scaling           = optional(bool)
    enable_host_encryption        = optional(bool)
    enable_node_public_ip         = optional(bool)
    eviction_policy               = optional(string)
    gpu_instance                  = optional(string)
    kubelet_config = optional(object({
      cpu_manager_policy        = optional(string)
      cpu_cfs_quota_enabled     = optional(bool)
      cpu_cfs_quota_period      = optional(string)
      image_gc_high_threshold   = optional(number)
      image_gc_low_threshold    = optional(number)
      topology_manager_policy   = optional(string)
      allowed_unsafe_sysctls    = optional(set(string))
      container_log_max_size_mb = optional(number)
      container_log_max_files   = optional(number)
      pod_max_pid               = optional(number)
    }))
    linux_os_config = optional(object({
      sysctl_config = optional(object({
        fs_aio_max_nr                      = optional(number)
        fs_file_max                        = optional(number)
        fs_inotify_max_user_watches        = optional(number)
        fs_nr_open                         = optional(number)
        kernel_threads_max                 = optional(number)
        net_core_netdev_max_backlog        = optional(number)
        net_core_optmem_max                = optional(number)
        net_core_rmem_default              = optional(number)
        net_core_rmem_max                  = optional(number)
        net_core_somaxconn                 = optional(number)
        net_core_wmem_default              = optional(number)
        net_core_wmem_max                  = optional(number)
        net_ipv4_ip_local_port_range_min   = optional(number)
        net_ipv4_ip_local_port_range_max   = optional(number)
        net_ipv4_neigh_default_gc_thresh1  = optional(number)
        net_ipv4_neigh_default_gc_thresh2  = optional(number)
        net_ipv4_neigh_default_gc_thresh3  = optional(number)
        net_ipv4_tcp_fin_timeout           = optional(number)
        net_ipv4_tcp_keepalive_intvl       = optional(number)
        net_ipv4_tcp_keepalive_probes      = optional(number)
        net_ipv4_tcp_keepalive_time        = optional(number)
        net_ipv4_tcp_max_syn_backlog       = optional(number)
        net_ipv4_tcp_max_tw_buckets        = optional(number)
        net_ipv4_tcp_tw_reuse              = optional(bool)
        net_netfilter_nf_conntrack_buckets = optional(number)
        net_netfilter_nf_conntrack_max     = optional(number)
        vm_max_map_count                   = optional(number)
        vm_swappiness                      = optional(number)
        vm_vfs_cache_pressure              = optional(number)
      }))
      transparent_huge_page_enabled = optional(string)
      transparent_huge_page_defrag  = optional(string)
      swap_file_size_mb             = optional(number)
    }))
    fips_enabled       = optional(bool)
    kubelet_disk_type  = optional(string)
    max_count          = optional(number)
    max_pods           = optional(number)
    message_of_the_day = optional(string)
    mode               = optional(string, "User")
    min_count          = optional(number)
    node_network_profile = optional(object({
      node_public_ip_tags = optional(map(string))
    }))
    node_labels                  = optional(map(string))
    node_public_ip_prefix_id     = optional(string)
    node_taints                  = optional(list(string))
    orchestrator_version         = optional(string)
    os_disk_size_gb              = optional(number)
    os_disk_type                 = optional(string, "Managed")
    os_sku                       = optional(string)
    os_type                      = optional(string, "Linux")
    pod_subnet_id                = optional(string)
    priority                     = optional(string, "Regular")
    proximity_placement_group_id = optional(string)
    spot_max_price               = optional(number)
    scale_down_mode              = optional(string, "Delete")
    snapshot_id                  = optional(string)
    ultra_ssd_enabled            = optional(bool)
    vnet_subnet_id               = optional(string)
    upgrade_settings = optional(object({
      drain_timeout_in_minutes      = number
      node_soak_duration_in_minutes = number
      max_surge                     = string
    }))
    windows_profile = optional(object({
      outbound_nat_enabled = optional(bool, true)
    }))
    workload_runtime      = optional(string)
    zones                 = optional(set(string))
    create_before_destroy = optional(bool, true)
  }))
  default     = {}
  description = <<-EOT
  A map of node pools that need to be created and attached on the Kubernetes cluster. The key of the map can be the name of the node pool, and the key must be static string. The value of the map is a `node_pool` block as defined below:
  map(object({
    name                          = (Required) The name of the Node Pool which should be created within the Kubernetes Cluster. Changing this forces a new resource to be created. A Windows Node Pool cannot have a `name` longer than 6 characters. A random suffix of 4 characters is always added to the name to avoid clashes during recreates.
    node_count                    = (Optional) The initial number of nodes which should exist within this Node Pool. Valid values are between `0` and `1000` (inclusive) for user pools and between `1` and `1000` (inclusive) for system pools and must be a value in the range `min_count` - `max_count`.
    tags                          = (Optional) A mapping of tags to assign to the resource. At this time there's a bug in the AKS API where Tags for a Node Pool are not stored in the correct case - you [may wish to use Terraform's `ignore_changes` functionality to ignore changes to the casing](https://www.terraform.io/language/meta-arguments/lifecycle#ignore_changess) until this is fixed in the AKS API.
    vm_size                       = (Required) The SKU which should be used for the Virtual Machines used in this Node Pool. Changing this forces a new resource to be created.
    host_group_id                 = (Optional) The fully qualified resource ID of the Dedicated Host Group to provision virtual machines from. Changing this forces a new resource to be created.
    capacity_reservation_group_id = (Optional) Specifies the ID of the Capacity Reservation Group where this Node Pool should exist. Changing this forces a new resource to be created.
    custom_ca_trust_enabled       = (Optional) Specifies whether to trust a Custom CA. This requires that the Preview Feature `Microsoft.ContainerService/CustomCATrustPreview` is enabled and the Resource Provider is re-registered, see [the documentation](https://learn.microsoft.com/en-us/azure/aks/custom-certificate-authority) for more information.
    enable_auto_scaling           = (Optional) Whether to enable [auto-scaler](https://docs.microsoft.com/azure/aks/cluster-autoscaler).
    enable_host_encryption        = (Optional) Should the nodes in this Node Pool have host encryption enabled? Changing this forces a new resource to be created.
    enable_node_public_ip         = (Optional) Should each node have a Public IP Address? Changing this forces a new resource to be created.
    eviction_policy               = (Optional) The Eviction Policy which should be used for Virtual Machines within the Virtual Machine Scale Set powering this Node Pool. Possible values are `Deallocate` and `Delete`. Changing this forces a new resource to be created. An Eviction Policy can only be configured when `priority` is set to `Spot` and will default to `Delete` unless otherwise specified.
    gpu_instance                  = (Optional) Specifies the GPU MIG instance profile for supported GPU VM SKU. The allowed values are `MIG1g`, `MIG2g`, `MIG3g`, `MIG4g` and `MIG7g`. Changing this forces a new resource to be created.
    kubelet_config = optional(object({
      cpu_manager_policy        = (Optional) Specifies the CPU Manager policy to use. Possible values are `none` and `static`, Changing this forces a new resource to be created.
      cpu_cfs_quota_enabled     = (Optional) Is CPU CFS quota enforcement for containers enabled? Changing this forces a new resource to be created.
      cpu_cfs_quota_period      = (Optional) Specifies the CPU CFS quota period value. Changing this forces a new resource to be created.
      image_gc_high_threshold   = (Optional) Specifies the percent of disk usage above which image garbage collection is always run. Must be between `0` and `100`. Changing this forces a new resource to be created.
      image_gc_low_threshold    = (Optional) Specifies the percent of disk usage lower than which image garbage collection is never run. Must be between `0` and `100`. Changing this forces a new resource to be created.
      topology_manager_policy   = (Optional) Specifies the Topology Manager policy to use. Possible values are `none`, `best-effort`, `restricted` or `single-numa-node`. Changing this forces a new resource to be created.
      allowed_unsafe_sysctls    = (Optional) Specifies the allow list of unsafe sysctls command or patterns (ending in `*`). Changing this forces a new resource to be created.
      container_log_max_size_mb = (Optional) Specifies the maximum size (e.g. 10MB) of container log file before it is rotated. Changing this forces a new resource to be created.
      container_log_max_files   = (Optional) Specifies the maximum number of container log files that can be present for a container. must be at least 2. Changing this forces a new resource to be created.
      pod_max_pid               = (Optional) Specifies the maximum number of processes per pod. Changing this forces a new resource to be created.
    }))
    linux_os_config = optional(object({
      sysctl_config = optional(object({
        fs_aio_max_nr                      = (Optional) The sysctl setting fs.aio-max-nr. Must be between `65536` and `6553500`. Changing this forces a new resource to be created.
        fs_file_max                        = (Optional) The sysctl setting fs.file-max. Must be between `8192` and `12000500`. Changing this forces a new resource to be created.
        fs_inotify_max_user_watches        = (Optional) The sysctl setting fs.inotify.max_user_watches. Must be between `781250` and `2097152`. Changing this forces a new resource to be created.
        fs_nr_open                         = (Optional) The sysctl setting fs.nr_open. Must be between `8192` and `20000500`. Changing this forces a new resource to be created.
        kernel_threads_max                 = (Optional) The sysctl setting kernel.threads-max. Must be between `20` and `513785`. Changing this forces a new resource to be created.
        net_core_netdev_max_backlog        = (Optional) The sysctl setting net.core.netdev_max_backlog. Must be between `1000` and `3240000`. Changing this forces a new resource to be created.
        net_core_optmem_max                = (Optional) The sysctl setting net.core.optmem_max. Must be between `20480` and `4194304`. Changing this forces a new resource to be created.
        net_core_rmem_default              = (Optional) The sysctl setting net.core.rmem_default. Must be between `212992` and `134217728`. Changing this forces a new resource to be created.
        net_core_rmem_max                  = (Optional) The sysctl setting net.core.rmem_max. Must be between `212992` and `134217728`. Changing this forces a new resource to be created.
        net_core_somaxconn                 = (Optional) The sysctl setting net.core.somaxconn. Must be between `4096` and `3240000`. Changing this forces a new resource to be created.
        net_core_wmem_default              = (Optional) The sysctl setting net.core.wmem_default. Must be between `212992` and `134217728`. Changing this forces a new resource to be created.
        net_core_wmem_max                  = (Optional) The sysctl setting net.core.wmem_max. Must be between `212992` and `134217728`. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_min   = (Optional) The sysctl setting net.ipv4.ip_local_port_range min value. Must be between `1024` and `60999`. Changing this forces a new resource to be created.
        net_ipv4_ip_local_port_range_max   = (Optional) The sysctl setting net.ipv4.ip_local_port_range max value. Must be between `1024` and `60999`. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh1  = (Optional) The sysctl setting net.ipv4.neigh.default.gc_thresh1. Must be between `128` and `80000`. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh2  = (Optional) The sysctl setting net.ipv4.neigh.default.gc_thresh2. Must be between `512` and `90000`. Changing this forces a new resource to be created.
        net_ipv4_neigh_default_gc_thresh3  = (Optional) The sysctl setting net.ipv4.neigh.default.gc_thresh3. Must be between `1024` and `100000`. Changing this forces a new resource to be created.
        net_ipv4_tcp_fin_timeout           = (Optional) The sysctl setting net.ipv4.tcp_fin_timeout. Must be between `5` and `120`. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_intvl       = (Optional) The sysctl setting net.ipv4.tcp_keepalive_intvl. Must be between `10` and `75`. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_probes      = (Optional) The sysctl setting net.ipv4.tcp_keepalive_probes. Must be between `1` and `15`. Changing this forces a new resource to be created.
        net_ipv4_tcp_keepalive_time        = (Optional) The sysctl setting net.ipv4.tcp_keepalive_time. Must be between `30` and `432000`. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_syn_backlog       = (Optional) The sysctl setting net.ipv4.tcp_max_syn_backlog. Must be between `128` and `3240000`. Changing this forces a new resource to be created.
        net_ipv4_tcp_max_tw_buckets        = (Optional) The sysctl setting net.ipv4.tcp_max_tw_buckets. Must be between `8000` and `1440000`. Changing this forces a new resource to be created.
        net_ipv4_tcp_tw_reuse              = (Optional) Is sysctl setting net.ipv4.tcp_tw_reuse enabled? Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_buckets = (Optional) The sysctl setting net.netfilter.nf_conntrack_buckets. Must be between `65536` and `147456`. Changing this forces a new resource to be created.
        net_netfilter_nf_conntrack_max     = (Optional) The sysctl setting net.netfilter.nf_conntrack_max. Must be between `131072` and `1048576`. Changing this forces a new resource to be created.
        vm_max_map_count                   = (Optional) The sysctl setting vm.max_map_count. Must be between `65530` and `262144`. Changing this forces a new resource to be created.
        vm_swappiness                      = (Optional) The sysctl setting vm.swappiness. Must be between `0` and `100`. Changing this forces a new resource to be created.
        vm_vfs_cache_pressure              = (Optional) The sysctl setting vm.vfs_cache_pressure. Must be between `0` and `100`. Changing this forces a new resource to be created.
      }))
      transparent_huge_page_enabled = (Optional) Specifies the Transparent Huge Page enabled configuration. Possible values are `always`, `madvise` and `never`. Changing this forces a new resource to be created.
      transparent_huge_page_defrag  = (Optional) specifies the defrag configuration for Transparent Huge Page. Possible values are `always`, `defer`, `defer+madvise`, `madvise` and `never`. Changing this forces a new resource to be created.
      swap_file_size_mb             = (Optional) Specifies the size of swap file on each node in MB. Changing this forces a new resource to be created.
    }))
    fips_enabled       = (Optional) Should the nodes in this Node Pool have Federal Information Processing Standard enabled? Changing this forces a new resource to be created. FIPS support is in Public Preview - more information and details on how to opt into the Preview can be found in [this article](https://docs.microsoft.com/azure/aks/use-multiple-node-pools#add-a-fips-enabled-node-pool-preview).
    kubelet_disk_type  = (Optional) The type of disk used by kubelet. Possible values are `OS` and `Temporary`.
    max_count          = (Optional) The maximum number of nodes which should exist within this Node Pool. Valid values are between `0` and `1000` and must be greater than or equal to `min_count`.
    max_pods           = (Optional) The minimum number of nodes which should exist within this Node Pool. Valid values are between `0` and `1000` and must be less than or equal to `max_count`.
    message_of_the_day = (Optional) A base64-encoded string which will be written to /etc/motd after decoding. This allows customization of the message of the day for Linux nodes. It cannot be specified for Windows nodes and must be a static string (i.e. will be printed raw and not executed as a script). Changing this forces a new resource to be created.
    mode               = (Optional) Should this Node Pool be used for System or User resources? Possible values are `System` and `User`. Defaults to `User`.
    min_count          = (Optional) The minimum number of nodes which should exist within this Node Pool. Valid values are between `0` and `1000` and must be less than or equal to `max_count`.
    node_network_profile = optional(object({
      node_public_ip_tags = (Optional) Specifies a mapping of tags to the instance-level public IPs. Changing this forces a new resource to be created.
    }))
    node_labels                  = (Optional) A map of Kubernetes labels which should be applied to nodes in this Node Pool.
    node_public_ip_prefix_id     = (Optional) Resource ID for the Public IP Addresses Prefix for the nodes in this Node Pool. `enable_node_public_ip` should be `true`. Changing this forces a new resource to be created.
    node_taints                  = (Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g `key=value:NoSchedule`). Changing this forces a new resource to be created.
    orchestrator_version         = (Optional) Version of Kubernetes used for the Agents. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade). AKS does not require an exact patch version to be specified, minor version aliases such as `1.22` are also supported. - The minor version's latest GA patch is automatically chosen in that case. More details can be found in [the documentation](https://docs.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#alias-minor-version). This version must be supported by the Kubernetes Cluster - as such the version of Kubernetes used on the Cluster/Control Plane may need to be upgraded first.
    os_disk_size_gb              = (Optional) The Agent Operating System disk size in GB. Changing this forces a new resource to be created.
    os_disk_type                 = (Optional) The type of disk which should be used for the Operating System. Possible values are `Ephemeral` and `Managed`. Defaults to `Managed`. Changing this forces a new resource to be created.
    os_sku                       = (Optional) Specifies the OS SKU used by the agent pool. Possible values include: `Ubuntu`, `CBLMariner`, `Mariner`, `Windows2019`, `Windows2022`. If not specified, the default is `Ubuntu` if OSType=Linux or `Windows2019` if OSType=Windows. And the default Windows OSSKU will be changed to `Windows2022` after Windows2019 is deprecated. Changing this forces a new resource to be created.
    os_type                      = (Optional) The Operating System which should be used for this Node Pool. Changing this forces a new resource to be created. Possible values are `Linux` and `Windows`. Defaults to `Linux`.
    pod_subnet_id                = (Optional) The ID of the Subnet where the pods in the Node Pool should exist. Changing this forces a new resource to be created.
    priority                     = (Optional) The Priority for Virtual Machines within the Virtual Machine Scale Set that powers this Node Pool. Possible values are `Regular` and `Spot`. Defaults to `Regular`. Changing this forces a new resource to be created.
    proximity_placement_group_id = (Optional) The ID of the Proximity Placement Group where the Virtual Machine Scale Set that powers this Node Pool will be placed. Changing this forces a new resource to be created. When setting `priority` to Spot - you must configure an `eviction_policy`, `spot_max_price` and add the applicable `node_labels` and `node_taints` [as per the Azure Documentation](https://docs.microsoft.com/azure/aks/spot-node-pool).
    spot_max_price               = (Optional) The maximum price you're willing to pay in USD per Virtual Machine. Valid values are `-1` (the current on-demand price for a Virtual Machine) or a positive value with up to five decimal places. Changing this forces a new resource to be created. This field can only be configured when `priority` is set to `Spot`.
    scale_down_mode              = (Optional) Specifies how the node pool should deal with scaled-down nodes. Allowed values are `Delete` and `Deallocate`. Defaults to `Delete`.
    snapshot_id                  = (Optional) The ID of the Snapshot which should be used to create this Node Pool. Changing this forces a new resource to be created.
    ultra_ssd_enabled            = (Optional) Used to specify whether the UltraSSD is enabled in the Node Pool. Defaults to `false`. See [the documentation](https://docs.microsoft.com/azure/aks/use-ultra-disks) for more information. Changing this forces a new resource to be created.
    vnet_subnet_id               = (Optional) The ID of the Subnet where this Node Pool should exist. Changing this forces a new resource to be created. A route table must be configured on this Subnet.
    upgrade_settings = optional(object({
      drain_timeout_in_minutes      = number
      node_soak_duration_in_minutes = number
      max_surge                     = string
    }))
    windows_profile = optional(object({
      outbound_nat_enabled = optional(bool, true)
    }))
    workload_runtime = (Optional) Used to specify the workload runtime. Allowed values are `OCIContainer` and `WasmWasi`. WebAssembly System Interface node pools are in Public Preview - more information and details on how to opt into the preview can be found in [this article](https://docs.microsoft.com/azure/aks/use-wasi-node-pools)
    zones            = (Optional) Specifies a list of Availability Zones in which this Kubernetes Cluster Node Pool should be located. Changing this forces a new Kubernetes Cluster Node Pool to be created.
    create_before_destroy = (Optional) Create a new node pool before destroy the old one when Terraform must update an argument that cannot be updated in-place. Set this argument to `true` will add add a random suffix to pool's name to avoid conflict. Default to `true`.
  }))
  EOT
  nullable    = false
}

variable "agents_count" {
  type        = number
  default     = null
  description = "The number of Agents that should exist in the Agent Pool. Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes."
}

variable "agents_labels" {
  type        = map(string)
  default     = {}
  description = "(Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool. Changing this forces a new resource to be created."
}

variable "agents_max_count" {
  type        = number
  default     = null
  description = "Maximum number of nodes in a pool"
}

variable "agents_max_pods" {
  type        = number
  default     = null
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
}

variable "agents_min_count" {
  type        = number
  default     = null
  description = "Minimum number of nodes in a pool"
}

variable "agents_pool_drain_timeout_in_minutes" {
  type        = number
  default     = null
  description = "(Optional) The amount of time in minutes to wait on eviction of pods and graceful termination per node. This eviction wait time honors waiting on pod disruption budgets. If this time is exceeded, the upgrade fails. Unsetting this after configuring it will force a new resource to be created."
}

variable "agents_pool_name" {
  type        = string
  default     = "nodepool"
  description = "The default Azure AKS agentpool (nodepool) name."
  nullable    = false
}

variable "agents_type" {
  type        = string
  default     = "VirtualMachineScaleSets"
  description = "(Optional) The type of Node Pool which should be created. Possible values are AvailabilitySet and VirtualMachineScaleSets. Defaults to VirtualMachineScaleSets."
}

variable "agents_size" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "The default virtual machine size for the Kubernetes agents. Changing this without specifying `var.temporary_name_for_rotation` forces a new resource to be created."
}

variable "agents_tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) A mapping of tags to assign to the Node Pool."
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "(Optional) The type of identity used for the managed cluster. Conflicts with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, an `identity_ids` must be set as well."

  validation {
    condition     = var.identity_type == "SystemAssigned" || var.identity_type == "UserAssigned"
    error_message = "`identity_type`'s possible values are `SystemAssigned` and `UserAssigned`"
  }
}

variable "private_cluster_public_fqdn_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether a Public FQDN for this Private Cluster should be added. Defaults to `false`."
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "(Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, `System` to have AKS manage this or `None`. In case of `None` you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning. Changing this forces a new resource to be created."
}

variable "public_ssh_key" {
  type        = string
  default     = ""
  description = "A custom ssh key to control access to the AKS cluster. Changing this forces a new resource to be created."
}

variable "rbac_aad" {
  type        = bool
  default     = true
  description = "(Optional) Is Azure Active Directory integration enabled?"
  nullable    = false
}

variable "rbac_aad_admin_group_object_ids" {
  type        = list(string)
  default     = null
  description = "Object ID of groups with admin access."
}

variable "rbac_aad_azure_rbac_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Is Role Based Access Control based on Azure AD enabled?"
}

variable "rbac_aad_managed" {
  type        = bool
  default     = true
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  nullable    = false
}

variable "rbac_aad_tenant_id" {
  type        = string
  default     = null
  description = "(Optional) The Tenant ID used for Azure Active Directory Application. If this isn't specified the Tenant ID of the current Subscription is used."
}

variable "role_based_access_control_enabled" {
  type        = bool
  default     = true
  description = "Enable Role Based Access Control."
  nullable    = false
}

variable "run_command_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether to enable run command for the cluster or not."
}

variable "scale_down_mode" {
  type        = string
  default     = "Delete"
  description = "(Optional) Specifies the autoscaling behaviour of the Kubernetes Cluster. If not specified, it defaults to `Delete`. Possible values include `Delete` and `Deallocate`. Changing this forces a new resource to be created."
}

variable "secret_rotation_enabled" {
  type        = bool
  default     = false
  description = "Is secret rotation enabled? This variable is only used when `key_vault_secrets_provider_enabled` is `true` and defaults to `false`"
  nullable    = false
}

variable "secret_rotation_interval" {
  type        = string
  default     = "2m"
  description = "The interval to poll for secret rotation. This attribute is only set when `secret_rotation` is `true` and defaults to `2m`"
  nullable    = false
}

variable "service_mesh_profile" {
  type = object({
    mode                             = string
    internal_ingress_gateway_enabled = optional(bool, true)
    external_ingress_gateway_enabled = optional(bool, true)
  })
  default     = null
  description = <<-EOT
    `mode` - (Required) The mode of the service mesh. Possible value is `Istio`.
    `internal_ingress_gateway_enabled` - (Optional) Is Istio Internal Ingress Gateway enabled? Defaults to `true`.
    `external_ingress_gateway_enabled` - (Optional) Is Istio External Ingress Gateway enabled? Defaults to `true`.
  EOT
}

variable "sku_tier" {
  type        = string
  default     = "Free"
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are `Free`, `Standard` and `Premium`"

  validation {
    condition     = contains(["Free", "Standard", "Premium"], var.sku_tier)
    error_message = "The SKU Tier must be either `Free`, `Standard` or `Premium`. `Paid` is no longer supported since AzureRM provider v3.51.0."
  }
}

variable "snapshot_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Snapshot which should be used to create this default Node Pool. `temporary_name_for_rotation` must be specified when changing this property."
}

variable "storage_profile_blob_driver_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Is the Blob CSI driver enabled? Defaults to `false`"
}

variable "storage_profile_disk_driver_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Is the Disk CSI driver enabled? Defaults to `true`"
}

variable "storage_profile_disk_driver_version" {
  type        = string
  default     = "v1"
  description = "(Optional) Disk CSI Driver version to be used. Possible values are `v1` and `v2`. Defaults to `v1`."
}

variable "storage_profile_enabled" {
  type        = bool
  default     = false
  description = "Enable storage profile"
  nullable    = false
}

variable "storage_profile_file_driver_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Is the File CSI driver enabled? Defaults to `true`"
}

variable "storage_profile_snapshot_controller_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Is the Snapshot Controller enabled? Defaults to `true`"
}

variable "support_plan" {
  type        = string
  default     = "KubernetesOfficial"
  description = "The support plan which should be used for this Kubernetes Cluster. Possible values are `KubernetesOfficial` and `AKSLongTermSupport`."

  validation {
    condition     = contains(["KubernetesOfficial", "AKSLongTermSupport"], var.support_plan)
    error_message = "The support plan must be either `KubernetesOfficial` or `AKSLongTermSupport`."
  }
}

variable "temporary_name_for_rotation" {
  type        = string
  default     = null
  description = "(Optional) Specifies the name of the temporary node pool used to cycle the default node pool for VM resizing. the `var.agents_size` is no longer ForceNew and can be resized by specifying `temporary_name_for_rotation`"
}

variable "image_cleaner_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Specifies whether Image Cleaner is enabled."
}

variable "image_cleaner_interval_hours" {
  type        = number
  default     = 48
  description = "(Optional) Specifies the interval in hours when images should be cleaned up. Defaults to `48`."
}

variable "key_vault_secrets_provider_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Whether to use the Azure Key Vault Provider for Secrets Store CSI Driver in an AKS cluster. For more details: https://docs.microsoft.com/en-us/azure/aks/csi-secrets-store-driver"
  nullable    = false
}

variable "kms_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Enable Azure KeyVault Key Management Service."
  nullable    = false
}

variable "kms_key_vault_key_id" {
  type        = string
  default     = null
  description = "(Optional) Identifier of Azure Key Vault key. When Azure Key Vault key management service is enabled, this field is required and must be a valid key identifier."
}

variable "kms_key_vault_network_access" {
  type        = string
  default     = "Public"
  description = "(Optional) Network Access of Azure Key Vault. Possible values are: `Private` and `Public`."

  validation {
    condition     = contains(["Private", "Public"], var.kms_key_vault_network_access)
    error_message = "Possible values are `Private` and `Public`"
  }
}

variable "kubelet_identity" {
  type = object({
    client_id                 = optional(string)
    object_id                 = optional(string)
    user_assigned_identity_id = optional(string)
  })
  default     = null
  description = <<-EOT
 - `client_id` - (Optional) The Client ID of the user-defined Managed Identity to be assigned to the Kubelets. If not specified a Managed Identity is created automatically. Changing this forces a new resource to be created.
 - `object_id` - (Optional) The Object ID of the user-defined Managed Identity assigned to the Kubelets.If not specified a Managed Identity is created automatically. Changing this forces a new resource to be created.
 - `user_assigned_identity_id` - (Optional) The ID of the User Assigned Identity assigned to the Kubelets. If not specified a Managed Identity is created automatically. Changing this forces a new resource to be created.
EOT
}

variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Specify which Kubernetes release to use. The default used is the latest Kubernetes version available in the region"
}

variable "load_balancer_profile_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Enable a load_balancer_profile block. This can only be used when load_balancer_sku is set to `standard`."
  nullable    = false
}

variable "load_balancer_profile_idle_timeout_in_minutes" {
  type        = number
  default     = 30
  description = "(Optional) Desired outbound flow idle timeout in minutes for the cluster load balancer. Must be between `4` and `120` inclusive."
}

variable "load_balancer_profile_managed_outbound_ip_count" {
  type        = number
  default     = null
  description = "(Optional) Count of desired managed outbound IPs for the cluster load balancer. Must be between `1` and `100` inclusive"
}

variable "load_balancer_profile_managed_outbound_ipv6_count" {
  type        = number
  default     = null
  description = "(Optional) The desired number of IPv6 outbound IPs created and managed by Azure for the cluster load balancer. Must be in the range of `1` to `100` (inclusive). The default value is `0` for single-stack and `1` for dual-stack. Note: managed_outbound_ipv6_count requires dual-stack networking. To enable dual-stack networking the Preview Feature Microsoft.ContainerService/AKS-EnableDualStack needs to be enabled and the Resource Provider re-registered, see the documentation for more information. https://learn.microsoft.com/en-us/azure/aks/configure-kubenet-dual-stack?tabs=azure-cli%2Ckubectl#register-the-aks-enabledualstack-preview-feature"
}

variable "load_balancer_profile_outbound_ip_address_ids" {
  type        = set(string)
  default     = null
  description = "(Optional) The ID of the Public IP Addresses which should be used for outbound communication for the cluster load balancer."
}

variable "load_balancer_profile_outbound_ip_prefix_ids" {
  type        = set(string)
  default     = null
  description = "(Optional) The ID of the outbound Public IP Address Prefixes which should be used for the cluster load balancer."
}

variable "load_balancer_profile_outbound_ports_allocated" {
  type        = number
  default     = 0
  description = "(Optional) Number of desired SNAT port for each VM in the clusters load balancer. Must be between `0` and `64000` inclusive. Defaults to `0`"
}

variable "load_balancer_sku" {
  type        = string
  default     = "standard"
  description = "(Optional) Specifies the SKU of the Load Balancer used for this Kubernetes Cluster. Possible values are `basic` and `standard`. Defaults to `standard`. Changing this forces a new kubernetes cluster to be created."

  validation {
    condition     = contains(["basic", "standard"], var.load_balancer_sku)
    error_message = "Possible values are `basic` and `standard`"
  }
}

variable "local_account_disabled" {
  type        = bool
  default     = null
  description = "(Optional) - If `true` local accounts will be disabled. Defaults to `false`. See [the documentation](https://docs.microsoft.com/azure/aks/managed-aad#disable-local-accounts) for more information."
}

variable "cluster_log_analytics_workspace_name" {
  type        = string
  default     = null
  description = "(Optional) The name of the Analytics workspace"
}

variable "vnet_name" {
  type        = string
  description = "Name of the vnet to create."
}

variable "use_for_each" {
  type        = bool
  default     = true
  description = "Use `for_each` instead of `count` to create multiple resource instances."
  nullable    = false
}

variable "address_space" {
  type        = string
  default     = "10.0.0.0/16"
  description = "The address space that is used by the virtual network."
}

variable "address_spaces" {
  type        = list(string)
  default     = []
  description = "The list of the address spaces that is used by the virtual network."
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "The DNS servers to be used with vNet."
}

variable "subnet_delegation" {
  type = map(list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = optional(list(string))
    })
  })))
  default     = {}
  description = "`service_delegation` blocks for `azurerm_subnet` resource, subnet names as keys, list of delegation blocks as value, more details about delegation block could be found at the [document](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet#delegation)."
  nullable    = false
}

variable "subnet_enforce_private_link_endpoint_network_policies" {
  type        = map(bool)
  default     = {}
  description = "A map with key (string) `subnet name`, value (bool) `true` or `false` to indicate enable or disable network policies for the private link endpoint on the subnet. Default value is false."
}

variable "subnet_names" {
  type        = list(string)
  default     = ["subnet1"]
  description = "A list of public subnets inside the vNet."
}

variable "subnet_prefixes" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "The address prefix to use for the subnet."
}

variable "subnet_service_endpoints" {
  type        = map(list(string))
  default     = {}
  description = "A map with key (string) `subnet name`, value (list(string)) to indicate enabled service endpoints on the subnet. Default value is []."
}

variable "argocd_chart_version" {
  type        = string
  default     = "7.8.2"
  description = "The version of the ArgoCD Helm chart to install"
}

#######################

variable "key_vault_name" {
  type        = string
  description = "The name of the Key Vault."

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,24}$", var.key_vault_name))
    error_message = "The name must be between 3 and 24 characters long and can only contain letters, numbers and dashes."
  }
  validation {
    error_message = "The name must not contain two consecutive dashes"
    condition     = !can(regex("--", var.key_vault_name))
  }
  validation {
    error_message = "The name must start with a letter"
    condition     = can(regex("^[a-zA-Z]", var.key_vault_name))
  }
  validation {
    error_message = "The name must end with a letter or number"
    condition     = can(regex("[a-zA-Z0-9]$", var.key_vault_name))
  }
}

variable "key_vault_contacts" {
  type = map(object({
    email = string
    name  = optional(string, null)
    phone = optional(string, null)
  }))
  default     = {}
  description = "A map of contacts for the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time."
}

variable "key_vault_diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.key_vault_diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.key_vault_diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "key_vault_enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "key_vault_enabled_for_deployment" {
  type        = bool
  default     = false
  description = "Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the vault."
}

variable "key_vault_enabled_for_disk_encryption" {
  type        = bool
  default     = false
  description = "Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
}

variable "key_vault_enabled_for_template_deployment" {
  type        = bool
  default     = false
  description = "Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault."
}

variable "key_vault_keys" {
  type = map(object({
    name     = string
    key_type = string
    key_opts = optional(list(string), ["sign", "verify"])

    key_size        = optional(number, null)
    curve           = optional(string, null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
    tags            = optional(map(any), null)

    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})

    rotation_policy = optional(object({
      automatic = optional(object({
        time_after_creation = optional(string, null)
        time_before_expiry  = optional(string, null)
      }), null)
      expire_after         = optional(string, null)
      notify_before_expiry = optional(string, null)
    }), null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of keys to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - The name of the key.
- `key_type` - The type of the key. Possible values are `EC` and `RSA`.
- `key_opts` - A list of key options. Possible values are `decrypt`, `encrypt`, `sign`, `unwrapKey`, `verify`, and `wrapKey`.
- `key_size` - The size of the key. Required for `RSA` keys.
- `curve` - The curve of the key. Required for `EC` keys.  Possible values are `P-256`, `P-256K`, `P-384`, and `P-521`. The API will default to `P-256` if nothing is specified.
- `not_before_date` - The not before date of the key.
- `expiration_date` - The expiration date of the key.
- `tags` - A mapping of tags to assign to the key.
- `rotation_policy` - The rotation policy of the key.
  - `automatic` - The automatic rotation policy of the key.
    - `time_after_creation` - The time after creation of the key before it is automatically rotated.
    - `time_before_expiry` - The time before expiry of the key before it is automatically rotated.
  - `expire_after` - The time after which the key expires.
  - `notify_before_expiry` - The time before expiry of the key when notification emails will be sent.

Supply role assignments in the same way as for `var.role_assignments`.
DESCRIPTION
  nullable    = false
}

variable "key_vault_lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = "The lock level to apply to the Key Vault. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`."

  validation {
    condition     = var.key_vault_lock != null ? contains(["CanNotDelete", "ReadOnly"], var.key_vault_lock.kind) : true
    error_message = "Lock kind must be either `\"CanNotDelete\"` or `\"ReadOnly\"`."
  }
}

variable "key_vault_network_acls" {
  type = object({
    bypass                     = optional(string, "None")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
The network ACL configuration for the Key Vault.
If not specified then the Key Vault will be created with a firewall that blocks access.
Specify `null` to create the Key Vault with no firewall.

- `bypass` - (Optional) Should Azure Services bypass the ACL. Possible values are `AzureServices` and `None`. Defaults to `None`.
- `default_action` - (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`.
- `ip_rules` - (Optional) A list of IP rules in CIDR format. Defaults to `[]`.
- `virtual_network_subnet_ids` - (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Key Vault. Defaults to `[]`.
DESCRIPTION

  validation {
    condition     = var.key_vault_network_acls == null ? true : contains(["AzureServices", "None"], var.key_vault_network_acls.bypass)
    error_message = "The bypass value must be either `AzureServices` or `None`."
  }
  validation {
    condition     = var.key_vault_network_acls == null ? true : contains(["Allow", "Deny"], var.key_vault_network_acls.default_action)
    error_message = "The default_action value must be either `Allow` or `Deny`."
  }
}

variable "key_vault_private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
  nullable    = false
}

variable "key_vault_public_network_access_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether public access is permitted."
}

variable "key_vault_purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether protection against purge is enabled for this Key Vault. Note once enabled this cannot be disabled."
}

variable "key_vault_role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. If you are using a condition, valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "key_vault_secrets" {
  type = map(object({
    name            = string
    content_type    = optional(string, null)
    tags            = optional(map(any), null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)

    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
  }))
  default     = {}
  description = <<DESCRIPTION
A map of secrets to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - The name of the secret.
- `content_type` - The content type of the secret.
- `tags` - A mapping of tags to assign to the secret.
- `not_before_date` - The not before date of the secret.
- `expiration_date` - The expiration date of the secret.

Supply role assignments in the same way as for `var.role_assignments`.

> Note: the `value` of the secret is supplied via the `var.secrets_value` variable. Make sure to use the same map key.
DESCRIPTION
  nullable    = false
}

variable "key_vault_secrets_value" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
A map of secret keys to values.
The map key is the supplied input to `var.secrets`.
The map value is the secret value.

This is a separate variable to `var.secrets` because it is sensitive and therefore cannot be used in a `for_each` loop.
DESCRIPTION
  sensitive   = true
}

variable "key_vault_sku_name" {
  type        = string
  default     = "premium"
  description = "The SKU name of the Key Vault. Default is `premium`. Possible values are `standard` and `premium`."

  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku_name)
    error_message = "The SKU name must be either `standard` or `premium`."
  }
}

variable "key_vault_soft_delete_retention_days" {
  type        = number
  default     = null
  description = <<DESCRIPTION
The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days.
DESCRIPTION

  validation {
    condition     = var.key_vault_soft_delete_retention_days == null ? true : var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "Value must be between 7 and 90."
  }
  validation {
    condition     = var.key_vault_soft_delete_retention_days == null ? true : ceil(var.key_vault_soft_delete_retention_days) == var.key_vault_soft_delete_retention_days
    error_message = "Value must be an integer."
  }
}

variable "key_vault_private_dns_zone_name" {
  type        = string
  default     = "privatelink.vaultcore.azure.net"
  description = "The name of the private DNS zone to create for the Key Vault. If not set, no private DNS zone will be created."
}

variable "audience" {
  type        = list(string)
  description = "The audience for the token"
  default     = ["api://AzureADTokenExchange"]
}

variable "service_account_namespace" {
  type        = string
  description = "The namespace for the service account"
  default     = "default"
}

variable "service_account_name" {
  type        = string
  description = "The name of the service account"
  default     = "external-secrets-sa"
}
