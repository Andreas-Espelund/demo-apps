function(
  name='security-champion-api',
  env,
  version,
  gsmSecretStoreName='<SECRET_STORE_NAME>',
  gsmProjectId,
  databaseHost,
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
      resources: {
        requests: {
          cpu: '25m',
          memory: '256Mi',
        },
      },
      replicas: {
        min: 1,
        max: 2,
      },
      liveness: {
        path: '/actuator/health',
        port: 8081,
        failureThreshold: 10,
        initialDelay: 30,
      },
      readiness: {
        path: '/actuator/health',
        port: 8081,
        failureThreshold: 10,
        initialDelay: 30,
      },
      prometheus: {
        path: '/actuator/prometheus',
        port: 8081,
      },
      accessPolicy: {
        inbound: {
          rules: [
            {
              application: 'backstage',
              namespace: 'backstage',
            },
            {
              application: 'sikkerhetsmetrikker',
              namespace: 'sikkerhetsmetrikker-main',
            },
          ],
        },
        outbound: {
          external: [
            {
              host: if env == 'prod' then 'smapi-db-prod' else 'smapi-db-dev',
              ip: databaseHost,
              ports: [
                {
                  name: 'sql',
                  port: 5432,
                  protocol: 'TCP',
                },
              ],
            },
            {
              host: '<MICROSOFT_LOGIN_HOST>',
            },
          ],
        },
      },
      env: [
        {
          name: 'DB_USERNAME',
          value: '<DB_USERNAME>',
        },
        {
          name: 'DB_URL',
          value: 'jdbc:postgresql://' + databaseHost + ':5432/secchamp?sslmode=require&sslrootcert=/app/db-ssl-ca/server-ca.pem&sslcert=/app/db-ssl-ca/client-cert.pem&sslkey=/app/db-ssl-ca/client-key.pk8',
        },
      ],
      // Load all secrets from the kubernetes secret into the application as environment variables
      envFrom: [
        {
          secret: 'secchamp-db-user-password',
        },
      ],
      // Load the ssl cert and private key into the application as files mounted in the container
      filesFrom: [
        {
          mountPath: '/app/db-ssl-ca',
          secret: 'secchamp-db-ssl-values',
        },
      ],
    },
  },
  // Database credentials from cloudsql config terraform module. Should be mounted as files in the application
  {
    apiVersion: 'external-secrets.io/v1',
    kind: 'ExternalSecret',
    metadata: {
      name: 'secchamp-db-ssl-values',
    },
    spec: {
      refreshInterval: '1h',
      secretStoreRef: {
        name: gsmSecretStoreName,
        kind: 'SecretStore',
      },
      target: {
        name: 'secchamp-db-ssl-values',
        creationPolicy: 'Owner',
      },
      data: [
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'Base64',
            key: 'cloudsql-smapi-db-secchampapplicationuser',
            metadataPolicy: 'None',
            property: 'private_key_pkcs8',
          },
          secretKey: 'client-key.pk8',
        },
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'None',
            key: 'cloudsql-smapi-db-secchampapplicationuser',
            metadataPolicy: 'None',
            property: 'cert',
          },
          secretKey: 'client-cert.pem',
        },
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'None',
            key: 'cloudsql-smapi-db-instance',
            metadataPolicy: 'None',
            property: 'cert',
          },
          secretKey: 'server-ca.pem',
        },
      ],
    },
  },
  // Database HOST and PASSWORD from cloudsql config terraform module. Should be mounted as env vars in the application
  {
    apiVersion: 'external-secrets.io/v1',
    kind: 'ExternalSecret',
    metadata: {
      name: 'secchamp-db-user-password',
    },
    spec: {
      refreshInterval: '1h',
      secretStoreRef: {
        name: gsmSecretStoreName,
        kind: 'SecretStore',
      },
      target: {
        name: 'secchamp-db-user-password',
        creationPolicy: 'Owner',
      },
      data: [
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'None',
            key: 'cloudsql-smapi-db-secchampapplicationuser',
            metadataPolicy: 'None',
            property: 'password',
          },
          secretKey: 'DB_PASSWORD',
        },
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'None',
            key: 'cloudsql-smapi-db-instance',
            metadataPolicy: 'None',
            property: 'private_ip',
          },
          secretKey: 'DB_HOST',
        },
      ],
    },
  },
  {
    apiVersion: 'external-secrets.io/v1',
    kind: 'SecretStore',
    metadata: {
      name: gsmSecretStoreName,
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
    // TODO: Change to v1 when upstream Istio + skipctl has fixed their CRDs, already supported by SKIP
    apiVersion: 'security.istio.io/v1beta1',
    kind: 'AuthorizationPolicy',
    metadata: {
      name: name + '-auth-z',
    },
    spec: {
      selector: {
        matchLabels: {
          app: name,
        },
      },
      action: 'ALLOW',
      rules: [
        {
          from: [
            {
              source: {
                principals: [
                  'cluster.local/ns/backstage/sa/backstage',
                ],
              },
            },
          ],
          to: [
            {
              operation: {
                methods: ['POST', 'GET'],
                paths: ['/api/securityChampion', '/api/setSecurityChampion'],
              },
            },
          ],
        },
        {
          from: [
            {
              source: {
                principals: [
                  'cluster.local/ns/sikkerhetsmetrikker-main/sa/sikkerhetsmetrikker',
                ],
              },
            },
          ],
          to: [
            {
              operation: {
                methods: ['GET'],
                paths: ['/api/repositories/all'],
              },
            },
          ],
        },
      ],
    },
  },
]