# BeforeAll {
#     Import-Module Pester
# }

# Describe "ADM - S - Limit Admin Sessions" {
#     BeforeAll {
#         $GraphResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Method GET
#         $Policy = $GraphResponse.Value | Where-Object { $_.displayName -eq "ADM - S - Limit admin sessions" }
#         $AdministratorRoles = @("<INSERT ROLE IDs>")
#         $AdministratorUserGroup = @("<INSERT GROUP ID>")
#         $CAExcludeGroup = @("<INSERT GROUP ID>")
#     }

#     Contex "Enable Policy" {
#         It "Should have the policy enabled" {
#             $Policy.State | Should -Be "enabled"
#         }
#     }

#     Context "Users" {
#         It "Should not include guests or external users" {
#             $Policy.Conditions.Users.IncludeGuestsOrExternalUsers | Should -Be $null
#         }

#         It "Should include applicable administrator roles" {
#             $Policy.Conditions.Users.IncludeRoles | Sort-Object | Should -Be ($AdministratorRoles | Sort-Object)
#         }

#         It "Should include the administrative user group" {
#             $Policy.Conditions.Users.IncludeGroups | Sort-Object | Should -Be ($AdministratorUserGroup | Sort-Object)
#         }

#         It "Should not include any users" {
#             $Policy.Conditions.Users.IncludeUsers | Should -BeNullOrEmpty
#         }

#         It "Should not exclude guest or external users" {
#             $Policy.Conditions.Users.ExcludeGuestsOrExternalUsers | Should -Be $null
#         }

#         It "Should not exclude directory roles" {
#             $Policy.Conditions.Users.IncludeRoles | Should -BeNullOrEmpty
#         }

#         It "Should exclude the conditional access exclude group for this policy" {
#             $Policy.Conditions.Users.ExcludeGroups | Sort-Object | Should -Be ($CAExcludeGroup | Sort-Object)
#         }

#         It "Should not exclude any users" {
#             $Policy.Conditions.Users.ExcludeUsersUsers | Should -BeNullOrEmpty
#         }
#     }

#     Context "Target Resources" {
#         It "Should include all resources (formerly 'All cloud apps')" {
#             $Policy.Conditions.Applications.IncludeApplications | Should -Be @("All")
#         }

#         It "Should not exclude any applications" {
#             $Policy.Conditions.Applications.ExludeApplications | Should -BeNullOrEmpty
#         }
#     }

#     # This context block refers to the 'Network' section
#     Context "Network" {
#         It "Should not have locations configured" {
#             $Policy.Conditions.Locations | Should -BeNullOrEmpty
#         }
#     }

#     Context "Grant" {
#         It "Should control access enforcement to grant access" {
#             $Policy.GrantControls.BuiltInControls | Should -Not -Contain "block"
#         }

#         # The only options are AND or OR, hence why it seems redundant
#         It "Should require all of the selected controls if there are multiple controls" {
#             $Policy.GrantControls.Operator | Should -Be "ALL" 
#         }

#         # Split the tests into two as there are too many for just one
#         It "Should not require multifactor authentication, authentication strength, app protection policy, terms and password change" {
#             $Policy.GrantControls.BuiltInControls | Should -BeNullOrEmpty
#         }

#         It "Should not require a device to be marked as compliant, to be Microsoft Entra hybrid joined device and to be an approved client app" {
#             $Policy.GrantControls.BuiltInControls | Should -BeNullOrEmpty
#         }
#     }

#     Context "Session" {
#         It "Should not use app enforced restrictions" {
#             $Policy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled | Should -Be $false
#         }

#         It "Should not use conditonal access app control" {
#             $Policy.SessionControls.CloudAppSecurity.IsEnabled | Should -Be $false
#         }

#         It "Should have sign in frequency enabled" {
#             $Policy.SessionControls.SignInFrequency.IsEnabled | Should -Be $true
#         }

#         It "Should have sign in frequency of every 4 hours" {
#             $Policy.SessionControls.SignInFrequency.Value | Should -Be 4
#         }

#         It "Should have time based sign in frequency" {
#             $Policy.SessionControls.SignInFrequency.FrequencyInterval | Should -Be "timeBased"
#         }

#         It "Should not have persistent browser session enabled" {
#             $Policy.SessionControls.PersistentBrowser.IsEnabled | Should -Be $false
#         }

#         It "Should not have customised continuous access evaluation enabled" {
#             # No Graph API Property
#         }

#         It "Should not have resilience defaults disabled" {
#             $Policy.SessionControls.DisableResilienceDefaults | Should -Be $false
#         }

#         It "Should not require require token protection for sign-in sessions (preview setting)" {
#             # No Graph API property
#         }

#         It "Use Global Secure Access security profile" {
#             # No Graph API property
#         }
#     }

# }