#initial reqiurements
Write-Host "Before continuing, go to azure portal shell and do this:";
Get-Content cloud-init.txt | Write-Host;
#wait for user confirmation
While($Selection -ne "Y" ){
   $Selection = read-host "Continue? (Y/N)"
    Switch ($Selection) 
        { 
            Y {Write-host "Continuing with validation"} 
            N {Write-Host "Breaking out of script"} 
        } 
    If($Selection -eq "N"){Return}
}
Write-Host "Continuing with Script"

#login to azure
Write-Host "Logging in to azure service principal..."
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

#create resource group
Write-Host "Creating Resource Group..."
$myrg = "MyLoadBalancerRG"
$loc = "eastus"
az group create --name $myrg --location $loc
az group list -o table

#create public IP
Write-Host "Creating Public IP-address..."
$mypub = "MyPublicIP"
az network public-ip create -g $myrg --name $mypub

#create load balancer
Write-Host "Creating Load Balancer..."
$mylb = "MyLoadBalancer"
az network lb create `
-g $myrg `
--name $mylb `
--frontend-ip-name MyFrontEndPool `
--backend-pool-name MyBackEndPool `
--public-ip-address $mypub

#create lb health probe
Write-Host "Creating Health Probe..."
az network lb probe create `
-g $myrg `
--lb-name $mylb `
--name MyHealthProbe `
--protocol tcp `
--port 80

#create load balancer rule
Write-Host "Creating LB rule..."
az network lb rule create `
-g $myrg `
--lb-name $mylb `
--name MyLoadBalancerRule `
--protocol tcp `
--frontend-port 80 `
--backend-port 80 `
--frontend-ip-name MyFrontEndPool `
--backend-pool-name MyBackEndPool `
--probe-name MyHealthProbe

#create virtual network
Write-Host "Creating Virtual Network..."
az network vnet create -g $myrg --name MyVnet --subnet-name MySubnet

#create security group
Write-Host "Creating Network Security Group..."
az network nsg create -g $myrg --name MyNSG

#create security rule
Write-Host "Creating NSG Rule..."
az network nsg rule create `
-g $myrg `
--nsg-name MyNSG `
--name MyNSGRule `
--priority 1001 `
--protocol tcp `
--destination-port-range 80

#create interfaces
for ( $i = 1 ; $i -le 3 ; $i++) {
    Write-Host "Creating Nic$i..."
    az network nic create `
    -g $myrg `
    --name MyNic$i `
    --vnet-name MyVnet `
    --subnet MySubnet `
    --network-security-group MyNSG `
    --lb-name $mylb `
    --lb-address-pools MyBackEndPool
}

#create availability set
Write-Host "Creating Availability Set..."
az vm availability-set create -g $myrg --name MyAvailSet

#create VMs
for ( $i = 1 ; $i -le 3 ; $i++) {
    Write-Host "Creating VM$i..."
    az vm create `
    -g $myrg `
    --name MyVM$i `
    --availability-set MyAvailSet `
    --nics MyNic$i `
    --image UbuntuLTS `
    --admin-username azureuser `
    --generate-ssh-keys `
    --custom-data cloud-init.txt `
    --no-wait
}
#test load balancer
Write-Host "Cretion Completed! Input this Public IP-address in browser to test:"
az network public-ip show `
--resource-group MyLoadBalancerRG `
--name myPublicIP `
--query [ipAddress] `
--output tsv

Write-Host "When done, don't forget to clean up with the command 'az group delete -g $myrg'"

