param sku string = 'B1' // The SKU of App Service Plan
param linuxFxVersion string = 'php|7.4' // The runtime stack of web app
param location string = resourceGroup().location // Location for all resources

param webAppName string = uniqueString(resourceGroup().id, deployment().name) // Generate unique String for web app name
var appServicePlanName = toLower('appserviceplan-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')

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
  name: webSiteName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}
