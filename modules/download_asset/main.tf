terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.2.2"
    }
  }
}

data "github_release" "selected" {
  repository  = var.asset_repository_name
  owner       = var.asset_repository_organization_name
  retrieve_by = var.vcl_version_min
}

locals {
  asset_download_url = [
    for asset in data.github_release.selected.assets :
    asset.browser_download_url
    if asset.name == var.vcl_asset_name
  ][0]

  asset_path = var.asset_download_path
}

resource "null_resource" "download_asset" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p "${path.cwd}/assets"
      curl -L -o "${local.asset_path}" "${local.asset_download_url}"
    EOT
  }
}
