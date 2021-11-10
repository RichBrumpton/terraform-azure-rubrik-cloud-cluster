variable "create_storage_account" {
  type = bool
  default = false
}

variable "env" {
  type    = string
  default = ""
}

variable "cluster_name" {
  type    = string
  default = "cc"
}

variable "admin_username" {
  type    = string
  default = "adminuser"
}

variable "admin_password" {
  type    = string
  default = "P@ssw0rd123!"
}

variable "azure_location" {
  type    = string
  default = "westus2"
}

variable "subnet_id" {
  type = string
}

variable "number_of_nodes" {
  type    = number
  default = 4
}

variable "data_disk_count" {
  description = "Number of disks per node, set this to **1** for Cloud Cluster ES"
  type        = number
  default     = 4
}

variable "data_disk_size" {
  description = "size of each data disk, set this to **512** for Cloud Cluster ES."
  type    = number
  default = 512
}

variable "cluster_disk_type" {
  type    = string
  default = "Premium_LRS"
}

variable "use_dense_nodes" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
