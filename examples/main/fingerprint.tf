module "fingerprint_fastly_vcl_integration" {
  source = "../.."
  agent_script_download_path = var.agent_script_download_path
  get_result_path = var.get_result_path
  integration_domain = var.integration_domain
  integration_path = var.integration_path
  main_host = var.main_host
  proxy_secret = var.proxy_secret
  fastly_api_token = var.fastly_api_token
}
