function(version, ingress, spring_profiles, service_account, db_host, db_ip, nibas_db_secret='nibas-db-secret', namespace='nibas-main', db_name='nibas') [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'nibas-backend',
    },
    spec: {
      image: version,
      port: 8080,
      ingresses: [ingress],
      replicas: {
        min: 2,
        max: 5,
        targetCpuUtilization: 80,
      },
      gcp: {
        auth: {
          serviceAccount: service_account,
        },
      },
      envFrom: [
        { secret: nibas_db_secret },
        { secret: 'nibas-backend-secret' },
        { secret: 'nibas-backend-apikeys-secret' },
        { secret: 'nibas-events-apikeys-secret' },
      ],
      env: [
        {
          name: 'SPRING_PROFILES_ACTIVE',
          value: spring_profiles,
        },
        {
          name: 'nibas-events.host',
          value: 'http://nibas-events.' + namespace + ':8080',
        },
        {
          name: 'nibas.arbeidsliste.host',
          value: 'http://nibas-arbeidsliste.' + namespace + ':8080',
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
          memory: '2G',
        },
        requests: {
          cpu: '0.3',
          memory: '750M',
        },
      },
      accessPolicy: {
        inbound: {
          rules: [
            { application: 'nibas-frontend', namespace: namespace },
            { application: 'nibas-arbeidsliste', namespace: namespace },
            { application: 'nibas-frontend', namespace: 'nibas-e2e' },
            { application: 'nibas-data-exporter-skipjob', namespace: 'nibas-misc' },
            { application: 'dataplattform-proxy', namespace: 'dataplattform' },
          ],
        },
        outbound: {
          rules: [
            { application: 'nibas-events', namespace: namespace },
            { application: 'nibas-arbeidsliste', namespace: namespace },
            { application: 'mock-oauth2-server' },
          ],
          external: [
            { host: db_host, ip: db_ip, ports: [{ name: 'postgisport', protocol: 'TCP', port: 5432 }] },
            { host: '<EXTERNAL_HOST>' },
          ],
        },
      },
    },
  },
]
