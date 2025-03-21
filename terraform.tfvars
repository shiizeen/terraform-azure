# Resource Group et localisation
resource_group_name      = "rg-KD-terraform"
location                 = "westeurope"

# Virtual Network
vnet_name                = "vnet-KD-terraform"
vnet_address_space       = "172.18.0.0/16"

# Subnets pour les VMs
subnet_names             = ["sub1"]
subnet_address_prefixes  = ["172.18.1.0/24"]

# Subnet dédié au Bastion
bastion_subnet_prefix    = "172.18.255.0/27"

# Paramètres pour les VMs
vm_size                = "Standard_B1s"
admin_username         = "adminuser"
admin_password         = "P@ssw0rd1234!"
image_publisher        = "Canonical"
image_offer            = "UbuntuServer"
image_sku              = "18.04-lts"

# Application Gateway
ag_public_ip_name      = "pip-KD-terraform-appgw"
appgw_name             = "appgw-KD-terraform"
appgw_capacity         = 2

# Availability Zones
availability_zones     = ["1", "2", "3"]
primary_zone           = "1"

# Bastion
bastion_public_ip_name = "pip-KD-terraform-bastion"
bastion_name           = "bastion-KD-terraform"

# Storage Account (optionnel)
storage_account_prefix = "storaccKD"
