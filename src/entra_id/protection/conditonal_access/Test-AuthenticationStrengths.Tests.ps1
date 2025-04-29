<#
Pester Module: https://www.powershellgallery.com/packages/Pester/5.3.1
Microsoft.Graph Module: https://www.powershellgallery.com/packages/Microsoft.Graph/1.7.0
#>


BeforeAll {
    Import-Module Pester
    # Connect-MgGraph -Scopes "Policy.Read.All"
}

Describe "Authentication Strengths" {
    Context "Phishing-resistant MFA and TAP" {
        BeforeAll {
            $GraphResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/policies/authenticationStrengthPolicies" -Method GET
            $Policy = $GraphResponse.Value | Where-Object { $_.DisplayName -eq "Phishing-resistant MFA and TAP" }
            $AuthCombinationsList = $Policy.AllowedCombinations
            $ExpectedAuthList = @(
                "windowsHelloForBusiness"
                "fido2"
                "x509CertificateMultiFactor"
                "temporaryAccessPassOneTime"
                "temporaryAccessPassMultiUse"
            )
        }

        It "Should have the correct authentication methods" {
            $AuthCombinationsList | Sort-Object | Should -Be ($ExpectedAuthList | Sort-Object)
        }
    }
}