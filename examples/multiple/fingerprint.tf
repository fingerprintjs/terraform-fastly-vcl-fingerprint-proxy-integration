module "fingerprint_fastly_vcl_integration" {
  source   = "../.."
  for_each = var.integrations

  integration_name   = "fingerprint-fastly-vcl-${each.key}"
  integration_domain = each.value.integration_domain
  integration_path   = each.value.integration_path
  main_host          = each.value.main_host
  proxy_secret       = var.proxy_secret
}

output "integration_urls" {
  description = "Integration URL of each integration, for the JavaScript agent `endpoints` option"
  value       = { for name, integration in module.fingerprint_fastly_vcl_integration : name => integration.integration_url }
}

output "service_ids" {
  description = "Fastly CDN service ID of each integration"
  value       = { for name, integration in module.fingerprint_fastly_vcl_integration : name => integration.service_id }
}
