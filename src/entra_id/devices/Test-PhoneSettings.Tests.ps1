Describe "Microsoft Entra Device Settings Verification" {
    BeforeEach {
        # Import Microsoft Graph PowerShell SDK
        Import-Module Microsoft.Graph -WarningAction Stop
        Connect-MgGraph -Scopes "Device.ReadAll", "Group.ReadAll", "User.ReadAll"
    }

    It "Verifies device joining permissions are set to 'All'" {
        $deviceJoiningSettings = Get-MgDeviceSetting -SettingId "DeviceJoiningPermissions"
        $deviceJoiningSettings.Value | Should Be "All"
    }

    It "Verifies device registration permissions are set to 'All'" {
        $deviceRegistrationSettings = Get-MgDeviceSetting -SettingId "DeviceRegistrationPermissions"
        $deviceRegistrationSettings.Value | Should Be "All"
    }

    It "Confirms MFA is not required for device registration/joining" {
        $mfaSettings = Get-MgDeviceSetting -SettingId "DeviceRegistrationMfaRequired"
        $mfaSettings.Value | Should Be "No"
    }

    It "Verifies device limit is set to 'Unlimited'" {
        $deviceLimitSettings = Get-MgDeviceSetting -SettingId "DeviceLimitPerUser"
        $deviceLimitSettings.Value | Should Be "Unlimited"
    }

    It "Checks local admin settings" {
        $localAdminSettings = Get-MgDeviceSetting -SettingId "LocalAdministratorSettings"
        
        $globalAdminAsLocalAdmin = $localAdminSettings.Value['GlobalAdministratorAsLocalAdmin']
        $globalAdminAsLocalAdmin | Should Be $false
        
        $registeringUserAsLocalAdmin = $localAdminSettings.Value['RegisteringUserAsLocalAdmin']
        $registeringUserAsLocalAdmin | Should Be $null
        
        $lapsEnabled = $localAdminSettings.Value['LapsEnabled']
        $lapsEnabled | Should Be $true
    }

    It "Verifies BitLocker key recovery is not restricted" {
        $bitlockerSettings = Get-MgDeviceSetting -SettingId "BitLockerKeyRecovery"
        $bitlockerSettings.Value | Should Be "No"
    }

    AfterEach {
        Disconnect-MgGraph
    }
}