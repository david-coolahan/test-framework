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
$result = Invoke-Pester

if ($result.FailedCount -gt 0) {
    throw "$($result.FailedCount) tests failed."
}