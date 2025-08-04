provider "azurerm" {
  features {}
  subscription_id = "************************************"
  client_id       = "************************************"
  client_secret   = "****************************************"
  tenant_id       = "************************************"
}

## resource Block ##
resource "azurerm_resource_group" "rg" {
  name     = "RG-01"
  location = "centralindia"
}

## Virtual Network ##
resource "azurerm_virtual_network" "vnet" {
  name                = "Vnet-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "Subnet" {
  name                 = "subnet-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "Subnet01" {
  name                 = "subnet-02"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

## PUBLICIP BLOCK ##

resource "azurerm_public_ip" "pip0" {
  name                = "pip0"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "pip1" {
  name                = "pip1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
}


## NIC Block ##
resource "azurerm_network_interface" "nic0" {
  name                = "VM01-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "testconfigure1"
    subnet_id                     = azurerm_subnet.Subnet.id
    public_ip_address_id          = azurerm_public_ip.pip0.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic1" {
  name                = "VM02-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  ip_configuration {
    name                          = "testconfigure1"
    subnet_id                     = azurerm_subnet.Subnet01.id
    public_ip_address_id          = azurerm_public_ip.pip1.id
    private_ip_address_allocation = "Dynamic"
  }
}

## VM Block ##
resource "azurerm_virtual_machine" "vm" {
  name                             = "VM-01"
  location                         = azurerm_resource_group.rg.location
  resource_group_name              = azurerm_resource_group.rg.name
  network_interface_ids            = [azurerm_network_interface.nic0.id]
  vm_size                          = "standard_Ds1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "mohit"
    admin_password = "Password@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name                             = "VM-02"
  location                         = azurerm_resource_group.rg.location
  resource_group_name              = azurerm_resource_group.rg.name
  network_interface_ids            = [azurerm_network_interface.nic1.id]
  vm_size                          = "standard_Ds1_v2"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "mohit"
    admin_password = "Password@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

## NETWORK SECURITY GROUP ##
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "assoc" {
  network_interface_id      = azurerm_network_interface.nic0.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface_security_group_association" "assoc01" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_public_ip" "lbpip" {
  name                = "azpip01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "LB-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "FIP-01"
    public_ip_address_id = azurerm_public_ip.lbpip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bp" {
  name            = "BP-01"
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_probe" "hp" {
  name                = "hp-01"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lbr" {
  name                           = "LBR-01"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "FIP-01"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bp.id]
  probe_id                       = azurerm_lb_probe.hp.id
}
