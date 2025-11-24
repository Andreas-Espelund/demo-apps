function(
  env,
  name='ros-plugin-backend',
  version,
  gsmProjectId,
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
      envFrom: [
        {
          secret: 'ros-plugin-backend-secrets',
        },
      ],
      env: [
        {
          name: 'RISC_FOLDER_PATH',
          value: '.security/risc',
        },
        {
          name: 'ISSUER_URI',
          value: if env == 'dev' then 'https://backstage.<DOMAIN_PREFIX>-dev.<DOMAIN_SUFFIX>/api/auth' else if env == 'prod' then 'https://<PROD_DOMAIN>/api/auth',
        },
        {
          name: 'FILENAME_PREFIX',
          value: 'risc',
        },
        {
          name: 'FILENAME_POSTFIX',
          value: 'risc',
        },
        {
          name: 'JSON_SCHEMA_PATH',
          value: '/kartverket/backstage-plugin-risk-scorecard-backend/contents/docs',
        },
        {
          name: 'CRYPTO_SERVICE_URL',
          value: 'http://crypto-service.ros-plugin-main:8080',
        },
        {
          name: 'INIT_RISC_URL',
          value: 'http://init-risc-service.sikkerhetsmetrikker-main:8085',
        },
        {
          name: 'BACKEND_PUBLIC_KEY',
          value: '<BACKEND_PUBLIC_KEY>',
        },
        {
          name: 'ROSA_URL',
          value: 'http://rosa-service.ros-plugin-main:8888',
        },
      ],
      accessPolicy: {
        inbound: {
          rules: [
            {
              application: 'backstage',
              namespace: 'backstage',
            },
          ],
        },
        outbound: {
          rules: [
            {
              application: 'crypto-service',
            },
            {
              application: 'rosa-service',
            },
            {
              namespace: 'sikkerhetsmetrikker-main',
              application: 'init-risc-service',
            },
          ],
          external: [
            {
              host: '<GITHUB_API_HOST>',
            },
            {
              host: '<GOOGLE_OAUTH_HOST>',
            },
            {
              host: '<GOOGLE_CLOUD_RESOURCE_MANAGER_HOST>',
            },
            {
              host: '<DOCUMENTATION_HOST>',
            },
            {
              host: '<SLACK_WEBHOOK_HOST>',
            },
            {
              host: if env == 'dev' then 'backstage.<DOMAIN_PREFIX>-dev.<DOMAIN_SUFFIX>' else if env == 'prod' then '<PROD_DOMAIN>',
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
      name: 'ros-plugin-backend-secrets',
    },
    spec: {
      data: [
        {
          remoteRef: {
            key: 'backstage-risc-github-app-id',
            metadataPolicy: 'None',
          },
          secretKey: 'GITHUB_APP_ID',
        },
        {
          remoteRef: {
            key: 'backstage-risc-github-app-private-key',
            metadataPolicy: 'None',
          },
          secretKey: 'GITHUB_APP_PRIVATE_KEY',
        },
        {
          remoteRef: {
            key: 'backstage-risc-github-app-installation-id',
            metadataPolicy: 'None',
          },
          secretKey: 'GITHUB_APP_INSTALLATION_ID',
        },
        {
          remoteRef: {
            key: 'ros-plugin-backend-slack-feedback-webhook-url',
            metadataPolicy: 'None',
          },
          secretKey: 'SLACK_FEEDBACK_WEBHOOK_URL',
        },
      ],
      refreshInterval: '1h',
      secretStoreRef: {
        kind: 'SecretStore',
        name: 'ros-plugin-backend-secret-store',
      },
      target: {
        name: 'ros-plugin-backend-secrets',
      },
    },
  },
  {
    apiVersion: 'external-secrets.io/v1',
    kind: 'SecretStore',
    metadata: {
      name: 'ros-plugin-backend-secret-store',
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
                paths: ['/api/*'],
              },
            },
          ],
        },
      ],
    },
  },
]