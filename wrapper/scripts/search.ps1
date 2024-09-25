param(
  [Parameter(Mandatory=$true)]
  [string]$subid,

  [Parameter(Mandatory=$true)]
  [string]$rg,

  [Parameter(Mandatory=$true)]
  [string]$name
)



# Construct the URI
$uri = "https://management.azure.com/subscriptions/$subid/resourceGroups/$rg/providers/Microsoft.Search/searchServices/$name"

Write-Output "Constructed URI: $uri"


# join this to uri "?api-version=2024-03-01-Preview"
$uri = $uri + "?api-version=2024-03-01-Preview"

Write-Output "Constructed URI with API version: $uri"

# Use Azure CLI to get the resource details and save to search.json
az rest --uri $uri > search.json

# Update the networkRuleSet.bypass property in the JSON file
jq '.properties.networkRuleSet.bypass = "AzureServices"' search.json > search_updated.json

# Use Azure CLI to update the resource with the modified JSON
az rest --uri $uri `
  --method PUT `
  --header "Content-Type=application/json" `
  --body "@search_updated.json"