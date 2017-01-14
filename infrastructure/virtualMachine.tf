resource "azurerm_virtual_machine" "default" {
    name = "${var.vm_name_prefix}"
    location = "${var.azure_region_fullname}"
    resource_group_name = "${azurerm_resource_group.default.name}"
    network_interface_ids = ["${azurerm_network_interface.default.id}"]
    vm_size = "${var.vm_size}"
	delete_os_disk_on_termination = "true"

    storage_image_reference {
        publisher = "MicrosoftVisualStudio"
        offer = "VisualStudio"
        sku = "VS-2015-Comm-AzureSDK-29-WS2012R2"
        version = "latest"
    }

    storage_os_disk {
        name = "myosdisk1"
        vhd_uri = "${azurerm_storage_account.default.primary_blob_endpoint}${azurerm_storage_container.default.name}/vs2015dev.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.vm_name_prefix}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
		custom_data = "${base64encode("Param($RemoteHostName = \"${var.vm_name_prefix}.${var.azure_region}.${var.azure_dns_suffix}\", $ComputerName = \"${var.vm_name_prefix}\", $WinRmPort = ${var.vm_winrm_port}) ${file("Deploy.PS1")}")}"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = false
		provision_vm_agent = false
		
		additional_unattend_config {
            pass = "oobeSystem"
            component = "Microsoft-Windows-Shell-Setup"
            setting_name = "AutoLogon"
            content = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
        }
		
		#Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
        additional_unattend_config {
            pass = "oobeSystem"
            component = "Microsoft-Windows-Shell-Setup"
            setting_name = "FirstLogonCommands"
            content = "${file("FirstLogonCommands.xml")}"
        }
    }

	provisioner "file" {
        source = ".\\provision\\InstallChocolateyDependencies.PS1"
        destination = "C:\\Scripts\\InstallChocolateyDependencies.PS1"
        connection {
            type = "winrm"
            https = true
            insecure = true
            user = "${var.admin_username}"
            password = "${var.admin_password}"
            host = "${var.vm_name_prefix}.${var.azure_region}.${var.azure_dns_suffix}"
			port = "${var.vm_winrm_port}"
        }
    }
	
	provisioner "remote-exec" {
      inline = [
        "powershell.exe -sta -ExecutionPolicy Unrestricted -file C:\\Scripts\\InstallChocolateyDependencies.ps1",
      ]
        connection {
            type = "winrm"
            timeout = "20m"
            https = true
            insecure = true
            user = "${var.admin_username}"
            password = "${var.admin_password}"
            host = "${var.vm_name_prefix}.${var.azure_region}.${var.azure_dns_suffix}"
			port = "${var.vm_winrm_port}"
        }
    }
    tags {
        environment = "${var.environment_tag}"
    }
}