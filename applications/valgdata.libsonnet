function(image, valgdata_secret, valgdata_bucket)
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'valgdata',
    },
    spec: {
      image: image,
      port: 8080,
      replicas: {
        min: 2,
        max: 5,
        targetCpuUtilization: 80,
      },
      envFrom: [
        { secret: valgdata_secret },
      ],
      env: [
        {
          name: 'ENV',
          value: 'cloud',
        },
        {
          name: 'VALGDATA_BUCKET_NAME',
          value: valgdata_bucket,
        },
      ],
      liveness: {
        path: '/actuator/health/liveness',
        port: 8081,
        initialDelay: 60,
      },
      readiness: {
        path: '/actuator/health/readiness',
        port: 8081,
        initialDelay: 60,
      },
      prometheus: {
        port: 8081,
        path: '/actuator/prometheus',
      },
      resources: {
        limits: {
          memory: '1G',
        },
        requests: {
          cpu: '100m',
          memory: '250M',
        },
      },
      accessPolicy: {
        outbound: {
          external: [
            { host: 'storage.googleapis.com' },
            { host: 'oauth2.googleapis.com' },
          ],
        },
      },
    },
  }
