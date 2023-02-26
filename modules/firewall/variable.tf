locals {
  prefix      = "az-firewall"
}

variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "location" {
  description = "Location of the network"
}