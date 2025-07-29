data "azurerm_public_ip" "ip_tanu" {
  name                = var.ip_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "frontend_subnet" {
   name                 = var.frontend_subnet
  virtual_network_name = var.virtual_network_name
  resource_group_name  = "rg-todoapp1"
}

variable "ip_name" {
  description = "The name of the public IP"
  type        = string
}

variable "frontend_subnet" {
  description = "The name of the frontend subnet"
  type        = string
}

data "azurerm_key_vault" "kv" {
  name                = "security"
  resource_group_name = "rg-security"
}

data "azurerm_key_vault_secret" "vm-username" {
  name         = "vm-username"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "vm-password" {
  name         = "vm-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}