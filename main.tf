locals {
  cluster_name      = var.env == "" ? var.cluster_name : "${var.env}-${var.cluster_name}"
  cluster_node_name = [for n in range(1, var.number_of_nodes + 1) : format("${local.cluster_name}-%02s", n)]
  cluster_node_config = {
    computer_name_prefix = "rcdm-n"
    location             = azurerm_resource_group.rcdm[0].location,
    resource_group       = azurerm_resource_group.rcdm[0].name,
    size                 = var.use_dense_nodes ? "Standard_DS5_v2" : "Standard_DS3_v2",
    admin_username       = var.admin_username,
    admin_password       = var.admin_password,
    subnet_id            = var.subnet_id,
    source_image_id      = module.rubrik_image.id
    data_disk_count      = var.data_disk_count
    data_disk_size       = var.data_disk_size
  }
  cluster_disk = {
    for v in setproduct(local.cluster_node_name, range(var.data_disk_count)) :
    "${v[0]}-datadisk${v[1]}" => {
      lun                  = v[1] + 1
      vm                   = v[0],
      size                 = var.data_disk_size,
      storage_account_type = var.cluster_disk_type
    }
  }
}

resource "azurerm_resource_group" "rcdm" {
  count    = 1
  name     = "${var.env}-${var.azure_location}-cloud-cluster-es"
  location = var.azure_location
}

module "rubrik_image" {
  source = "./modules/image"

  image_storage_account_name   = var.image_storage_account_name #segaiawu2ccesimage
  image_storage_container_name = var.image_storage_container_name #releases
  image_source_uri             = var.image_source_uri #https://rubrikazurevhdsstdwestus.blob.core.windows.net/release/rubrik-6-0-0-EA2-12277.vhd?sr=c&sp=rl&sv=2018-03-28&st=2021-05-24T16%3A58%3A37Z&sig=97TKpHWzPOsmtvp1TMDPlxznsTezkTXcy1tXbyGGNQI%3D&se=2026-05-24T16%3A58%3A37Z
  image_file                   = var.image_filename #rubrik-6-0-0-EA2-12277.vhd
  image_name                   = var.image_name #rubrik-6-0-0-EA2-12277
  resource_group_name          = azurerm_resource_group.rcdm[0].name
  location                     = azurerm_resource_group.rcdm[0].location
  tags                         = var.tags
}

module "rubrik_es_storage" {
  source = "./modules/blob"

  storage_account_name     = var.storage_account_name
  storage_container_name   = local.cluster_name
  resource_group_name      = azurerm_resource_group.rcdm[0].name
  location                 = azurerm_resource_group.rcdm[0].location
  account_replication_type = var.storage_account_replication_type
  create_storage_account = var.create_storage_account

  tags = var.tags
}

module "rubrik_node" {
  source = "./modules/node"

  cluster_node_name   = local.cluster_node_name
  cluster_node_config = local.cluster_node_config
  cluster_disk        = local.cluster_disk

  tags = var.tags
}
