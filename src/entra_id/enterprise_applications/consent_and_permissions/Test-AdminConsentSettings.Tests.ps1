Import-Module Microsoft.Graph

Describe "Admin Consent Settings Validation" {
    BeforeEach {
        # Authenticate to Microsoft Graph
        $scopes = "User.Read.All", "Directory.Read.All"
        Connect-MgOrganization -Scopes $scopes -ScopeId "https://graph.microsoft.com"
    }

    It "Should verify admin consent is disabled" {
        $setting = Get-MgDirectorySetting -SettingId "Consent"
        $setting | Should Not Be $null
        $setting | Should HaveProperty "AllowAdminConsent" -Exactly 0
    }

    It "Should confirm email notifications are enabled for admin consent requests" {
        $setting = Get-MgDirectorySetting -SettingId "Consent"
        $setting | Should Not Be $null
        $setting | Should HaveProperty "EnableEmailNotificationsForAdminConsentRequests" -Exactly 1
    }

    It "Should ensure reminders are enabled for admin consent requests" {
        $setting = Get-MgDirectorySetting -SettingId "Consent"
        $setting | Should Not Be $null
        $setting | Should HaveProperty "EnableRemindersForAdminConsentRequests" -Exactly 1
    }

    It "Should validate consent request expiration is set to 30 days" {
        $setting = Get-MgDirectorySetting -SettingId "Consent"
        $setting | Should Not Be $null
        $setting | Should HaveProperty "ConsentRequestExpiryInDays" -Exactly 30
    }
}