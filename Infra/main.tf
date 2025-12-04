module "rgs" {
  source = "../modules/ResourceGroup"
  rgs    = var.rgs
}

module "storage_accounts" {
  depends_on       = [module.rgs]
  source           = "../modules/StorageAccount_Dynamic"
  storage_accounts = var.storage_accounts
}

module "networking" {
  depends_on    = [module.rgs]
  source        = "../modules/Networking"
  vnets_subnets = var.vnets_subnets
}

module "vms" {
  depends_on      = [module.rgs, module.networking]
  source          = "../modules/LinuxVirtualMachine"
  vms             = var.vms
  vnet_subnet_ids = module.networking.vnet_subnet_ids
}

module "database" {
  depends_on  = [module.rgs]
  source      = "../modules/Database"
  servers_dbs = var.servers_dbs
}
