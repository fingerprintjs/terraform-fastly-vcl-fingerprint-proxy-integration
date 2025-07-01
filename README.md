# Prerequisites

* Copy your Fastly API Key
* Create your own terraform folder and create main.tf file
* Fill the file like this:
```terraform
terraform {
  required_version = ">=1.5"
}

module "vcl" {
  source                     = "github.com/fingerprintjs/temp-fastly-vcl-terraform"
  fastly_api_key             = "<your fastly api key>"
  integration_domain         = "<your domain to serve fingerprint integration>"
  agent_script_download_path = "<random path like this: qwe123>"
  get_result_path            = "<random path like this: asd987>"
  integration_path           = "<random path like this: xyz456>"
  main_host                  = "<your origin domain to serve your website>"
  proxy_secret               = "<your proxy secret>"
}
```
* Run `terraform init`

# Deploy

Run these commands in order
```shell
terraform init
terraform apply -target=module.vcl.module.vcl_asset
terraform apply
```

# Custom VCL

If you want to use your own asset instead of downloading latest follow these steps:

Place your custom asset in `<your_module_root>/assets/custom-asset.vcl` and then edit your `main.tf` file, and add these 2 variables inside "vcl" module block:
```terraform
download_asset = false
vcl_asset_name = "custom-asset.vcl"
```

Run these commands:
```shell
terraform init
terraform apply
```

# Destroy

To destroy, run this:
```shell
terraform destroy
```
