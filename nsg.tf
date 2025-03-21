###########################################
# 9. Sécurité Réseau : NSG et associations
###########################################

# Création d'un Network Security Group pour les VMs
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.resource_group_name}-vm-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Autoriser le trafic HTTP (port 80) uniquement depuis l'IP publique de l'Application Gateway
  security_rule {
    name                       = "Allow-LB-Traffic"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "172.18.10.0/24"
    destination_address_prefix = "*"
  }

  # Autoriser le trafic SSH (port 22) uniquement depuis le Bastion
  security_rule {
    name                       = "Allow-SSH-From-Bastion"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = "*"
  }

  # Refuser tout le reste
  security_rule {
    name                       = "Deny-All-Inbound"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
  name                       = "Allow-Ephemeral-Ports"
  priority                   = 999
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_ranges    = ["65200-65535"]
  source_address_prefix      = "*"
  destination_address_prefix = "*"
}

}

# Association du NSG au premier subnet (celui qui héberge les VMs)
resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg_assoc" {
  subnet_id                 = element(azurerm_subnet.subnet[*].id, 0)
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}
