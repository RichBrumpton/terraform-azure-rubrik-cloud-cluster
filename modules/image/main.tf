variable "image_storage_account_name" {}
variable "image_storage_container_name" {}
variable "image_source_uri" {}
variable "image_file" {}
variable "image_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "tags" {}

resource "azurerm_storage_account" "this" {
  count                    = 1
  name                     = var.image_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

resource "azurerm_storage_container" "this" {
  count                 = 1
  name                  = var.image_storage_container_name
  storage_account_name  = azurerm_storage_account.this[0].name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "this" {
  count                  = 1
  name                   = var.image_file
  storage_account_name   = azurerm_storage_account.this[0].name
  storage_container_name = azurerm_storage_container.this[0].name
  type                   = "Page"
  source_uri             = var.image_source_uri
  timeouts {
    create = "2h"
  }
}


resource "azurerm_image" "this" {
  count               = 1
  name                = var.image_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = azurerm_storage_blob.this[0].url
    size_gb  = 512
  }
}

output "id" {
  value = azurerm_image.this[0].id
}