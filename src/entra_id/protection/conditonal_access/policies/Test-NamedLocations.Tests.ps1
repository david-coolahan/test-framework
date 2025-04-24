# BeforeAll {
#     Import-Module Pester 

#     # Connect-MgGraph -ScopesPolicy.Read.All
# }

# Describe "Named Locations" {
#     BeforeAll {
#         $GraphResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/namedLocations" -Method GET
#         $Location = $GraphResponse.Value 
#     }
#     Context "Countries Location" {
#         BeforeAll {
#             $Australia = $Location | Where-Object { $_.DisplayName -eq "Australia" }
#         }

#         It "Should use client IP address as the country lookup method" {
#             $Australia.CountryLookupMethod | Should -Be "clientIpAddress"
#         }

#         It "Should not include unknown countries/regions" {
#             $Australia.IncludeUnknownCountriesAndRegions | Should -Be $false
#         }

#     }

#     Context "IP Ranges Location" {
#         BeforeAll {
#             $TrustedIPs = $Location | Where-Object { $_.DisplayName -eq "Trusted IPs" }
#             $IPRanges = @("<INSERT IP RANGES>")
#             $TrustedIPsList = $TrustedIPs | ForEach-Object { $_.cidrAddress }

#         }

#         It "Should be marked as trusted" {
#             $TrustedIPs.IsTrusted | Should -Be $true
#         }

#         It "Should have the correct IP range" {
#             $IPRanges | Sort-Object | Should -Be ($TrustedIPsList | Sort-Object)
#         }
#     }
# }