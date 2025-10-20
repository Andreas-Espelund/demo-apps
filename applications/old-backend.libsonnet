function(
  env,
  name='regelrett-backend',
  version,
  gsmProjectId,
  secretStoreName='regelrett-backend-skvis-gsm',
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
      ingresses: ['regelrett.atgcp1-' + env + '.kartverket-intern.cloud'],
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
          value: 'regelrett.atgcp1-' + env + '.kartverket-intern.cloud',
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
          value: 'https://regelrett.atgcp1-' + env + '.kartverket-intern.cloud',
        },
        {
          name: 'FRONTEND_URL_HOST',
          value: 'regelrett.atgcp1-' + env + '.kartverket-intern.cloud',
        },
        {
          name: 'TENANT_ID',
          value: '7f74c8a2-43ce-46b2-b0e8-b6306cba73a3',
        },
        {
          name: 'AUTH_PROVIDER_URL',
          value: 'https://regelrett.atgcp1-' + env + '.kartverket-intern.cloud/callback',
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
          value: 'https://frisk.atgcp1-' + env + '.kartverket-intern.cloud',
        },
        {
          name: 'RR_OAUTH_TENANT_ID',
          value: '7f74c8a2-43ce-46b2-b0e8-b6306cba73a3',
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
          value: 'frisk.atgcp1-' + env + '.kartverket-intern.cloud',
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
        groups: [{ id: 'a6578085-e0ee-4168-bf97-1b3026f6f3bd' }],  //legger til kartverket i groups, for å assigne alle i kartverket til RR.
      },
      replyUrls: [
        {
          url: replyUrl,
        },
      ],
      preAuthorizedApplications: [
        {
          cluster: ' ',
          namespace: ' ',
          application: if env == 'dev' then '3129a75a-aad3-4fec-b972-61d1b7c21e6c'
          else if env == 'prod' then 'feafce12-89c6-4ffe-8bc6-98cb5c6fa2bf',
        },
      ],
      secretName: kubernetesSecretEntraIdSecretName,
      secretKeyPrefix: 'RR_',
    },
  },
]
