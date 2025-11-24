function(name, image, ingress, accessPolicy, env, namespace) {
  apiVersion: 'skiperator.kartverket.no/v1alpha1',
  kind: 'Application',
  metadata: {
    name: name,
  },
  spec: {
    image: image,
    port: 8080,
    ingresses: ingress,
    replicas: {
      min: 2,
      max: 5,
      targetCpuUtilization: 80,
    },
    env: env,
    filesFrom: [
      { emptyDir: 'data', mountPath: '/data' },
      { emptyDir: 'config', mountPath: '/config' },
    ],
    liveness: {
      path: '/',
      port: 8080,
      initialDelay: 30,
    },
    readiness: {
      path: '/',
      port: 8080,
      initialDelay: 30,
    },
    resources: {
      limits: {
        memory: '1G',
      },
      requests: {
        cpu: '10m',
        memory: '500M',
      },
    },
    accessPolicy: accessPolicy,
  },
}
