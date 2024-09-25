param(
    [Parameter(Mandatory=$true)]
    [string]$subid

    [string]rg

    [string]name
)



# Construct the URI
$uri = "https://management.azure.com/subscriptions/$subid/resourceGroups/$rg/providers/Microsoft.Search/searchServices/$name?api-version=2024-03-01-Preview"

# Use Azure CLI to get the resource details and save to search.json
az rest --uri $uri > search.json

# Update the networkRuleSet.bypass property in the JSON file
jq '.properties.networkRuleSet.bypass = "AzureServices"' search.json > search_updated.json

# Use Azure CLI to update the resource with the modified JSON
az rest --uri $uri `
  --method PUT `
  --body search_updated.json