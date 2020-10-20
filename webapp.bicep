param webAppName string
param location string = resourceGroup().location

param acrName string
param dockerUsername string
param dockerPassword string
param dockerImageAndTag string

resource site 'microsoft.web/sites@2020-06-01' = {
  name: '${webAppName}-site'
  location: location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${acrName}.azurecr.io' 
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: dockerUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: dockerPassword
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false' // swagger issue
        }
      ]
      linuxFxVersion: 'DOCKER|${acrName}.azurecr.io/${dockerImageAndTag}'
    }
    serverFarmId: farm.id
  }
}

resource farm 'microsoft.web/serverFarms@2020-06-01' = {
  name: webAppName
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  kind: 'linux' // if kind=app -> windows
  properties: {
    targetWorkerSizeId: 0
    targetWorkerCount: 1
    reserved: true
  }
}

output websiteId string = site.id

