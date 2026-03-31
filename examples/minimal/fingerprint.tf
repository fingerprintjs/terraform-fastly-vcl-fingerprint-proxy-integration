module "fingerprint_fastly_vcl_integration" {
  source = "../.."
  integration_domain = var.integration_domain
  integration_path = var.integration_path
  main_host = var.main_host
  proxy_secret = var.proxy_secret
  fastly_api_token = var.fastly_api_token
}
