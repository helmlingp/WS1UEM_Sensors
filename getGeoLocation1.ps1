<#	
  .Synopsis
  USING NAT'd IP OF DEVICE WITH IPINFO.IO SERVICE
  .NOTES
  Created:	May, 2021
  Created by:	Phil Helmling, @philhelmling
  Organization:	VMware, Inc.

  .DESCRIPTION
  USING NAT'd IP OF DEVICE WITH IPINFO.IO SERVICE
  
  Return Type: String
  Execution Context: System
#>

#ipinfo.io APIToken
$APIToken = '98734134kjh'

#Ensure Internet Explorer first launch is disabled
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2

#Get NAT IP Address
$devicenatip = (Invoke-WebRequest -Uri 'http://ipinfo.io/ip').Content

#Get GeoLocation Data
$endpoint = "http://ipinfo.io/$devicenatip"+"?token="+"$APIToken"
$devicegeodata = Invoke-RestMethod -Uri $endpoint
$devicegeoCountry = $devicegeodata.Country
$devicegeoRegion = $devicegeodata.Region
$devicegeoCity = $devicegeodata.City

#Refer to https://www.geonames.org/countries/ for $devicegeoCountry codes.

#example to return Country
return $devicegeoCountry