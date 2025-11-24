function(
  name='crypto-service',
  version,
  gsmProjectId,
  secretStoreName='secret-store-crypto-service',
  esoName='crypto-service-secrets'
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
          name: 'SECURITY_TEAM_PUBLIC_KEY',
          value: '<SECURITY_TEAM_PUBLIC_KEY>',
        },
        {
          name: 'SECURITY_PLATFORM_PUBLIC_KEY',
          value: '<SECURITY_PLATFORM_PUBLIC_KEY>',
        },
        {
          name: 'BACKEND_PUBLIC_KEY',
          value: '<BACKEND_PUBLIC_KEY>',
        },
      ],
      envFrom: [
        {
          secret: esoName,
        },
      ],
      accessPolicy: {
        inbound: {
          rules: [
            {
              application: 'ros-plugin-backend',
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
            key: 'ros-plugin-sops-age-key',
            metadataPolicy: 'None',
          },
          secretKey: 'SOPS_AGE_KEY',
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
                  '<PRINCIPAL_PATH>',
                ],
              },
            },
          ],
          to: [
            {
              operation: {
                paths: ['/*'],
              },
            },
          ],
        },
      ],
    },
  },
]