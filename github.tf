data "github_release" "selected" {
  repository = var.repository_name
  owner      = var.repository_organization_name
  retrieve_by = var.vcl_version_min
}

locals {
  vcl_download_url = [
    for asset in data.github_release.selected.assets :
    asset.browser_download_url
    if asset.name == var.vcl_asset_name
  ][0]
}

resource "null_resource" "download_vcl" {
  provisioner "local-exec" {

    command = <<EOT
      mkdir -p ./assets
      curl -L \
        -o ./assets/${var.vcl_asset_name} \
        "${local.vcl_download_url}"
    EOT
  }

  triggers = {
    release = data.github_release.selected.release_tag
    asset   = var.vcl_asset_name
  }
}

data "local_file" "vcl" {
  filename = "${path.module}/assets/${var.vcl_asset_name}"
  depends_on = [null_resource.download_vcl]
}
