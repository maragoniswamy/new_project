data "azurerm_subscription" "current" {}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = azurerm_resource_group.aks_acr_rg.location
  resource_group_name = azurerm_resource_group.aks_acr_rg.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    #vm_size             = "standard_b16als_v2"
    vm_size             = "Standard_B2s"
    type                = "VirtualMachineScaleSets"
    zones  = [1]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
  }
  
  depends_on = [
    azurerm_container_registry.acr,
    azurerm_virtual_network_peering.acr_to_aks,
    azurerm_virtual_network_peering.aks_to_acr,
  ]
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                     = var.acr_registry_name
  resource_group_name      = azurerm_resource_group.aks_acr_rg.name
  location                 = azurerm_resource_group.aks_acr_rg.location
  sku                      = "Standard"
  admin_enabled            = true
 # georeplication_locations = []  # Optional, add other Azure regions if needed
}

# resource "null_resource" "connect_to_aks" {
#   provisioner "local-exec" {
#     command = "az connectedk8s connect --name Manish-test --resource-group manish-test"
#     interpreter = ["cmd", "/C"]  # Use ["bash", "-c"] for Linux/Mac

#   }
#   depends_on = [
#     azurerm_kubernetes_cluster.aks_cluster,
#   ]
# }

# resource "null_resource" "connect_to_aks" {

#   provisioner "local-exec" {
#     # Set the subscription
#     command = "az account set --subscription b354355c-cd23-4463-b394-3781e2cd3f1b"
#     interpreter = ["cmd", "/C"]  # Use ["bash", "-c"] for Linux/Mac
#   }

#   provisioner "local-exec" {
#     # Get AKS cluster credentials
#     command = "az aks get-credentials --resource-group manish-test --name Manish-test"
#     interpreter = ["cmd", "/C"]  # Use ["bash", "-c"] for Linux/Mac
#   }

#   provisioner "local-exec" {
#     # Connect the AKS cluster to Azure Arc
#     command = "az connectedk8s connect --name Manish-test --resource-group manish-test"
#     interpreter = ["cmd", "/C"]  # Use ["bash", "-c"] for Linux/Mac
#   }


#   depends_on = [
#     azurerm_kubernetes_cluster.aks_cluster,
#   ]
# }


# Define the resource group
# resource "azurerm_resource_group" "aks_acr_rg" {
#   name     = var.resource_group_name
#   location = var.location
# }

# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = var.cluster_name
#   kubernetes_version  = var.kubernetes_version
#   location            = var.location
#   resource_group_name = azurerm_resource_group.aks_acr_rg.name
#   dns_prefix          = var.cluster_name

#   default_node_pool {
#     name                = "system"
#     node_count          = var.system_node_count
#     #vm_size             = "standard_b16als_v2"
#     vm_size             = "Standard_B2s"
#     type                = "VirtualMachineScaleSets"
#     zones  = [1]
#     enable_auto_scaling = false
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   network_profile {
#     load_balancer_sku = "standard"
#     network_plugin    = "kubenet" 
#   }
# }


# resource "azurerm_kubernetes_cluster" "example" {
#   name                         = "Manish-arctest"
#   resource_group_name          = azurerm_resource_group.manish_test.name
#   location                     = var.location
#   agent_public_key_certificate = filebase64("public.cer")

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = {
#     ENV = "Test"
#   }
# }

# Use the official AzureAD provider from Microsoft for Azure Active Directory
# provider "azuread" {
#   version = "~> 2.0"
# }

# # Use the Azure Arc provider from Microsoft for Azure Arc
# provider "azurearc" {
#   version = "~> 0.1"  # Use the latest version compatible with your Terraform version
# }

# resource "azurearc_connectedk8s" "aks_arc" {
#   name                = "my-aks-cluster-arc"
#   location            = "EastUS"  # Change this to your desired region
#   resource_group_name = "manish-test"
#   cluster_name        = "Manish-test"
#   cluster_resource_id = "/subscriptions/b354355c-cd23-4463-b394-3781e2cd3f1b/resourceGroups/manish-test/providers/Microsoft.ContainerService/managedClusters/Manish-test"
#   tenant_id           = "92677b25-e4ec-4de5-8465-27929a5f4d29"
#   subscription_id     = "b354355c-cd23-4463-b394-3781e2cd3f1b"
# }


# resource "azurerm_arc_kubernetes_cluster_extension" "example" {
#   name           = "example-ext"
#   cluster_id     = azurerm_arc_kubernetes_cluster.example.id
#   #extension_type = "microsoft.flux"
#   extension_type  = "Microsoft.Kubernetes/connectedClusters"

#   identity {
#     type = "SystemAssigned"
#   }
# }

# resource "azurerm_kubernetes_cluster_extension" "aks_arc_extension" {
#   name           = var.aks_arc_extension_name
#   extension_type = var.aks_extension_type
#   cluster_id     = azurerm_kubernetes_cluster.aks.id
# }

# resource "azurerm_provider_registration" "container_service" {
#   provider_namespace = "Microsoft.ContainerService"
# }

# Retrieve the current subscription ID

# provider "azurerm" {
#   alias = "aks"
#   features {}
# }

# resource "azurerm_kubernetes_cluster" "aks_cluster" {
#   name                = "my-aks-cluster1"
#   kubernetes_version  = "1.21.2"
#   location            = azurerm_resource_group.aks_acr_rg.location
#   resource_group_name = azurerm_resource_group.aks_acr_rg.name
#   dns_prefix          = "my-aks-cluster"

#   default_node_pool {
#     name                = "system"
#     node_count          = 2
#     vm_size             = "Standard_B2s"
#     type                = "VirtualMachineScaleSets"
#     zones               = [1]
#     enable_auto_scaling = true
#     min_count           = 1
#     max_count           = 2
#   }

#   identity {
#     type = "SystemAssigned"
#   }

#   network_profile {
#     load_balancer_sku = "standard"
#     network_plugin    = "kubenet"
#   }
# }


# resource "azurerm_connectedk8s" "aks_arc_attachment" {
#   name                = "attach-aks-to-azure-arc"
#   location            = azurerm_kubernetes_cluster.aks.location
#   resource_group_name = azurerm_resource_group.aks_arc_rg.name
#   cluster_name        = azurerm_kubernetes_cluster.aks.name
# }

/*

provider "azurerm" {
  alias = "arc"
  features {}
}

provider "azurerm" {
  alias = "arc_k8s"
  features {}
}

resource "azurerm_resource_group" "arc-rg" {
  name     = "azure-arc-rg"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "arc_k8s_cluster" {
  provider             = azurerm.arc_k8s
  name                 = "my-aks-cluster-arc"
  location             = azurerm_resource_group.arc-rg.location
  resource_group_name  = azurerm_resource_group.arc-rg.name
  dns_prefix           = "my-aks-cluster-arc"
  private_cluster_enabled = true

  default_node_pool {
    name                = "system"
    node_count          = 3
    vm_size             = "Standard_B2s"
    type                = "VirtualMachineScaleSets"
    zones               = [1]
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_extension" "arc_cluster_extension" {
  provider = azurerm.arc_k8s
  name                 = "azure-arc-k8s"
  cluster_id         = azurerm_kubernetes_cluster.arc_k8s_cluster.id
 # cluster_resource_id  = azurerm_kubernetes_cluster.arc_k8s_cluster.id
  extension_type       = "Microsoft.Kubernetes/connectedClusters"

  depends_on = [
    azurerm_kubernetes_cluster_extension.aks_arc_extension,
  ]
}

*/