param location string = resourceGroup().location
param password string {
  secure: true
}

resource vnet 'microsoft.network/virtualNetworks@2020-06-01' = {
  name: 'vnet001'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet001'
        properties: {
          addressPrefix: '10.0.0.0/24'
        } 
      }
    ]
  }
}

module vm './vm-linux.bicep' = {
  name: 'vmDeploy'
  params: {
    vmName: 'xwing'
    adminUsername: 'luke'
    authenticationType: 'password'
    adminPasswordOrKey: password
    virtualNetworkName: vnet.name
    subnetName: vnet.properties.subnets[0].name
  }
}