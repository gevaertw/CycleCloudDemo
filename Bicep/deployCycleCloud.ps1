# check the parameters file for the correct values before running this script

$location = "swedencentral"

az deployment sub create `
    --name MyCycleCloudDeployment `
    --template-file ./main.bicep `
    --location $location `
    --parameters '@CycleCloudParameters.json'
