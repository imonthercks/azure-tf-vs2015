variable "vm_name_prefix" { 
	description = "The Virtual Machine Name"
    default = "cj-dev-vm"
}

variable "vm_size" {
	description = "The size of the Virtual Machine"
	default = "Standard_DS2_V2"
}

variable "admin_username" {
    description = "Username for the Administrator account"
    default = "vsdevadmin"
}

variable "admin_password" {
    description = "Password for the Administrator account"
}

variable "vm_winrm_port" {
    description = "WinRM Public Port"
    default = "5986"
}

variable "azure_region" {
    description = "Azure Region for all resources"
    default = "eastus"
}

variable "azure_region_fullname" {
    description = "Long name for the Azure Region, ie. North Europe"
    default = "East US"
}

variable "azure_dns_suffix" {
    description = "Azure DNS suffix for the Public IP"
    default = "cloudapp.azure.com"
}

variable "environment_tag" {
    description = "Tag to apply to the resoucrces"
    default = "dev"
}