## Main example for Fingerprint Fastly VCL Proxy Integration

This project is an example of how to create a Fastly VCL service for the [Fingerprint Fastly VCL proxy integration Terraform module](https://github.com/fingerprintjs/terraform-fastly-fingerprint-vcl-proxy-integration).
Learn more in the [Fastly VCL Proxy Terraform installation guide](https://dev.fingerprint.com/docs/deploy-fastly-vcl-using-terraform).

### Running the example

To quickly run the example for testing purposes, you can:

1. Copy the [terraform.tfvars.example](./terraform.tfvars.example) file into a new `terraform.tfvars` file and replace the values with your own. The variables are defined and described in the [variables.tf](./variables.tf) file.
2. Copy your Fastly API token
3. Run `terraform init`.
4. Run `terraform apply -target=module.fingerprint_fastly_vcl_integration.module.compute_asset`
5. Run `terraform plan`.
6. Run `terraform apply`.

### Using in production

This is a simplified example. Use it as a reference but make sure to **adjust the code to your needs and security practices** before deploying it to production environments.

### Additional resources

- [Fingerprint Fastly VCL Proxy Integration documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration)
