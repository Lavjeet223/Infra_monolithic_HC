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