{
  apiVersion: 'external-secrets.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'aal-register-secret',
  },
  spec: {
    data: [
      {
        remoteRef: {
          key: 'DATASOURCE_PASSWORD',
          metadataPolicy: 'None'
        },
        secretKey: 'SPRING_DATASOURCE_PASSWORD',
      },
      {
        remoteRef: {
          key: 'DATASOURCE_USERNAME',
          metadataPolicy: 'None'
        },
        secretKey: 'SPRING_DATASOURCE_USERNAME',
      },
      {
        remoteRef: {
          key: 'AGRESSO_USERNAME',
          metadataPolicy: 'None'
        },
        secretKey: 'AGRESSO_USERNAME',
      },
      {
        remoteRef: {
          key: 'AGRESSO_PASSWORD',
          metadataPolicy: 'None'
        },
        secretKey: 'AGRESSO_PASSWORD',
      },
    ],
    refreshInterval: '1h',
    secretStoreRef: {
      kind: 'SecretStore',
      name: 'gsm',
    },
    target: {
      name: 'aal-register-secret',
    },
  },
}
