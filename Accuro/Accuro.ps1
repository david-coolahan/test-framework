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
Invoke-Pester