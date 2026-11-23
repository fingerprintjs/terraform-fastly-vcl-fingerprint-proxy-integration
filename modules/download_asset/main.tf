# Downloads the Fingerprint VCL template from the GitHub releases of fastly-vcl-proxy.
# - asset_version = "latest" picks the newest stable tag of the supported major version
# - Tags come from the git matching-refs API, which returns all tags with the v<major>. prefix in one response (no pagination)
# - A tag can exist before its release asset is uploaded. "latest" then falls back to the next newest tag on HTTP 404 only,
#   so a GitHub outage fails the plan instead of moving the service to an older template
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
  sorted_tags = [for key in reverse(sort(keys(local.tags_by_sort_key))) : local.tags_by_sort_key[key]]

  # Newest tags to try, in order. A pinned asset_version is the only candidate.
  # - The number of candidates only depends on asset_version, so it is known at plan time even when the
  #   tag lookup is deferred to apply, for example by depends_on on the module
  # - With fewer tags than candidates, the last candidates repeat the oldest tag. "none" means there is no tag
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
    # 404 means the asset isn't uploaded (yet), anything else is an error
    postcondition {
      condition     = contains([200, 404], self.status_code)
      error_message = "Could not download ${var.vcl_asset_name} from release ${local.candidate_tags[count.index]} of ${local.repository}. GitHub returned HTTP ${self.status_code}."
    }
  }
}
