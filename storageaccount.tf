###########################################
# 7. Storage Accounts
###########################################

# 1. Création d'un Storage Account par subnet
resource "azurerm_storage_account" "storage" {
  # On crée autant de comptes de stockage qu'il y a de subnets
  count                    = length(var.subnet_address_prefixes)
  name                     = lower("${var.storage_account_prefix}${count.index}")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Autoriser l'accès depuis le subnet correspondant
  network_rules {
    default_action             = "Allow"
    virtual_network_subnet_ids = [element(azurerm_subnet.subnet[*].id, count.index)]
  }
}

# 2. Container "images" en accès privé (pas de lecture publique)
resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_id    = azurerm_storage_account.storage[0].id
  container_access_type = "private"
}

# 3. Upload automatique des images dans le container
resource "azurerm_storage_blob" "images" {
  # Boucle sur la liste var.images_to_upload
  for_each               = toset(var.images_to_upload)
  name                   = basename(each.value)                            # Nom du blob (ex: "azure.png")
  storage_account_name   = azurerm_storage_account.storage[0].name         # Compte de stockage (index 0)
  storage_container_name = azurerm_storage_container.images.name           # Container "images"
  type                   = "Block"
  source                 = each.value                                      # Chemin local vers l'image
  content_type           = lookup({                                        # Deviner le content_type
    ".jpg" = "image/jpeg",
    ".png" = "image/png"
  }, lower(substr(each.value, length(each.value)-3, 4)), "application/octet-stream")
}

###########################################
# Data source : SAS au niveau du compte
###########################################
data "azurerm_storage_account_sas" "images_sas" {
  # Connection string du compte de stockage (index 0)
  connection_string = azurerm_storage_account.storage[0].primary_connection_string

  # Période de validité du SAS
  start  = "2025-01-01"
  expiry = "2025-12-31"

  # Forcer l'usage du HTTPS
  https_only = true

  # Services activés : ici, seulement le Blob
  services {
    blob  = true
    file  = false
    queue = false
    table = false
  }

  # Ressources ciblées : service, container, object
  resource_types {
    service   = true
    container = true
    object    = true
  }

  # Permissions : lecture et liste activées
  permissions {
    read   = true
    write  = false
    create = false
    delete = false
    list   = true
    add    = false
    update = false
    process = false
    tag    = false
    filter = false
  }
}

###########################################
# Locals : construction d'une URL signée
###########################################

locals {
  # single_image_key = la première clé du map "azurerm_storage_blob.images"
  single_image_key  = keys(azurerm_storage_blob.images)[0]

  # single_image_blob = la ressource blob associée à cette clé
  single_image_blob = azurerm_storage_blob.images[local.single_image_key]

  # single_image_url = URL signée (SAS) permettant de lire l'image
  single_image_url = format(
    "%s%s/%s?%s",
    azurerm_storage_account.storage[0].primary_blob_endpoint,  // ex: https://storaccabcd.blob.core.windows.net/
    azurerm_storage_container.images.name,                     // "images"
    local.single_image_blob.name,                              // "azure.png"
    data.azurerm_storage_account_sas.images_sas.sas            // le token SAS généré
  )
}
