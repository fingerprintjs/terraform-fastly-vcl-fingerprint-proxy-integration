terraform {
  required_version = ">= 1.5"

  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 7.0.0"
    }
  }
}

provider "fastly" {
  api_key = var.fastly_api_key
}

module "vcl_asset" {
  count                        = var.download_asset ? 1 : 0
  source                       = "./modules/download_asset"
  repository_name              = var.repository_name
  repository_organization_name = var.repository_organization_name
  vcl_asset_name               = var.vcl_asset_name
  vcl_version_min              = var.asset_version
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
    content = file("${path.cwd}/assets/${var.vcl_asset_name}")
    main = true
  }

  force_destroy = true
}

locals {
  selected_dictionary = {
    for d in fastly_service_vcl.fingerprint_integration.dictionary : d.name => d
  }[var.dictionary_name]
}

resource "fastly_service_dictionary_items" "fingerprint_integration_dictionary_items" {
  service_id    = fastly_service_vcl.fingerprint_integration.id
  dictionary_id = local.selected_dictionary.dictionary_id
  items = {
    PROXY_SECRET : var.proxy_secret,
    INTEGRATION_PATH : var.integration_path,
    AGENT_SCRIPT_DOWNLOAD_PATH : var.agent_script_download_path,
    GET_RESULT_PATH : var.get_result_path,
  }
}
