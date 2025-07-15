variable "agent_script_download_path" {
  description = "The Fingerprint agent download will be proxied through this path"
  type = string
  default = "agent"
}

variable "get_result_path" {
  description = "The Fingerprint agent download will be proxied through this path"
  type = string
  default = "result"
}

variable "integration_path" {
  description = "The Fingerprint integration will be proxied through this path prefix"
  type = string
  default = "integration"
}

variable "integration_domain" {
  description = "Domain used for your proxy integration"
  type = string
}

variable "main_host" {
  description = "Your origin server domain"
  type = string
}

variable "proxy_secret" {
  description = "Your Fingerprint proxy secret"
  type = string
}

variable "fastly_api_token" {
  type = string
}
