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
  description = "Number of disks per node, set this to **0** for Cloud Cluster ES"
  type        = number
  default     = 4
}

variable "data_disk_size" {
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

variable "cc_image_storage_account_name" {
  default = "segaiatempccimagesa1"
}
variable "ss_image_container_name" {
  default = "releases"
}
variable "cc_image_name" {
  default = "rubrik-6-0-0-EA2-12277.vhd"
}
variable "cc_image_source_uri" {
  default = "https://rubrikazurevhdsstdwestus.blob.core.windows.net/release/rubrik-6-0-0-EA2-12277.vhd?sr=c&sp=rl&sv=2018-03-28&st=2021-05-24T16%3A58%3A37Z&sig=97TKpHWzPOsmtvp1TMDPlxznsTezkTXcy1tXbyGGNQI%3D&se=2026-05-24T16%3A58%3A37Z"
}
variable "cc_storage_account_name" {
  default = "segaiatempccessa1"
}
variable "cc_storage_container_name" {
  default =  "cc-test"
}