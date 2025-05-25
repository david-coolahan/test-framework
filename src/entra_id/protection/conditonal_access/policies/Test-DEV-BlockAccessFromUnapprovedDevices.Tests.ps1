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
        It "Should include all resources (formerly 'All cloud apps')" {
            $Policy.Conditions.Applications.IncludeApplications | Should -Be @("All")
        }

        It "Should not exclude any applications" {
            $Policy.Conditions.Applications.ExludeApplications | Should -BeNullOrEmpty
        }
    }

    Context "Device Platforms" {
        It "Should include Android, Windows Phone, macOS, and Linux" {
        }
        It "Should not include iOS or Windows" {
        }
        It "Should not exclude any platforms" {
        }
    }

    Context "Grant Controls" {
        It "Should block access" {
        }
    }

    Context "Policy Enabled" {
        It "Should be enabled" {

        }
    }
}