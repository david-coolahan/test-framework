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
            Install-Module -Name $Module -Force
        }
    }

    Import-Module Microsoft.Graph.Groups
    Import-Module Microsoft.Graph.Identity.DirectoryManagement
    Import-Module Pester
    # Connect-MgGraph -Scopes "Directory.Read.All"
}

Describe "Entra ID General Group Settings" {

    # Context "Self Service Group Management" {
    #     It "Should prevent owners managing group membership requests in My Groups" {
        # No API Available
    #     }

    #     It "Should not restrict user ability to access groups features in My Groups." {
        # No API Available
    #     }
    # }

    Context "Security Groups" {
        BeforeAll {
            # $AllowedToCreateSecurityGroupsValue = Get-MgPolicyAuthorizationPolicy | Select-Object -ExpandProperty "DefaultUserRolePermissions" | Select-Object -ExpandProperty "AllowedToCreateSecurityGroups"
            $AuthorisationGraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/policies/authorizationPolicy" -Method GET
            $AllowedToCreateSecurityGroupsValue = $AuthorisationGraphResult.DefaultUserRolePermissions.AllowedToCreateSecurityGroups
        }
        It "Should not allow users to create security groups in Azure portals, API or PowerShell" {
            # $AllowedToCreateSecurityGroupsValue is of type boolean
            $AllowedToCreateSecurityGroupsValue | Should -Be $false
        }
    }

    Context "Microsoft 365 Groups" {
        BeforeAll {
            $ListSettings = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/groupSettings" -Method GET 
            $EnableGroupCreationValue = $null
            <#
            If retrieving the list of group settings returns no group setting, then the default value (true) for the 'Group.Unified' object is used
            #>
            if (-not $ListSettings.Value -or $ListSettings.Value.Count -eq 0) 
            {
                $EnableGroupCreationValue = "true"
            } 
            else 
            {
                $EnableGroupCreationValue = ($ListSettings.Value.Values | Where-Object { $_.Name -eq "EnableGroupCreation" }).Value 
            }
        }
        It "Should allow users to create Microsoft 365 groups in Azure portals, API or PowerShell" {
            $EnableGroupCreationValue | Should -Be "true"
        }
    }
}
