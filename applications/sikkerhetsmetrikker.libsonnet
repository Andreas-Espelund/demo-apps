function(env, name, version, gcpAuth, clientId, gsmProjectId, gsm='<SECRET_STORE_NAME>', dbHost) [
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
      env: [
        {
          name: 'GSM_PROJECT_ID',
          value: if env == 'dev' then '<GSM_PROJECT_ID_DEV>'
          else if env == 'prod' then '<GSM_PROJECT_ID_PROD>',
        },
        {
          name: 'DB_USERNAME',
          value: '<DB_USERNAME>',
        },
      ],
      filesFrom: [
        {
          mountPath: '/app/db-ssl-ca',
          secret: 'db-ssl-values',
        },
      ],
      envFrom: [
        {
          secret: 'smapi-db-user-password',
        },
      ],
      resources: {
        requests: {
          cpu: '25m',
          memory: '512Mi',
        },
      },
      ingresses: ['sikkerhetsmetrikker.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>'],
      gcp: {
        auth: gcpAuth,
      },
      accessPolicy: {
        inbound: {
          rules: [
            {
              application: 'backstage',
              namespace: 'backstage',
            },
            {
              application: 'nightly-update-skipjob',
            },
          ],
        },
        outbound: {
          rules: [
            {
              application: 'security-champion-api',
            },
          ],
          external: [
            {
              host: 'api.github.com',
            },
            {
              host: 'eu1.app.sysdig.com',
            },
            {
              host: '<EXTERNAL_DOMAIN>',
            },
            {
              host: 'login.microsoftonline.com',
            },
            {
              host: 'hooks.slack.com',
            },
            {
              host: 'cloud.tenable.com',
            },
            {
              host: if env == 'dev' then 'smapi-db-dev'
              else if env == 'prod' then 'smapi-db-prod',
              ip: dbHost,
              ports: [
                {
                  name: 'sql',
                  port: 5432,
                  protocol: 'TCP',
                },
              ],
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
      name: 'istio-sticky',
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
    // TODO: Change to v1 when upstream Istio + skipctl has fixed their CRDs, already supported by SKIP
    apiVersion: 'security.istio.io/v1beta1',
    kind: 'RequestAuthentication',
    metadata: {
      name: name + '-auth-n',
    },
    spec: {
      selector: {
        matchLabels: {
          app: name,
        },
      },
      jwtRules: [
        {
          issuer: 'https://login.microsoftonline.com/<TENANT_ID>/v2.0',
          jwksUri: 'https://login.microsoftonline.com/<TENANT_ID>/discovery/v2.0/keys',
          audiences: [clientId],
          forwardOriginalToken: true,
        },
      ],
    },
  },

  // Database credentials from cloudsql config terraform module. Should be mounted as files in the application
  {
    apiVersion: 'external-secrets.io/v1',
    kind: 'ExternalSecret',
    metadata: {
      name: 'db-ssl-values',
    },
    spec: {
      refreshInterval: '1h',
      secretStoreRef: {
        name: gsm,
        kind: 'SecretStore',
      },
      // Load the keys into the kubernetes secret, which is mounted as files in the application
      target: {
        name: 'db-ssl-values',
        creationPolicy: 'Owner',
      },
      data: [
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'Base64',
            key: 'cloudsql-smapi-db-smapiapplication',
            metadataPolicy: 'None',
            property: 'private_key_pkcs8',
          },
          secretKey: 'client-key.pk8',
        },
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'None',
            key: 'cloudsql-smapi-db-smapiapplication',
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
      name: 'smapi-db-user-password',
    },
    spec: {
      refreshInterval: '1h',
      secretStoreRef: {
        name: gsm,
        kind: 'SecretStore',
      },
      target: {
        name: 'smapi-db-user-password',
        creationPolicy: 'Owner',
      },
      data: [
        {
          remoteRef: {
            conversionStrategy: 'Default',
            decodingStrategy: 'None',
            key: 'cloudsql-smapi-db-smapiapplication',
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
      name: gsm,
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
          to: [
            {
              operation: {
                methods: ['GET'],
                paths: [
                  '/swagger-ui*',
                  '/api-docs*',
                  '/token',
                  '/login/oauth2/code/entra',
                  '/oauth2/authorization/entra',
                  '/dummy/vulnerabilities/*',
                  '/api/dynamicScan/**',
                  '/api/dynamicScan/*',
                  '/api/dynamicScan/',
                ],
              },
            },
            {
              operation: {
                methods: ['POST'],
                paths: [
                  '/api/risc/test',
                ],
              },
            },
          ],
        },
        {
          to: [
            {
              operation: {
                methods: ['POST', 'DELETE'],
                paths: ['/api/oppdateringer*', '/api/securityChampion/update'],
              },
            },
          ],
          when: [
            {
              key: 'request.auth.claims[roles]',
              values: ['sikkerhetsmetrikker.skrive.alt'],
            },
          ],
        },
        {
          to: [
            {
              operation: {
                methods: ['GET'],
              },
            },
          ],
          when: [
            {
              key: 'request.auth.claims[roles]',
              values: ['sikkerhetsmetrikker.lese.alt'],
            },
          ],
        },
        {
          to: [
            {
              operation: {
                methods: ['POST'],
                paths: ['/api/securityChampion'],
              },
            },
          ],
          when: [
            {
              key: 'request.auth.claims[iss]',
              values: ['https://login.microsoftonline.com/<TENANT_ID>/v2.0'],
            },
          ],
        },
        {
          to: [
            {
              operation: {
                methods: ['GET'],
                paths: ['/api/securityChampion/workMail'],
              },
            },
          ],
          when: [
            {
              key: 'request.auth.claims[roles]',
              values: ['sikkerhetsmetrikker.lese.alt', 'githubkvmail.lese.alt'],
            },
          ],
        },
        {
          to: [
            {
              operation: {
                methods: ['GET'],
                paths: ['/api/metrikker/*', '/api/scannerData/*'],
              },
            },
            {
              operation: {
                methods: ['POST'],
                paths: ['/api/metrikker/vulnerabilities/trends/counts', '/api/securityChampion/workMail', '/api/scannerData', '/api/scannerData/trends', '/api/metrikker/ros-status', '/api/metrikker/ros-status/v2', '/api/dynamicScan/', '/api/dynamicScan/*', '/api/dynamicScan/**', '/api/oppdateringer/alertsMetadata/accept'],
              },
            },
          ],
          when: [
            {
              key: 'request.auth.claims[iss]',
              values: ['https://login.microsoftonline.com/<TENANT_ID>/v2.0'],
            },
          ],
        },
        {
          from: [
            {
              source: {
                principals: [
                  'cluster.local/ns/sikkerhetsmetrikker-main/sa/nightly-update-skipjob',
                ],
              },
            },
          ],
          to: [
            {
              operation: {
                methods: ['POST', 'GET'],
                paths: ['/api/oppdateringer*'],
              },
            },
          ],
        },
        {
          from: [
            {
              source: {
                principals: [
                  'cluster.local/ns/sikkerhetsmetrikker-main/sa/nightly-update-skipjob',
                ],
              },
            },
          ],
          to: [
            {
              operation: {
                methods: ['POST'],
                paths: ['/api/slack/nightlyUpdate'],
              },
            },
          ],
        },
        {
          to: [
            {
              operation: {
                methods: ['POST'],
                paths: ['/api/backstage/catalogInfo'],
              },
            },
          ],
        },
        {
          to: [
            {
              operation: {
                methods: ['GET'],
                paths: ['/api/public/metrikker/avdeling'],
              },
            },
          ],
        },
      ],
    },
  },
]