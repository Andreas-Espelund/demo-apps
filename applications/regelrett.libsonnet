function(
  env,
  name='regelrett-backend',
  version,
  gsmProjectId,
  secretStoreName='<SECRET_STORE_NAME>',
  esoName='regelrett-backend-secrets',
  kubernetesSecretEntraIdSecretName='entraid-secret-rr',
  cloudSqlConfig,
  dbUser,
  replyUrl,
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
      ingresses: ['regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>'],
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
        {
          secret: kubernetesSecretEntraIdSecretName,
        },
      ],
      env: [
        {
          name: 'RR_SERVER_DOMAIN',
          value: 'regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'RR_SERVER_PROTOCOL',
          value: 'https',
        },
        {
          name: 'RR_SERVER_HTTP_PORT',
          value: '8080',
        },
        {
          name: 'RR_SERVER_ROOT_URL',
          value: 'https://regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'FRONTEND_URL_HOST',
          value: 'regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'TENANT_ID',
          value: '<TENANT_ID>',
        },
        {
          name: 'AUTH_PROVIDER_URL',
          value: 'https://regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>/callback',
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
          name: 'FRISK_FRONTEND_URL_HOST',
          value: 'https://frisk.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'RR_OAUTH_TENANT_ID',
          value: '<TENANT_ID>',
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
          value: 'frisk.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'RR_MICROSOFT_GRAPH_GROUPFILTER',
          value: "startswith(displayName,'AAD -') or displayName eq 'Kartverket' or displayName eq 'ED Eiendomsdivisjonen'",
        },
        {
          name: 'RR_OAUTH_CLIENT_ID',
          valueFrom: {
            secretKeyRef: {
              name: kubernetesSecretEntraIdSecretName,
              key: 'RR_APP_CLIENT_ID',
            },
          },
        },
        {
          name: 'RR_OAUTH_CLIENT_SECRET',
          valueFrom: {
            secretKeyRef: {
              name: kubernetesSecretEntraIdSecretName,
              key: 'RR_APP_CLIENT_SECRET',
            },
          },
        },
      ],
      filesFrom: [
        {
          mountPath: '/etc/regelrett/provisioning/schemasources',
          secret: 'provisioning-file',
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
              host: 'api.airtable.com',
            },
            {
              host: 'login.microsoftonline.com',
            },
            {
              host: 'graph.microsoft.com',
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
            key: 'regelrett-airtable-token',
            metadataPolicy: 'None',
          },
          secretKey: 'RR_SCHEMA_DRIFTSKONTINUITET_AIRTABLE_ACCESS_TOKEN',
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
    kind: 'ExternalSecret',
    metadata: {
      name: 'provisioning-file',
    },
    spec: {
      data: [
        {
          remoteRef: {
            key: 'regelrett-defaults',
            metadataPolicy: 'None',
          },
          secretKey: 'defaults.yaml',
        },
      ],
      refreshInterval: '1h',
      secretStoreRef: {
        kind: 'SecretStore',
        name: secretStoreName,
      },
      target: {
        name: 'provisioning-file',
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
  {
    apiVersion: 'nais.io/v1',
    kind: 'AzureAdApplication',
    metadata: {
      name: 'regelrett-service-entraid',
      namespace: 'regelrett-main',
    },
    spec: {
      claims: {
        groups: [{ id: '<GROUP_ID>' }],  //legger til kartverket i groups, for å assigne alle i kartverket til RR.
      },
      replyUrls: [
        {
          url: replyUrl,
        },
      ],
      secretName: kubernetesSecretEntraIdSecretName,
      secretKeyPrefix: 'RR_',
    },
  },
]