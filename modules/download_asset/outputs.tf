output "content" {
  description = "Content of the downloaded VCL template"
  value       = data.http.asset[local.selected_index].response_body

  precondition {
    condition     = var.asset_version != "latest" || length(local.sorted_tags) > 0
    error_message = "${local.repository} has no stable v${local.supported_major_version}.x.y release."
  }
  precondition {
    condition     = local.selected_tag != null
    error_message = "${var.vcl_asset_name} is missing from release ${join(", ", distinct(local.candidate_tags))} of ${local.repository}."
  }
}

output "version" {
  description = "Release tag of the downloaded VCL template, for example v2.1.2"
  value       = local.selected_tag
}
