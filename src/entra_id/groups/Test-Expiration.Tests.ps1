# Expiration policy for a M365 group equires Microsoft Entra ID P1 or P2 licenses (https://learn.microsoft.com/en-us/entra/identity/users/groups-lifecycle)

# BeforeAll {
#     Import-Module Pester
#     Connect-MgGraph -Scopes "Directory.Read.All"
# }

# Describe "Expiration" {
#     Context "Self Service Group Management" {
#         BeforeAll {
#             $ListGroupLifeCyclePolicy = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/groupLifecyclePolicies" -Method GET
#         }

#         It "Should have a group lifetime of 180 days" {
#             $ListGroupLifeCyclePolicy.GroupLifetimeInDays | Should -Be 180
#         }

#         It "Should have an email contact for groups with no owners" {
#             $ListGroupLifeCyclePolicy.AlternateNotificationEmails | Should -Not -BeNullOrEmpty
#         }

#         It "Should enable expiration for these Microsoft 365 groups" {
#             $ListGroupLifeCyclePolicy.ManagedGroupTypes | Should -Be "All"
#         }
#     }

# }