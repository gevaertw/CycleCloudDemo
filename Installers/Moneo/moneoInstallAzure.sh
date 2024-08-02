#!/bin/bash
# root is assumed here.  (if running from cloud init, you are root, if not run sudo -i)

# based on https://github.com/Azure/Moneo/blob/main/docs/HeadlessDeployment.md

# Run this script on all nodes in the scale set, by starting it from the cyclecloud cloud init script

# run once per scale set
az login

scaleSetName=htc-5hggnrljtvfmx
cycleCloudMonitoringRGName=CycleCloudPOC-Monitoring-rg
resourceGroupScaleSet=alma-01-Costing-G43WEZDEMU2WCLJYGIZDELJUMM

moneoIdentityID=${az identity show --resource-group $cycleCloudMonitoringRGName --name moneo-identity --query id --output tsv}
az vmss identity assign --resource-group $resourceGroupScaleSet --name $scaleSetName --identities $moneoIdentityID

