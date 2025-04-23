# BeforeAll {
#     Import-Module Pester
#     # Connect-MgGraph -Scopes	"Policy.Read.All"
# }

# Describe "Policies" {
#     BeforeAll {
#         $ConditionalGraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Method GET
#         $ConditonalList = $ConditionalGraphResult.Value
#     }

#     It "Should not have the policy 'Multifactor authentication for admins accessing Microsoft Admin Portals' enabled'" {
#         ($ConditonalList | Where-Object { $_.displayName -eq "Multifactor authentication for admins accessing Microsoft Admin Portals" }).Value | Should -Be "disabled"
#     }

#     It "Should not have the policy 'Multifactor authentication for per-user multifactor authentication users'" {
#         ($ConditonalList | Where-Object { $_.displayName -eq "Multifactor authentication for per-user multifactor authentication users" }).Value | Should -Be "disabled"
#     }

#     It "Should not have the policy 'Multifactor authentication and reauthentication for risky sign-ins'" {
#         ($ConditonalList | Where-Object { $_.displayName -eq "Multifactor authentication and reauthentication for risky sign-ins" }).Value | Should -Be "disabled"
#     }

#     It "Should not have the policy 'Block legacy authentication'" {
#         ($ConditonalList | Where-Object { $_.displayName -eq "Block legacy authentication" }).Value | Should -Be "disabled"
#     }

#     It "Should not have the policy 'Require multifactor authentication for Azure management'" {
#         ($ConditonalList | Where-Object { $_.displayName -eq "Require multifactor authentication for Azure management" }).Value | Should -Be "disabled"
#     }

#     It "Should not have the policy 'Require multifactor authentication for admins'" {
#         ($ConditonalList | Where-Object { $_.displayName -eq "Require multifactor authentication for admins" }).Value | Should -Be "disabled"
#     }

#     It "Require multifactor authentication for all users'" {
#         ($ConditonalList | Where-Object { $_.displayName -eq "Require multifactor authentication for all users" }).Value | Should -Be "disabled"
#     }
# }