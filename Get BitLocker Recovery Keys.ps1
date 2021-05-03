# Credit: Saurabh Jhunjhunwala
# Identify all the Bitlocker volumes.
$BitlockerVolumers = Get-BitLockerVolume
# For each volume, get the RecoveryPassowrd and display it.
$BitlockerVolumers |
    ForEach-Object {
        $MountPoint = $_.MountPoint 
        $RecoveryKey = [string]($_.KeyProtector).RecoveryPassword       
        if ($RecoveryKey.Length -gt 5) {
            Write-Output ("The drive $MountPoint has a recovery key $RecoveryKey.")
        }        
    }