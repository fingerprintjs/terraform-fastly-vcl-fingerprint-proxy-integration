---
"terraform-fastly-vcl-fingerprint-proxy-integration": major
---

Introduce Fingerprint Fastly Proxy Integration v2.0 support

Docs:
- [Deploy Fastly VCL using Terraform for APIv4](https://docs.fingerprint.com/docs/deploy-fastly-vcl-using-terraform)

Notice:
Changes does not break your current deployments. The properties `agent_script_download_path` and `get_result_path` are now optional.
