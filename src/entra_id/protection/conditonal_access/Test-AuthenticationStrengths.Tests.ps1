Describe "Authentication Strengths Configuration Validation" -Tag "AzureAD", "Authentication" {
    BeforeEach {
        # Replace with actual tenant details
        $tenantName = "your-tenant-name.onmicrosoft.com"
        $resourceId = "https://graph.microsoft.com"
        
        # Authenticate to Azure AD
        try {
            Connect-MicrosoftGraph -Scopes "User.Read", "Directory.Read.All" -Tenant $tenantName
        } catch {
            Write-Error "Failed to connect to Microsoft Graph: $_"
            Return
        }
    }

    It "Verifies Phishing-Resistant MFA and TAP configuration" {
        # Retrieve authentication policies
        $policies = Get-MgPolicy -Properties "Authentication"
        
        # Validate Phishing-resistant MFA settings
        $phishingMfaSettings = $policies | Where-Object { $_.Name -eq "Phishing-resistant MFA and TAP" }
        
        if (-not $phishingMfaSettings) {
            throw "Phishing-resistant MFA and TAP policy not found"
        }

        # Verify Phishing-resistant MFA methods
        $expectedMfaMethods = @("Windows Hello For Business", "Passkeys (FIDO2)", "Certificate-based Authentication (Multifactor)")
        $actualMfaMethods = $phishingMfaSettings.MfaMethods
        
        $actualMfaMethods | Should BeExactly $expectedMfaMethods

        # Verify Multifactor authentication options
        $expectedTAPOptions = @("Temporary Access Pass (One-time use)", "Temporary Access Pass (Multi-use)")
        $actualTAPOptions = $phishingMfaSettings.TapOptions
        
        $actualTAPOptions | Should BeExactly $expectedTAPOptions
    }

    It "Verifies Conditional Access policy visibility" {
        # Check if policies are available in Conditional Access
        $policies = Get-MgPolicy -Properties "ConditionalAccess"
        
        $policies | Should HaveProperty "Authentication" -Exactly
        $policies.Authentication | Should HaveProperty "AuthenticationContext" -Exactly
    }

    AfterEach {
        # Clean up connection
        Disconnect-MicrosoftGraph
    }
}