# 1. Resource Group - The bucket for everything
resource "azurerm_resource_group" "rg" {
  name     = "rg-voting-${var.environment}"
  location = var.location
}

# 2. Networking - A VNet to hold the cluster
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "subnet-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 3. Azure Container Registry (ACR) - Where your images live
resource "azurerm_container_registry" "acr" {
  name                = "acrvotingapp${var.environment}${random_integer.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

# Random suffix because ACR names must be globally unique
resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

# 4. AKS Cluster - The Kubernetes Engine
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-voting-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "voting-${var.environment}"

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = "Standard_B2s" # Burstable, cheap for dev/test
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    
    service_cidr       = "10.1.0.0/16"  # Changed from default 10.0.0.0/16 to avoid conflict
    dns_service_ip     = "10.1.0.10"    # Must be inside the service_cidr
  }
}

# 5. CRITICAL: Connect ACR to AKS (The "Glue")
# This gives the AKS cluster permission to PULL images from your ACR
resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}