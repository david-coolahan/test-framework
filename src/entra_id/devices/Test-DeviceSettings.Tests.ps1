Describe "Device Settings Validation" -Tags "AzureAD", "DeviceSettings" {
    BeforeEach {
        # Ensure authentication is properly configured
        Connect-MgGraph -Scopes "Device.ReadWrite.All"
    }

    It "Verifies device join and registration settings" {
        # Check if users can join devices
        $deviceJoinSettings = Get-MgDeviceSetting -Filter "DisplayName eq 'Device Join Settings'"
        $deviceJoinSettings.DisplayName | Should Be "Device Join Settings"
        $deviceJoinSettings.IsEnabled | Should Be $true
        
        # Check if users can register devices
        $deviceRegistrationSettings = Get-MgDeviceSetting -Filter "DisplayName eq 'Device Registration Settings'"
        $deviceRegistrationSettings.DisplayName | Should Be "Device Registration Settings"
        $deviceRegistrationSettings.IsEnabled | Should Be $true
        
        # Verify MFA requirement for registration/join
        $mfaSettings = Get-MgDeviceSetting -Filter "DisplayName eq 'Multifactor Authentication Settings'"
        $mfaSettings.DisplayName | Should Be "Multifactor Authentication Settings"
        $mfaSettings.IsEnabled | Should Be $false
    }

    It "Verifies local administrator settings" {
        # Check LAPS configuration
        $lapsSettings = Get-MgDeviceSetting -Filter "DisplayName eq 'Local Administrator Password Solution Settings'"
        $lapsSettings.DisplayName | Should Be "Local Administrator Password Solution Settings"
        $lapsSettings.IsEnabled | Should Be $true
        
        # Verify local admin role during join
        $localAdminSettings = Get-MgDeviceSetting -Filter "DisplayName eq 'Local Administrator Role During Join'"
        $localAdminSettings.DisplayName | Should Be "Local Administrator Role During Join"
        $localAdminSettings.IsEnabled | Should Be $false
    }

    It "Verifies other device settings" {
        # Check BitLocker key recovery restriction
        $bitLockerSettings = Get-MgDeviceSetting -Filter "DisplayName eq 'BitLocker Key Recovery Restriction'"
        $bitLockerSettings.DisplayName | Should Be "BitLocker Key Recovery Restriction"
        $bitLockerSettings.IsEnabled | Should Be $false
    }
}