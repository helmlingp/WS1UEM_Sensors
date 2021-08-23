# Report Status of Windows Update - Up-To-Date/Pending Reboot/Out-of-Date
# Return Type: String
# Execution Context: System 
# Execution Architecture: Auto

$Criteria = "IsHidden=0 and IsInstalled=0" #and Type='Software'"
$Session = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $Session.CreateUpdateSearcher()
$SearchResult = $UpdateSearcher.Search($Criteria).Updates
$Installer = New-Object -ComObject Microsoft.Update.Installer
$Installer.Updates = $SearchResult

$pending = $InstallResult.rebootRequired
if($pending -eq $true){ 
  return "Pending Reboot"
} else { 
  if ($SearchResult.Count -ne 0) {
    return "Out-of-Date"
  } else { return "Up-to-Date"}
}
