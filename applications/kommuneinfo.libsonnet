function(image, db_host, db_ip) {
  apiVersion: 'skiperator.kartverket.no/v1alpha1',
  kind: 'Application',
  metadata: {
    name: 'kommuneinfo',
  },
  spec: {
    image: image,
    port: 5000,
    envFrom: [
      { secret: 'kommuneinfo-db-secret' },
    ],
    resources: {
      limits: {
        memory: '1G',
      },
      requests: {
        cpu: '100m',
        memory: '250M',
      },
    },
    prometheus: {
      path: '/kommuneinfo/v1/metrics',
      port: 5000,
    },
    accessPolicy: {
      outbound: {
        external: [
          {
            host: db_host,
            ip: db_ip,
            ports: [
              {
                name: 'psql',
                protocol: 'TCP',
                port: 5432,
              },
            ],
          },
        ],
      },
    },
    liveness: {
      path: '/kommuneinfo/v1/healthx',
      port: 5000,
    },
    readiness: {
      path: '/kommuneinfo/v1/healthz',
      port: 5000,
    },
  },
}
