// ============================================
// App Service Plan Module
// ============================================

targetScope = 'resourceGroup'

@description('Environment name')
param environment string

@description('Azure region')
param location string

@description('Project name')
param projectName string

@description('Resource tags')
param tags object

var appServicePlanName = 'asp-${projectName}-${environment}'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  tags: tags
  sku: {
    name: 'F1'      // Free tier - costs nothing
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 1
  }
  properties: {
    reserved: false  // false = Windows
  }
}

// ---- Outputs ----
output appServicePlanName string = appServicePlan.name
output appServicePlanId string = appServicePlan.id