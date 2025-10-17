Describe "Microsoft Entra Device Settings Validation" -Tag "DeviceSettings" {
    BeforeEach {
        # Authenticate to Microsoft Graph using a credential
        $credential = Get-Credential -Message "Enter your Microsoft Entra account credentials"
        Connect-MgGraph -Scopes "Device.ReadWrite.All" -Credential $credential
    }

    It "Verifies device join and registration settings" {
        $devicePolicy = Get-MgDevicePolicy -All $true
        $devicePolicy | Should Not Be $null
        
        # Validate device join settings
        $devicePolicy.DeviceJoinSettings | Should Not Be $null
        $devicePolicy.DeviceJoinSettings.UsersMayJoinDevices | Should Be "All"
        $devicePolicy.DeviceJoinSettings.UsersMayRegisterDevices | Should Be "All"
        $devicePolicy.DeviceJoinSettings.RequireMFAForRegistrationOrJoin | Should Be $false
        
        # Validate device registration settings
        $devicePolicy.DeviceRegistrationSettings | Should Not Be $null
        $devicePolicy.DeviceRegistrationSettings.MaxDevicesPerUser | Should Be "Unlimited"
    }

    It "Verifies local administrator settings" {
        $devicePolicy.LocalAdministratorSettings | Should Not Be $null
        $devicePolicy.LocalAdministratorSettings.GlobalAdminAsLocalAdmin | Should Be $false
        $devicePolicy.LocalAdministratorSettings.RegisterUserAsLocalAdmin | Should Be $null
        $devicePolicy.LocalAdministratorSettings.EnableLAPS | Should Be $true
    }

    It "Verifies other device settings" {
        $devicePolicy.OtherDeviceSettings | Should Not Be $null
        $devicePolicy.OtherDeviceSettings.RestrictBitLockerRecovery | Should Be $false
    }
}