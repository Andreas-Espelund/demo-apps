function(
  env,
  name='regelrett-backend',
  version,
  clientId,
  gsmProjectId,
  secretStoreName='<SECRET_STORE_NAME>',
  esoName='regelrett-backend-secrets',
  cloudSqlConfig,
  dbUser
) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: name,
    },
    spec: {
      image: version,
      port: 8080,
      liveness: {
        path: '/health',
        port: 8080,
      },
      readiness: {
        path: '/health',
        port: 8080,
      },
      ingresses: ['api.regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>'],
      resources: {
        requests: {
          cpu: '25m',
          memory: '256Mi',
        },
      },
      gcp: {
        cloudSqlProxy: cloudSqlConfig,
      },
      envFrom: [
        {
          secret: esoName,
        },
      ],
      env: [
        {
          name: 'FRONTEND_URL_HOST',
          value: 'regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'TENANT_ID',
          value: '<TENANT_ID>',
        },
        {
          name: 'CLIENT_ID',
          value: clientId,
        },
        {
          name: 'AUTH_PROVIDER_URL',
          value: 'https://api.regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>/callback',
        },
        {
          name: 'DB_NAME',
          value: dbUser,
        },
        {
          name: 'DB_PASSWORD',
          value: '',
        },
        {
          name: 'SUPER_USER_MAIL',
          value: '<SUPER_USER_EMAIL>',
        },
        {
          name: 'FRISK_FRONTEND_URL_HOST',
          value: 'https://frisk.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'RR_OAUTH_TENANT_ID',
          value: '<TENANT_ID>',
        },
        {
          name: 'RR_OAUTH_CLIENT_ID',
          value: clientId,
        },
        {
          name: 'RR_DATABASE_HOST',
          value: 'localhost:5432',
        },
        {
          name: 'RR_DATABASE_NAME',
          value: 'regelrett',
        },
        {
          name: 'RR_DATABASE_USER',
          value: dbUser,
        },
        {
          name: 'RR_DATABASE_PASSWORD',
          value: '',
        },
        {
          name: 'RR_SERVER_ALLOWED_ORIGINS',
          value: 'frisk.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>,regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
      ],
      accessPolicy: {
        inbound: {
          rules: [
            {
              application: 'regelrett-frontend',
            },
            {
              application: 'frisk-backend',
            },
          ],
        },
        outbound: {
          external: [
            {
              host: '<AIRTABLE_API_HOST>',
            },
            {
              host: '<MICROSOFT_LOGIN_HOST>',
            },
            {
              host: '<MICROSOFT_GRAPH_HOST>',
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: 'networking.istio.io/v1',
    kind: 'DestinationRule',
    metadata: {
      name: 'istio-sticky' + name,
    },
    spec: {
      host: name,
      trafficPolicy: {
        loadBalancer: {
          consistentHash: {
            httpCookie: {
              name: 'ISTIO-STICKY',
              path: '/',
              ttl: '0',
            },
          },
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
            key: 'regelrett-airtable-token',
            metadataPolicy: 'None',
          },
          secretKey: 'AIRTABLE_ACCESS_TOKEN',
        },
        {
          remoteRef: {
            key: 'regelrett-client-secret-backend',
            metadataPolicy: 'None',
          },
          secretKey: 'CLIENT_SECRET',
        },
        {
          remoteRef: {
            key: 'regelrett-sikkerhetskontroller-webhook-secret',
            metadataPolicy: 'None',
          },
          secretKey: 'SIKKERHETSKONTROLLER_WEBHOOK_SECRET',
        },
        {
          remoteRef: {
            key: 'regelrett-driftskontinuitet-webhook-secret',
            metadataPolicy: 'None',
          },
          secretKey: 'DRIFTSKONTINUITET_WEBHOOK_SECRET',
        },
        {
          remoteRef: {
            key: 'regelrett-sikkerhetskontroller-webhook-id',
            metadataPolicy: 'None',
          },
          secretKey: 'SIKKERHETSKONTROLLER_WEBHOOK_ID',
        },
        {
          remoteRef: {
            key: 'regelrett-driftskontinuitet-webhook-id',
            metadataPolicy: 'None',
          },
          secretKey: 'DRIFTSKONTINUITET_WEBHOOK_ID',
        },
        {
          remoteRef: {
            key: 'regelrett-superuser',
            metadataPolicy: 'None',
          },
          secretKey: 'SUPER_USER_GROUP_ID',
        },
        {
          remoteRef: {
            key: 'regelrett-airtable-token',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_SCHEMA_DRIFTSKONTINUITET_AIRTABLE_ACCESS_TOKEN',
        },
        {
          remoteRef: {
            key: 'regelrett-client-secret-backend',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_OAUTH_CLIENT_SECRET',
        },
        {
          remoteRef: {
            key: 'regelrett-superuser',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_OAUTH_SUPER_USER_GROUP',
        },
        {
          remoteRef: {
            key: 'regelrett-sikkerhetskontroller-webhook-secret',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_SCHEMA_SIKKERHETSKONTROLLER_WEBHOOK_SECRET',
        },
        {
          remoteRef: {
            key: 'regelrett-sikkerhetskontroller-webhook-id',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_SCHEMA_SIKKERHETSKONTROLLER_WEBHOOK_ID',
        },
        {
          remoteRef: {
            key: 'regelrett-driftskontinuitet-webhook-id',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_SCHEMA_DRIFTSKONTINUITET_WEBHOOK_SECRET',
        },
        {
          remoteRef: {
            key: 'regelrett-driftskontinuitet-webhook-id',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_SCHEMA_DRIFTSKONTINUITET_WEBHOOK_ID',
        },
        {
          remoteRef: {
            key: 'regelrett-airtable-token',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_SCHEMA_SIKKERHETSKONTROLLER_AIRTABLE_ACCESS_TOKEN',
        },
        {
          remoteRef: {
            key: 'regelrett-airtable-token',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_AIRTABLE_ACCESS_TOKEN',
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