output "ip" {
    value = "${azurerm_public_ip.default.ip_address}"
}

output "fqdn" {
	value = "${azurerm_public_ip.default.fqdn}"
}

output "vm_name" {
	value = "${var.vm_name_prefix}"
}

output "resource_group_name" {
	value = "${var.resource_group_name}"
}