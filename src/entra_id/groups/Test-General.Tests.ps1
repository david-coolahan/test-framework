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

    Import-Module Microsoft.Graph.Groups
    Import-Module Microsoft.Graph.Identity.DirectoryManagement
    Import-Module Pester
    Connect-MgGraph -Scopes "Directory.ReadWrite.All"
}

# To configure M36 >> Configure 'EnableGroupCreation' object in the 'groupSettings' object.


# List groupSettigTemplates resource type [Get-MgGroupSettingTemplateGroupSettingTemplate]>> Fiter for Group.Unified object >> 'EnableGroupCreation' setting

# ______________________________
# To configure security groups >> update 'allowedToCreateSecurityGroups' property of 'defaultUserRolePermissions' in the 'authorizationPolicy' resource type.


# >> 

Describe "Entra ID General Group Settings" {

    # Context "Self Service Group Management" {
    #     It "Should prevent owners managing group membership requests in My Groups" {

    #     }

    #     It "Should not restrict user ability to access groups features in My Groups." {

    #     }
    # }

    # Context "Security Groups" {
    #     It "Should not allow users to create security groups in Azure portals, API or PowerShell" {

    #     }
    # }

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
