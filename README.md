# Prerequisites

* Create a `terraform.tfvars` file, fill your `fastly_api_key`, `integration_domain`, `main_host`, `get_result_path`, `agent_script_download_path`, `proxy_secret`

# Deploy

After filling `terraform.tfvars` file, run these in order:
```shell
terraform init
terraform apply -target=module.vcl_asset
terraform apply
```

# Custom VCL

If you want to use your own asset instead of downloading latest follow these steps:

Place your custom asset in `<project_root>/assets/custom-asset.vcl` and then edit your `terraform.tfvars` file, and add these 2 variables:
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
