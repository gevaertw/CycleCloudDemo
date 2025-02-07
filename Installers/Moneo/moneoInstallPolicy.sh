#!/bin/bash

#WORK IN PROGRESS, MANUAL FOR NOW

# Read the parameters file for use in this script
$jsonContent = Get-Content -Raw -Path './CycleCloudParameters.json'
$parametersObj = ConvertFrom-Json $jsonContent

az policy definition create --name "vmssUserAssignedIdentityPolicy" --display-name "VMSS User Assigned Identity Policy" --description "Ensure VMSS have user assigned identity for Moneo monitoring" --rules vmssUserAssignedIdentityPolicy.json --mode Indexed 
az policy assignment create --name "vmssUserAssignedIdentityPolicyAssignment" --policy "vmssUserAssignedIdentityPolicy" --scope "/subscriptions/$cycleCloudSubscriptionID" --params "{ \"userAssignedIdentities\": { \"value\": \"/subscriptions/$cycleCloudSubscriptionID/resourceGroups/$cycleCloudMonitoringRGName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$monitoringUserAssignedIdentityName\" } }"