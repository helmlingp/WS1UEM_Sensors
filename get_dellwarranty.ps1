<# 
  .SYNOPSIS
    This script gathers the Dell Warranty info on the current Dell device.
  .DESCRIPTION
    Credit to https://github.com/connochio/Powershell.Modules/blob/master/Get-DellWarranty/Get-DellWarranty.psm1  
    Uses Dell Tech Direct API to gather Dell Warranty info on the current device.

    Requires Dell Tech Direct API authentication APIKey and APISecret. These must be provided as variables to a Workspace ONE Script.
    Can be deployed as both Script and Sensor
  .EXAMPLE
    .\get_dellwarranty.ps1
  .NOTES 
    Created:   	    August, 2023
    Created by:	    Phil Helmling, @philhelmling
    Organization:   VMware, Inc.
    Filename:       get_dellwarranty.ps1
    GitHub:         https://github.com/helmlingp/sensors
#>

#register for a Dell Tech Direct account for API access here - https://tdm.dell.com/portal
#use this API to retrieve warranty details based on the device serial number
#https://apigtwb2c.us.dell.com/PROD/sbil/eapi/v5/asset-entitlements
#example powershell module here - https://github.com/connochio/Powershell.Modules/blob/master/Get-DellWarranty/Get-DellWarranty.psm1
#need to auth first, then do get
$registryPath = "HKLM:\SOFTWARE\DELL\WARRANTY"
$ApiKey = $env:apikey
$ApiSecret = $env:apisecret
if(!$ApiKey){
  if (!(Test-Path $registryPath)){
    return $null
  } else {
    $WarrantyEndDate = Get-ItemPropertyValue -Path $registryPath -Name 'WarrantyEndDate'
    return $WarrantyEndDate
  }
} else {
  if (!(Test-Path $registryPath)){
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Auth = Invoke-WebRequest "https://apigtwb2c.us.dell.com/auth/oauth/v2/token?client_id=${ApiKey}&client_secret=${ApiSecret}&grant_type=client_credentials" -Method Post
    $AuthSplit = $Auth.Content -split('"')
    $AuthKey = $AuthSplit[3]

    $ServiceTag = ((Get-WmiObject -Class "Win32_Bios").SerialNumber)

    $body = "?servicetags=" + $ServiceTag + "&Method=Get"
    $response = Invoke-WebRequest -uri https://apigtwb2c.us.dell.com/PROD/sbil/eapi/v5/asset-entitlements${body} -Headers @{"Authorization"="bearer ${AuthKey}";"Accept"="application/json"}
    $content = $response.Content | ConvertFrom-Json

    #get data in response, format and return warranty end date
    #Sort, then parse the first (start) and last (end) warranty entitlement
    $sortedEntitlements = $content.entitlements | Sort endDate #Dell doesn't list in order. This sorts so the latest entitlement is last.
    $WarrantyEndDateRaw = (($sortedEntitlements.endDate | Select -Last 1).split("T"))[0]
    $WarrantyEndDate = [datetime]::ParseExact($WarrantyEndDateRaw, "yyyy-MM-dd", $null)

    #stamp the registry so we only do this once per machine
    $registryPath = "HKLM:\SOFTWARE\DELL\WARRANTY"
    If (-NOT (Test-Path $registryPath)) {
        New-Item $registryPath | Out-Null
        }

    New-ItemProperty -Path $registryPath -Name 'WarrantyStartDate' -Value $WarrantyStartDate -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name 'WarrantyEndDate' -Value $WarrantyEndDate -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name 'WarrantySupportLevel' -Value $WarrantyLevel -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name 'Model' -Value $Model -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name 'OriginalShipDate' -Value $ShipDate -PropertyType ExpandString -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name 'ServiceTag' -Value $ServiceTag -PropertyType ExpandString -Force | Out-Null
    } else {
      $WarrantyEndDate = Get-ItemPropertyValue -Path $registryPath -Name 'WarrantyEndDate'
      return $WarrantyEndDate
    }
}

