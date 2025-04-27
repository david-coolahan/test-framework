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
$PesterConfiguration.Run.Exit = $true
$result = Invoke-Pester -Configuration $PesterConfiguration
