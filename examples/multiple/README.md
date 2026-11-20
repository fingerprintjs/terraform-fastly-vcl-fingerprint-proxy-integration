## Example with several Fingerprint Fastly VCL Proxy Integrations

This example deploys one integration per entry in `integrations` with `for_each`, and prints the integration URLs from the module outputs.
`count` and `depends_on` work on the module the same way.

Learn more in the [Fastly VCL Proxy Terraform installation guide](https://docs.fingerprint.com/docs/deploy-fastly-vcl-using-terraform).

### Running the example

1. Copy [terraform.tfvars.example](./terraform.tfvars.example) into a new `terraform.tfvars` file and replace the values with your own.
    ```shell
    cd examples/multiple && cp terraform.tfvars.example terraform.tfvars
    ```
2. Set the `FASTLY_API_KEY` environment variable to your Fastly API token.
3. Run `terraform init`
4. Run `terraform apply`

To remove the integrations, run `terraform destroy`.

### Using in production

This is a simplified example. Use it as a reference but make sure to **adjust the code to your needs and security practices** before deploying it to production environments.
