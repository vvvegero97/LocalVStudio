#login
az login

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

