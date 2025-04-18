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
$result = Invoke-Pester -PassThru

if ($result.FailedCount -gt 0) {
    Write-Host "$($result.FailedCount) tests failed."
    exit 1
}

Write-Host "AFTER CONDITIONAL"
