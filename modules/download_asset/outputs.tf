output "content" {
  description = "Content of the downloaded VCL template"
  value       = data.http.asset.response_body
}

output "version" {
  description = "Release tag of the downloaded VCL template, for example v2.1.2"
  value       = local.selected_tag
}
