#!/bin/bash

# Get the list of all Azure regions
regions=$(az account list-locations --query "[].name" -o tsv)

# Loop through each region and list VM SKU quotas and their availability
for region in $regions; do
  echo "VM SKU quotas and availability in region: $region"
  az vm list-usage --location $region --output table
  echo ""
done