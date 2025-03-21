###########################################
# 5. Application Gateway
###########################################

# Création d'une IP publique Standard pour l'Application Gateway
resource "azurerm_public_ip" "ag_public_ip" {
  name                = var.ag_public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"    # Adresse IP fixe
  sku                 = "Standard"  # Obligatoire pour l'App Gateway v2
  zones               = [var.primary_zone]  # Zone primaire (ex: "1")
}

# Configuration de l'Application Gateway en HTTP (port 80)
resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # SKU Standard_v2 requis pour les fonctionnalités avancées (autoscaling, zones, etc.)
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2  # Nombre d'instances
  }

  # Configuration IP : association au subnet dédié (appgw_subnet)
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  # L'Application Gateway expose son IP publique via ce bloc
  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.ag_public_ip.id
  }

  # Définition du port frontal (ici, port 80 pour le HTTP)
  frontend_port {
    name = "appgw-frontend-port"
    port = 80
  }

  # Pool backend : liste d'adresses IP privées des NIC (VM) à load-balancer
  backend_address_pool {
    name         = "appgw-backend-pool"
    # On récupère l'IP privée de chaque NIC web_nic
    ip_addresses = [ for nic in azurerm_network_interface.web_nic : nic.private_ip_address ]
  }

  # Paramètres HTTP pour communiquer avec les serveurs backend (port 80, HTTP)
  backend_http_settings {
    name                  = "appgw-backend-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30  # Timeout en secondes
  }

  # Configuration du listener HTTP (port 80)
  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "appgw-frontend-port"
    protocol                       = "Http"
  }

  # Règle de routage : associe le listener au pool backend et aux settings
  request_routing_rule {
    name                       = "appgw-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "appgw-backend-pool"
    backend_http_settings_name = "appgw-backend-http-settings"
    priority                   = 100
  }

  # Déploiement dans la zone primaire (ex: "1")
  zones = [var.primary_zone]
}

