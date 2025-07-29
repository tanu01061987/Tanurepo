module"resource_group"{
    source = "../modules/azurerm_resource_group"
    resource_group_name = "rg-todoapp1"
    resource_group_location = "Central US"
}
module "virtual_network" {
  source                   = "../modules/azurerm_virtual_network"
  resource_group_name      = "rg-todoapp1"
  virtual_network_name     = "vnet-todoapp1"
  address_space            = ["10.0.0.0/24"]
  virtual_network_location = "Central US"
}

module "frontend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = "rg-todoapp1"
  virtual_network_name = "vnet-todoapp1"
  subnet_address_prefixes     = ["10.0.0.0/25"]
  subnet_name          = "frontend_subnet"
}
module "backend_subnet" {
  depends_on           = [module.virtual_network]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = "rg-todoapp1"
  virtual_network_name = "vnet-todoapp1"
  subnet_address_prefixes     = ["10.0.128/25"]
  subnet_name          = "backend_subnet"
}




module "public_ip_frontend" {
  depends_on = [ module.resource_group, module.virtual_network, module.frontend_subnet]
  source              = "../modules/azurerm_public_ip"
  public_ip_name      = "pip-todoapp1-frontend" 
  resource_group_name = "rg-todoapp1"
  location            = "eastus"
  allocation_method   = "Static"
}

module "frontend_vm" {
  depends_on = [module.frontend_subnet, module.public_ip_frontend]
  source     = "../modules/azurerm_virtual_machine"

  resource_group_name    = "rg-todoapp1"
  location               = "eastus"
  vm_name                = "vm-frontend"
  vm_size                = "Standard_B1s"
  admin_username         = "devopsinsider"
  admin_password         = "P@ssw0rd1234"
  image_publisher        = "Canonical"
  image_offer            = "0001-com-ubuntu-server-focal"
  image_sku              = "20_04-lts"
  image_version          = "latest"
  nic_name               = "nic-vm-frontend"
  virtual_network_name   = "vnet-todoapp1"
  subnet_name            = "frontend_subnet"
  pip_name               = "pip-todoapp1-frontend"
  ip_name                = "pip-todoapp1-frontend"
  frontend_subnet        = "frontend_subnet"
}

module "public_ip_backend" {
  depends_on = [ module.resource_group , module.virtual_network, module.backend_subnet]
  source              = "../modules/azurerm_public_ip"
  public_ip_name      = "pip-todoapp1-backend"
  resource_group_name = "rg-todoapp1"
  location            = "Central US"
  allocation_method   = "Static"
}

 module "backend_vm" {
  depends_on = [module.backend_subnet, module.public_ip_backend]
  source     = "../modules/azurerm_virtual_machine"
  resource_group_name  = "rg-todoapp1"
  location             = "Central US"
  vm_name              = "vm-backend"
  vm_size              = "Standard_B1s"
  admin_username       = "devopsinsider"
  admin_password       = "P@ssw0rd1234"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-vm-backend"
  virtual_network_name = "vnet-todoapp1"
  subnet_name          = "backend_subnet"
  pip_name             = "pip-todoapp1-backend"
  ip_name              = "pip-todoapp1-backend"
  frontend_subnet      = "frontend_subnet"
}

module "sql_server" {
  source              = "../modules/azurerm_sql_server"
  sql_server_name     = "sqlserver-todoapp1"
  resource_group_name = "rg-todoapp1"
  location            = "Central US"
  administrator_login          = "DevOpsAdmin"
  administrator_login_password = "tanu@123"
}





module "key_vault" {
  source              = "../modules/azurerm_key_vault"
  key_vault_name      = "khajana"
  location            = "East US"
  resource_group_name = "rg-todoapp1"
}

module "vm-password" {
  source              = "../modules/azurerm_key_vault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "Khajana"
  resource_group_name = "rg-todoapp1"
  secret_name         = "vm-password"
  secret_value        = "tanu@1234"
}

module "vm-username" {
  source              = "../modules/azurerm_key_vault_secret"
  depends_on          = [module.key_vault]
  key_vault_name      = "Khajana"
  resource_group_name = "rg-todoapp1"
  secret_name         = "vm-username"
  secret_value        = "tanu@1234"
}