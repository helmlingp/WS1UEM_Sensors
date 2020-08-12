<#	
    .Synopsis
      Windows Update Sensors
    .NOTES
	  Created:   	June, 2020
	  Created by:	Phil Helmling, @philhelmling
	  Organization: 	VMware, Inc.
	  Filename:     	
	.DESCRIPTION
	  A bunch of Windows Update related Sensors
    .EXAMPLE
      
#>
wu_uptodate
$updateSession = new-object -com Microsoft.Update.Session
$updates=$updateSession.CreateUpdateSearcher().Search("IsInstalled=0 AND Type='Software'").updates
if ($updates.count -eq 0){ return $true} else { return $false}
 
wu_outofdate
$updateSession = new-object -com Microsoft.Update.Session
$updates=$updateSession.CreateUpdateSearcher().Search("IsInstalled=0 AND Type='Software'").updates
if ($updates.count -gt 0){ return $true} else { return $false}
 
wu_pendingreboot
$pending = Invoke-CimMethod -Namespace "root/Microsoft/Windows/WindowsUpdate" -ClassName "MSFT_WUSettings" -MethodName IsPendingReboot
$PR = $pending.PendingReboot
return $PR

wu_forcescan


wu_installKB
