param acrPassword string {
  secure: true
}
param sqlServerPassword string {
  secure: true
}
param location string = resourceGroup().location
param webAppName string = 'lfa'

module appService './webapp.bicep' = {
  name: 'lfadeploy'
  params: {
    webAppName: webAppName
    acrName: 'lawrencefarmsantiques'
    dockerImageAndTag: 'lfa/frontend:latest'
    dockerUsername: 'lfaAdmin'
    dockerPassword: acrPassword
  }
}

module datatier './datatier.bicep' = {
  name: 'datadeploy'
  params: {
    dbName: 'db'
    serverName: 'lfa'
    username: 'adminUser'
    password: sqlServerPassword
  }
}

output siteId string = appService.outputs.websiteId