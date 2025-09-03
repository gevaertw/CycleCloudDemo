#!/bin/bash
PARAMETERFILE="CycleCloudParameters.json"
SECRETFILE="CycleCloudParameters_secrets.json"

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Install it with: sudo apt-get install jq"
    exit 1
fi

# Export variables in the current shell context
eval "$(jq -r '.parameters | to_entries[] | "export \(.key)=\(.value.value)"' $PARAMETERFILE)"
eval "$(jq -r '.parameters | to_entries[] | "export \(.key)=\(.value.value)"' $SECRETFILE)"

# Example usage:
echo "tenantID: ${cycleCloudTenantID}"
echo "subscriptionID: ${cycleCloudSubscriptionID}"
echo "location: ${location}"
