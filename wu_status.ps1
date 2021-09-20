# Report Status of Windows Update - Up-To-Date/Pending Reboot/Out-of-Date
# Return Type: String
# Execution Context: System 
# Execution Architecture: Auto
# based on https://docs.microsoft.com/en-us/windows/win32/wua_sdk/searching--downloading--and-installing-updates
# Criteria - https://docs.microsoft.com/en-us/windows/win32/api/wuapi/nf-wuapi-iupdatesearcher-search

$Session = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $Session.CreateUpdateSearcher()
$UpdateHistory = $UpdateSearcher.QueryHistory(0,100)

$Criteria = "IsHidden=0 and IsInstalled=0 and IsAssigned=1"
$SearchResult = $UpdateSearcher.Search($Criteria).Updates

$Sysinfo = New-Object -ComObject Microsoft.Update.SystemInfo
$pending = $Sysinfo.RebootRequired
if($pending -eq $true){return "Pending Reboot"} 

$status = 0
if ($SearchResult.Count -ne 0) {
  foreach ($newupd in $SearchResult) {
    $UpdateID = $newupd.Identity.UpdateID
    $updhistoryitem = $updhistory | Where-Object {$_.UpdateIdentity.UpdateID -match $UpdateID}
    if($updhistoryitem){
      if($updhistoryitem.ResultCode -eq 4) {$status = 4}
    }
  }
}

if ($SearchResult.Count -eq 0){
  return "Up-to-Date"
}else{
  if($status -eq 4){
    return "Update-Failed"
  } else {
    return "Out-of-Date"
  }
}