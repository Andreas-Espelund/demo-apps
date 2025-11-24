function(version, ingress, service_account, db_host, db_ip, namespace='nibas-main', db_name='nibas') [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'nibas-events',
    },
    spec: {
      image: version,
      port: 8080,
      ingresses: [ingress],
      replicas: {
        min: 1,
        max: 3,
        targetCpuUtilization: 80,
      },
      gcp: {
        auth: {
          serviceAccount: service_account,
        },
      },
      envFrom: [
        { secret: 'nibas-events-db-secret' },
        { secret: 'nibas-events-apikeys-secret' },
      ],
      env: [
        {
          name: 'spring.datasource.url',
          value: 'jdbc:postgresql://' + db_host + ':' + '5432' + '/' + db_name,
        },
      ],
      liveness: {
        path: '/actuator/health/liveness',
        port: 8080,
        initialDelay: 90,
      },
      readiness: {
        path: '/actuator/health/readiness',
        port: 8080,
        initialDelay: 90,
      },
      prometheus: {
        port: 8080,
        path: '/actuator/prometheus',
      },
      resources: {
        limits: {
          memory: '1G',
        },
        requests: {
          cpu: '30m',
          memory: '500M',
        },
      },
      accessPolicy: {
        inbound: {
          rules: [
            { application: 'nibas-backend', namespace: namespace },
            { application: 'dataplattform-proxy', namespace: 'dataplattform' },
          ],
        },
        outbound: {
          external: [
            { host: db_host, ip: db_ip, ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
          ],
        },
      },
    },
  },
]
