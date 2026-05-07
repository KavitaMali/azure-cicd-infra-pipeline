// ============================================
// Storage Account Module
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

// Storage account name must be lowercase, 3-24 chars, globally unique
var storageAccountName = 'st${projectName}${environment}${uniqueString(resourceGroup().id)}'
var shortName = length(storageAccountName) > 24 
  ? substring(storageAccountName, 0, 24) 
  : storageAccountName

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: shortName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'   // Cheapest - perfect for free tier
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false  // Security best practice
    minimumTlsVersion: 'TLS1_2'  // Security best practice
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// ---- Outputs ----
output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob