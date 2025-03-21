###########################################
# 3. Interfaces Réseau pour les VMs
###########################################

# Data source pour générer un fichier cloud-init 
# en injectant l'URL signée (SAS) de l'image.
data "template_file" "cloud_init" {
  # Chemin vers le fichier template (cloud-init.tpl)
  template = file("${path.module}/cloud-init.tpl")

  # Variables à substituer dans le template
  vars = {
    # On récupère l'URL signée stockée dans local.single_image_url
    image_url = local.single_image_url
  }
}

# Création de 3 interfaces réseau (une par VM)
resource "azurerm_network_interface" "web_nic" {
  count               = 3
  name                = "web-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-ip-config"
    # On associe chaque NIC au même subnet (index 0)
    subnet_id                     = element(azurerm_subnet.subnet[*].id, 0)
    # Allocation dynamique de l'IP privée
    private_ip_address_allocation = "Dynamic"
  }
}

###########################################
# 4. Machines Virtuelles Ubuntu Linux 
###########################################

# Déploiement de 3 machines virtuelles Linux
resource "azurerm_linux_virtual_machine" "web_vm" {
  count                           = 3
  name                            = "web-vm-${count.index}"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false  # Permet l'authentification par mot de passe

  # Chaque VM est reliée à l'interface réseau correspondante
  network_interface_ids           = [
    azurerm_network_interface.web_nic[count.index].id
  ]

  # Configuration du disque principal
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Spécification de l'image Ubuntu à utiliser
  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }

  # Injection du script cloud-init (avec l'URL de l'image) en base64
  custom_data = base64encode(data.template_file.cloud_init.rendered)
}

