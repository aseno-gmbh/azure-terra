 
# Use variables to customize the deployment
variable "client_id" {}
variable "client_secret" {}
variable "subscription_id" {}
variable "tenant_id" {}

variable "root_id" {
  type    = string
  default = "aseno"
}

variable "root_name" {
  type    = string
  default = "ASENO Ltd."
}

variable "location" {
  type    = string
  default = "eastus"
}
variable "resource_group_name" {
  type    = string
  default = "cdp-group"
}