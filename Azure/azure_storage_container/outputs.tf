#----------------------------------------------------------------------------------------
# Terraform With Azure
#
# outputs.tf file
#
# Made by y.tkachenko@mobidev.biz
#-----------------------------------------------------------------------------------------

output "primary_blob_endpoint" {
  value = azurerm_storage_account.az_storage.primary_blob_endpoint
}

output "blob_url" {
  value = azurerm_storage_blob.blob.url
}