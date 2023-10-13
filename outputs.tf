output "cdp_admin_client_certificate" {
  sensitive = true
  value     = module.aks.admin_client_certificate
}

output "cdp_admin_client_key" {
  sensitive = true
  value     = module.aks.admin_client_key
}

output "cdp_admin_cluster_ca_certificate" {
  sensitive = true
  value     = module.aks.admin_client_certificate
}

output "cdp_admin_host" {
  sensitive = true
  value     = module.aks.admin_host
}

output "cdp_admin_password" {
  sensitive = true
  value     = module.aks.admin_password
}

output "cdp_admin_username" {
  sensitive = true
  value     = module.aks.admin_username
}

output "cdp_aks_id" {
  value = module.aks.aks_id
}

output "cdp_client_certificate" {
  sensitive = true
  value     = module.aks.client_certificate
}

output "cdp_client_key" {
  sensitive = true
  value     = module.aks.client_key
}

output "cdp_cluster_ca_certificate" {
  sensitive = true
  value     = module.aks.client_certificate
}

output "cdp_cluster_portal_fqdn" {
  value = module.aks.cluster_portal_fqdn
}

output "cdp_cluster_private_fqdn" {
  value = module.aks.cluster_private_fqdn
}

output "cdp_host" {
  sensitive = true
  value     = module.aks.host
}

output "cdp_kube_raw" {
  sensitive = true
  value     = module.aks.kube_config_raw
}

output "cdp_password" {
  sensitive = true
  value     = module.aks.password
}

output "cdp_username" {
  sensitive = true
  value     = module.aks.username
}