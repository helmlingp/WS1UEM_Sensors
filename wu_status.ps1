# Report Status of Windows Update - Up-To-Date/Pending Reboot/Out-of-Date
# Return Type: String
# Execution Context: System 
# Execution Architecture: Auto
# based on https://docs.microsoft.com/en-us/windows/win32/wua_sdk/searching--downloading--and-installing-updates
# Criteria - https://docs.microsoft.com/en-us/windows/win32/api/wuapi/nf-wuapi-iupdatesearcher-search

$Session = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $Session.CreateUpdateSearcher()
$Criteria = "IsHidden=0 and IsInstalled=0 and IsAssigned=1"
$SearchResult = $UpdateSearcher.Search($Criteria).Updates

$Sysinfo = New-Object -ComObject Microsoft.Update.SystemInfo
$pending = $Sysinfo.RebootRequired
if($pending -eq $true){return "Pending Reboot"} 

$failedstate = 0

if ($SearchResult.Count -ne 0) {
  $SearchResult | ForEach-Object {
    $UpdateID = $_.Identity.UpdateID
    $UpdateIdQuery = "UpdateID='$UpdateID'"
    $query = $session.QueryHistory("$UpdateIdQuery",0,100)
    #match Updates not installed with previous install status if exists
    $failed = $query | Where-Object {$_.ResultCode -eq 4} | Sort-Object -Property @{Expression = "Date"; Descending = $true} | Select-Object -First 1 
    if ($failed) {
      $failedstate = 1
    }
  }
  if($failedstate -eq 1){return "Update-Failed"} else {return "Out-of-Date"}
}
if ($SearchResult -eq 0){return "Up-to-Date"}
