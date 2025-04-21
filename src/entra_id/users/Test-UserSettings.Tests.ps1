BeforeAll {
    Import-Module Microsoft.Graph.Identity.SignIns
    Import-Module Pester
    Connect-MgGraph -Scopes "Policy.Read.All"
}

Describe "Entra ID User Settings" {
    BeforeAll {
        $AuthorisationPolicy = Get-MgPolicyAuthorizationPolicy
    }

    Context "Default User Role Permissions" {
        BeforeAll {
            $DefaultUserRolePermissions = $AuthorisationPolicy | Select-Object -ExpandProperty "DefaultUserRolePermissions"
        }

        It "User can register application" {
            $DefaultUserRolePermissions.AllowedToCreateApps | Should -Be $false
        }

        It "Restrict non-admin users from creating tenants" {
            $DefaultUserRolePermissions.AllowedToCreateTenants | Should -Be $false
        }

        It "Users can create security groups" {
            $DefaultUserRolePermissions.AllowedToCreateSecurityGroups | Should -Be $false
        }
    }

    Context "Guest User Access" {
        <#
        'Restricted access' permission level = 2af84b1e-32c8-42b7-82bc-daa82404023b (https://learn.microsoft.com/en-us/entra/identity/users/users-restrict-guest-permissions)
        #>
        It "Guest user access restrictions" {
            $AuthorisationPolicy.GuestUserRoleId | Should -Be "2af84b1e-32c8-42b7-82bc-daa82404023b"
        }
        
    }

    # Context "Administration Centre" {
        # No API Available
    # }

    # Context "LinkedIn Account Connections" {
        # No API Available
    # }

    # Context "Show Keep User Signed In" {
        # No API Available
    # }
}