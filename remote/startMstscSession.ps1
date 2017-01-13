$fqdn = terraform output fqdn

if ($LastExitCode -ne 0) {
        $Host.UI.WriteErrorLine("Cannot start new RDP Session because VM has not been created.  Run terraform apply to create VM")
}
else{
	Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:$fqdn"
}