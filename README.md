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
2. Configure it with your Fingerprint proxy secret, integration domain, and other required values.
3. The module uses the `fastly` provider from your configuration, so configure the provider with your Fastly API token.

```terraform
terraform {
  required_version = ">=1.5"
  required_providers {
    fastly = {
      source  = "fastly/fastly"
      version = ">= 7.0.0"
    }
  }
}

provider "fastly" {
  # To use the FASTLY_API_KEY environment variable instead, leave out api_key.
  # When api_key is set, the provider ignores FASTLY_API_KEY.
  api_key = "FASTLY_API_TOKEN"
}

module "fingerprint_fastly_vcl_integration" {
  source                     = "fingerprintjs/vcl-fingerprint-proxy-integration/fastly"
  version                    = "~> 3.0"
  proxy_secret               = "FINGERPRINT_PROXY_SECRET"
  integration_path           = "INTEGRATION_PATH"
  integration_domain         = "metrics.yourwebsite.com"
  main_host                  = "yourwebsite.com"
}
```

You can see the full list of the Terraform module's variables below:

| Variable                         | Description                                                                                                                                                                                   | Required | Example                                        |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|------------------------------------------------|
| `proxy_secret`                   | Your Fingerprint proxy secret                                                                                                                                                                 | Required | `"9h7jk2s1"`                                   |
| `integration_path`               | Path prefix for proxy requests                                                                                                                                                                | Required | `"kyfy7t0a"`                                   |
| `integration_domain`             | Domain used for the proxy integration                                                                                                                                                         | Required | `"metrics.yourwebsite.com"`                    |
| `main_host`                      | Your origin server domain                                                                                                                                                                     | Required | `"yourwebsite.com"`                            |
| `agent_script_download_path`     | Path for serving the JavaScript agent (API v3 Only)                                                                                                                                           | Optional | `"cc7bu2o8"`                                   |
| `get_result_path`                | Path for identification requests (API v3 Only)                                                                                                                                                | Optional | `"sy5k3279"`                                   |
| `dictionary_name`                | Name of the Fastly Dictionary for config values                                                                                                                                               | Optional | `"fingerprint_config"`                         |
| `integration_name`               | Name of the Fastly CDN service                                                                                                                                                                | Optional | `"fingerprint-fastly-vcl-proxy-integration"`   |
| `vcl_asset_name`                 | Name of the VCL asset in the GitHub release, also used as the VCL name in the Fastly service                                                                                                  | Optional | `"fingerprint-pro-fastly-vcl-integration.vcl"` |
| `asset_version`                  | `"latest"` for the newest v2.x.y release of the VCL template, or a v2 release tag to pin                                                                                                      | Optional | `"v2.1.2"`                                     |
| `custom_vcl`                     | Your own VCL template, for example `{ content = file("custom.vcl") }`. When set, the module doesn't download the official template                                                            | Optional | `null`                                         |
| `github_token`                   | Optional GitHub token for listing the VCL template releases, so plans don't hit the limit of 60 requests per hour per IP. Needs no scopes                                                     | Optional | `"ghp_..."`                                    |
| `manage_fastly_dictionary_items` | Manage Fastly Dictionary items via terraform, see [Fastly documentation](https://registry.terraform.io/providers/fastly/fastly/latest/docs/resources/service_dictionary_items#manage_items-1) | Optional | `false`                                        |
| `force_destroy`                  | Let Terraform delete the Fastly service while it is active. Set to `false` to protect the service from being deleted                                                                          | Optional | `true`                                         |

The module has these outputs:

| Output               | Description                                                                                         |
|----------------------|-----------------------------------------------------------------------------------------------------|
| `service_id`         | ID of the Fastly CDN service                                                                        |
| `service_name`       | Name of the Fastly CDN service                                                                      |
| `active_version`     | Active version of the Fastly CDN service                                                            |
| `dictionary_id`      | ID of the Fastly dictionary that holds the integration config                                       |
| `vcl_version`        | Release tag of the downloaded VCL template, for example `v2.1.2`. Null when `custom_vcl` is set     |
| `integration_domain` | Domain of the integration, read from the service                                                    |
| `integration_url`    | Integration URL for the JavaScript agent `endpoints` option. Add `?region=REGION` to it             |

## 2. Deploy your Terraform changes

1. Initialize the Terraform module:
   
    ```shell
    terraform init
    ```

2. Apply the changes to your Fastly service:

    ```shell
    terraform apply
    ```

## Using a custom VCL asset (optional)

You can use your own VCL asset instead of downloading the official one. Pass its content in `custom_vcl`:

```diff
module "fingerprint_fastly_vcl_integration" {
  # ...
+ custom_vcl = { content = file("${path.module}/custom-asset.vcl") }
}
```

Then run `terraform apply`.

## Examples

This repository also includes an example Terraform project. Use this example only as a reference, and make sure to follow best practices when provisioning Fastly services:

- [Minimal example](./examples/minimal/)
- [Several integrations with `for_each`](./examples/multiple/)

## How to update

To keep your integration up to date, run `terraform apply` regularly:

* With `asset_version = "latest"` (the default), each plan checks the [VCL template releases](https://github.com/fingerprintjs/fastly-vcl-proxy/releases) and updates your service to the newest v2.x.y release.
* The module never moves to a new major version of the VCL template. That needs a new major version of this module.
* Keep the module pinned to one major version, for example `version = "~> 3.0"`, so you move to a new major version only when you change the pin.
* To stay on one release, set `asset_version` to its tag, for example `"v2.1.2"`.

### Upgrading from v2 to v3

v3 no longer configures the `fastly` provider itself. This lets you use the module with `count`, `for_each` and `depends_on`.

1. Add a `provider "fastly"` block with your Fastly API token to your configuration, as shown in [Install the Terraform module](#1-install-the-terraform-module).
2. Remove `fastly_api_token` from the module block.
3. Remove `download_asset` from the module block if you set it, with any value. If it was `false`, pass your VCL file with `custom_vcl = { content = file("PATH_TO_YOUR_VCL_FILE") }` instead.
4. If you set `asset_version`, use `"latest"` or a v2.x.y release tag. Other values are rejected.
5. Run `terraform init -upgrade`, then `terraform plan`.

The plan destroys `module.vcl_asset[0].null_resource.download_asset`, which only ran the old download script. It doesn't touch Fastly.
v2 of the module downloaded the VCL template only once, so the plan may also update the VCL in your Fastly service to the newest v2.x.y release.

## More resources

- [Documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration)

## License

This project is licensed under the MIT license. See the [LICENSE](/LICENSE) file for more info.

