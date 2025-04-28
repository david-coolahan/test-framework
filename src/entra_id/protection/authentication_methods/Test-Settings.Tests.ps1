# Requires Entra P1/P2

BeforeAll {
    Import-Module Pester
    # Connect-MgGraph -Scopes "Policy.Read.All"
}

Describe "Settings" {
    BeforeAll {
        $GraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/policies/authenticationMethodsPolicy" -Method GET
    }

    Context "Report Suspicious Activity" {
        BeforeAll {
            $SuspiciousActivity = $GraphResult.ReportSuspiciousActivitySettings
        }
        
        It "Should have the state be 'Microsoft Managed'" {
            $SuspiciousActivity.Id | Should -Be "default"
        }

        It "Should target all users" {
            $SuspiciousActivity.IncludeTarget.Id | Should -Be "all_users"
        }

        It "Should have a reporting code of 0" {
            $SuspiciousActivity.VoiceReportingCode | Should -Be 0
        }
    }

    Context "System-preferred Multifactor Authentication" {
        BeforeAll {
            $SystemMFA = $GraphResult.SystemCredentialPreferences
        }

        It "Should have the state be 'Microsoft Managed'" {
            $SystemMFA.Id | Should -Be "default"
        }

        It "Should target all users" {
            $SystemMFA.IncludeTarget.Id | Should -Be "all_users"
        }
    }
}