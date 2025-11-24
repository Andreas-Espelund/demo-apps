function(version, environment) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'komreg-frontend'
    },
    spec: {
      image: version,
      port: 8080,
      ingresses: ['komreg.<DOMAIN_PREFIX>-' + environment + '.<DOMAIN_SUFFIX>'],
      replicas: {
        min: 2,
        max: 4,
        targetCpuUtilization: 80,
      },
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
            { application: 'komreg-backend', namespace: 'komreg-main' },
          ],
        },
      },
    },
  }
]
