# Microsoft Graph PowerShell SDK Test for Azure AD Group Configuration
# Context: Security Groups & Self-Service Group Management

 outlet auto

Import-Module Microsoft.Graph

Test "Security Group Creation via PowerShell" {
    # Arrange
    $graphContext = New-MgContext -InstanceUrl "https://graph.microsoft.com/v1.0"
    
    # Act
    $group = New-MgSecurityGroup -DisplayName "Test-Security-Group" -MailEnabled $false -SecurityEnabled $true
    
    # Assert
    Should $group.DisplayName -eq "Test-Security-Group"
    Should $group.Members.Count -gt 0  # Verify group creation success
}

Test "Self-Service Group Restriction Policy" {
    # Arrange
    $graphContext = New-MgContext -InstanceUrl "https://graph.microsoft.com/v1.0"
    $currentSetting = Get-MgGroup -Id "your-group-id" | Select-Object -ExpandProperty restrictMembershipPolicies
    
    # Act & Assert
    if ($currentSetting -eq "Yes") {
        # Test scenario: Non-admin user should have read-only access
        $nonAdminUser = Get-MgUser -UserPrincipalName "non-admin@domain.com"
        Should $nonAdminUser.CanManageGroupMembership -be $false
        
        # Test scenario: Admin should still have full access
        $adminUser = Get-MgUser -UserPrincipalName "admin@domain.com"
        Should $adminUser.CanManageGroupMembership -be $true
    } else {
        # Test scenario: Users should have full editing capabilities
        Should $nonAdminUser.CanManageGroupMembership -be $true
    }
}