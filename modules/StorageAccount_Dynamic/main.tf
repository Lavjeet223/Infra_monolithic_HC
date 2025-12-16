resource "azurerm_storage_account" "stgaccount" {
  for_each                 = var.storage_accounts
  name                     = each.key
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  min_tls_version          = lookup(each.value, "min_tls_version", "TLS1_2") # each.value.min_tls_version != null ? each.value.min_tls_version : "TLS1_2" working but lookup is better here
  tags                     = lookup(each.value, "tags", {})                  #try(each.value.tags, {}) but lookup is better here 

  dynamic "network_rules" {
    for_each = length(try(each.value.ips_allowed, [])) > 0 ? [1] : []
    content {
      default_action = "Deny"
      ip_rules       = each.value.ips_allowed
    }
  }
}


# Why try() is bestc compare to lookup() here? 
# If tags is defined → returns tags
# If tags is missing → safely returns {}
# No errors
# No unnecessary lookup
# tags = lookup(each.value, "tags", {})




