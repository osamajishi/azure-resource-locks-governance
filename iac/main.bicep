param virtualMachines_vm1_name string = 'vm1'
param networkInterfaces_vm1338_name string = 'vm1338'
param publicIPAddresses_vm1_ip_name string = 'vm1-ip'
param networkSecurityGroups_vm1_nsg_name string = 'vm1-nsg'
param virtualNetworks_vnet_eastus_1_name string = 'vnet-eastus-1'

resource networkSecurityGroups_vm1_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_vm1_nsg_name
  location: 'eastus'
  properties: {
    securityRules: [
      {
        name: 'SSH'
        id: networkSecurityGroups_vm1_nsg_name_SSH.id
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_vm1_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_vm1_ip_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.163.184.10'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnet_eastus_1_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet_eastus_1_name
  location: 'eastus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-eastus-1'
        id: virtualNetworks_vnet_eastus_1_name_snet_eastus_1.id
        properties: {
          addressPrefixes: [
            '172.16.0.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualMachines_vm1_name_resource 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: virtualMachines_vm1_name
  location: 'eastus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_vm1_name}_disk1_55624472618341f28898eb8091954c26'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_vm1_name}_disk1_55624472618341f28898eb8091954c26'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_vm1_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm1338_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource networkSecurityGroups_vm1_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_vm1_nsg_name}/SSH'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_vm1_nsg_name_resource
  ]
}

resource virtualNetworks_vnet_eastus_1_name_snet_eastus_1 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet_eastus_1_name}/snet-eastus-1'
  properties: {
    addressPrefixes: [
      '172.16.0.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_eastus_1_name_resource
  ]
}

resource networkInterfaces_vm1338_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vm1338_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm1338_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '172.16.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_vm1_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_vnet_eastus_1_name_snet_eastus_1.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_vm1_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

// ============================================================================
// GOVERNANCE & RESOURCE LOCKS
// ============================================================================

// 1. CanNotDelete Lock applied directly to the Virtual Machine
resource vmCanNotDeleteLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: '${virtualMachines_vm1_name}-prevent-deletion'
  scope: virtualMachines_vm1_name_resource
  properties: {
    level: 'CanNotDelete'
    notes: 'Workload Protection: Explicitly blocks deletion of the production VM.'
  }
}

// 2. ReadOnly Lock applied at the Resource Group scope
// (Omitting the "scope" parameter automatically applies the lock to the parent Resource Group)
resource rgReadOnlyLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'Resource Read'
  properties: {
    level: 'ReadOnly'
    notes: 'Environment Freeze: Inherits down to all resources to prevent configuration changes and deletions.'
  }
}
