variable "integration_domain" {
  type = string
}

variable "main_host" {
  type = string
}

variable "test_domain_name" {
  type = string
  default = ""
}

variable "repository_organization_name" {
  type    = string
  default = "fingerprintjs"
}

variable "repository_name" {
  type    = string
  default = "fingerprint-pro-fastly-vcl-integration"
}

variable "vcl_asset_name" {
  type    = string
  default = "fingerprint-pro-fastly-vcl-integration.vcl"
}

variable "vcl_version_min" {
  type    = string
  default = "latest"
}

variable "fastly_api_key" {
  type = string
}

variable "integration_path" {
  type = string
  default = "integration"
}

variable "agent_script_download_path" {
  type = string
  default = "agent"
}

variable "get_result_path" {
  type = string
  default = "result"
}

variable "proxy_secret" {
  type = string
  default = "secret"
}

variable "dictionary_name" {
  type = string
  default = "fingerprint_config"
}

variable "integration_name" {
  type = string
  default = "fingerprint_integration"
}

variable "download_asset" {
  type = bool
  default = true
}
