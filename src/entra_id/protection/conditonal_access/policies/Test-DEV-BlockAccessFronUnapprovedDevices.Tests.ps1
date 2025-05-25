BeforeAll {
    Import-Module Pester
}

Describe "DEV - B - Block Access from Unapproved Devices" {

    BeforeAll {
        $GraphResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Method GET
        $Policy = $GraphResponse.Value | Where-Object { $_.displayName -eq "DEV - B - Block access from unapproved devices" }
        $CAExcludeGroup = @("<INSERT GROUP ID>")
    }

    Context "Users" {
        It "Should include all users" {
            $Policy.Conditions.Users.IncludeGuestsOrExternalUsers | Should -Be "All"
        }

        It "Should not exclude guest or external users" {
            $Policy.Conditions.Users.ExcludeGuestsOrExternalUsers | Should -Be $null
        }

        It "Should not exclude directory roles" {
            $Policy.Conditions.Users.IncludeRoles | Should -BeNullOrEmpty
        }

        It "Should exclude the correct group" {
            $Policy.Conditions.Users.ExcludeGroups | Sort-Object | Should -Be ($CAExcludeGroup | Sort-Object)
        }
    }



























    Context "Target Resources" {
        It "Should include all resources" {
            $policy.TargetResources.Include | Should -Be "All resources"
        }
        It "Should not exclude any resources" {
            $policy.TargetResources.Exclude | Should -BeEmpty
        }
    }

    Context "Device Platforms" {
        It "Should include Android, Windows Phone, macOS, and Linux" {
            $policy.DevicePlatforms.Include | Should -Contain "Android"
            $policy.DevicePlatforms.Include | Should -Contain "Windows Phone"
            $policy.DevicePlatforms.Include | Should -Contain "macOS"
            $policy.DevicePlatforms.Include | Should -Contain "Linux"
        }
        It "Should not include iOS or Windows" {
            $policy.DevicePlatforms.Include | Should -NotContain "iOS"
            $policy.DevicePlatforms.Include | Should -NotContain "Windows"
        }
        It "Should not exclude any platforms" {
            $policy.DevicePlatforms.Exclude | Should -BeEmpty
        }
    }

    Context "Grant Controls" {
        It "Should block access" {
            $policy.GrantControls | Should -Be "Block access"
        }
    }

    Context "Policy Enabled" {
        It "Should be enabled" {
            $policy.Enabled | Should -Be $true
        }
    }
}