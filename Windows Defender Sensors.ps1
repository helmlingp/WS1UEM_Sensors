<#	
    .Synopsis
      Windows Defender Sensors
    .NOTES
	  Created:   	June, 2020
	  Created by:	Phil Helmling, @philhelmling
	  Organization: 	VMware, Inc.
	  Filename:     	
	.DESCRIPTION
	  A bunch of Windows Defender related Sensors
	  See https://docs.microsoft.com/en-us/previous-versions/windows/desktop/defender/msft-mpthreatdetection for info on MSFT_MpThreatDetection class and return codes.

	  defender_uptodate returns True if Windows Defender signature was last updated less than or equal to 1 day ago. You want this to be True!
	  defender_outofdate7 returns True if Windows Defender signature was last updated less than or equal to 7 day ago and more than 1 day ago. 
	  defender_outofdate14 returns True if Windows Defender signature was last updated less than or equal to 14 day ago and more than 7 day ago. 
	  defender_threatremovalfailure returns True if any threat is detected and the status is either "CleanFailed", "QuarantineFailed", "RemoveFailed", "AllowFailed", "Abondoned", or "BlockedFailed"
	  defender_reqreboot returns True if any threat is detected and any status requires Reboot, eg. is either "RebootRequired", "FullScanAndRebootRequired", "RebootAndManualStepsRequired", "FullScanAndRebootAndManualStepsRequired", "RebootAndOfflineScanRequired", "FullScanAndRebootAndOfflineScanRequired", "RebootAndManualStepsAndOfflineScanRequired", "FullScanAndRebootAndManualStepsAndOfflineScanRequired"
	  defender_reqofflinescan returns True if any threat is detected and status is OfflineScanRequired
	  defender_reqfullscan returns True if any threat is detected and status requires FullScan, eg. is either "FullScanRequired", "FullScanAndRebootRequired", "FullScanAndManualStepsRequired", "FullScanAndRebootAndManualStepsRequired", "FullScanAndOfflineScanRequired", "FullScanAndManualStepsAndOfflineScanRequired", "FullScanAndRebootAndManualStepsAndOfflineScanRequired"
      
#>
defender_uptodate
$defender=(Get-Date).Subtract((Get-MpComputerStatus).AntispywareSignatureLastUpdated).TotalDays -LE 1
return $defender
 
 
defender_outofdate7
$defender=(Get-Date).Subtract((Get-MpComputerStatus).AntispywareSignatureLastUpdated).TotalDays -GT 1 -and (Get-Date).Subtract((Get-MpComputerStatus).AntispywareSignatureLastUpdated).TotalDays -LE 7
return $defender
 
 
defender_outofdate14
$defender=(Get-Date).Subtract((Get-MpComputerStatus).AntispywareSignatureLastUpdated).TotalDays -GT 7 -and (Get-Date).Subtract((Get-MpComputerStatus).AntispywareSignatureLastUpdated).TotalDays -LE 14
return $defender
 
 
defender_threatremovalfailure
$defender=(Get-MpThreatDetection | Where-Object {($_.ThreatStatusId -GT 6)} | Measure).Count -GT 0
return $defender
 
 
defender_reqreboot
$defender=((Get-MpThreatDetection | Where ThreatID -In (Get-MpThreat | Where IsActive -EQ $true | Select-Object -Property ThreatId).ThreatId | Where AdditionalActionsBitMask -IN @(8,12,24,28,32776,32780,32792,32796)) | Measure).Count -GT 0
return $defender
 
 
defender_reqofflinescan
$defender=((Get-MpThreatDetection | Where ThreatID -In (Get-MpThreat | Where IsActive -EQ $true | Select-Object -Property ThreatId).ThreatId | Where AdditionalActionsBitMask -ge 32768) | Measure).Count -GT 0
return $defender
 
 
defender_reqfullscan
$defender=((Get-MpThreatDetection | Where ThreatID -In (Get-MpThreat | Where IsActive -EQ $true | Select-Object -Property ThreatId).ThreatId | Where AdditionalActionsBitMask -IN @(4,12,20,28,32772,32788,32796)) | Measure).Count -GT 0
return $defender