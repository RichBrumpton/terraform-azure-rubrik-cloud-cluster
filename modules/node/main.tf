variable "cluster_node_name" {
  type = list(string)
}

variable "cluster_node_config" {
  type = map(string)
}

variable "cluster_disk" {
  type = map(any)
}

variable "tags" {
  type = map(string)
}

resource "azurerm_network_interface" "nic" {
  for_each            = toset(var.cluster_node_name)
  name                = "${each.value}-nic"
  resource_group_name = var.cluster_node_config.resource_group
  location            = var.cluster_node_config.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.cluster_node_config.subnet_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
  }

  tags = merge(
    var.tags,
    {}
  )
}


resource "azurerm_managed_disk" "disk" {
  for_each             = var.cluster_disk
  name                 = each.key
  location             = var.cluster_node_config.location
  resource_group_name  = var.cluster_node_config.resource_group
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.size

  tags = merge(
    var.tags,
    {}
  )
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = toset(var.cluster_node_name)
  name                            = each.value
  computer_name                   = "${var.cluster_node_config.computer_name_prefix}${index(var.cluster_node_name, each.value)}"
  location                        = var.cluster_node_config.location
  resource_group_name             = var.cluster_node_config.resource_group
  size                            = var.cluster_node_config.size
  admin_username                  = var.cluster_node_config.admin_username
  admin_password                  = var.cluster_node_config.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.value].id,
  ]

  os_disk {
    name                 = "${each.key}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_id = var.cluster_node_config.source_image_id

  tags = merge(
    var.tags,
    {}
  )
}

resource "azurerm_virtual_machine_data_disk_attachment" "cc" {
  for_each           = var.cluster_disk
  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm[each.value.vm].id
  lun                = each.value.lun
  caching            = "ReadWrite"
}

output "nodes" {
  value = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}