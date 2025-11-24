function(version, service_account, source_db, target_db) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'SKIPJob',
    metadata: {
      name: 'nibas-db-copy-prod-to-backup',
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
          { secret: 'nibas-proddump-backup-secret' },
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
              { host: source_db.host, ip: source_db.ip, ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
              { host: target_db.host, ip: target_db.ip, ports: [{ name: 'sql', protocol: 'TCP', port: 5432 }] },
            ],
          },
        },
      },
      cron: {
        schedule: '0 3 * * *',
        suspend: false,
      },
    },
  },
]
