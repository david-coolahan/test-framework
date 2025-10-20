<#
Pester Module: https://www.powershellgallery.com/packages/Pester/5.3.1
Microsoft.Graph Module: https://www.powershellgallery.com/packages/Microsoft.Graph/1.7.0

No API endpoints available to configure the settings:
- Selected users will receive email notifications for requests​
- Selected users will receive request expiration reminders​
- Consent request expires after (days)​

However, the setting 'Users can request admin consent to apps they are unable to consent to​' makes
the previous settings redundant.
#> 

BeforeAll {
    Import-Module Pester
}

Describe "Admin Consent Settings" {
    Context "Admin Consent Requests" {
        BeforeAll {
            $GroupGraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/groupSettings" -Method GET
            $GroupSettings = $GroupGraphResult.Value.Values
        }

        # "EnableAdminConsentRequests" value is returned as a string
        It "Should not allow users to request admin consent to apps they are unable to consent to" {
            ($GroupSettings | Where-Object { $_.Name -eq "EnableAdminConsentRequests" }).Value | Should -Be "false"
        }
    }
}