###########################################
# 2.Subnets 
###########################################

# Création du subnet pour les VMs
resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_address_prefixes)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ var.subnet_address_prefixes[count.index] ]
  #Endpoint storage pour les storage account
  service_endpoints    = ["Microsoft.Storage"]
}

# Création d'un subnet dédié au Bastion
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [ var.bastion_subnet_prefix ]
}

#Création d'un subnet dédié à l'Application Gateway  
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "subnet-appgw"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["172.18.10.0/24"]
}
