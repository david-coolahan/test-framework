# Requies P1/P2 licensing
BeforeAll {
    Import-Module Pester
    # Connect-MgGraph -Scopes "AuthenticationContext.Read.All"
}

Describe "Authentication Contexts" {
    BeforeAll {
        $GraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/authenticationContextClassReferences" -Method GET
        $AuthContext = $GraphResult.Value | Where-Object { $_.DisplayName -eq "PROTECTED information"}
    }

    It "Should have an authentication context called 'PROTECTED information'" {
        $AuthContext | Should -Not -BeNullOrEmpty
    }

    It "Should be published to be used by apps" {
        $AuthContext.IsAvailable | Should -Be $true
    }

    It "Should have the ID 'c1" {
        $AuthContext.Id | Should -Be "c1"
    }
}