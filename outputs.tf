output "service_id" {
  description = "ID of the Fastly CDN service"
  value       = fastly_service_vcl.fingerprint_integration.id
}

output "service_name" {
  description = "Name of the Fastly CDN service"
  value       = fastly_service_vcl.fingerprint_integration.name
}

output "active_version" {
  description = "Active version of the Fastly CDN service"
  value       = fastly_service_vcl.fingerprint_integration.active_version
}

output "dictionary_id" {
  description = "ID of the Fastly dictionary that holds the integration config"
  value       = local.selected_dictionary.dictionary_id
}

output "vcl_version" {
  description = "Release tag of the downloaded VCL template, for example v2.1.2. Null when vcl_content is set"
  value       = var.vcl_content == null ? module.vcl_asset[0].version : null
}

output "integration_domain" {
  description = "Domain of the integration. Read from the service, so resources that use it wait for the service, for example a TLS subscription"
  value       = one(fastly_service_vcl.fingerprint_integration.domain).name
}

output "integration_url" {
  description = "Integration URL for the JavaScript agent `endpoints` option. Add `?region=REGION` to it, for example `?region=eu`"
  value       = "https://${var.integration_domain}/${var.integration_path}"
}
