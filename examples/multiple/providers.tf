terraform {
  required_version = ">= 1.5"
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 7.1.0"
    }
  }
}

# Reads the API token from the FASTLY_API_KEY environment variable
provider "fastly" {}
