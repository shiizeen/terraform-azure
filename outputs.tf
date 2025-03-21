output "resource_group_name" {
  description = "Nom du Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "ID du Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "IDs du subnet"
  value       = azurerm_subnet.subnet[*].id
}

output "vm_ips" {
  description = "IP des VMs"
  value       = azurerm_linux_virtual_machine.web_vm[*].private_ip_address
}

output "ag_public_ip" {
  description = "Public IP de l'Application Gateway"
  value       = azurerm_public_ip.ag_public_ip.ip_address
}

output "storage_account_names" {
  description = "Storage Accounts"
  value       = azurerm_storage_account.storage[*].name
}

output "application_gateway_name"{
  description = "ID de l'Application gateway"
  value       =  azurerm_application_gateway.appgw.id 
}
