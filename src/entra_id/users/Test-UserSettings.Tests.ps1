BeforeAll {
    Import-Module Microsoft.Graph.Identity.SignIns
    Import-Module Pester
    Connect-MgGraph -Scopes "Policy.Read.All"
}

Describe "Entra ID User Settings" {
    Context "Default User Role Permissions" {
        BeforeAll {
            $DefaultUserRolePermissions = Get-MgPolicyAuthorizationPolicy | Select-Object -ExpandProperty "DefaultUserRolePermissions"
        }

        It "User can register application" {
            $DefaultUserRolePermissions.AllowedToCreateApps | Should -Be $false
        }

        It "Restrict non-admin users from creating tenants" {
            $DefaultUserRolePermissions.AllowedToCreateTenants | Should -Be $true
        }

        It "Users can create security groups" {
            $DefaultUserRolePermissions.AllowedToCreateSecurityGroups | Should -Be $false
        }
    }

    # Context "Guest User Access" {
        
    # }

    # Context "Administration Center" {
        
    # }

    # Context "LinkedIn Account Connections" {
        
    # }

    # Context "Show Keep User Signed In" {
        
    # }
}