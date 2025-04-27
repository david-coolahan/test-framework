BeforeAll {
    Import-Module Pester
    # Connect-MgGraph -Scopes "Policy.Read.All"
}

Describe "Registration Campaign" {
    BeforeAll {
        $GraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/policies/authenticationMethodsPolicy" -Method GET
        $RegistrationEnforcement = $GraphResult.RegistrationEnforcement.AuthenticationMethodsRegistrationCampaign
        # $ExcludedUsers = @("<INSERT USER IDs>") # If none set to $null
        $ExcludedUsers = $null
        # $ExcludedGroups = @("<INSERT GROUP IDs>") # If none set to $null
        $ExcludedGroups = $null
    }

    Context "Settings" {
        It "Should be enabled" {
            $RegistrationEnforcement.State | Should -Be "enabled"
        }

        It "Should have 14 days allowed to snooze" {
            $RegistrationEnforcement.SnoozeDurationInDays | Should -Be 14
        }

        It "Should have a limited number of snoozes" {
            # Microsoft has removed the setting
        }

        It "Should exclude conditional access excluded users" {
            $RegistrationEnforcement.ExcludeTargets.Id | Sort-Object | Should -Contain ($ExcludedUsers | Sort-Object)
        }

        It "Should exclude conditional access excluded groups" {
            $RegistrationEnforcement.ExcludeTargets.Id | Sort-Object | Should -Contain ($ExcludedGroups | Sort-Object)
        }

        Context "Authentication Method" {
            It "Should have Microsoft Authenticator target all users" {
                ($RegistrationEnforcement.IncludeTargets | Where-Object { $_.TargetedAuthenticationMethod -eq "microsoftAuthenticator" }).Id | Should -Be "all_users"
            }
        }
    }
}