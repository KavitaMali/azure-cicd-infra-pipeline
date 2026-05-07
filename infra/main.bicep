// ============================================
// Main Bicep Entry Point
// Azure CI/CD Infrastructure Pipeline - Project 1
// ============================================

targetScope = 'subscription'

// ---- Parameters ----
@description('Environment name - dev, staging, prod')
@allowed(['dev', 'staging', 'prod'])
param environment string = 'dev'

@description('Azure region for all resources')
param location string = 'westindia'

@description('Project name used in resource naming')
param projectName string = 'cicdinfra'

// ---- Variables ----
var resourceGroupName = 'rg-${projectName}-${environment}'
var tags = {
  Environment: environment
  Project: projectName
  ManagedBy: 'Bicep'
  CreatedBy: 'AzureDevOps'
}

// ---- Resource Group ----
resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ---- Storage Account Module ----
module storage './modules/storage.bicep' = {
  name: 'storageDeployment'
  scope: rg
  params: {
    environment: environment
    location: location
    projectName: projectName
    tags: tags
  }
}

// ---- App Service Plan Module ----
module appServicePlan './modules/appserviceplan.bicep' = {
  name: 'appServicePlanDeployment'
  scope: rg
  params: {
    environment: environment
    location: location
    projectName: projectName
    tags: tags
  }
}

// ---- Outputs ----
output resourceGroupName string = rg.name
output storageAccountName string = storage.outputs.storageAccountName
output appServicePlanName string = appServicePlan.outputs.appServicePlanName