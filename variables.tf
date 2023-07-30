variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}

variable "aks_virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "acr_virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "acr_registry_name" {
  description = "Name of ACR"
  type        = string
}

variable "aks_subnet" {
  description = "Name of the subnet"
  type        = string
}

variable "acr_subnet" {
  description = "Name of the subnet"
  type        = string
}

