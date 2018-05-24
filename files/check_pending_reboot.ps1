function Test-PendingReboot {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    process {
        if (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired' -ErrorAction SilentlyContinue) { return $true }
        if (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager' -Name 'PendingFileRenameOperations' -ErrorAction SilentlyContinue) { return $true }
        if (Get-ChildItem -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending' -ErrorAction SilentlyContinue) { return $true }
        if ((Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName').ComputerName -ne (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName').ComputerName) { return $true}

        $Environment002 = Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet002\Control\Session Manager\Environment' -ErrorAction SilentlyContinue | Select-Object -Property * -ExcludeProperty PSChildName, PSDrive, PSParentPath, PSPath, PSProvider
        if ($Environment002 -ne $null) {
            $Environment001 = Get-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Session Manager\Environment' -ErrorAction SilentlyContinue | Select-Object -Property * -ExcludeProperty PSChildName, PSDrive, PSParentPath, PSPath, PSProvider
            foreach ($property in $Environment001.PSObject.Properties.Name) {
                if (Compare-Object -DifferenceObject $Environment002 -ReferenceObject $Environment001 -Property $property) { return $true }
            }
        }

        $CCM_Client = Invoke-WmiMethod -Namespace 'ROOT\ccm\ClientSDK' -Class 'CCM_ClientUtilities' -Name 'DetermineIfRebootPending' -ErrorAction SilentlyContinue
        if ($CCM_Client -ne $null -and ($CCM_Client.RebootPending -or $CCM_Client.IsHardRebootPending)) { return $true }

        return $false
    }
}

Test-PendingReboot
