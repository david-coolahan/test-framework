# BeforeAll {
#     Import-Module Pester
# }

# Describe "DEV - B - Block Access from Unapproved Devices" {

#     BeforeAll {
#         $GraphResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Method GET
#         $Policy = $GraphResponse.Value | Where-Object { $_.displayName -eq "DEV - B - Block access from unapproved devices" }
#         $CAExcludeGroup = @("<INSERT GROUP ID>")
#     }

#     Context "Enable Policy" {
#         It "Should have the policy enabled" {
#             $Policy.State | Should -Be "enabled"
#         }
#     }

#     Context "Users" {
#         It "Should include all users" {
#             $Policy.Conditions.Users.IncludeGuestsOrExternalUsers | Should -Be "All"
#         }

#         It "Should not exclude guest or external users" {
#             $Policy.Conditions.Users.ExcludeGuestsOrExternalUsers | Should -Be $null
#         }

#         It "Should not exclude directory roles" {
#             $Policy.Conditions.Users.IncludeRoles | Should -BeNullOrEmpty
#         }

#         It "Should exclude the correct group" {
#             $Policy.Conditions.Users.ExcludeGroups | Sort-Object | Should -Be ($CAExcludeGroup | Sort-Object)
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

#     Context "Network" {
#         It "Should not have locations configured" {
#             $Policy.Conditions.Locations | Should -BeNullOrEmpty
#         }
#     }

#     Context "Conditions" {
#         BeforeAll {
#             $ExpectedDevicePlatforms = @(
#                 "android",
#                 "windowsPhone",
#                 "macOS",
#                 "linux"
#             )
#         } 

#         It "Should not have user risk levels configured" {
#             $Policy.Conditions.UserRiskLevels | Should -BeNullOrEmpty
#         }

#         It "Should not have sign in risk levels configured" {
#             $Policy.Conditions.SignInRiskLevels | Should -BeNullOrEmpty
#         }

#         It "Should not have insider risk levels configured" {
#             $Policy.Conditions.SignInRiskLevels | Should -BeNullOrEmpty
#         }

#         It "Should include the device platforms: Android, Windows Phone, macOS and Linux" {
#             $Policy.Conditions.Platforms | Sort-Object | Should -Be ($ExpectedDevicePlatforms | Sort-Object)
#         }

#         It "Should exclude no device platforms" {
#             $Policy.Conditions.Platforms | Should -BeNullOrEmpty
#         }

#         It "Should not have client applications configured" {
#             $Policy.Conditions.ClientApplications | Should -BeNullOrEmpty
#         }

#         It "Should not filter for devices" {
#             $Policy.Conditions.Devices | Should -BeNullOrEmpty
#         }

#         It "Should not have authentication flows configured" {
#             $Policy.Conditions.AuthenticationFlows | Should -BeNullOrEmpty
#         }
#     }

#     Context "Grant" {
#         It "Should control access enforcement to grant access" {
#             $Policy.GrantControls.BuiltInControls | Should -Contain "block"
#         }
#     }

#     Context "Session" {
#         It "Should not use app enforced restrictions" {
#             $Policy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled | Should -Be $false
#         }

#         It "Should not use conditonal access app control" {
#             $Policy.SessionControls.CloudAppSecurity.IsEnabled | Should -Be $false
#         }

#         It "Should not have sign in frequency enabled" {
#             $Policy.SessionControls.SignInFrequency.IsEnabled | Should -Be $false
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