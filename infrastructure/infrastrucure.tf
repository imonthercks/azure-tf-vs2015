# Configure the Microsoft Azure Provider
provider "azurerm" {}

# Create a resource group
resource "azurerm_resource_group" "default" {
    name     = "${var.resource_group_name}"
    location = "${var.azure_region_fullname}"
}

resource "azurerm_public_ip" "default" {
  name                         = "${var.vm_name_prefix}-ip"
  location                     = "${var.azure_region_fullname}"
  resource_group_name          = "${azurerm_resource_group.default.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label = "${var.vm_name_prefix}"
}

# Create a virtual network in the web_servers resource group
resource "azurerm_virtual_network" "default" {
  name                = "azuredevnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.azure_region_fullname}"
  resource_group_name = "${azurerm_resource_group.default.name}"
}

resource "azurerm_subnet" "default" {
    name = "defaultsubnet"
    resource_group_name = "${azurerm_resource_group.default.name}"
    virtual_network_name = "${azurerm_virtual_network.default.name}"
    address_prefix = "10.0.2.0/24"
}

resource "azurerm_network_interface" "default" {
    name = "defaultnic"
    location = "${var.azure_region_fullname}"
    resource_group_name = "${azurerm_resource_group.default.name}"

    ip_configuration {
        name = "defaultnicconfig"
        subnet_id = "${azurerm_subnet.default.id}"
        private_ip_address_allocation = "dynamic"
		public_ip_address_id = "${azurerm_public_ip.default.id}"
    }
}

