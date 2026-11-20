---
"terraform-fastly-vcl-fingerprint-proxy-integration": major
---

The module now downloads the VCL template with the `hashicorp/http` provider, so `terraform apply` picks up new template releases. It only uses v2.x.y releases of the template, so a future v3 template is never applied by this major version. `asset_version` accepts `"latest"` or a v2.x.y tag. Replace `download_asset = false` with the new `custom_vcl` variable. The `terraform apply -target` step and the `integrations/github` provider are no longer needed.
