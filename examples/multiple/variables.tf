variable "proxy_secret" {
  description = "Your Fingerprint proxy secret"
  type        = string
  sensitive   = true
}

variable "integrations" {
  description = "Integrations to deploy. The key is used in the Fastly service name"
  type = map(object({
    integration_domain = string
    integration_path   = string
    main_host          = string
  }))
}
