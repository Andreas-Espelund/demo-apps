function(version, service_account) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'SKIPJob',
    metadata: {
      name: 'nibas-db-copy-prod-to-dev',
    },
    spec: {
      container: {
        image: version,
        gcp: {
          auth: {
            serviceAccount: service_account,
          },
        },
        envFrom: [
          { secret: 'nibas-proddump-secret' },
        ],
        env: [
          { name: 'PGPASSFILE', value: '/app/pgpass/.pgpass' },
        ],
        resources: {
          limits: {
            memory: '2G',
          },
          requests: {
            cpu: '100m',
            memory: '250M',
          },
        },
        filesFrom: [
          { mountPath: '/app/pgpass', secret: 'pgpass-secret', defaultMode: 384 },
        ],
        accessPolicy: {
          outbound: {
            external: [
              { host: '<DB_HOST_1>', ip: '<DB_IP_1>', ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
              { host: '<DB_HOST_2>', ip: '<DB_IP_2>', ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
              { host: '<DB_HOST_3>', ip: '<DB_IP_3>', ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
            ],
          },
        },
      },
      cron: {
        schedule: '0 3 * * *',
        suspend: true,
      },
    },
  },
]
