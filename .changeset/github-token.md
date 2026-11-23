---
"terraform-fastly-vcl-fingerprint-proxy-integration": minor
---

Add the optional `github_token` variable. The module sends it when it lists the VCL template releases, so plans don't hit GitHub's limit of 60 unauthenticated requests per hour per IP.
