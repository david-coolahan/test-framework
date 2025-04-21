BeforeAll {
    Import-Module Pester
    Connect-MgGraph -Scopes "Policy.Read.All"
}

Describe "Per-user MFA" {
    BeforeAll {
        $batchBody = @{
            requests = @(
              @{
                id     = "1" # Arbitrary ID
                method = "GET"
                url    = "/policies/mfaServicePolicy"
                headers = @{
                  "Content-Type" = "application/json"
                }
              }
            )
          } | ConvertTo-Json -Depth 5
          
        
        $result = Invoke-MgGraphRequest -Method POST `
          -Uri 'https://graph.microsoft.com/beta/$batch' `
          -Body $batchBody `
          -ContentType "application/json"
        
        $AllowAppPasswords = $result.responses[0].body.allowAppPasswords
        $SkipMfaForFederatedUsers   = $result.responses[0].body.trustedIps.skipMfaForFederatedUsers
        $RememberMfaOnTrustedDevice = $result.responses[0].body.rememberMfaOnTrustedDevice.isEnabled
    }

    Context "Service Settings" {
        It "App passwords" {
            $AllowAppPasswords | Should -Be $false
        }

        It "Skip multi-factor authentication for requests from federated users on my intranet" {
            $SkipMfaForFederatedUsers | Should -Be $false
        }

        It "Remember multi-factor authentication on trusted device" {
            $RememberMfaOnTrustedDevice | Should -Be $false
        }
    }
    
    # Item "Methods available to users" put into its own context block as it has multiple values
    Context "Methods Available to Users" {
        BeforeAll {
            $AuthenticationMethodPolicy = (Get-MgPolicyAuthenticationMethodPolicy).AuthenticationMethodConfigurations
            $HardwareTokenConfiguration = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy/authenticationMethodConfigurations/hardwareOath" -Method GET 
        }

        # Default is Microsoft Authenticator. If another solution is used, this test will need to be updated.
        It "Should allow notification through mobile app" {
            $MobileApp = $AuthenticationMethodPolicy | Where-Object { $_.Id -eq "MicrosoftAuthenticator" }
            $MobileApp.State | Should -Be "enabled"
        }

        It "Should allow verification code from hardware token" {
            $HardwareTokenConfiguration.State | Should -Be "enabled"
        }
    }
}