BeforeAll {
    $modules = @("Pester", "Microsoft.Graph")

    foreach ( $module in $modules )
    {
        if (Get-Module -ListAvailable -Name $module) 
        {
            continue
        }
        else
        {
            Write-Host $module "needs to be installed. Press 'Y' to install the module."
            Install-Module -Name $module
        }
    }

    Import-Module Microsoft.Graph.Authentication
    Import-Module Microsoft.Graph.Users
    Import-Module Microsoft.Graph.Groups
    Import-Module Microsoft.Graph.Identity.DirectoryManagement
    Import-Module Pester
    Connect-MgGraph -Scopes "GroupMember.Read.All, Group.ReadWrite.All, Group.Read.All, Directory.ReadWrite.All, Directory.Read.All, RoleManagement.Read.Directory, RoleManagement.ReadWrite.Directory"
}


Describe "Entra ID Break Glass Accounts Configuration" {
    BeforeAll {
        $domain = Get-MgDomain | Select-Object -First 1 -ExpandProperty Id 
        $breakGlassUser1PrincipalName = "breakglass1@$($domain)"
        $breakGlassUser2PrincipalName = "breakglass2@$($domain)"
        $conditionalAccessExcludeGroupName = "conditional_access_exclude"
        $globalAdminRoleName = "Global administrator"
    }

    Context "Conditional Access Exclude Group" {
        BeforeAll {
            $caExcludeGroup = Get-MgGroup -Filter "displayName eq '$conditionalAccessExcludeGroupName'"
        }

        It "Should have a conditional_access_exclude group" {
            $caExcludeGroup | Should -Not -BeNullOrEmpty
        }

        It "Should have security enabled for the conditional_access_exclude group" {
            $caExcludeGroup.SecurityEnabled | Should -BeTrue
        }
    }

    Context "Break Glass User 1" {
        BeforeAll {
            $breakGlassUser1 = Get-MgUser -Filter "userPrincipalName eq '$($breakGlassUser1PrincipalName)'" -Property "DisplayName, UsageLocation, AccountEnabled"
        }

        It "Should have the Break Glass 1 user created" {
            $breakGlassUser1 | Should -Not -BeNullOrEmpty
        }

        It "Should have the correct display name for Break Glass 1" {
            $breakGlassUser1.DisplayName | Should -Be "Break Glass 1"
        }

        It "Should have the correct usage location for Break Glass 1" {
            $breakGlassUser1.UsageLocation | Should -Be "AU"
        }

        It "Should have the account enabled for Break Glass 1" {
            $breakGlassUser1.AccountEnabled | Should -Be "True"
        }

        It "Should have Break Glass 1 in the Global Administrator role" {
            $globalAdminRole = Get-MgDirectoryRole -Filter "displayName eq '$globalAdminRoleName'"
            $roleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $globalAdminRole.Id
            $memberIds = $roleMembers.Id
            $memberUPNs = @()
            
            foreach ($memberId in $memberIds) {
                $user = Get-MgUser -UserId $memberId -ErrorAction SilentlyContinue
                if ($user) {
                    $memberUPNs += $user.UserPrincipalName
                }
            }

            $memberUPNs | Should -Contain $breakGlassUser1PrincipalName
        }
    }

    Context "Break Glass User 2" {
        BeforeAll {
            $breakGlassUser2 = Get-MgUser -Filter "userPrincipalName eq '$($breakGlassUser2PrincipalName)'" -Property "DisplayName, UsageLocation, AccountEnabled"
        }

        It "Should have the Break Glass 2 user created" {
            $breakGlassUser2 | Should -Not -BeNullOrEmpty
        }

        It "Should have the correct display name for Break Glass 2" {
            $breakGlassUser2.DisplayName | Should -Be "Break Glass 2"
        }

        It "Should have the correct usage location for Break Glass 2" {
            $breakGlassUser2.UsageLocation | Should -Be "AU"
        }

        It "Should have the account enabled for Break Glass 2" {
            $breakGlassUser2.AccountEnabled | Should -Be "True"
        }

        It "Should have Break Glass 2 in the Global Administrator role" {
            $globalAdminRole = Get-MgDirectoryRole -Filter "displayName eq '$globalAdminRoleName'"
            $roleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $globalAdminRole.Id
            $memberIds = $roleMembers.Id
            $memberUPNs = @()
            
            foreach ($memberId in $memberIds) {
                $user = Get-MgUser -UserId $memberId -ErrorAction SilentlyContinue
                if ($user) {
                    $memberUPNs += $user.UserPrincipalName
                }
            }
            
            $memberUPNs | Should -Contain $breakGlassUser2PrincipalName
        }
    }

    Context "Conditional Access Configuration" {
        It "Should ensure Break Glass accounts be in the conditional_access_exclude group" {
            $caExcludeGroup = Get-MgGroup -Filter "displayName eq '$($conditionalAccessExcludeGroupName)'"
            $groupMembers = Get-MgGroupMember -GroupId $caExcludeGroup.Id
            $memberIds = $groupMembers.Id
            $memberUPNs = @()
            
            foreach ($memberId in $memberIds) {
                $user = Get-MgUser -UserId $memberId -ErrorAction SilentlyContinue
                if ($user) {
                    $memberUPNs += $user.UserPrincipalName
                }
            }
            
            $memberUPNs | Should -Contain $breakGlassUser1PrincipalName
            $memberUPNs | Should -Contain $breakGlassUser2PrincipalName
        }
    }
}