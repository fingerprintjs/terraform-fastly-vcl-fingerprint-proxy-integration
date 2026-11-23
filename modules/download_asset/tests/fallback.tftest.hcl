# Offline tests for picking the VCL template release. Run with `terraform test` in modules/download_asset (Terraform >= 1.7).

mock_provider "http" {
  mock_data "http" {
    defaults = {
      status_code   = 200
      response_body = "VCL"
    }
  }
}

override_data {
  target = data.http.tags[0]
  values = {
    status_code   = 200
    response_body = "[{\"ref\":\"refs/tags/v2.0.0\"},{\"ref\":\"refs/tags/v2.0.0-rc.1\"},{\"ref\":\"refs/tags/v2.1.1\"},{\"ref\":\"refs/tags/v2.1.2\"},{\"ref\":\"refs/tags/v2.10.0\"}]"
  }
}

run "latest_picks_newest_by_semver" {
  command = plan
  assert {
    condition     = output.version == "v2.10.0"
    error_message = "got ${output.version}"
  }
  assert {
    condition     = jsonencode(local.candidate_tags) == jsonencode(["v2.10.0", "v2.1.2", "v2.1.1"])
    error_message = "got ${jsonencode(local.candidate_tags)}"
  }
}

run "falls_back_on_404" {
  command = plan
  override_data {
    target = data.http.asset[0]
    values = { status_code = 404, response_body = "Not Found" }
  }
  assert {
    condition     = output.version == "v2.1.2"
    error_message = "got ${output.version}"
  }
}

run "fails_on_503_instead_of_falling_back" {
  command = plan
  override_data {
    target = data.http.asset[0]
    values = { status_code = 503, response_body = "" }
  }
  expect_failures = [data.http.asset[0]]
}

run "fails_when_all_candidates_404" {
  command = plan
  override_data {
    target = data.http.asset[0]
    values = { status_code = 404 }
  }
  override_data {
    target = data.http.asset[1]
    values = { status_code = 404 }
  }
  override_data {
    target = data.http.asset[2]
    values = { status_code = 404 }
  }
  expect_failures = [output.content]
}

run "pinned_version_is_only_candidate" {
  command = plan
  variables {
    asset_version = "v2.1.1"
  }
  assert {
    condition     = output.version == "v2.1.1" && jsonencode(local.candidate_tags) == jsonencode(["v2.1.1"])
    error_message = "got ${output.version}"
  }
}

run "pinned_other_major_rejected" {
  command = plan
  variables {
    asset_version = "v1.0.0"
  }
  expect_failures = [data.http.asset[0]]
}

run "single_tag_fills_all_candidates" {
  command = plan
  override_data {
    target = data.http.tags[0]
    values = {
      status_code   = 200
      response_body = "[{\"ref\":\"refs/tags/v2.0.0\"},{\"ref\":\"refs/tags/v2.0.0-rc.1\"}]"
    }
  }
  assert {
    condition     = output.version == "v2.0.0" && jsonencode(local.candidate_tags) == jsonencode(["v2.0.0", "v2.0.0", "v2.0.0"])
    error_message = "got ${output.version} from ${jsonencode(local.candidate_tags)}"
  }
}

run "fails_without_stable_tags" {
  command = plan
  override_data {
    target = data.http.tags[0]
    values = {
      status_code   = 200
      response_body = "[{\"ref\":\"refs/tags/v2.0.0-rc.1\"}]"
    }
  }
  expect_failures = [output.content]
}

run "github_token_is_sent_to_the_tags_api" {
  command = plan
  variables {
    github_token = "TOKEN"
  }
  assert {
    condition     = data.http.tags[0].request_headers["Authorization"] == "Bearer TOKEN"
    error_message = "Authorization header is missing"
  }
}

run "no_authorization_header_without_token" {
  command = plan
  assert {
    condition     = !contains(keys(data.http.tags[0].request_headers), "Authorization")
    error_message = "Authorization header should not be set"
  }
}
