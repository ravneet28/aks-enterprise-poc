targetScope = 'resourceGroup'

@description('Azure region for all resources. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Globally unique storage account name. Must be 3-24 lowercase letters and numbers.')
@minLength(3)
@maxLength(24)
param storageAccountName string

@description('Storage account SKU. Use Standard_ZRS where the region supports it; use Standard_GRS or Standard_RAGRS when cross-region resiliency is required.')
@allowed([
  'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param skuName string = 'Standard_ZRS'

@description('Storage account kind. StorageV2 is recommended for Terraform remote state.')
@allowed([
  'StorageV2'
  'BlockBlobStorage'
])
param kind string = 'StorageV2'

@description('Access tier for blob data.')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Blob container used by Terraform remote state.')
@minLength(3)
@maxLength(63)
param tfStateContainerName string = 'tfstate'

@description('Additional private blob containers to create.')
param additionalContainerNames array = []

@description('Terraform state blob names used as backend keys. Terraform creates and updates these blobs during init/plan/apply.')
param tfStateBlobNames array = [
  'platform-management.tfstate'
  'platform-connectivity.tfstate'
  'aks.tfstate'
]

@description('Resource tags.')
param tags object = {}

@description('Allow public network access to the storage account. Set to Disabled when using private endpoints only.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Default network action. Deny is production-safe, but requires allowed IPs, VNet rules, private endpoints, or trusted Azure services.')
@allowed([
  'Allow'
  'Deny'
])
param networkDefaultAction string = 'Deny'

@description('Azure service bypass setting for storage firewall.')
@allowed([
  'None'
  'AzureServices'
  'Logging'
  'Metrics'
  'Logging, Metrics'
  'Logging, Metrics, AzureServices'
])
param networkBypass string = 'AzureServices'

@description('Public IPv4 CIDR ranges allowed through the storage firewall. Example: ["203.0.113.10"].')
param allowedIpRules array = []

@description('Subnet resource IDs allowed through the storage firewall. Microsoft.Storage service endpoint should be enabled on these subnets.')
param allowedSubnetIds array = []

@description('Allow shared key authorization. Prefer false when Terraform and operators use Microsoft Entra ID authentication.')
param allowSharedKeyAccess bool = false

@description('Set OAuth as the default authentication mode in supported clients.')
param defaultToOAuthAuthentication bool = true

@description('Allow blob anonymous/public access. Keep false for Terraform state.')
param allowBlobPublicAccess bool = false

@description('Allow cross-tenant object replication. Keep false unless explicitly required.')
param allowCrossTenantReplication bool = false

@description('Minimum TLS version.')
@allowed([
  'TLS1_2'
  'TLS1_3'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Enable blob versioning for state recovery.')
param enableBlobVersioning bool = true

@description('Enable blob change feed for auditing and recovery.')
param enableChangeFeed bool = true

@description('Blob soft delete retention in days. Set to 0 to disable.')
@minValue(0)
@maxValue(365)
param blobDeleteRetentionDays int = 30

@description('Container soft delete retention in days. Set to 0 to disable.')
@minValue(0)
@maxValue(365)
param containerDeleteRetentionDays int = 30

@description('Automatically delete old blob versions after this many days. Set to 0 to disable the lifecycle rule.')
@minValue(0)
@maxValue(3650)
param deleteVersionsAfterDays int = 90

@description('Infrastructure encryption for storage account data.')
param requireInfrastructureEncryption bool = true

@description('Enable customer-managed keys. If true, keyVaultUri, keyVaultKeyName, and customerManagedKeyIdentityResourceId must be set.')
param enableCustomerManagedKey bool = false

@description('Key Vault URI for customer-managed keys. Example: https://kv-name.vault.azure.net/')
param keyVaultUri string = ''

@description('Key Vault key name for customer-managed keys. Required when enableCustomerManagedKey is true.')
param keyVaultKeyName string = ''

@description('Key Vault key version for customer-managed keys. Leave empty to use the current version.')
param keyVaultKeyVersion string = ''

@description('User-assigned managed identity resource ID used for customer-managed key access. Required when enableCustomerManagedKey is true. The identity must have access to the Key Vault key.')
param customerManagedKeyIdentityResourceId string = ''

@description('Deploy a private endpoint for the blob service.')
param enablePrivateEndpoint bool = false

@description('Subnet resource ID for the private endpoint. Required when enablePrivateEndpoint is true.')
param privateEndpointSubnetId string = ''

@description('Private endpoint name. Defaults to pe-<storageAccountName>-blob.')
param privateEndpointName string = 'pe-${storageAccountName}-blob'

@description('Private DNS zone resource ID for privatelink.blob.core.windows.net. Leave empty to skip DNS zone group creation.')
param privateDnsZoneId string = ''

@description('Enable diagnostic settings for the storage account control plane.')
param enableDiagnostics bool = false

@description('Log Analytics workspace resource ID for diagnostic settings. Required when enableDiagnostics is true.')
param logAnalyticsWorkspaceId string = ''

@description('Diagnostic setting name.')
param diagnosticSettingName string = 'diag-${storageAccountName}'

var normalizedAllowedIpRules = [
  for ipRule in allowedIpRules: {
    action: 'Allow'
    value: ipRule
  }
]

var normalizedAllowedSubnetRules = [
  for subnetId in allowedSubnetIds: {
    action: 'Allow'
    id: subnetId
  }
]

var containerNames = union([
  tfStateContainerName
], additionalContainerNames)

var storageIdentityType = enableCustomerManagedKey ? 'SystemAssigned, UserAssigned' : 'SystemAssigned'
var storageUserAssignedIdentities = enableCustomerManagedKey ? {
  '${customerManagedKeyIdentityResourceId}': {}
} : {}
var storageIdentity = enableCustomerManagedKey ? {
  type: storageIdentityType
  userAssignedIdentities: storageUserAssignedIdentities
} : {
  type: storageIdentityType
}
var blobDeleteRetentionPolicy = blobDeleteRetentionDays > 0 ? {
  enabled: true
  days: max(blobDeleteRetentionDays, 1)
} : {
  enabled: false
}
var containerDeleteRetentionPolicy = containerDeleteRetentionDays > 0 ? {
  enabled: true
  days: max(containerDeleteRetentionDays, 1)
} : {
  enabled: false
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: kind
  sku: {
    name: skuName
  }
  identity: storageIdentity
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowCrossTenantReplication: allowCrossTenantReplication
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: true
    encryption: {
      keySource: enableCustomerManagedKey ? 'Microsoft.Keyvault' : 'Microsoft.Storage'
      requireInfrastructureEncryption: requireInfrastructureEncryption
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
      }
      keyvaultproperties: enableCustomerManagedKey ? {
        keyvaulturi: keyVaultUri
        keyname: keyVaultKeyName
        keyversion: keyVaultKeyVersion
      } : null
      identity: enableCustomerManagedKey ? {
        userAssignedIdentity: customerManagedKeyIdentityResourceId
      } : null
    }
    networkAcls: {
      bypass: networkBypass
      defaultAction: networkDefaultAction
      ipRules: normalizedAllowedIpRules
      virtualNetworkRules: normalizedAllowedSubnetRules
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
  properties: {
    changeFeed: {
      enabled: enableChangeFeed
    }
    deleteRetentionPolicy: blobDeleteRetentionPolicy
    containerDeleteRetentionPolicy: containerDeleteRetentionPolicy
    isVersioningEnabled: enableBlobVersioning
    restorePolicy: {
      enabled: false
    }
  }
}

resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = [
  for containerName in containerNames: {
    parent: blobService
    name: containerName
    properties: {
      publicAccess: 'None'
      immutableStorageWithVersioning: {
        enabled: false
      }
    }
  }
]

resource lifecyclePolicy 'Microsoft.Storage/storageAccounts/managementPolicies@2023-05-01' = if (deleteVersionsAfterDays > 0) {
  parent: storageAccount
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          name: 'delete-old-versions'
          enabled: true
          type: 'Lifecycle'
          definition: {
            actions: {
              version: {
                delete: {
                  daysAfterCreationGreaterThan: deleteVersionsAfterDays
                }
              }
            }
            filters: {
              blobTypes: [
                'blockBlob'
              ]
            }
          }
        }
      ]
    }
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = if (enablePrivateEndpoint) {
  name: privateEndpointName
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${privateEndpointName}-connection'
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = if (enablePrivateEndpoint && !empty(privateDnsZoneId)) {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

resource storageDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics) {
  name: diagnosticSettingName
  scope: storageAccount
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

resource blobDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics) {
  name: '${diagnosticSettingName}-blob'
  scope: blobService
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'StorageRead'
        enabled: true
      }
      {
        category: 'StorageWrite'
        enabled: true
      }
      {
        category: 'StorageDelete'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output primaryBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
output containerNames array = containerNames
output tfStateContainerName string = tfStateContainerName
output tfStateBlobNames array = tfStateBlobNames
output terraformBackendConfig object = {
  resource_group_name: resourceGroup().name
  storage_account_name: storageAccount.name
  container_name: tfStateContainerName
}
output terraformBackendConfigs array = [
  for stateBlobName in tfStateBlobNames: {
    resource_group_name: resourceGroup().name
    storage_account_name: storageAccount.name
    container_name: tfStateContainerName
    key: stateBlobName
  }
]
output platformManagementBackendConfig object = {
  resource_group_name: resourceGroup().name
  storage_account_name: storageAccount.name
  container_name: tfStateContainerName
  key: 'platform-management.tfstate'
}
output platformConnectivityBackendConfig object = {
  resource_group_name: resourceGroup().name
  storage_account_name: storageAccount.name
  container_name: tfStateContainerName
  key: 'platform-connectivity.tfstate'
}
output aksBackendConfig object = {
  resource_group_name: resourceGroup().name
  storage_account_name: storageAccount.name
  container_name: tfStateContainerName
  key: 'aks.tfstate'
}
