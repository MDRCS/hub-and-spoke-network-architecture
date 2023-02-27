# Hub NVA -> Network Security Group, Public IP, Network Interface and Virtual Machine.
resource "azurerm_public_ip" "hub-nva-public-ip" {
  name                = "${local.prefix-hub-nva}-public-ip"
  resource_group_name = var.hub_nva_resource_group_name
  location             = var.location

  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "hub-nva-nic" {
  name                 = "${local.prefix-hub-nva}-nic"
  resource_group_name = var.hub_nva_resource_group_name
  location             = var.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-hub-nva
    subnet_id                     = module.network.hub_vnet_dmz_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.36"
    public_ip_address_id          = azurerm_public_ip.hub-nva-public-ip.id
  }

  tags = merge(
    tomap({ ResourceGroupe = var.hub_nva_resource_group_name }),
    local.default_tags
  )
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "hub-nva-nsg" {
  name                = "${local.prefix-hub-nva}-nsg"
  resource_group_name = var.hub_vnet_resource_group_name
  location             = var.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }

  # Allow Outbound Access from Hub and Spoke Network to my laptop IP Address
  security_rule {
    name                       = "Conn"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.my_ip
  }

tags = merge(
    tomap({ ResourceGroupe = var.hub_nva_resource_group_name }),
    local.default_tags
  )
} 

resource "azurerm_subnet_network_security_group_association" "mgmt-nsg-association" {
  subnet_id                 = module.network.hub_vnet_mgmt_id
  network_security_group_id = azurerm_network_security_group.hub-nva-nsg.id
}

resource "azurerm_virtual_machine" "hub-nva-vm" {
  name                  = "${local.prefix-hub-nva}-vm"
  resource_group_name = var.hub_nva_resource_group_name
  location             = var.location
  network_interface_ids = [azurerm_network_interface.hub-nva-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix-hub-nva}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-hub-nva}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

tags = merge(
    tomap({ ResourceGroupe = var.hub_nva_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_virtual_machine_extension" "enable-routes" {
  name                 = "${local.prefix-hub-nva}-enable-iptables-routes"
  virtual_machine_id   = azurerm_virtual_machine.hub-nva-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"


  settings = <<SETTINGS
    {
        "fileUris": [
        "https://raw.githubusercontent.com/mspnp/reference-architectures/master/scripts/linux/enable-ip-forwarding.sh"
        ],
        "commandToExecute": "bash enable-ip-forwarding.sh"
    }
SETTINGS

tags = merge(
    tomap({ ResourceGroupe = var.hub_nva_resource_group_name }),
    local.default_tags
  )
}

# Hub VNET -> Network Security Group, Public IP, Network Interface and Virtual Machine.
resource "azurerm_network_interface" "hub-vnet-nic" {
  name                 = "${local.prefix-hub-vnet}-nic"
  resource_group_name  = var.hub_vnet_resource_group_name
  location             = var.location
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-hub-vnet
    subnet_id                     = module.network.hub_vnet_mgmt_id
    private_ip_address_allocation = "Dynamic"
  }

tags = merge(
    tomap({ ResourceGroupe = var.hub_vnet_resource_group_name }),
    local.default_tags
  )
}



#Virtual Machine
resource "azurerm_virtual_machine" "hub-vnet-vm" {
  name                  = "${local.prefix-hub-vnet}-vm"
  resource_group_name  = var.hub_vnet_resource_group_name
  location             = var.location
  network_interface_ids = [azurerm_network_interface.hub-vnet-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix-hub-vnet}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-hub-vnet}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

tags = merge(
    tomap({ ResourceGroupe = var.hub_vnet_resource_group_name }),
    local.default_tags
  )
}


# Spoke 1 -> Network Security Group, Public IP, Network Interface and Virtual Machine.
resource "azurerm_public_ip" "spoke-1-public-ip" {
  name                = "${local.prefix-spoke1}-public-ip"
  location            = var.location
  resource_group_name = var.spoke1_vnet_resource_group_name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "spoke1-nic" {
  name                 = "${local.prefix-spoke1}-nic"
  location             = var.location
  resource_group_name  = var.spoke1_vnet_resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-spoke1
    subnet_id                     = module.network.spoke1_mgmt_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spoke-1-public-ip.id
  }
  
  tags = merge(
    tomap({ ResourceGroupe = var.spoke1_vnet_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_network_security_group" "spoke-1-nsg" {
  # """ Create Network Security Group and rule to Allow Inbound/Outbound Traffic """
  name                = "${local.prefix-spoke1}-nsg"
  location            = var.location
  resource_group_name       = var.spoke1_vnet_resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }

  # Allow Outbound Access from Hub and Spoke Network to my laptop IP Address
  security_rule {
    name                       = "Conn"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.my_ip
  }

tags = merge(
    tomap({ ResourceGroupe = var.spoke1_vnet_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_virtual_machine" "spoke1-vm" {
  name                  = "${local.prefix-spoke1}-vm"
  location              = var.location
  resource_group_name   = var.spoke1_vnet_resource_group_name
  network_interface_ids = [azurerm_network_interface.spoke1-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix-spoke1}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-spoke1}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

tags = merge(
    tomap({ ResourceGroupe = var.spoke1_vnet_resource_group_name }),
    local.default_tags
  )
}


# Create Network Security Group and rule to Allow Inbound/Outbound Traffic
resource "azurerm_network_security_group" "spoke-2-nsg" {
  name                = "${local.prefix-spoke2}-nsg"
  location            = var.location
  resource_group_name       = var.spoke2_vnet_resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }

  # Allow Outbound Access from Hub and Spoke Network to my laptop IP Address
  security_rule {
    name                       = "Conn"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = var.my_ip
  }

tags = merge(
    tomap({ ResourceGroupe = var.spoke2_vnet_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_public_ip" "spoke-2-public-ip" {
  name                = "${local.prefix-spoke2}-public-ip"
  location            = var.location
  resource_group_name = var.spoke2_vnet_resource_group_name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "spoke2-nic" {
  name                 = "${local.prefix-spoke2}-nic"
  location             = var.location
  resource_group_name  = var.spoke2_vnet_resource_group_name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-spoke2
    subnet_id                     = module.network.spoke2_mgmt_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spoke-2-public-ip.id
  }

tags = merge(
    tomap({ ResourceGroupe = var.spoke2_vnet_resource_group_name }),
    local.default_tags
  )
}

resource "azurerm_virtual_machine" "spoke2-vm" {
  name                  = "${local.prefix-spoke2}-vm"
  location              = var.location
  resource_group_name   = var.spoke2_vnet_resource_group_name
  network_interface_ids = [azurerm_network_interface.spoke2-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix-spoke2}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-spoke2}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

tags = merge(
    tomap({ ResourceGroupe = var.spoke2_vnet_resource_group_name }),
    local.default_tags
  )
}
