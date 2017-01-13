resource "azurerm_storage_account" "default" {
    name = "cjazuredevstorage"
    resource_group_name = "${azurerm_resource_group.default.name}"
    location = "${var.azure_region_fullname}"
    account_type = "Standard_LRS"

    tags {
        environment = "${var.environment_tag}"
    }
}

resource "azurerm_storage_container" "default" {
    name = "defaultstoragecontainer"
    resource_group_name = "${azurerm_resource_group.default.name}"
    storage_account_name = "${azurerm_storage_account.default.name}"
    container_access_type = "private"
}

