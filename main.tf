terraform {
  required_version = ">= 1.5"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 7.0.0"
    }
  }
}

locals {
  selected_dictionary = {
    for d in fastly_service_vcl.fingerprint_integration.dictionary : d.name => d
  }[
  var.dictionary_name
  ]
}

module "vcl_asset" {
  count                              = var.custom_vcl == null ? 1 : 0
  source                             = "./modules/download_asset"
  asset_repository_name              = var.asset_repository_name
  asset_repository_organization_name = var.asset_repository_organization_name
  vcl_asset_name                     = var.vcl_asset_name
  asset_version                      = var.asset_version
  github_token                       = var.github_token
}

resource "fastly_service_vcl" "fingerprint_integration" {
  name = var.integration_name

  domain {
    name = var.integration_domain
  }

  backend {
    address = var.main_host
    name    = "Main Host"
    port    = 443
  }

  dictionary {
    name = var.dictionary_name
  }

  vcl {
    name = var.vcl_asset_name
    content = var.custom_vcl != null ? var.custom_vcl.content : module.vcl_asset[0].content
    main = true
  }

  force_destroy = var.force_destroy
}

resource "fastly_service_dictionary_items" "fingerprint_integration_dictionary_items" {
  service_id    = fastly_service_vcl.fingerprint_integration.id
  dictionary_id = local.selected_dictionary.dictionary_id
  manage_items = var.manage_fastly_dictionary_items
  items = {
    for k, v in {
      PROXY_SECRET               = var.proxy_secret
      INTEGRATION_PATH           = var.integration_path
      AGENT_SCRIPT_DOWNLOAD_PATH = var.agent_script_download_path
      GET_RESULT_PATH            = var.get_result_path
    } : k => v if v != null
  }
}

# Terraform deletes the dictionary items before the service. With force_destroy = false, Fastly then refuses to
# delete the active service, which would leave it running without its config. This guard is deleted first and
# fails instead, so nothing is deleted.
resource "terraform_data" "destroy_guard" {
  input = var.force_destroy

  provisioner "local-exec" {
    when    = destroy
    command = self.input ? "exit 0" : "echo force_destroy is false, so the Fastly service and its dictionary items are kept && exit 1"
  }

  depends_on = [fastly_service_dictionary_items.fingerprint_integration_dictionary_items]
}
