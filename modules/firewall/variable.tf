locals {
  prefix      = "az-firewall"
  fw_name     = "tcm-labs-azfw"
  fw_policy   = "tcm-labs-fw-policy"
  fw_location = "eastus"
}

variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "location" {
  description = "Location of the network"
}