BeforeAll {
    Import-Module Pester
}

Describe "Naming Policy" {
    BeforeAll {
        $GraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/groupSettings" -Method GET
        $GroupSettings = $GraphResult.Value.Values
    }

    Context "Blocked Words" {
        It "Should not have a blocked word list configured" {
            ($GroupSettings | Where-Object { $_.Name -eq "CustomBlockedWordsList" }).Value | Should -BeNullOrEmpty
        }
    }

    Context "Group Naming Policy" {
        It "Should not have a prefix and sufix configured" {
            ($GroupSettings | Where-Object { $_.Name -eq "PrefixSuffixNamingRequirement" }).Value | Should -BeNullOrEmpty
        }
    }
}