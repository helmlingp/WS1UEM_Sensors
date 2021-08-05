# Windows Update is Out-Of-Date
# Return Type: Boolean
# Execution Context: System 
# Execution Architecture: Auto

$updateSession = new-object -com Microsoft.Update.Session
$updates=$updateSession.CreateUpdateSearcher().Search("IsInstalled=0 AND Type='Software'").updates
if ($updates.count -gt 0){ return $true} else { return $false}