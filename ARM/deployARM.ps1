$templateFile = "./ARM/template.json"
$parameterFile="./ARM/parameters.json"
$resourceGroupName="CycleCloud-rg"
$region="swedencentral"

az group create `
  --name $resourceGroupName `
  --location $region

az deployment group create `
  --name "devenvironment" `
  --resource-group $resourceGroupName `
  --template-file $templateFile `
  --parameters $parameterFile