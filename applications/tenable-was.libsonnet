function(
  name='tenable-was-service',
  env,
  version,
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
      env: [
        {
          name: 'WAS_SCANNER_NAME',
          value: 'my-scanner-name',
        },
        {
          name: 'WAS_SCANNER_LOG_FILE',
          value: '/tmp/scanner.log',
        },
      ],
      envFrom: [
        {
          secret: 'WAS_LINKING_KEY',
        },
      ],
      // TODO: Add liveness and readiness probes and prometheus
      /*  liveness: {
           path: '/health',
           port: 8081,
           failureThreshold: 10,
           initialDelay: 30,
       },
       readiness: {
           path: '/health',
           port: 8081,
           failureThreshold: 10,
           initialDelay: 30,
       },
       prometheus: {
           path: '/prometheus',
           port: 8081,
       }, */
      ingresses: ['tenable.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>'],
      accessPolicy: {
        outbound: {
          external: [
            {
              host: 'cloud.tenable.com',
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
      name: 'tenable-api-secret',
    },
    spec: {
      secretStoreRef: {
        kind: 'SecretStore',
        name: 'gsm',
      },
      target: {
        name: 'tenable-linking-key',
      },
      data: [
        {
          secretKey: 'WAS_LINKING_KEY',
          remoteRef: {
            key: 'tenable-linking-key',
          },
        },
      ],
    },
  },
]