<p align="center">
<a href="https://fingerprint.com">
<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://fingerprintjs.github.io/home/resources/logo_light.svg" />
<source media="(prefers-color-scheme: light)" srcset="https://fingerprintjs.github.io/home/resources/logo_dark.svg" />
<img src="https://fingerprintjs.github.io/home/resources/logo_dark.svg" alt="Fingerprint logo" width="312px" />
</picture>
</a>
</p>

<p align="center">
<a href="https://registry.terraform.io/modules/fingerprintjs/fingerprint-fastly-proxy-integration/vcl/latest"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fregistry.terraform.io%2Fv2%2Fmodules%2Ffingerprintjs%2Ffingerprint-fastly-proxy-integration%2Fvcl%3Finclude%3Dlatest-version&query=%24.included%5B0%5D.attributes.version&prefix=v&label=Terraform" alt="Current version"></a>
<a href="https://github.com/fingerprintjs/terraform-fastly-vcl-fingerprint-proxy-integration"><img src="https://img.shields.io/github/v/release/fingerprintjs/terraform-fastly-vcl-fingerprint-proxy-integration" alt="Current version"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/:license-mit-blue.svg" alt="MIT license"></a>
<a href="https://discord.gg/39EpE2neBg"><img src="https://img.shields.io/discord/852099967190433792?style=logo&label=Discord&logo=Discord&logoColor=white" alt="Discord server"></a>
</p>

# Fingerprint Fastly VCL Integration (Terraform module)

[Fingerprint](https://fingerprint.com/) is a device intelligence platform offering industry-leading accuracy.

Fingerprint Fastly VCL Integration is responsible for

- Proxying download requests of the latest Fingerprint JS Agent between your site and Fingerprint CDN.
- Proxying identification requests and responses between your site and Fingerprint's APIs.

This [improves](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration#the-benefits-of-using-the-fastly-vcl-proxy-integration) both accuracy and reliability of visitor identification and bot detection on your site.

You can install the Fastly VCL proxy integration [manually](https://dev.fingerprint.com/docs/deploy-fastly-vcl-manually) or as [a Terraform module](https://registry.terraform.io/modules/fingerprintjs/fingerprint-fastly-proxy-integration/vcl/latest) included in this repository. For more details, see the [full documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration).


## Requirements

- [Fastly](https://www.fastly.com/signup) Account
- [Terraform CLI](https://developer.hashicorp.com/terraform/install).
- [Fastly API Token](https://manage.fastly.com/account/tokens)

> [!IMPORTANT]  
> The Fastly VCL Proxy Integration is exclusively supported for customers on the Enterprise Plan. Other customers are encouraged to use [Custom subdomain setup](https://dev.fingerprint.com/docs/custom-subdomain-setup) or [Cloudflare Proxy Integration](https://dev.fingerprint.com/docs/cloudflare-integration).

> [!WARNING]  
> The underlying data contract in the identification logic can change to keep up with browser updates. Using the Fastly VCL Proxy Integration might require occasional manual updates on your side. Ignoring these updates will lead to lower accuracy or service disruption.

## 1. Install the Terraform module

- Create your own terraform folder and create main.tf file
- Fill the file like this:

```terraform
terraform {
  required_version = ">=1.5"
}

module "fingerprint_fastly_vcl_integration" {
  source                     = "github.com/fingerprintjs/temp-fastly-vcl-terraform"
  fastly_api_token             = "<your fastly api token>"
  integration_domain         = "<your domain to serve fingerprint integration>"
  agent_script_download_path = "<random path like this: qwe123>"
  get_result_path            = "<random path like this: asd987>"
  integration_path           = "<random path like this: xyz456>"
  main_host                  = "<your origin domain to serve your website>"
  proxy_secret               = "<your proxy secret>"
}
```

You can see the full list of the Terraform module's variables below:

| Variable                     | Description                                               | Required | Example                                        |
| ---------------------------- | --------------------------------------------------------- | -------- | ---------------------------------------------- |
| `fastly_api_token`           | Your Fastly API token                                     | Required | `"ABC123...xyz"`                               |
| `integration_domain`         | Domain used for the proxy integration                     | Required | `"metrics.yourwebsite.com"`                    |
| `main_host`                  | Your origin server domain                                 | Required | `"yourwebsite.com"`                            |
| `proxy_secret`               | Your Fingerprint proxy secret                             | Required | `"9h7jk2s1"`                                   |
| `integration_path`           | Path prefix for proxy requests                            | Required | `"kyfy7t0a"`                                   |
| `agent_script_download_path` | Path for serving the JavaScript agent                     | Required | `"cc7bu2o8"`                                   |
| `get_result_path`            | Path for identification requests                          | Required | `"sy5k3279"`                                   |
| `dictionary_name`            | Name of the Fastly Dictionary for config values           | Optional | `"fingerprint_config"`                         |
| `integration_name`           | Name of the Fastly CDN service                            | Optional | `"fingerprint-fastly-vcl-proxy-integration"`   |
| `download_asset`             | Whether to auto-download the latest VCL release           | Optional | `true`                                         |
| `vcl_asset_name`             | Custom VCL asset file if not downloading the official one | Optional | `"fingerprint-pro-fastly-vcl-integration.vcl"` |
| `asset_version`              | GitHub release version used for the VCL asset             | Optional | `"latest"`                                     |

* Run `terraform init`

## 2. Deploy your Terraform changes

Run these commands in order:
```shell
terraform init
```

```shell
terraform apply -target=module.fingerprint_fastly_vcl_integration.module.vcl_asset
```

```shell
terraform apply
```

## Using a custom VCL asset

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

## Destroy

To destroy, run this:
```shell
terraform destroy
```
