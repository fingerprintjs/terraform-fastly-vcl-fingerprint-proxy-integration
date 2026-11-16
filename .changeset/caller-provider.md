---
"terraform-fastly-vcl-fingerprint-proxy-integration": major
---

The module no longer configures the `fastly` provider, so it can be used with `count`, `for_each` and `depends_on`. Configure `provider "fastly"` in your own configuration and remove `fastly_api_token` from the module block.
