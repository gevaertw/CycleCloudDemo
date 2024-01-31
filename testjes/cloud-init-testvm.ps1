# demonstartes how to use cloud-init to configure a VM

$cloudInitVMName = "cloudinittestvm"
$cloudInitRGName = "cloud-init-test-rg"

az group create --name $cloudInitRGName --location eastus

az vm create `
    --resource-group $cloudInitRGName `
    --name $cloudInitVMName `
    --image Ubuntu2204 `
    --admin-username azureuser `
    --generate-ssh-keys `
    --custom-data cloud-init-testvm.yaml

az vm open-port `
    --port 80 `
    --resource-group $cloudInitRGName  `
    --name $cloudInitVMName