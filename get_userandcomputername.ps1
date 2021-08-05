# Return current logged in user comma computername
# Return Type: Boolean
# Execution Context: System or User
# Execution Architecture: Auto

$domainuser = Get-WmiObject -Class "Win32_ComputerSystem" | select username
$user = ($domainuser.username).Substring($domainuser.username.IndexOf('\')+1)
$computername = Get-WmiObject -Class "Win32_ComputerSystem" | select name

return $user + "," + $computername.Name
