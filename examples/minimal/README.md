## Minimal example for Fingerprint Fastly VCL Proxy Integration

This is an example Terraform project using [Fingerprint Fastly VCL proxy integration Terraform module](https://github.com/fingerprintjs/terraform-fastly-fingerprint-vcl-proxy-integration).
Learn more in the [Fastly VCL Proxy Terraform installation guide](https://dev.fingerprint.com/docs/deploy-fastly-vcl-using-terraform).

### Running the example

To quickly run the example for testing purposes, you can:

1. Copy the [terraform.tfvars.example](./terraform.tfvars.example) file into a new `terraform.tfvars` file and replace the values with your own. 
    ```shell 
    cd examples/minimal && cp terraform.tfvars.example terraform.tfvars
    ```
    The variables are defined and described in the [variables.tf](./variables.tf).
2. Run `terraform init`
3. Run `terraform apply -target=module.fingerprint_fastly_vcl_integration.module.vcl_asset`
4. Run `terraform plan`
5. Run `terraform apply`

### Using in production

This is a simplified example. Use it as a reference but make sure to **adjust the code to your needs and security practices** before deploying it to production environments.

### Additional resources

- [Fingerprint Fastly VCL Proxy Integration documentation](https://dev.fingerprint.com/docs/fastly-vcl-proxy-integration)
