<#
Pester Module: https://www.powershellgallery.com/packages/Pester/5.3.1
Microsoft.Graph Module: https://www.powershellgallery.com/packages/Microsoft.Graph/1.7.0
#>

BeforeAll {
    $Modules = @("Pester", "Microsoft.Graph")

    foreach ( $Module in $Modules )
    {
        if (Get-Module -ListAvailable -Name $Module) 
        {
            continue
        }
        else
        {
            Write-Host $Module "needs to be installed. Press 'Y' to install the module."
            Install-Module -Name $Module
        }
    }

    Import-Module Microsoft.Graph.Authentication
    Import-Module Microsoft.Graph.Users
    Import-Module Microsoft.Graph.Groups
    Import-Module Microsoft.Graph.Identity.DirectoryManagement
    Import-Module Pester
    Connect-MgGraph -Scopes "GroupMember.Read.All, Group.Read.All, Directory.Read.All, RoleManagement.Read.Directory"
}


Describe "Entra ID Break Glass Accounts Configuration" {
    BeforeAll {
        $Domain = Get-MgDomain | Select-Object -First 1 -ExpandProperty Id 
        $BreakGlassUser1PrincipalName = "breakglass1@$($Domain)"
        $BreakGlassUser2PrincipalName = "breakglass2@$($Domain)"
        $ConditionalAccessExcludeGroupName = "conditional_access_exclude"
        $GlobalAdminRoleName = "Global administrator"
    }

    Context "Conditional Access Exclude Group" {
        BeforeAll {
            $CaExcludeGroup = Get-MgGroup -Filter "displayName eq '$ConditionalAccessExcludeGroupName'"
        }

        It "Should have a conditional_access_exclude group" {
            $CaExcludeGroup | Should -Not -BeNullOrEmpty
        }

        It "Should have security enabled for the conditional_access_exclude group" {
            $CaExcludeGroup.SecurityEnabled | Should -BeTrue
        }
    }

    Context "Break Glass User 1" {
        BeforeAll {
            $BreakGlassUser1 = Get-MgUser -Filter "userPrincipalName eq '$($BreakGlassUser1PrincipalName)'" -Property "DisplayName, UsageLocation, AccountEnabled, UserType"
        }

        It "Should have the Break Glass 1 user created" {
            $BreakGlassUser1 | Should -Not -BeNullOrEmpty
        }

        It "Should have the 'member' type" {
            $BreakGlassUser1.UserType | Should -Be "Member"
        }

        It "Should have the correct display name for Break Glass 1" {
            $BreakGlassUser1.DisplayName | Should -Be "Break Glass 1"
        }

        It "Should have the correct usage location for Break Glass 1" {
            $BreakGlassUser1.UsageLocation | Should -Be "AU"
        }

        It "Should have the account enabled for Break Glass 1" {
            $BreakGlassUser1.AccountEnabled | Should -Be $true
        }

        It "Should have Break Glass 1 in the Global Administrator role" {
            $GlobalAdminRole = Get-MgDirectoryRole -Filter "displayName eq '$GlobalAdminRoleName'"
            $RoleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $GlobalAdminRole.Id
            $MemberIds = $RoleMembers.Id
            $MemberUPNs = @()
            
            foreach ($MemberId in $MemberIds) {
                $User = Get-MgUser -UserId $MemberId -ErrorAction SilentlyContinue
                if ($User) {
                    $MemberUPNs += $User.UserPrincipalName
                }
            }

            $MemberUPNs | Should -Contain $BreakGlassUser1PrincipalName
        }
    }

    Context "Break Glass User 2" {
        BeforeAll {
            $BreakGlassUser2 = Get-MgUser -Filter "userPrincipalName eq '$($BreakGlassUser2PrincipalName)'" -Property "DisplayName, UsageLocation, AccountEnabled, UserType"
        }

        It "Should have the Break Glass 2 user created" {
            $BreakGlassUser2 | Should -Not -BeNullOrEmpty
        }

        It "Should have the 'member' type" {
            $BreakGlassUser2.UserType | Should -Be "Member"
        }

        It "Should have the correct display name for Break Glass 2" {
            $BreakGlassUser2.DisplayName | Should -Be "Break Glass 2"
        }

        It "Should have the correct usage location for Break Glass 2" {
            $BreakGlassUser2.UsageLocation | Should -Be "AU"
        }

        It "Should have the account enabled for Break Glass 2" {
            $BreakGlassUser2.AccountEnabled | Should -Be $true
        }

        It "Should have Break Glass 2 in the Global Administrator role" {
            $GlobalAdminRole = Get-MgDirectoryRole -Filter "displayName eq '$GlobalAdminRoleName'"
            $RoleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $GlobalAdminRole.Id
            $MemberIds = $RoleMembers.Id
            $MemberUPNs = @()
            
            foreach ($MemberId in $MemberIds) {
                $User = Get-MgUser -UserId $MemberId -ErrorAction SilentlyContinue
                if ($User) {
                    $MemberUPNs += $User.UserPrincipalName
                }
            }
            
            $MemberUPNs | Should -Contain $BreakGlassUser2PrincipalName
        }
    }

    Context "Conditional Access Configuration" {
        It "Should ensure Break Glass accounts be in the conditional_access_exclude group" {
            $CaExcludeGroup = Get-MgGroup -Filter "displayName eq '$($ConditionalAccessExcludeGroupName)'"
            $GroupMembers = Get-MgGroupMember -GroupId $CaExcludeGroup.Id
            $MemberIds = $GroupMembers.Id
            $MemberUPNs = @()
            
            foreach ($MemberId in $MemberIds) {
                $User = Get-MgUser -UserId $MemberId -ErrorAction SilentlyContinue
                if ($User) {
                    $MemberUPNs += $User.UserPrincipalName
                }
            }
            
            $MemberUPNs | Should -Contain $BreakGlassUser1PrincipalName
            $MemberUPNs | Should -Contain $BreakGlassUser2PrincipalName
        }
    }
}