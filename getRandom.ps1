<#	
  .Synopsis
  Returns a random number between 1 and 9
  .NOTES
  Created:	May, 2021
  Created by:	Phil Helmling, @philhelmling
  Organization:	VMware, Inc.

  .DESCRIPTION
  Use this sensor to write a random number to the registry if not already set
  and return the value to WS1 Intelligence. 
  Can be used to create dynamic SmartGroups for Windows Update Deployment Rings.
  
  Return Type: Integer
  Execution Context: System
#>

$value = Get-Random -Minimum 1 -Maximum 10
$name = "DeploymentRing"
$key = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Airwatch"
if(Get-ItemProperty -Path $key -Name $name -ErrorAction Ignore) {
  $returnvalue = (Get-ItemProperty -Path $key -Name $name).$name
} else {
  New-ItemProperty -Path $key -Name $name -PropertyType DWORD -Value $value -ErrorAction SilentlyContinue -Force
  sleep 1
  $returnvalue = (Get-ItemProperty -Path $key -Name $name).$name
}

return $returnvalue
