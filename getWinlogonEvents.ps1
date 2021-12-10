<#	
  .Synopsis
  Returns user logon events found in Windows Security Event Log
  .NOTES
  Created:	December, 2021
  Created by:	Phil Helmling, @philhelmling
  Organization:	VMware, Inc.

  .DESCRIPTION
  Use this sensor to report on user logons as shown in Windows Security Event Log within the time window
  Will return 0 if no user logon events.
  Excludes SYSTEM logon events, preventing reporting of system services

  Change variables to match requirement
  
  Return Type: String
  Execution Context: System
#>

#Variables to modify
$StartTime = (Get-Date).AddDays(-1) #1 day prior to now
$EndTime = Get-Date
$Log = 'Security'
$Id = '4624'

$filterTable = @{'StartTime' = $StartTime;
'EndTime' = $EndTime;
'LogName' = $Log;
'Id' = $Id
}
$Events = Get-WinEvent -FilterHashTable $filterTable -ea 'SilentlyContinue'
$eventarray = @();
foreach ($event in $events){
	$PSObject = New-Object PSObject -Property @{
		TimeCreated = $event.TimeCreated
		SID = $event.Properties.value[4]
		UPN = $event.Properties.value[5]
		Domain = $event.Properties.value[6]
	}
	$eventarray += $PSObject
}
$eventproperties = @(
	@{N="TimeCreated";E={$_.TimeCreated}},
	@{N="UPN";E={$_.UPN}},
	@{N="Domain";E={$_.Domain}},
	@{N="SID";E={$_.SID}}
	)
$streventarray = $eventarray | select-object -Property $eventproperties | where-object {$_.SID -ne "S-1-5-18"} | Sort-Object TimeCreated | Format-Table

if($Events){return $streventarray}else{return 0}