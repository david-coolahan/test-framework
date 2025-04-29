<#
Pester Module: https://www.powershellgallery.com/packages/Pester/5.3.1
Microsoft.Graph Module: https://www.powershellgallery.com/packages/Microsoft.Graph/1.7.0
#>

BeforeAll {
    Import-Module Pester
    
}

Describe "User Consent Settings" {
    BeforeAll {
        $AuthorisationGraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/policies/authorizationPolicy" -Method GET
        $HasConsent = $AuthorisationGraphResult.DefaultUserRolePermissions.PermissionGrantPoliciesAssigned | Where-Object { $_ -like "ManagePermissionGrantsForSelf*"}
        $SelfUserConsent = $null

        if($HasConsent) 
        {
            $SelfUserConsent = $true
        }
        else 
        {
            $SelfUserConsent = $false
        }
    }

    It "Should not allow user consent for applications to access your organization's data" {
        $SelfUserConsent | Should -Be $false
    }
}