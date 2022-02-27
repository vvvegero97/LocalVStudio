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
