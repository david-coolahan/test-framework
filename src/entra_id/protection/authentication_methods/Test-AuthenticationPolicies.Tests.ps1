<#
Pester Module: https://www.powershellgallery.com/packages/Pester/5.3.1
Microsoft.Graph Module: https://www.powershellgallery.com/packages/Microsoft.Graph/1.7.0
#>

BeforeAll {
    Import-Module Pester
    # Connect-MgGraph -Scopes "Policy.Read.All"
}

Describe "Policies" {
    BeforeAll {
        $GraphResult = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/beta/policies/authenticationMethodsPolicy" -Method GET
        $EnabledMethods = @()
        $GraphResult.AuthenticationMethodConfigurations | ForEach-Object {
            if ($_.State -eq "enabled") {
                $EnabledMethods += $_.Id
            }
        }

        $ExpectedEnabledMethods = @(
            "Fido2",
            "MicrosoftAuthenticator",
            "TemporaryAccessPass"
        )

    }

    It "Should have the correct authentication method policies" {
        $EnabledMethods | Sort-Object | Should -Be ($ExpectedEnabledMethods | Sort-Object)
    }

    Context "Passkey (FIDO2) Settings" {
        BeforeAll {
            $Fido2Settings = $GraphResult.AuthenticationMethodConfigurations | Where-Object { $_.Id -eq "Fido2"}
            $Fido2ExcludeGroup = @("<INSERT GROUP IDS>")
            $Fido2AAGUIDs = @("<Insert Organisation's Fido2 AAGUIDs>")
            # iOS Microsoft Authenticator: 90a3ccdf-635c-4729-a248-9b709135078f, Android Microsoft Authenticator: de1e552d-db1d-4423-a619-566b625cdc84
            $MicrosoftAuthenticatorAAGUIDs = @("90a3ccdf-635c-4729-a248-9b709135078f", "de1e552d-db1d-4423-a619-566b625cdc84")

        }

        It "Should be enabled" {
            $Fido2Settings.State | Should -Be "enabled"
        }

        It "Should target all users" {
            $Fido2Settings.IncludeTargets.Id | Should -Be "all_users"
        }


        It "Should have self service set up" {
            $Fido2Settings.IsSelfServiceRegistrationAllowed | Should -Be $true
        }

        It "Should enforce attestation" {
            $Fido2Settings.IsAttestationEnforced | Should -Be $true
        }

        It "Should enforce key restrictions" {
            $Fido2Settings.keyRestrictions.IsEnforced | Should -Be $true
        }

        It "Should restrict specific keys" {
            $Fido2Settings.keyRestrictions.EnforcementType | Should -Be "Allow"
        }

        It "Should not have Microsoft Authenticator AAGUIDs enabled" {
            $IdentifiedAuthenticatorAAGUIDs = @()

            foreach ($AAGUID in $Fido2Settings.keyRestrictions.AaGuids) {
                if ($MicrosoftAuthenticatorAAGUIDs -contains $AAGUID) 
                {
                    $IdentifiedAuthenticatorAAGUIDs += $AAGUID
                }
            }
            $IdentifiedAuthenticatorAAGUIDs | Should -BeNullOrEmpty
        }

    }

    Context "Microsoft Authenticator Settings" {
        BeforeAll {
            $MSAuthSettings = $GraphResult.AuthenticationMethodConfigurations | Where-Object { $_.Id -eq "MicrosoftAuthenticator"}
            $MSAuthExcludeGroup = @("<INSERT GROUP IDS>")
        }

        It "Should be enabled" {
            $MSAuthSettings.State | Should -Be "enabled"
        }

        It "Should target all users" {
            $MSAuthSettings.IncludeTargets.Id | Should -Be "all_users"
        }

        It "Should not allow use of Microsoft Authenticator OTP" {
            $MSAuthSettings.IsSoftwareOathEnabled | Should -Be $false
        }

        It "Should require number matching for push notifications" {
            $MSAuthSettings.FeatureSettings.NumberMatchingRequiredState.State | Should -Be "enabled"
        }

        It "Should have number matching for push notifcations target all users" {
            $MSAuthSettings.FeatureSettings.NumberMatchingRequiredState.IncludeTarget.Id | Should -Be "all_users"
        }

        # 'Default' equals Microsoft managed
        It "Should have application name in push and passwordless notifications be Microsoft managed" {
            $MSAuthSettings.FeatureSettings.DisplayAppInformationRequiredState.State | Should -Be "default"
        }
        
        It "Should have application name in push and passwordless notifications target all users" {
            $MSAuthSettings.FeatureSettings.DisplayAppInformationRequiredState.IncludeTarget.Id | Should -Be "all_users"
        }

        It "Should have geographic location in push and passwordless notifications be Microsoft managed" {
            $MSAuthSettings.FeatureSettings.DisplayLocationInformationRequiredState.State | Should -Be "default"
        }

        It "Should have geographic location in push and passwordless notifications target all users" {
            $MSAuthSettings.FeatureSettings.DisplayLocationInformationRequiredState.IncludeTarget.Id | Should -Be "all_users"
        }

        It "Should have Microsoft Authenticator on companion applications to be Microsoft managed" {
            $MSAuthSettings.FeatureSettings.CompanionAppAllowedState.State | Should -Be "default"
        }

        It "Should have Microsoft Authenticator on companion applications target all users" {
            $MSAuthSettings.FeatureSettings.CompanionAppAllowedState.IncludeTarget.Id | Should -Be "all_users"
        }
    }

    Context "Temporary Access Pass Settings" {
        BeforeAll {
            $TAPSettings = $GraphResult.AuthenticationMethodConfigurations | Where-Object { $_.Id -eq "TemporaryAccessPass"}
            $TAPExcludeGroup = @("<INSERT GROUP IDS>")
        }

        It "Should be enabled" {
            $TAPSettings.State | Should -Be "enabled"
        }

        It "Should target all users" {
            $TAPSettings.IncludeTargets.Id | Should -Be "all_users"
        }


        It "Should have minimum lifetime of 1 hour" {
            $TAPSettings.MinimumLifetimeInMinutes | Should -Be 60
        }

        It "Should maximum lifetime of 8 hours" {
            $TAPSettings.MaximumLifetimeInMinutes | Should -Be 480
        }

        It "Should have a default lifetime of 1 hour" {
            $TAPSettings.DefaultLifetimeInMinutes | Should -Be 60
        }

        It "Should not have one time use" {
            $TAPSettings.IsUsableOnce | Should -Be $false
        }

        It "Should have a default length of 14 characters" {
            $TAPSettings.DefaultLength | Should -Be 14
        }
    }
}