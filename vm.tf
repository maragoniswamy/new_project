resource "azurerm_resource_group" "aks_acr_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Define the virtual network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_virtual_network_name
  location            = azurerm_resource_group.aks_acr_rg.location
  resource_group_name = azurerm_resource_group.aks_acr_rg.name
  address_space       = ["10.1.0.0/16"]
}

# Define the subnet
resource "azurerm_subnet" "aks_subnet" {
  name                 = var.aks_subnet
  resource_group_name  = azurerm_resource_group.aks_acr_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.1.1.0/24"]

  service_endpoints = ["Microsoft.ContainerRegistry"]
}

# Define the virtual network
resource "azurerm_virtual_network" "acr_vnet" {
  name                = var.acr_virtual_network_name
  location            = azurerm_resource_group.aks_acr_rg.location
  resource_group_name = azurerm_resource_group.aks_acr_rg.name
  address_space       = ["10.2.0.0/16"]
}

# Define the subnet
resource "azurerm_subnet" "acr_subnet" {
  name                 = var.acr_subnet
  resource_group_name  = azurerm_resource_group.aks_acr_rg.name
  virtual_network_name = azurerm_virtual_network.acr_vnet.name
  address_prefixes     = ["10.2.1.0/24"]
}

# Peer ACR VNET to AKS VNET
resource "azurerm_virtual_network_peering" "acr_to_aks" {
  name                         = "acr-to-aks"
  resource_group_name          = azurerm_resource_group.aks_acr_rg.name
  virtual_network_name         = azurerm_virtual_network.acr_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.aks_vnet.id
  allow_virtual_network_access = true
}

# Peer AKS VNET to ACR VNET
resource "azurerm_virtual_network_peering" "aks_to_acr" {
  name                         = "aks-to-acr"
  resource_group_name          = azurerm_resource_group.aks_acr_rg.name
  virtual_network_name         = azurerm_virtual_network.aks_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.acr_vnet.id
  allow_virtual_network_access = true
}

# Define the network security group
resource "azurerm_network_security_group" "mynsg" {
  name                = "my-nsg"
  location            = azurerm_resource_group.aks_acr_rg.location
  resource_group_name = azurerm_resource_group.aks_acr_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


