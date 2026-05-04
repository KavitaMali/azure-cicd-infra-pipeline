# Azure CI/CD Infrastructure Pipeline

![Azure DevOps](https://img.shields.io/badge/Azure%20DevOps-Pipeline-blue)
![Bicep](https://img.shields.io/badge/IaC-Bicep-orange)
![Status](https://img.shields.io/badge/Status-Active-green)

## Overview
This project demonstrates a full CI/CD Infrastructure Pipeline using
Azure DevOps and Bicep (Infrastructure as Code). The pipeline
automatically validates, previews, and deploys Azure resources
on every commit to main.

## Architecture
```
GitHub Push → Azure DevOps Pipeline
                    │
                    ├── Stage 1: Validate (Lint + Build Bicep)
                    ├── Stage 2: Plan    (What-If preview)
                    └── Stage 3: Deploy  (Actual deployment)
                                │
                                └── Azure Subscription
                                        ├── Resource Group
                                        ├── Storage Account
                                        └── App Service Plan
```

## Resources Deployed
| Resource | Name Pattern | Tier |
|---|---|---|
| Resource Group | rg-cicdinfra-dev | N/A |
| Storage Account | stcicdinfradev[unique] | Standard_LRS |
| App Service Plan | asp-cicdinfra-dev | F1 (Free) |

## Pipeline Stages
- **Validate** — Bicep lint + compile, runs on every PR and push
- **Plan** — What-If analysis shows changes before applying
- **Deploy Dev** — Deploys to dev, runs only on main branch

## How to Run Locally
```powershell
# Validate before pushing
.\scripts\validate.ps1

# Manual deploy (optional)
az deployment sub create \
  --location centralindia \
  --template-file infra/main.bicep \
  --parameters infra/main.parameters.json
```

## Technologies Used
- Azure DevOps Pipelines
- Azure Bicep (IaC)
- Azure CLI
- Azure Resource Manager

## Project Series
This is **Project 1 of 8** in my Azure Portfolio.e
