param webAppNamePrefix string = 'wapp' // Prefix for the web app name
param sku string = 'B1' // The SKU of App Service Plan
param linuxFxVersion string = 'php|7.4' // The runtime stack of web app
param location string = resourceGroup().location // Location for all resources

var webAppNameSuffix = uniqueString(resourceGroup().id, deployment().name) // Generate unique string with deployment name
var webAppName = toLower('${webAppNamePrefix}-${webAppNameSuffix}')
var appServicePlanName = toLower('appserviceplan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webAppName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}
