# You can use the azurerm_client_config data resource to dynamically
# extract connection settings from the provider configuration.
data "azurerm_client_config" "core" {}

# Declare the Azure landing zones Terraform module
# and provide a base configuration.
# module "caf-enterprise-scale" {
#   source  = "Azure/caf-enterprise-scale/azurerm"
#   version = "4.2.0" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

#   default_location =  "eastus"
#   providers = {
#     azurerm              = azurerm
#     azurerm.connectivity = azurerm
#     azurerm.management   = azurerm
#   }
# }

# root_parent_id = data.azurerm_client_config.core.tenant_id
#   root_id        = var.root_id
#   root_name      = var.root_name
#   library_path   = "${path.root}/lib"

#   custom_landing_zones = {
#     "${var.root_id}-online-example-1" = {
#       display_name               = "${upper(var.root_id)} Online Example 1"
#       parent_management_group_id = "${var.root_id}-landing-zones"
#       subscription_ids           = []
#       archetype_config = {
#         archetype_id   = "customer_online"
#         parameters     = {}
#         access_control = {}
#       }
#     }
#     "${var.root_id}-online-example-2" = {
#       display_name               = "${upper(var.root_id)} Online Example 2"
#       parent_management_group_id = "${var.root_id}-landing-zones"
#       subscription_ids           = []
#       archetype_config = {
#         archetype_id = "customer_online"
#         parameters = {
#           Deny-Resource-Locations = {
#             listOfAllowedLocations = ["eastus", ]
#           }
#           Deny-RSG-Locations = {
#             listOfAllowedLocations = ["eastus", ]
#           }
#         }
#         access_control = {}
#       }
#     }
#   }
# }

locals {
  resource_group = {
    name     = var.resource_group_name
    location = var.location
  }
}

# Create a resource group
resource "azurerm_resource_group" "cdp" {
  name     = local.resource_group.name
  location = local.resource_group.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "aseno-cdp-network" {
  name                = "aseno-cdp-network"
  resource_group_name = azurerm_resource_group.cdp.name
  location            = azurerm_resource_group.cdp.location
  address_space       = ["10.76.0.0/16"]
}

resource "azurerm_subnet" "cdp-subnet" {
  address_prefixes                               = ["10.76.0.0/24"]
  name                                           = "cdp-sn"
  resource_group_name                            = azurerm_resource_group.cdp.name
  virtual_network_name                           = azurerm_virtual_network.aseno-cdp-network.name
  # enforce_private_link_endpoint_network_policies = true
  # private_endpoint_network_policies_enabled = true not avaiable yet !
}


module "aks" {
  source  = "Azure/aks/azurerm"
  version = "7.4.0"

  prefix                    = "cdp"
  resource_group_name       = azurerm_resource_group.cdp.name
  kubernetes_version        = "1.26" # don't specify the patch version!
  automatic_channel_upgrade = "patch"
  agents_availability_zones = ["1", "2"]
  agents_count              = null
  agents_max_count          = 2
  agents_max_pods           = 100
  agents_min_count          = 1
  agents_pool_name          = "cdpnodepool"
  agents_pool_linux_os_configs = [
    {
      transparent_huge_page_enabled = "always"
      sysctl_configs = [
        {
          fs_aio_max_nr               = 65536
          fs_file_max                 = 100000
          fs_inotify_max_user_watches = 1000000
        }
      ]
    }
  ]
  agents_type          = "VirtualMachineScaleSets"
  azure_policy_enabled = true
  client_id            = var.client_id
  client_secret        = var.client_secret
  
  # confidential_computing = {
  #   sgx_quote_helper_enabled = true
  # }
  #disk_encryption_set_id                  = azurerm_disk_encryption_set.des.id
  enable_auto_scaling                     = true
  #enable_host_encryption                  = true
  http_application_routing_enabled        = true
  ingress_application_gateway_enabled     = true
  ingress_application_gateway_name        = "cdp-agw"
  ingress_application_gateway_subnet_cidr = "10.76.1.0/24"
  # TODO
  #local_account_disabled                  = true
  log_analytics_workspace_enabled         = true
  cluster_log_analytics_workspace_name    = "cdp-logs-ws"
  # maintenance_window = {
  #   allowed = [
  #     {
  #       day   = "Sunday",
  #       hours = [22, 23]
  #     },
  #   ]
  #   not_allowed = [
  #     {
  #       start = "2035-01-01T20:00:00Z",
  #       end   = "2035-01-01T21:00:00Z"
  #     },
  #   ]
  # }
  # maintenance_window_node_os = {
  #   frequency  = "Daily"
  #   interval   = 1
  #   start_time = "07:00"
  #   utc_offset = "+01:00"
  #   duration   = 16
  # }
  net_profile_dns_service_ip        = "10.0.0.10"
  net_profile_service_cidr          = "10.0.0.0/16"
  network_plugin                    = "azure"
  network_policy                    = "azure"
  os_disk_size_gb                   = 30
  # see https://registry.terraform.io/modules/Azure/aks/azurerm/latest?tab=inputs
  #private_cluster_enabled           = false --> if true no access from outside azure
  #public_network_access_enabled     = false
  rbac_aad                          = true
  rbac_aad_managed                  = true
  role_based_access_control_enabled = true
  #sku_tier                          = "Standard" default "Free"
  vnet_subnet_id                    = azurerm_subnet.cdp-subnet.id

  agents_labels = {
    "node1" : "label1"
  }

  depends_on = [
    azurerm_subnet.cdp-subnet,
  ]
}