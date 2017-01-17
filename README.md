# Building a Visual Studio dev maching on Azure with Terraform

This project allows a developer to create a new Windows 2012 VM with Visual Studio 2015 Community Edition, VS Code and some other supporting tools on Azure.

## Getting Started
In order to run this process, you first have to setup an Active Directory Application and Service Principal with the appropriate rights to create new infrastructure on the account.  The [createAppRegistration.ps1](../master/azure/createAppRegistration.ps1) powershell script is available to perform this registration.  From the root of the repo, you can make the following call, passing the name of the AD Application you want to create along with the Secret that you would like stored in your environment variables.
```
powershell .\azure\createAppRegistration.ps1 -appName "MyAppName" -secret "AReallyGreatSecret"
```

## Provisioning VM with Terraform
Once the above process to create your Active Directory Application and Service Principal are complete, you can then view the plan that terraform will use to create your new infrastructure by running the following from a command line.
```
cd infrastructure
terraform plan
```
This will show you a plan for creating the Resource Group, Network resources and VM along with a few other dependencies.  You can apply these changes by running the following in a command line.
```
terraform apply
```
Optionally you can pass in variables to *terraform apply* if you want to override the default variables as follows:
```
terraform apply -var 'admin_username=myuser' -var 'admin_password=really$tr0ngPa$$w0rd'
```
This step can take a number of minutes (usually about 15 minutes in my experience), however it will create the VM and run the following provisioning steps:
* Open firewall ports for RDP and WINRM
* Install Chocolatey
* Install multiple tools via Chocolatey (see [InstallChocolateyDependencies.ps1](../master/infrastructure/provision/InstallChocolateyDependencies.ps1) for a list of the tools)

## Starting RDP
Rather than going to Azure to find the IP Address or Host Name for you new VM, we can extract that directly from the terraform state, once the VM has been created successfully.  From the root of the repo, you can call the following to start up a new RDP session.  This will require the admin_username and admin_password that were defined in the [vars.tf](../master/infrastructure/vars.tf) file, unless you overrode those variables when calling terraform apply.
```
start-rdp.bat
```
