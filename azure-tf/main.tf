provider "azurerm" {
  features {}
}

variable "password" {
  description = "Tester123"
}

resource "azurerm_resource_group" "main" {
  name     = "wsb-resources"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = "wsb-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "wsb-public-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "main" {
  name                = "wsb-nic"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "wsb-vm"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B9ls"
  admin_username                  = "ubuntu"
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  os_profile {
    computer_name  = azurerm_linux_virtual_machine.main.name
    admin_username = "ubuntu"

    linux_config {
      disable_password_authentication = true

      ssh_keys {
        path     = "/home/ubuntu/.ssh/authorized_keys"
        key_data = "<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>"
      }
    }
  }
}

