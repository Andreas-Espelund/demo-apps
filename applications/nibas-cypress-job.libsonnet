function(version, service_account, db_host, db_ip) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'SKIPJob',
    metadata: {
      name: 'nibas-cypress',
    },
    spec: {
      job: {
        backoffLimit: 1,
      },
      container: {
        image: version,
        gcp: {
          auth: {
            serviceAccount: service_account,
          },
        },
        envFrom: [
          { secret: 'nibas-e2e-secret' },
        ],
        resources: {
          limits: {
            memory: '5G',
          },
          requests: {
            cpu: '1',
            memory: '1G',
          },
        },
        accessPolicy: {
          outbound: {
            rules: [
              { application: 'nibas-backend', namespace: 'nibas-e2e' },
              { application: 'nibas-frontend', namespace: 'nibas-e2e' },
            ],
            external: [
              { host: db_host, ip: db_ip, ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
              { host: '<EXTERNAL_HOST_1>' },
              { host: '<EXTERNAL_HOST_2>' },
              { host: '<EXTERNAL_HOST_3>' },
              { host: '<EXTERNAL_HOST_4>' },
              { host: '<EXTERNAL_HOST_5>' },
              { host: '<EXTERNAL_HOST_6>' },
              { host: '<EXTERNAL_HOST_7>' },
              { host: '<EXTERNAL_HOST_8>' },
              { host: '<EXTERNAL_HOST_9>' },
              { host: '<EXTERNAL_HOST_10>' },
              { host: '<EXTERNAL_HOST_11>' },
              { host: 'slack.com' },
              { host: 'files.slack.com' },
              { host: 'storage.googleapis.com' },
              { host: 'oauth2.googleapis.com' },
            ],
          },
        },
      },
    },
  },
]
