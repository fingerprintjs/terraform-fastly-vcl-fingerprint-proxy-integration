---
"terraform-fastly-vcl-fingerprint-proxy-integration": minor
---

Add the `force_destroy` variable. It defaults to `true`, the value the module used before. Set it to `false` to make `terraform destroy` fail before it deletes anything, so the service keeps running with its dictionary items.
