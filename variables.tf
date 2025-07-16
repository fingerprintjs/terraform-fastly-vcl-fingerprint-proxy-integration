variable "integration_domain" {
  type = string
  nullable = false
}

variable "main_host" {
  type = string
  nullable = false
}

variable "asset_repository_organization_name" {
  type    = string
  default = "fingerprintjs"
}

variable "asset_repository_name" {
  type    = string
  default = "fingerprint-pro-fastly-vcl-integration"
}

variable "vcl_asset_name" {
  type    = string
  default = "fingerprint-pro-fastly-vcl-integration.vcl"
  nullable = false
}

variable "asset_version" {
  type    = string
  default = "latest"
}

variable "fastly_api_token" {
  type = string
  nullable = false
}

variable "integration_path" {
  type = string
  nullable = false
  validation {
    condition     = can(regex("^([a-zA-Z0-9\\-])+$", var.integration_path))
    error_message = "value should only consist of alphanumeric values and dashes"
  }
}

variable "agent_script_download_path" {
  type = string
  nullable = false
  validation {
    condition     = can(regex("^([a-zA-Z0-9\\-])+$", var.agent_script_download_path))
    error_message = "value should only consist of alphanumeric values and dashes"
  }
}

variable "get_result_path" {
  type = string
  nullable = false
  validation {
    condition     = can(regex("^([a-zA-Z0-9\\-])+$", var.get_result_path))
    error_message = "value should only consist of alphanumeric values and dashes"
  }
}

variable "proxy_secret" {
  type = string
  sensitive = true
  nullable = false
  validation {
    condition     = can(regex("^([a-zA-Z0-9\\-])+$", var.proxy_secret))
    error_message = "value should only consist of alphanumeric values and dashes"
  }
}

variable "dictionary_name" {
  type = string
  default = "fingerprint_config"
  nullable = false
  validation {
    condition     = can(regex("^([a-zA-Z0-9\\_])+$", var.dictionary_name))
    error_message = "value should only consist of alphanumeric values and underscores"
  }
}

variable "integration_name" {
  type = string
  default = "fingerprint-fastly-vcl-proxy-integration"
  nullable = false
  validation {
    condition     = can(regex("^([a-zA-Z0-9\\_\\-])+$", var.integration_name))
    error_message = "value should only consist of alphanumeric values and underscores"
  }
}

variable "download_asset" {
  type = bool
  default = true
}
