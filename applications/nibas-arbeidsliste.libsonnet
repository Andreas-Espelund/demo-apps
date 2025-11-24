function(version, ingress, service_account, db_host, db_ip, spring_profiles, namespace='nibas-main', db_name='nibas') [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'nibas-arbeidsliste',
    },
    spec: {
      image: version,
      port: 8080,
      ingresses: [ingress],
      replicas: {
        min: 1,
        max: 1,
        targetCpuUtilization: 80,
      },
      gcp: {
        auth: {
          serviceAccount: service_account,
        },
      },
      envFrom: [
        { secret: 'nibas-arbeidsliste-secret' },
        { secret: 'nibas-backend-apikeys-secret' },
      ],
      env: [
        {
          name: 'SPRING_PROFILES_ACTIVE',
          value: spring_profiles,
        },
        {
          name: 'nibas.backend.host',
          value: 'http://nibas-backend.' + namespace + ':8080',
        },
        {
          name: 'spring.datasource.url',
          value: 'jdbc:postgresql://' + db_host + ':' + '5432' + '/' + db_name,
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
          memory: '8G',
        },
        requests: {
          cpu: '0.1',
          memory: '70M',
        },
      },
      accessPolicy: {
        inbound: {
          rules: [
            { application: 'nibas-backend', namespace: namespace },
          ],
        },
        outbound: {
          rules: [
            { application: 'nibas-backend', namespace: namespace },
          ],
          external: [
            { host: db_host, ip: db_ip, ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
            { host: 'api.kartverket.no' },
            { host: 'matrikkel.no' },
          ],
        },
      },
    },
  },
]
