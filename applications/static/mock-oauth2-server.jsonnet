[
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'mock-oauth2-server',
    },
    spec: {
      image: 'ghcr.io/navikt/mock-oauth2-server:2.2.1@sha256:2418020949eefdf15e64e5dff74eaa7614de382ed7276564adb2c9b57f864169',
      port: 8080,
      ingresses: ['mock-oauth2-server.atkv3-dev.kartverket-intern.cloud'],
      replicas: {
        min: 1,
        max: 3,
        targetCpuUtilization: 80,
      },
      gcp: {
        auth: {
          serviceAccount: 'nibas-backend-publisher@nibas-dev-075c.iam.gserviceaccount.com',
        },
      },
      liveness: {
        path: '/isalive',
        port: 8080,
        initialDelay: 60,
      },
      readiness: {
        path: '/isalive',
        port: 8080,
        initialDelay: 60,
      },
      resources: {
        limits: {
          cpu: '500m',
          memory: '512M',
        },
        requests: {
          cpu: '100m',
          memory: '256M',
        },
      },
      accessPolicy: {
        inbound: {
          rules: [
            { application: 'nibas-frontend' },
            { application: 'nibas-backend' },
          ],
        },
      },
    },
  },
]
