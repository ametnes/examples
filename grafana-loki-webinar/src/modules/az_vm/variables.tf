variable "instance_count" {
  description = "Number of instances to provision"
}


variable "public_key" {
  description = "Public Key"
}

variable "user_data" {
  description = "User data"
}

variable "resource_group_name_prefix" {
  default     = "wbn"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

