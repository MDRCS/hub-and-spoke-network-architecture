# Hub -> Network Security Group, Public IP, Network Interface and Virtual Machine.
resource "azurerm_public_ip" "hub-public-ip" {
  name                = "${local.prefix-hub-nva}-public-ip"
  location            = azurerm_resource_group.hub-nva-rg.location
  resource_group_name = azurerm_resource_group.hub-nva-rg.name

  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "hub-nva-nic" {
  name                 = "${local.prefix-hub-nva}-nic"
  location             = azurerm_resource_group.hub-nva-rg.location
  resource_group_name  = azurerm_resource_group.hub-nva-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-hub-nva
    subnet_id                     = azurerm_subnet.hub-dmz.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.36"
    public_ip_address_id          = azurerm_public_ip.hub-public-ip.id
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "hub-nsg" {
  name                = "${local.prefix-hub-nva}-nsg"
  location            = azurerm_resource_group.hub-nva-rg.location
  resource_group_name = azurerm_resource_group.hub-nva-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.external.my_ip.result.ip
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
    destination_address_prefix = data.external.my_ip.result.ip
  }

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_subnet_network_security_group_association" "mgmt-nsg-association" {
  subnet_id                 = azurerm_subnet.hub-mgmt.id
  network_security_group_id = azurerm_network_security_group.hub-nsg.id
}

resource "azurerm_virtual_machine" "hub-nva-vm" {
  name                  = "${local.prefix-hub-nva}-vm"
  location              = azurerm_resource_group.hub-nva-rg.location
  resource_group_name   = azurerm_resource_group.hub-nva-rg.name
  network_interface_ids = [azurerm_network_interface.hub-nva-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
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

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_virtual_machine_extension" "enable-routes" {
  name                 = "enable-iptables-routes"
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

  tags = {
    environment = local.prefix-hub-nva
  }
}

resource "azurerm_network_interface" "hub-nic" {
  name                 = "${local.prefix-hub}-nic"
  location             = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name  = azurerm_resource_group.hub-vnet-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-hub
    subnet_id                     = azurerm_subnet.hub-mgmt.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = local.prefix-hub
  }
}

#Virtual Machine
resource "azurerm_virtual_machine" "hub-vm" {
  name                  = "${local.prefix-hub}-vm"
  location              = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name   = azurerm_resource_group.hub-vnet-rg.name
  network_interface_ids = [azurerm_network_interface.hub-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-hub}-vm"
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = local.prefix-hub
  }
}


# Spoke 1 -> Network Security Group, Public IP, Network Interface and Virtual Machine.
resource "azurerm_public_ip" "spoke-1-public-ip" {
  name                = "${local.prefix-spoke1}-public-ip"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_interface" "spoke1-nic" {
  name                 = "${local.prefix-spoke1}-nic"
  location             = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-spoke1
    subnet_id                     = azurerm_subnet.spoke1-mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spoke-1-public-ip.id
  }
}

resource "azurerm_network_security_group" "spoke-1-nsg" {
  # """ Create Network Security Group and rule to Allow Inbound/Outbound Traffic """
  name                = "${local.prefix-spoke1}-nsg"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.external.my_ip.result.ip
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
    destination_address_prefix = data.external.my_ip.result.ip
  }

  tags = {
    environment = local.prefix-spoke1
  }
}

resource "azurerm_virtual_machine" "spoke1-vm" {
  name                  = "${local.prefix-spoke1}-vm"
  location              = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name   = azurerm_resource_group.spoke1-vnet-rg.name
  network_interface_ids = [azurerm_network_interface.spoke1-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
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

  tags = {
    environment = local.prefix-spoke1
  }
}

# 

locals {
  spoke2-location       = "eastus"
  spoke2-resource-group = "spoke2-vnet-rg"
  prefix-spoke2         = "spoke2"
}

# Create Network Security Group and rule to Allow Inbound/Outbound Traffic
resource "azurerm_network_security_group" "spoke-2-nsg" {
  name                = "${local.prefix-spoke2}-nsg"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.external.my_ip.result.ip
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
    destination_address_prefix = data.external.my_ip.result.ip
  }

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_public_ip" "spoke-2-public-ip" {
  name                = "${local.prefix-spoke2}-public-ip"
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "spoke2-nic" {
  name                 = "${local.prefix-spoke2}-nic"
  location             = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name  = azurerm_resource_group.spoke2-vnet-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = local.prefix-spoke2
    subnet_id                     = azurerm_subnet.spoke2-mgmt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.spoke-2-public-ip.id
  }

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_virtual_machine" "spoke2-vm" {
  name                  = "${local.prefix-spoke2}-vm"
  location              = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name   = azurerm_resource_group.spoke2-vnet-rg.name
  network_interface_ids = [azurerm_network_interface.spoke2-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
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

  tags = {
    environment = local.prefix-spoke2
  }
}
