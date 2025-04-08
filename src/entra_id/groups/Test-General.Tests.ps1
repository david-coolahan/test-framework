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
            Install-Module -Name $module -Force
        }
    }

    Import-Module Microsoft.Graph.Groups
    Import-Module Microsoft.Graph.Identity.DirectoryManagement
    Import-Module Pester
    Connect-MgGraph -Scopes "Directory.ReadWrite.All"
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
            $AllowedToCreateSecurityGroupsValue = Get-MgPolicyAuthorizationPolicy | Select-Object -ExpandProperty "DefaultUserRolePermissions" | Select-Object -ExpandProperty "AllowedToCreateSecurityGroups"
        }
        It "Should not allow users to create security groups in Azure portals, API or PowerShell" {
            # $AllowedToCreateSecurityGroupsValue is of type boolean
            $AllowedToCreateSecurityGroupsValue | Should -Be $false
        }
    }

    Context "Microsoft 365 Groups" {
        BeforeAll {
            $listSettings = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/groupSettings" -Method GET 
            $enableGroupCreationValue = $null
            <#
            If invoking 'List-MgGroupSetting' returns no group setting, then the default value (true) for the 'Group.Unified' object is used
            #>
            if (-not $listSettings.value -or $listSettings.value.Count -eq 0) 
            {
                $enableGroupCreationValue = "true"
            } 
            else 
            {
                $enableGroupCreationValue = ($listSettings.Value.values | Where-Object { $_.name -eq "EnableGroupCreation" }).value 
            }
        }
        It "Should allow users to create Microsoft 365 groups in Azure portals, API or PowerShell" {
            $enableGroupCreationValue | Should -Be "true"
        }
    }
}
