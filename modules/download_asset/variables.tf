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
}

variable "vcl_version_min" {
  type    = string
  default = "latest"
}
