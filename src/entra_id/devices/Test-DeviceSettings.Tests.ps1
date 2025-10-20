<#
Pester Module: https://www.powershellgallery.com/packages/Pester/5.3.1
Microsoft.Graph Module: https://www.powershellgallery.com/packages/Microsoft.Graph/1.7.0
#>

BeforeAll {
    Import-Module Pester
    # Connect-MgGraph -Scopes "Policy.Read.DeviceConfiguration, Policy.Read.All"
}

Describe "Device Settings" {
    BeforeAll {
        $DeviceGraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/policies/deviceRegistrationPolicy" -Method GET
        $AuthorisationGraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/policies/authorizationPolicy/authorizationPolicy" -Method GET
    }

    Context "Microsoft Entra Join and Registration Settings" {
        It "Should allow user to join devices to Microsoft Entra" {
            $DeviceGraphResult.AzureADJoin.AllowedToJoin.'@odata.type' | Should -Be "#microsoft.graph.allDeviceRegistrationMembership"
        }

        It "Should allow users to register their devices in Microsoft Entra" {
            $DeviceGraphResult.AzureADRegistration.AllowedToRegister.'@odata.type' | Should -Be "#microsoft.graph.allDeviceRegistrationMembership"
        }

        It "Should not require multifactor authentication to register or join devices with Microsoft Entra" {
            $DeviceGraphResult.MultiFactorAuthConfiguration | Should -Be "notRequired"
        }

        # 2147483647 is the value when you select the "Unlimited" option for the setting
        It "Should have an unlimited maximum number of devices per user" {
            $DeviceGraphResult.UserDeviceQuota | Should -Be 2147483647
        }
    }

    Context "Local Administrator Settings" {
        It "Should not have the global administrator role added as local administrator on the device during a Microsoft Entra join (Preview)" {
            $DeviceGraphResult.AzureADJoin.LocalAdmins.EnableGlobalAdmins | Should -Be $false
        }

        It "Should not register a user as a local administrator on a device during a Microsoft Entra join (Preview)" {
            $DeviceGraphResult.AzureADJoin.LocalAdmins.RegisteringUsers.'@odata.type' | Should -Be "#microsoft.graph.noDeviceRegistrationMembership"
        }

        It "Should have Microsoft Entra Local Administrator Password Solution (LAPS) enabled" {
            $DeviceGraphResult.LocalAdminPassword.IsEnabled | Should -Be $true
        }
    }

    Context "Other Settings" {
        It "Should not restrict users from recovering the BitLocker key(s) for their owned devices" {
            $AuthorisationGraphResult.DefaultUserRolePermissions.AllowedToReadBitlockerKeysForOwnedDevice | Should -Be $true
        }
    }
}