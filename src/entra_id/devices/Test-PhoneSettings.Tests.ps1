Describe "Microsoft Entra Device Settings Validation" {
    BeforeEach {
        # Connect to Microsoft Graph API
        Connect-MicrosoftGraph -Scopes 'Directory.ReadWrite.All'
    }

    It "Verifies Microsoft Entra device join and registration settings" {
        $settings = Get-MgDirectorySetting -SettingId '5a563597-181e-4446-b35b-05dd3d0d040c' # Microsoft Entra Device Settings
        $settings.Properties | Should HaveProperty 'AllowDeviceJoin' -Exactly 1
        $settings.Properties | Should HaveProperty 'AllowDeviceRegistration' -Exactly 1
        $settings.Properties | Should HaveProperty 'RequireMfaForDeviceJoin' -Exactly 0
        $settings.Properties | Should HaveProperty 'MaxDevicesPerUser' -Exactly 2
    }

    It "Verifies local administrator settings" {
        $settings = Get-MgDirectorySetting -SettingId 'a1e0d350-708c-4c3c-898e-300b5930a6d4' # Local Admin Settings
        $settings.Properties | Should HaveProperty 'GlobalAdminAsLocalAdmin' -Exactly 0
        $settings.Properties | Should HaveProperty 'RegisterUserAsLocalAdmin' -Exactly 0
        $settings.Properties | Should HaveProperty 'EnableLaps' -Exactly 1
    }

    It "Verifies other device settings" {
        $settings = Get-MgDirectorySetting -SettingId '156c0742-04d0-49f3-9061-7e025b5f3f4a' # Device Settings
        $settings.Properties | Should HaveProperty 'RestrictBitLockerRecovery' -Exactly 0
    }
}