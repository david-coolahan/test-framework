Describe "Device Settings Configuration" -Tag "DeviceSettings" {
    BeforeEach {
        # Authenticate to Microsoft Graph
        $scopes = @("https://graph.microsoft.com/.default")
        $token = Get-MsalToken -ClientId "your-client-id" -TenantId "your-tenant-id" -Scopes $scopes
        $graphClient = New-MgGraphClient -Token $token.Token
    }

    It "Verifies Microsoft Entra join and registration settings" {
        # Check device join permissions
        $deviceJoinSettings = Get-MgDeviceSetting -SettingName "Device Join Settings"
        $deviceJoinSettings.Value | Should Be "All"
        
        # Check device registration permissions
        $deviceRegistrationSettings = Get-MgDeviceSetting -SettingName "Device Registration Settings"
        $deviceRegistrationSettings.Value | Should Be "All"
        
        # Check MFA requirement for device registration
        $mfaSetting = Get-MgDeviceSetting -SettingName "Device Registration MFA Requirement"
        $mfaSetting.Value | Should Be "No"
        
        # Check maximum devices per user
        $maxDevicesSetting = Get-MgDeviceSetting -SettingName "Maximum Devices Per User"
        $maxDevicesSetting.Value | Should Be "Unlimited"
    }

    It "Verifies local administrator settings" {
        # Check global admin as local admin
        $globalAdminSetting = Get-MgDeviceSetting -SettingName "Global Admin as Local Admin"
        $globalAdminSetting.Value | Should Be "No"
        
        # Check registration user as local admin
        $registrationUserSetting = Get-MgDeviceSetting -SettingName "Registration User as Local Admin"
        $registrationUserSetting.Value | Should Be "None"
        
        # Check LAPS configuration
        $lapsSetting = Get-MgDeviceSetting -SettingName "LAPS Configuration"
        $lapsSetting.Value | Should Be "Yes"
    }

    It "Verifies other device settings" {
        # Check BitLocker key restriction
        $bitLockerSetting = Get-MgDeviceSetting -SettingName "BitLocker Key Recovery Restriction"
        $bitLockerSetting.Value | Should Be "No"
    }
}