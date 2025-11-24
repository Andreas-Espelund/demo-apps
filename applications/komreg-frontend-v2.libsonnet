function(version, environment, namespace) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'komreg-frontend-v2'
    },
    spec: {
      image: version,
      port: 8080,
      ingresses: ['komreg-frontend-v2.<DOMAIN_PREFIX>-' + environment + '.<DOMAIN_SUFFIX>'],
      replicas: {
        min: 0,
        max: 0,
        targetCpuUtilization: 80,
      },
      filesFrom: [
        { emptyDir: 'data', mountPath: '/data' },
        { emptyDir: 'config', mountPath: '/config' },
      ],
      env: [
      {
        name: 'BACKEND_HOST',
        value: 'http://komreg-backend.' + namespace + ':8080',
      },
    ],
      liveness: {
        path: '/',
        port: 8080,
      },
      readiness: {
        path: '/',
        port: 8080,
      },
      resources: {
        limits: {
          memory: '768M',
        },
        requests: {
          cpu: '25m',
          memory: '350M',
        },
      },
      accessPolicy: {
        outbound: {
          rules: [
            { application: 'komreg-backend', namespace: namespace },
          ],
        },
      },
    },
  }
]
