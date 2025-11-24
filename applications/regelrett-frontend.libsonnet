function(name='regelrett-frontend', env, version) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: name,
    },
    spec: {
      image: version,
      port: 3000,
      ingresses: ['regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>'],
      resources: {
        requests: {
          cpu: '25m',
          memory: '128Mi',
        },
      },
      accessPolicy: {
        outbound: {
          rules: [
            {
              application: 'regelrett-backend',
            },
          ],
        },
      },
      env: [
        {
          name: 'VITE_AUTHORITY',
          value: 'https://login.microsoftonline.com/<TENANT_ID>/v2.0',
        },
        {
          name: 'VITE_FRONTEND_URL',
          value: 'https://regelrett.<DOMAIN_PREFIX>-' + env + '.<DOMAIN_SUFFIX>',
        },
        {
          name: 'VITE_CLIENT_ID',
          value: if env == 'dev' then '<VITE_CLIENT_ID_DEV>'
          else if env == 'prod' then '<VITE_CLIENT_ID_PROD>',
        },
        {
          name: 'VITE_BACKEND_URL',
          value: '/api',
        },
      ],
    },
  },
]