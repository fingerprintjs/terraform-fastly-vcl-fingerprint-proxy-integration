# Downloads the Fingerprint VCL template from the GitHub releases of fastly-vcl-proxy.
# - asset_version = "latest" picks the newest stable tag of the supported major version
# - Tags come from the git matching-refs API, which returns all tags with the v<major>. prefix in one response (no pagination)
# - Any other asset_version must be a release tag of the supported major version, for example "v2.1.2"
# - A new major version of the template needs a new major version of this module
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
  # Matches stable tags of the supported major version only, for example v2.1.2. Captures minor and patch.
  tag_pattern = "^v${local.supported_major_version}\\.(\\d+)\\.(\\d+)$"

  # Pre-release tags like v2.0.0-rc.0 also have the prefix, the pattern skips them
  stable_tags = var.asset_version == "latest" ? [
    for ref in jsondecode(data.http.tags[0].response_body) : trimprefix(ref.ref, "refs/tags/")
    if can(regex(local.tag_pattern, trimprefix(ref.ref, "refs/tags/")))
  ] : []
  # Zero-padded minor and patch, so sorting the keys as strings sorts the tags by version
  tags_by_sort_key = {
    for tag in local.stable_tags :
    format("%06d.%06d", tonumber(regex(local.tag_pattern, tag)[0]), tonumber(regex(local.tag_pattern, tag)[1])) => tag
  }
  selected_tag = var.asset_version == "latest" ? try(local.tags_by_sort_key[reverse(sort(keys(local.tags_by_sort_key)))[0]], null) : var.asset_version
}

data "http" "tags" {
  count = var.asset_version == "latest" ? 1 : 0
  url   = "https://api.github.com/repos/${local.repository}/git/matching-refs/tags/v${local.supported_major_version}."
  request_headers = {
    Accept = "application/vnd.github+json"
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Could not list the v${local.supported_major_version} tags of ${local.repository}. GitHub returned HTTP ${self.status_code}."
    }
  }
}

data "http" "asset" {
  url = "https://github.com/${local.repository}/releases/download/${coalesce(local.selected_tag, "none")}/${var.vcl_asset_name}"

  lifecycle {
    precondition {
      condition     = local.selected_tag != null
      error_message = "${local.repository} has no stable v${local.supported_major_version}.x.y release."
    }
    precondition {
      condition     = can(regex(local.tag_pattern, coalesce(local.selected_tag, "none")))
      error_message = "asset_version must be \"latest\" or a v${local.supported_major_version}.x.y release tag, got \"${var.asset_version}\"."
    }
    postcondition {
      condition     = self.status_code == 200
      error_message = "Could not download ${var.vcl_asset_name} from release ${coalesce(local.selected_tag, "none")} of ${local.repository}. GitHub returned HTTP ${self.status_code}."
    }
  }
}
