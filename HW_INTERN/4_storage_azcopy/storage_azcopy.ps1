#login to azure
az login

#create resource group
Write-Host "Creating Resource group..."
$myrg="StorageRG"
$loc="eastus"
az group create --name $myrg --location $loc
az group list -o table

#create storage account
Write-Host "Creating Storage Account..."
$storacc="vegerostorage123"
az storage account create `
--name $storacc `
-g $myrg `
--location $loc `
--sku Standard_RAGRS `
--kind StorageV2

#login with azcopy
Write-Host "Logging in with AzCopy..."
$applicationId = "d1376579-6a02-4c84-bc1b-91445da6e083"
$env:AZCOPY_SPA_CLIENT_SECRET="$(Read-Host -prompt "Enter key")"
#key I.87Q~FfMue6-sZQiBEoXarDq-HxTgcda_DrI
$tenantID = "511626b7-f429-49dc-9090-fa0561d419af"
.\azcopy.exe login `
--service-principal `
--application-id $applicationId `
--tenant-id $tenantID

#create role assignment for blob
Write-Host "Creating role assignment..."
az role assignment create `
--role "Storage Blob Data Contributor" `
--assignee-object-id a2eac919-7b94-4d7e-8ee6-db9fd3f78919 `
--scope /subscriptions/a2eac919-7b94-4d7e-8ee6-db9fd3f78919/resourceGroups/StorageRG/providers/Microsoft.Storage/storageAccounts/vegerostorage123
<# f646ed11-9aa8-43a4-a09e-a88550506350 `#>
#create a container
Write-Host "Making a container with AzCopy..."
.\azcopy.exe make 'https://$storacc.blob.core.windows.net/mycontainer'

#copy a file
Write-Host "Copying TestFile.txt..."
.\azcopy.exe copy 'D:\DevOps\HW_INTERN\4_storage_azcopy\TestFile.txt' 'https://$storacc.blob.core.windows.net/mycontainer/TestFile.txt'

