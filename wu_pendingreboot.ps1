# Windows Update is Up-To-Date
# Return Type: Boolean
# Execution Context: System 
# Execution Architecture: Auto

$pending = Invoke-CimMethod -Namespace "root/Microsoft/Windows/WindowsUpdate" -ClassName "MSFT_WUSettings" -MethodName IsPendingReboot
$PR = $pending.PendingReboot
#if ($pending.PendingReboot -eq TRUE){ return $true} else { return $false}
return $PR
