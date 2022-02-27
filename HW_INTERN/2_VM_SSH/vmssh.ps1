#login to azure
Write-Host "Login to azure service principal..."
$applicationId = "d1376579-6a02-4c84-bc1b-91445da6e083"
$password = "I.87Q~FfMue6-sZQiBEoXarDq-HxTgcda_DrI"
$tenantID = "511626b7-f429-49dc-9090-fa0561d419af"
az login `
--service-principal `
--username "${applicationId}" `
--password "${password}" `
--tenant "${tenantID}"
#set context
az account set --subscription a2eac919-7b94-4d7e-8ee6-db9fd3f78919

#set resource group name and location
$resource = "VMtestSSHport-12345"
$loc = "eastus"
#create resource group
Write-Host "Creating resource-group..."
az group create --name "${resource}" --location "${loc}"

#set security group name
$nsgname = "TestNsg"
#create security group
Write-Host "Creating Network Security Group and opening SSH port..."
az network nsg create `
--resource-group "${resource}" `
--name "${nsgname}" `
--location "${loc}" 
#create network rules for TestNsg
#open ssh port on vnet subnet
az network nsg rule create `
--resource-group "${resource}" `
--nsg-name "${nsgname}" `
--name "AllowSSHin" `
--priority 100 `
--destination-address-prefixes 10.20.0.0/24 `
--destination-port-ranges 22 `
--access Allow

#create virtual network and subnet
Write-Host "Creating Virtual Network...."
az network vnet create `
--resource-group "${resource}" `
--name "TestVnet" `
--address-prefixes 10.20.0.0/16 `
--location "${loc}" `
--subnet-name "TestVnetSub" `
--subnet-prefixes 10.20.0.0/24 `
--nsg "${nsgname}"

#create virtual machine with vnet and nsg assigned
Write-Host "Creating Virtual Machine..."
az vm create `
--resource-group "${resource}" `
--location "${loc}" `
--name myVM `
--image UbuntuLTS `
--admin-username 'kekis' `
--nsg "${nsgname}" `
--vnet-name TestVnet `
--subnet TestVnetSub `
--generate-ssh-keys `
--size "Standard_DS2_v2" `
--verbose

Write-Host "All done! Don't forget to clean up with 'az group delete -g $resource'!"

