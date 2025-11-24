function(image, config) {
  apiVersion: 'skiperator.kartverket.no/v1alpha1',
  kind: 'Application',
  metadata: {
    name: 'aal-register',
  },
  spec: {
    image: image,
    port: config.server.port,
    replicas: 1,
    strategy: {
      type: 'Recreate',
    },
    filesFrom: [
      {
        mountPath: '/srv/aal-register/config/properties',
        configMap: 'aal-register-config',
      },
    ],
    envFrom: [
      {
        secret: 'aal-register-secret',
      },
    ],
    accessPolicy: {
      inbound: {
        rules: [
          {
            application: 'aal-integrator',
          }
        ]
      }
    },
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
  },
}
