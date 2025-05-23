# 📦 Fastly Fingerprint Integration Terraform Module

This Terraform module automates the setup of the Fingerprint Pro Fastly VCL integration. It retrieves the latest VCL template from GitHub, sets up the necessary Fastly service configuration, and manages secrets and paths via a Fastly Dictionary.

---

## 🚀 What It Does

- Downloads the latest Fingerprint Pro VCL integration release from GitHub
- Deploys a custom Fastly service with:
    - Your specified domain (and optional test domain)
    - Backend configuration for proxying to Fingerprint
    - Custom VCL logic
    - A dictionary with paths and secrets

---

## 🛠️ Prerequisites

- A [Fastly](https://fastly.com/) account and API key
- [Terraform](https://terraform.io/) installed on your machine
- A GitHub token if you want to increase GitHub API rate limits (not mandatory)
- [Fingerprint](https://dashboard.fingerprint.com) Proxy Secret Key 

---

## 📁 Files in This Module

- `main.tf`: Defines the Fastly service
- `variables.tf`: Input variables (edit via `terraform.tfvars`)
- `github.tf`: Downloads the latest VCL release from GitHub
- `terraform.tfvars.example`: Example input file (you’ll create your own)

---

## 🧾 Usage

### 1. Clone or Copy This Repository

```
git clone git@github.com:fingerprintjs/temp-fastly-vcl-terraform.git
cd temp-fastly-vcl-terraform
```

### 2. Create Your `terraform.tfvars`

Copy and edit the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

Fill in the required variables such as `fastly_api_key`, `integration_domain`, and `main_host`.

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted.

---

## 🔐 What It Stores in Fastly Dictionary

| Key                          | Description                            |
|------------------------------|----------------------------------------|
| `PROXY_SECRET`               | Shared secret for verifying requests   |
| `INTEGRATION_PATH`           | Path prefix used for the integration   |
| `AGENT_SCRIPT_DOWNLOAD_PATH` | Path to serve the agent script     |
| `GET_RESULT_PATH`            | Path to fetch the identification result|

---

## 🧽 Cleanup

To remove everything that was created:

```bash
terraform destroy
```

---
