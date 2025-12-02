rgs = {
  rg-TodoInfra-UK = {
    location = "southindia"
  }
}

vnets_subnets = {
  vnet-TodoInfra-UK = {
    location            = "southindia"
    resource_group_name = "rg-TodoInfra-UK"
    address_space       = ["10.0.0.0/16"]
    # The AzureBastionSubnet Block is required in subnets if enable_bastion=true 
    # AzureBastionSubnet = {
    #     address_prefix = "10.0.2.0/24"
    # }
    enable_bastion = false
    subnets = {
      frontend-subnet = {
        address_prefixes = ["10.0.0.0/24"]
      }
      backend-subnet = {
        address_prefixes = ["10.0.1.0/24"]
      }
      AzureBastionSubnet = {
        address_prefixes = ["10.0.2.0/24"]
      }
    }
  }
}

vms = {
  "frontendvm" = {
    resource_group_name = "rg-TodoInfra-UK"
    location            = "southindia"
    vnet_name           = "vnet-TodoInfra-UK"
    subnet_name         = "frontend-subnet"
    size                = "Standard_D2s_v3"
    admin_username      = "devopsadmin"
    admin_password      = "P@ssw01rd@123"
    userdata_script     = "install_nginx.sh"
    inbound_open_ports  = [22, 80]
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts"
      version   = "latest"
    }
    enable_public_ip = true
  }
  "backendvm" = {
    resource_group_name = "rg-TodoInfra-UK"
    location            = "southindia"
    vnet_name           = "vnet-TodoInfra-UK"
    subnet_name         = "backend-subnet"
    size                = "Standard_D2s_v3"
    admin_username      = "devopsadmin"
    admin_password      = "P@ssw01rd@123"
    userdata_script     = "install_python.sh"
    inbound_open_ports  = [22, 8000]
    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts"
      version   = "latest"
    }
    enable_public_ip = false
  }
}

loadbalancers = {
  lb-TodoInfra-UK = {
    location                       = "southindia"
    resource_group_name            = "rg-TodoInfra-UK"
    frontend_ip_configuration_name = "PublicIPAddress"
    sku                            = "Standard"
  }
}

backend_pools = {
  frontend-pool = {
    port        = 80
    lb_name     = "lb-TodoInfra-UK"
    backend_vms = ["frontendvm1", "frontendvm2"]
  }
}

servers_dbs = {
  "devopsinssrv1" = {
    resource_group_name            = "rg-TodoInfra-UK"
    location                       = "southindia"
    version                        = "12.0"
    administrator_login            = "devopsadmin"
    administrator_login_password   = "P@ssw01rd@123"
    allow_access_to_azure_services = true
    dbs                            = ["todoappdb"]
  }
}
