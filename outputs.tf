output "cc_resource_group" {
  value = azurerm_resource_group.rcdm
}
/*
output "cc_image_storage_account" {
  value = azurerm_storage_account.cc_image
  sensitive = true
}
*/
output "cc_es_storage_account" {
  value     = module.rubrik_es_storage.account
  sensitive = true
}