#!/bin/bash

# Get the list of all Azure regions
regions=$(az account list-locations --query "[].name" -o tsv)

# Loop through each region and list available VM SKUs
for region in $regions; do
  echo "Available VM SKUs in region: $region"
  az vm list-sizes --location $region --output table
  echo ""
done