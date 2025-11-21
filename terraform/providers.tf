terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  # Stores the state locally for now. 
  # In a real team, you would change this to "azurerm" (Storage Account).
  backend "local" {}
}

provider "azurerm" {
  features {}
}