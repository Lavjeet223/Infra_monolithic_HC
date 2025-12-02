# Infra_monolithic_HC
Monolithic Terraform-based Azure infrastructure (no Key Vault) // Tested and Verified

This repository defines a small, modular Terraform layout for deploying a monolithic Azure environment. The design uses simple, reusable modules (ResourceGroups, Networking, LinuxVirtualMachine, Database) wired together from the root `Infra/` configuration.

## Quick summary
- Cloud: Microsoft Azure (provider = azurerm)
- Modules: ResourceGroup, Networking, LinuxVirtualMachine, Database
- Root entrypoint: `Infra/main.tf` — wire-up of modules using map/object variables

## Repository layout

```
Infra/
	main.tf          # root composition of modules
	provider.tf
	variables.tf
	terraform.tfvars # example values used in this repo (contains actual secrets in this copy)

modules/
	ResourceGroup/
	Networking/
	LinuxVirtualMachine/
	Database/

scripts/ (referenced by VMs but not present in this repo)
```

## Big‑picture architecture
- Root `Infra/main.tf` wires up four modules in a monolithic deployment: resource groups, virtual networks + subnets, Linux VMs, and Azure SQL (MSSQL) servers/databases.
- Modules are intentionally parameterized using maps / nested objects: each module iterates using `for_each` over input maps supplied from `terraform.tfvars`.
- Networking module creates VNets and subnets and optionally configures Azure Bastion when `enable_bastion` is set to true.
- Linux VM module expects user-data scripts to live under `scripts/` and conditionally attaches public IPs based on each VM's `enable_public_ip` flag.

## Key files to inspect
- `Infra/main.tf` — shows module composition and dependency order
- `Infra/terraform.tfvars` — concrete example values and the canonical pattern for inputs (maps keyed by names)
- `modules/*/main.tf` — module implementation using `for_each` and outputs

## How to deploy (local)
1. Install Terraform (compatible with azurerm >= 4.3.0)
2. Authenticate to Azure (Azure CLI recommended):

```pwsh
az login
az account set --subscription <YOUR_SUBSCRIPTION_ID>
```

3. From the `Infra/` directory run:

```pwsh
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

4. To teardown:

```pwsh
terraform destroy -var-file=terraform.tfvars
```

Note: Provider credentials in `Infra/provider.tf` are commented out — this repo expects either Azure CLI auth or environment / service principal credentials.

## Variable & module conventions (observed patterns)
- Inputs are maps keyed by resource logical names (e.g. `rgs`, `vnets_subnets`, `vms`, `servers_dbs`). See `Infra/terraform.tfvars` for concrete examples.
- VM user-data scripts are referenced relative to the module: `path.module/../../scripts/<script>` (the `scripts/` folder is referenced by the TF vars but not included in this repo snapshot).
- Modules expose useful outputs (e.g. `Networking` → `vnet_subnet_ids`, VMs → `vm_public_ips`) which root code consumes.

## Project-specific gotchas & notes
- `terraform.tfvars` currently contains passwords and secrets in plain text (this is present in the current copy of the repo). If you share or commit, move secrets to a secure store (Key Vault, environment variables, or CI secrets).
- The repository is a single monolithic deployment (all resources are orchestrated together). For large environments, consider splitting state and workspaces.

## Next steps / missing items discovered
- `scripts/` referenced by the VM module (for `install_nginx.sh`, `install_python.sh`) are not in the repo — add these scripts or update `terraform.tfvars` to point to valid script files.
- There are no CI/CD or GitHub Actions workflows included — if you want automated plans/applies, add a pipeline that runs `terraform init/plan` and uses secure state backends.

---

If you want I can also add a short CONTRIBUTING section, an example `scripts/` folder, or generate a CI job (GitHub Actions) for terraform plan and validation.




