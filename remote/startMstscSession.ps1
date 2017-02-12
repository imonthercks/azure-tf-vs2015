cd .\infrastructure
$fqdn = terraform output fqdn
$vmname = terraform output vm_name
$rgname = terraform output resource_group_name

if ($LastExitCode -ne 0) {
    $Host.UI.WriteErrorLine("Cannot start new RDP Session because VM has not been created.  Run terraform apply to create VM")
	exit
}

$user = Login-AzureRmAccount
$status = Get-AzureRmVM -ResourceGroupName $rgname -Name $vmname -Status

if (($status.Statuses | Where {$_.Code -Match "PowerState/deallocated"}).DisplayStatus -eq "VM deallocated") {
	Write-Host "VM was not started.  Starting now..."
	Start-AzureRmVM -ResourceGroupName $rgname -Name $vmname
	Write-Host "VM Started"
}

Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:$fqdn"

cd ..