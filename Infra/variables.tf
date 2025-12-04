variable "rgs" {
  type = map(object({
    location = string
    tags     = optional(map(string))
  }))
}


variable "storage_accounts" {
  type = map(object({
    resource_group_name      = string
    location                 = string
    account_tier             = string
    account_replication_type = string
    min_tls_version          = optional(string)
    ips_allowed              = list(string)
    tags                     = optional(map(string))
  }))
  description = "A map of storage account configurations."
  default     = {}
}

variable "vnets_subnets" {
  type = map(object({
    location            = string
    resource_group_name = string
    address_space       = list(string)
    enable_bastion = optional(bool, false)

    subnets = map(object({
      address_prefixes = list(string)
    }))
  }))
  description = "Map of virtual networks and their corresponding subnets."
}


variable "vms" {}
variable "loadbalancers" {}
variable "backend_pools" {}
variable "servers_dbs" {}
