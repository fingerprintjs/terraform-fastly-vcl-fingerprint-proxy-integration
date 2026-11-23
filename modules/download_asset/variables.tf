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

variable "github_token" {
  type        = string
  default     = null
  sensitive   = true
  description = "Optional GitHub token for listing the release tags. Without it, GitHub allows 60 requests per hour per IP"
}
