$managementSubscriptionName = "ME-MngEnvMCAP376337-wgevaert-1"
$managementSubscriptionId = "c6900d9a-d481-4659-b69e-5bbe9bfd27f8"
$managementRGName = "CycleCloud-management-rg"
$managementRegion = "northeurope"

$managementKeyvaultName = "cc1684435486-kv"


$managementVMName = "CCM01"
$managementVMImage = "RedHat:RHEL:9-LVM:latest"
$managementVMSize = "Standard_D4s_v5"
$managementVMAdminUserName = "vmadmin"
$managementVMNicName = $managementVMName + "-nic"
$managementVMOSDiskName = $managementVMName + "-OSDisk"
$managementPublicIPName = $managementVMName + "-pip"


$managementVNetName = "CycleCloud-management-vnet"
$managementVNetAddressPrefix = "10.0.0.0/24"
$managementSubnetName = $managementVNetName + "-main-snet"
$managementSubnetAddressPrefix = "10.0.0.0/25"
$managementNSGName = $managementSubnetName + "-nsg"

$managementBastionName = "CycleCloud-management-bastion"
$managementBastionAddressPrefix = "10.0.0.128/25"
$managementBastionPublicIPName = $managementBastionName + "-pip"

$managementStorageAccountName = "cc1684435486"

$HPCExperiment001SubscriptionName = "ME-MngEnvMCAP376337-wgevaert-1"
$HPCExperiment001SubscriptionId = "c6900d9a-d481-4659-b69e-5bbe9bfd27f8"
$HPCExperiment001RGName = "HPCExperiment001-rg"
$HPCExperiment001Region = "swedencentral"

$HPCExperiment001VNetName = "CycleCloud-management-vnet"
$HPCExperiment001VNetAddressPrefix = "10.1.0.0/20"
$HPCExperiment001SubnetName = $managementVNetName + "-snet"
$HPCExperiment001SubnetAddressPrefix = "10.1.0.0/20"
$HPCExperiment001NSGName = $managementSubnetName + "-nsg"

$CyclecloudMi = "Cyclecloud-mi"
