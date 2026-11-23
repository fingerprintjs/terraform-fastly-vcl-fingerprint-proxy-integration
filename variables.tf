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
  default = "fastly-vcl-proxy"
}

variable "vcl_asset_name" {
  type    = string
  default = "fingerprint-pro-fastly-vcl-integration.vcl"
  nullable = false
}

variable "asset_version" {
  type        = string
  default     = "latest"
  nullable    = false
  description = "\"latest\" for the newest v2.x.y release of the VCL template, or a release tag to pin, for example \"v2.1.2\""
}

variable "github_token" {
  type        = string
  default     = null
  sensitive   = true
  description = "Optional GitHub token for listing the VCL template releases, to avoid the limit of 60 requests per hour per IP. Needs no scopes"
}

variable "custom_vcl" {
  type = object({
    content = string
  })
  default     = null
  description = "Your own VCL template, for example { content = file(\"custom.vcl\") }. When set, the official template isn't downloaded"
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
  type     = string
  nullable = true
  default  = null
  validation {
    condition     = var.agent_script_download_path == null ? true : can(regex("^([a-zA-Z0-9\\-])+$", var.agent_script_download_path))
    error_message = "value should only consist of alphanumeric values and dashes"
  }
}

variable "get_result_path" {
  type     = string
  nullable = true
  default  = null
  validation {
    condition     = var.get_result_path == null ? true : can(regex("^([a-zA-Z0-9\\-])+$", var.get_result_path))
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

variable "manage_fastly_dictionary_items" {
  type = bool
  default = false
  nullable = false
  description = "Manage Fastly Dictionary items via terraform, see link: https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items#manage_items-1"
}

variable "force_destroy" {
  type        = bool
  default     = true
  nullable    = false
  description = "Let Terraform delete the Fastly service and its dictionary items, for example on terraform destroy. Set to false to make the destroy fail without deleting anything"
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
