###########################################
# Variables
###########################################

# Nom du Resource Group
variable "resource_group_name" {
  description = "RG name"
  type        = string
}

# Localisation (ex: westeurope)
variable "location" {
  description = "Location"
  type        = string
  default     = "westeurope"
}

###########################################
# Réseau : VNet et Subnets
###########################################

# Nom du VNet
variable "vnet_name" {
  description = "VNet name"
  type        = string
}

# Espace d'adressage du VNet
variable "vnet_address_space" {
  description = "VNet CIDR"
  type        = string
  default     = "172.18.0.0/16"
}

# Noms de subnets
variable "subnet_names" {
  description = "Subnets names"
  type        = list(string)
}

# CIDR pour les subnets
variable "subnet_address_prefixes" {
  description = "Subnets CIDRs"
  type        = list(string)
}

# CIDR du subnet Bastion
variable "bastion_subnet_prefix" {
  description = "Bastion subnet CIDR"
  type        = string
}

###########################################
# Machines Virtuelles
###########################################

# Taille VM (ex: Standard_B1s)
variable "vm_size" {
  description = "VM size"
  type        = string
}

# Login admin
variable "admin_username" {
  description = "VM admin user"
  type        = string
}

# Password admin (sensible)
variable "admin_password" {
  description = "VM admin pass"
  type        = string
  sensitive   = true
}

# Image de la VM
variable "image_publisher" {
  description = "Image publisher"
  type        = string
}

variable "image_offer" {
  description = "Image offer"
  type        = string
}

variable "image_sku" {
  description = "Image SKU"
  type        = string
}

###########################################
# Application Gateway
###########################################

# IP publique pour l'App Gateway
variable "ag_public_ip_name" {
  description = "AG public IP name"
  type        = string
}

# Nom de l'Application Gateway
variable "appgw_name" {
  description = "AG name"
  type        = string
}

# Capacité (instances)
variable "appgw_capacity" {
  description = "AG capacity"
  type        = number
  default     = 2
}

# Zone primaire (ex: "1")
variable "primary_zone" {
  description = "Primary zone"
  type        = string
  default     = "1"
}

# Liste des zones (ex: ["1","2","3"])
variable "availability_zones" {
  description = "AG zones"
  type        = list(string)
  default     = ["1", "2", "3"]
}

###########################################
# Bastion
###########################################

# IP publique pour Bastion
variable "bastion_public_ip_name" {
  description = "Bastion IP name"
  type        = string
}

# Nom du Bastion
variable "bastion_name" {
  description = "Bastion name"
  type        = string
}

###########################################
# Stockage
###########################################

# Préfixe pour Storage Account
variable "storage_account_prefix" {
  description = "Storage prefix"
  type        = string
}

# Liste des images à uploader
variable "images_to_upload" {
  description = "Images to upload"
  type        = list(string)
  default     = ["/home/kdardenne/dev/azure/image/azure.png"]
}
