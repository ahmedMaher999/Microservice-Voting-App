variable "environment" {
  description = "The environment name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "uaenorth"
}

variable "node_count" {
  description = "Number of worker nodes in the cluster"
  type        = number
  default     = 1
}