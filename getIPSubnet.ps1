<#	
  .Synopsis
  Windows 10 Sensor to get Site Name based on IP Subnet Octet + IP Default GW
  .NOTES
  Created:	May, 2021
  Created by:	Phil Helmling, @philhelmling
  Organization:	VMware, Inc.
  Filename:	
  .DESCRIPTION
  Get Site Name based on IP Subnet Octet + IP Default GW
  Uses a 3d array. Each line must align with value in preceeding line. 
  For example, subnet 192.168.1 has default GW of 192.168.1.1 and is in Adelaide. Each is in the same position, on the relevant line
#>

$localsubnets = @(
  ('192.168.1','192.168.2','10.200.20','10.200.22'),
  ('192.168.1.1','192.168.2.1','10.200.20.254','10.200.22.254'),
  ('Adelaide','Sydney','Melbourne','Brisbane')
)

#Get local IP Address
$NIC = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
$CurrentIP = ($NIC.IPAddress[0])
#Get local subnet address
$CurrentIPOctet = $CurrentIP.Substring(0, $CurrentIP.lastIndexOf('.'))
$DefaultGW = ($NIC.DefaultIPGateway)

if($localsubnets[0].Contains($CurrentIPOctet)){
  $index = [array]::indexof($localsubnets[0],$CurrentIPOctet)
  if($localsubnets[1] -Contains $DefaultGW){
    return $localsubnets[2][$index]
  }
}