{
  apiVersion: 'external-secrets.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'pgpass-secret',
  },
  spec: {
    refreshInterval: '1h',
    secretStoreRef: {
      name: 'gsm',
      kind: 'SecretStore',
    },
    target: {
      name: 'pgpass-secret',
      template: {
        type: 'Opaque',
        data: {
          '.pgpass': '<DB_HOST>:5432:<DB_NAME>:<DB_USER>:{{ .password }}\n',
        },
      },
    },
    data: [
      {
        secretKey: 'password',
        remoteRef: {
          key: 'nibas-prod-read-password',
          metadataPolicy: 'None',
        },
      },
    ],
  },
}
