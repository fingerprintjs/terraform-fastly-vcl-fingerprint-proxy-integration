variable "proxy_secret" {
  description = "Your Fingerprint proxy secret"
  type = string
}

variable "fastly_api_token" {
  description = "Your Fastly API token"
  type = string
}

variable "integration_path" {
  description = "Path prefix for the proxied requests"
  type = string
}

variable "agent_script_download_path" {
  description = "Path for downloading the Fingerprint JavaScript Agent"
  type = string
}

variable "get_result_path" {
  description = "Path for proxying identification requests"
  type = string
}

variable "integration_domain" {
  description = "Domain used for your proxy integration"
  type = string
}

variable "main_host" {
  description = "Your origin server domain"
  type = string
}