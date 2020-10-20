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
    serverName: 'lfaserver'
    username: 'adminuser'
    password: sqlServerPassword
    dbName: 'lfadb'
  }
}

var principal = '5f1ed457-d451-4f9b-9e0d-eeca89bd066c'
var contributorRole = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
// add user as contributor to this resource group
resource rbac 'microsoft.authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id)
  properties: {
    principalId: principal
    roleDefinitionId: contributorRole
  }
}

output siteId string = appService.outputs.websiteId