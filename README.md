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
<a href="https://registry.terraform.io/modules/fingerprintjs/vcl-fingerprint-proxy-integration/fastly/latest"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fregistry.terraform.io%2Fv2%2Fmodules%2Ffingerprintjs%2Fvcl-fingerprint-proxy-integration%2Ffastly%3Finclude%3Dlatest-version&query=%24.included%5B0%5D.attributes.version&prefix=v&label=Terraform" alt="Current version"></a>
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

You can install the Fastly VCL proxy integration [manually](https://dev.fingerprint.com/docs/deploy-fastly-vcl-manually) or as [a Terraform module](https://registry.terraform.io/modules/fingerprintjs/vcl-fingerprint-proxy-integration/fastly/latest) included in this repository. For more details, see the [full documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration).


## Requirements

- [Fastly](https://www.fastly.com/signup) Account
- [Terraform CLI](https://developer.hashicorp.com/terraform/install).
- [Fastly API Token](https://manage.fastly.com/account/tokens)

> [!IMPORTANT]  
> The Fastly VCL Proxy Integration is exclusively supported for customers on the Enterprise Plan. Other customers are encouraged to use [Custom subdomain setup](https://dev.fingerprint.com/docs/custom-subdomain-setup) or [Cloudflare Proxy Integration](https://dev.fingerprint.com/docs/cloudflare-integration).

> [!WARNING]  
> The underlying data contract in the identification logic can change to keep up with browser updates. Using the Fastly VCL Proxy Integration might require occasional manual updates on your side. Ignoring these updates will lead to lower accuracy or service disruption.

## 1. Install the Terraform module

1. Add the module to your Terraform file (for example, `main.tf`).
2. Configure it with your Fastly API token, Fingerprint proxy secret, integration domain, and other required values.

```terraform
terraform {
  required_version = ">=1.5"
}

module "fingerprint_fastly_vcl_integration" {
  source                     = "github.com/fingerprintjs/temp-fastly-vcl-terraform"
  fastly_api_token           = "FASTLY_API_TOKEN"
  proxy_secret               = "FINGERPRINT_PROXY_SECRET"
  integration_path           = "INTEGRATION_PATH"
  agent_script_download_path = "AGENT_SCRIPT_DOWNLOAD_PATH"
  get_result_path            = "GET_RESULT_PATH"
  integration_domain         = "metrics.yourwebsite.com"
  main_host                  = "yourwebsite.com"
}
```

You can see the full list of the Terraform module's variables below:

| Variable                         | Description                                                                                                                                                                                   | Required | Example                                        |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|------------------------------------------------|
| `fastly_api_token`               | Your Fastly API token                                                                                                                                                                         | Required | `"ABC123...xyz"`                               |
| `proxy_secret`                   | Your Fingerprint proxy secret                                                                                                                                                                 | Required | `"9h7jk2s1"`                                   |
| `integration_path`               | Path prefix for proxy requests                                                                                                                                                                | Required | `"kyfy7t0a"`                                   |
| `agent_script_download_path`     | Path for serving the JavaScript agent                                                                                                                                                         | Required | `"cc7bu2o8"`                                   |
| `get_result_path`                | Path for identification requests                                                                                                                                                              | Required | `"sy5k3279"`                                   |
| `integration_domain`             | Domain used for the proxy integration                                                                                                                                                         | Required | `"metrics.yourwebsite.com"`                    |
| `main_host`                      | Your origin server domain                                                                                                                                                                     | Required | `"yourwebsite.com"`                            |
| `dictionary_name`                | Name of the Fastly Dictionary for config values                                                                                                                                               | Optional | `"fingerprint_config"`                         |
| `integration_name`               | Name of the Fastly CDN service                                                                                                                                                                | Optional | `"fingerprint-fastly-vcl-proxy-integration"`   |
| `download_asset`                 | Whether to auto-download the latest VCL release                                                                                                                                               | Optional | `true`                                         |
| `vcl_asset_name`                 | Custom VCL asset file if not downloading the official one                                                                                                                                     | Optional | `"fingerprint-pro-fastly-vcl-integration.vcl"` |
| `asset_version`                  | GitHub release version used for the VCL asset                                                                                                                                                 | Optional | `"latest"`                                     |
| `manage_fastly_dictionary_items` | Manage Fastly Dictionary items via terraform, see [Fastly documentation](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items#manage_items-1) | Optional | `false`                                        |

## 2. Deploy your Terraform changes

1. Initialize the Terraform module:
   
    ```shell
    terraform init
    ```

2. Apply the VCL asset:

    ```shell
    terraform apply -target=module.fingerprint_fastly_vcl_integration.module.vcl_asset
    ```

3. Apply the changes to your Fastly service:

    ```shell
    terraform apply
    ```

## Using a custom VCL asset (optional)

You can use your own VCL asset instead of downloading the official one: 

1. Place your custom asset in `<your_module_root>/assets/custom-asset.vcl`
2. In your `main.tf` file, add these 2 variables to the module configuration:

    ```diff
    module "fingerprint_fastly_vcl_integration" {
      # ...
    + download_asset = false
    + vcl_asset_name = "custom-asset.vcl"
    }
    ```

3. Run `terraform init`.
4. Run `terraform apply`.

## Examples

This repository also includes an example Terraform project. Use this example only as a reference, and make sure to follow best practices when provisioning Fastly services:

- [Minimal example](./examples/minimal/)

## How to update

The Terraform module does include any mechanism for automatic updates. To keep your integration up to date, please run `terraform apply` regularly.

## More resources

- [Documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration)

## License

This project is licensed under the MIT license. See the [LICENSE](/LICENSE) file for more info.

