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
}

variable "asset_version" {
  type     = string
  default  = "latest"
  nullable = false
}
