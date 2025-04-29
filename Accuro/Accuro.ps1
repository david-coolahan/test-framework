<#
Pester Module: https://www.powershellgallery.com/packages/Pester/5.3.1
Microsoft.Graph Module: https://www.powershellgallery.com/packages/Microsoft.Graph/1.7.0
#>

$modules = @("Pester", "Microsoft.Graph")

foreach ( $module in $modules )
{
    if (Get-Module -ListAvailable -Name $module) 
    {
        continue
    }
    else
    {
        Install-Module -Name $module -Force
    }
}
Set-Location ./repo/src
$PesterConfiguration = New-PesterConfiguration
$PesterConfiguration.TestResult.Enabled = $true
$PesterConfiguration.Should.ErrorAction = 'Stop'
$PesterConfiguration.Run.Throw = $true
$result = Invoke-Pester -Configuration $PesterConfiguration
