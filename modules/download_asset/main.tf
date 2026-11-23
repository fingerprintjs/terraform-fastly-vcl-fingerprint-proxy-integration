# Downloads the Fingerprint VCL template from the fastly-vcl-proxy GitHub releases.
# Only v2.x.y releases are used. A new template major needs a new major of this module.
terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.0"
    }
  }
}

locals {
  supported_major_version = 2
  repository              = "${var.asset_repository_organization_name}/${var.asset_repository_name}"
  # Stable v2.x.y tags only, so pre-releases are skipped
  tag_pattern = "^v${local.supported_major_version}\\.(\\d+)\\.(\\d+)$"

  stable_tags = var.asset_version == "latest" ? [
    for ref in jsondecode(data.http.tags[0].response_body) : trimprefix(ref.ref, "refs/tags/")
    if can(regex(local.tag_pattern, trimprefix(ref.ref, "refs/tags/")))
  ] : []
  # Zero-padded, so a string sort is a version sort
  tags_by_sort_key = {
    for tag in local.stable_tags :
    format("%06d.%06d", tonumber(regex(local.tag_pattern, tag)[0]), tonumber(regex(local.tag_pattern, tag)[1])) => tag
  }
  sorted_tags = [for key in reverse(sort(keys(local.tags_by_sort_key))) : local.tags_by_sort_key[key]]

  # Up to 3 newest tags to try. A fixed count keeps it known at plan time when depends_on defers the tag lookup
  candidate_count = var.asset_version == "latest" ? 3 : 1
  candidate_tags = var.asset_version == "latest" ? [
    for i in range(local.candidate_count) : try(local.sorted_tags[min(i, length(local.sorted_tags) - 1)], "none")
  ] : [var.asset_version]
  selected_index = try([for i, tag in local.candidate_tags : i if data.http.asset[i].status_code == 200][0], null)
  selected_tag   = local.selected_index == null ? null : local.candidate_tags[local.selected_index]
}

data "http" "tags" {
  count = var.asset_version == "latest" ? 1 : 0
  url   = "https://api.github.com/repos/${local.repository}/git/matching-refs/tags/v${local.supported_major_version}."
  request_headers = merge(
    { Accept = "application/vnd.github+json" },
    var.github_token == null ? {} : { Authorization = "Bearer ${var.github_token}" },
  )

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Could not list the v${local.supported_major_version} tags of ${local.repository}. GitHub returned HTTP ${self.status_code}."
    }
  }
}

data "http" "asset" {
  count = local.candidate_count
  url   = "https://github.com/${local.repository}/releases/download/${local.candidate_tags[count.index]}/${var.vcl_asset_name}"

  lifecycle {
    precondition {
      condition     = var.asset_version == "latest" || can(regex(local.tag_pattern, var.asset_version))
      error_message = "asset_version must be \"latest\" or a v${local.supported_major_version}.x.y release tag, got \"${var.asset_version}\"."
    }
    # 404: asset not uploaded yet, try the next tag
    postcondition {
      condition     = contains([200, 404], self.status_code)
      error_message = "Could not download ${var.vcl_asset_name} from release ${local.candidate_tags[count.index]} of ${local.repository}. GitHub returned HTTP ${self.status_code}."
    }
  }
}
