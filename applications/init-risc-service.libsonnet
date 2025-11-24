function(
  env,
  name='init-risc-service',
  version,
  clientId,
  gsmProjectId,
  secretStoreName='<SECRET_STORE_NAME>',
  esoName='init-risc-secrets'
) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: name,
    },
    spec: {
      image: version,
      port: 8085,
      replicas: {
        min: 1,
        max: 2,
      },
      liveness: {
        path: '/health',
        port: 8085,
      },
      readiness: {
        path: '/health',
        port: 8085,
      },
      resources: {
        requests: {
          cpu: '25m',
          memory: '256Mi',
        },
      },
      envFrom: [
        {
          secret: esoName,
        },
      ],
      env: [
        {
          name: 'SIKKERHETSMETRIKKER_BASE_URL',
          value: 'http://sikkerhetsmetrikker.sikkerhetsmetrikker-main:8080',
        },
        {
          name: 'SIKKERHETSMETRIKKER_CLIENT_ID',
          value: if env == 'dev' then '<SIKKERHETSMETRIKKER_CLIENT_ID_DEV>' else if env == 'prod' then '<SIKKERHETSMETRIKKER_CLIENT_ID_PROD>',
        },
        {
          name: 'TENANT_ID',
          value: '<TENANT_ID>',
        },
        {
          name: 'CLIENT_ID',
          value: clientId,
        },
      ],
      accessPolicy: {
        inbound: {
          rules: [
            {
              application: 'ros-plugin-backend',
              namespace: 'ros-plugin-main',
            },
          ],
        },
        outbound: {
          rules: [
            {
              application: 'sikkerhetsmetrikker',
            },
          ],
          external: [
            {
              host: 'api.airtable.com',
            },
            {
              host: 'login.microsoftonline.com',
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'external-secrets.io/v1',
    kind: 'ExternalSecret',
    metadata: {
      name: esoName,
    },
    spec: {
      data: [
        {
          remoteRef: {
            key: 'init-risc-client-secret',
            metadataPolicy: 'None',
          },
          secretKey: 'CLIENT_SECRET',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-base-id',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_BASE_ID',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-api-token',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_API_TOKEN',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-record-id',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_RECORD_ID',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-table-id',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_TABLE_ID',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-record-id-ops',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_RECORD_ID_OPS',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-record-id-internal-job',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_RECORD_ID_INTERNAL_JOB',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-record-id-standard',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_RECORD_ID_STANDARD',
        },
        {
          remoteRef: {
            key: 'init-risc-airtable-record-id-begrenset',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_RECORD_ID_BEGRENSET',
        },
      ],
      refreshInterval: '1h',
      secretStoreRef: {
        kind: 'SecretStore',
        name: secretStoreName,
      },
      target: {
        name: esoName,
      },
    },
  },
  {
    apiVersion: 'external-secrets.io/v1',
    kind: 'SecretStore',
    metadata: {
      name: secretStoreName,
    },
    spec: {
      provider: {
        gcpsm: {
          projectID: gsmProjectId,
        },
      },
    },
  },
]