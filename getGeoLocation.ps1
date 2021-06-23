<#	
  .Synopsis
  Windows 10 Sensor to determine location based on NAT'd IP of client
  .NOTES
  Created:	May, 2021
  Created by:	Phil Helmling, @philhelmling
  Organization:	VMware, Inc.
  Filename:	
  .DESCRIPTION
  Use this sensor to determine the Country or Region or City of the device based upon the NAT'd Public IP.
  Select which item you want to return.

  Might not be accurate for networks with centralized Internet Gateways.
  
  Return Type: String
  Execution Context: System
#>

#Use ipinfo.io service to get NAT IP Address as well as Geolocation data
#You will need a subscription to use this in a Company -> http://ipinfo.io
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
#Return value should be used to find in WS1 Intelligence Automation and Tag a device. 
#The Tag would be a filter in a SmartGroup which is used to assign a Profile/Application.

#example to return Country
return $devicegeoCountry

#Example to return proper Country names rather than shortnames
#if ($devicegeoCountry -eq "AU") {return "Australia"}
#elseif ($devicegeoCountry -eq "US") {return "United States"}
#elseif ($devicegeoCountry -eq "IN") {return "India"}

#example to return Region/State
#return $devicegeoRegion

#example to return City
#return $devicegeoCity

#example to return combination of all three attributes
#$returnvalue = "$devicegeoCountry-$devicegeoRegion-$devicegeoCity"