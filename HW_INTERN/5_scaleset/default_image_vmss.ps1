#login to azure
az login

Write-Host "Creating resource group..."
$myrg = "ScaleSetRg"
$loc = "eastus"
az group create --name $myrg --location $loc

Write-Host "Creating VM ScaleSet..."
az vmss create `
-g $myrg `
--name myScaleSet `
--image UbuntuLTS `
--admin-username kekis `
--generate-ssh-keys

Write-Host "Instances info:"
az vmss list-instances `
-g $myrg `
--name myScaleSet `
--output table

Write-Host "Connection info:"
az vmss list-instance-connection-info `
-g $myrg `
--name myScaleSet

Write-Host "Scaling up to 3 instances..."
az vmss scale `
-g $myrg `
--name myScaleSet `
--new-capacity 3

Write-Host "New Instances info:"
az vmss list-instances `
-g $myrg `
--name myScaleSet `
--output table

Write-Host "New Connection info:"
az vmss list-instance-connection-info `
-g $myrg `
--name myScaleSet

Get-Content D:\DevOps\REPOS_LOCAL_VS\LocalVStudio\HW_INTERN\5_scaleset\Message_to_user.txt | Write-Host
