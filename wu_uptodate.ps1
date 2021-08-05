# Windows Update is Up-To-Date
# Return Type: Boolean
# Execution Context: System 
# Execution Architecture: Auto

$updateSession = new-object -com Microsoft.Update.Session
$updates=$updateSession.CreateUpdateSearcher().Search("IsInstalled=0 AND Type='Software'").updates
if ($updates.count -eq 0){ return $true} else { return $false}
