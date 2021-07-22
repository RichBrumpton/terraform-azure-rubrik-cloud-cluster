variable "storage_account_name" {}
variable "storage_container_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "account_replication_type" {}
variable "tags" {}

resource "azurerm_storage_account" "this" {
  count                    = 1
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  count                 = 1
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.this[0].name
  container_access_type = "private"
}

output "account" {
  value = azurerm_storage_account.this
}