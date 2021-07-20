<#	
  .Synopsis
  Returns value of 1 if Event ID is found in Windows Event Log
  .NOTES
  Created:	July, 2021
  Created by:	Phil Helmling, @philhelmling
  Organization:	VMware, Inc.

  .DESCRIPTION
  Use this sensor to report if an Event ID is reported in a Windows Event Log within the time window
  Will return 1 if it finds an event with matching event id in matching event log

  Change variables to match requirement
  
  Return Type: Integer
  Execution Context: System
#>

#Variables to modify
$StartTime = (Get-Date).AddDays(-1) #1 day prior to now
$EndTime = Get-Date
$Log = 'System'
$Id = '8'

$Logs = (Get-WinEvent -ListLog * | Where-Object { $_.RecordCount }).LogName
$filterTable = @('StartTime' = $StartTime
'EndTime' = $EndTime
'LogName' = $Log
'Id' = $Id
)
$Events = Get-WinEvent -FilterHashTable $filterTable -ea 'SilentlyContinue'

if($Events){return 1}else{return 0}