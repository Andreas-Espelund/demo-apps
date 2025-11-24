local argokit = import '../argokit/jsonnet/argokit.libsonnet';

function(image, db_host, db_ip) {
  apiVersion: 'skiperator.kartverket.no/v1alpha1',
  kind: 'Application',
  metadata: {
    name: 'stedsnavn',
  },
  spec: {
    image: image,
    port: 5000,
    envFrom: [
      { secret: 'stedsnavn-db-secret' },
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
      path: '/stedsnavn/v1/metrics',
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
      path: '/stedsnavn/v1/healthx',
      port: 5000,
    },
    readiness: {
      path: '/stedsnavn/v1/healthz',
      port: 5000,
    },
  },
}
