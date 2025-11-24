function(version, environment, project_id, matrikkel_db_host, matrikkel_db_ip, komreg_db_host, komreg_db_ip) [
  {
    apiVersion: 'skiperator.kartverket.no/v1alpha1',
    kind: 'Application',
    metadata: {
      name: 'komreg-backend'
    },
    spec: {
      image: version,
      port: 8080,
      priority: 'high',
      ingresses: ['komreg-backend' + '.<DOMAIN_PREFIX>-' + environment + '.<DOMAIN_SUFFIX>'],
      replicas: {
        min: 1,
        max: 1,
        targetCpuUtilization: 80,
      },
      gcp: {
          auth: {
            serviceAccount: '<SERVICE_ACCOUNT>'
          },
      },
      env: [
        {
          name: 'GOOGLE_CLOUD_PROJECT',
          value: project_id,
        },
        {
          name: 'environment',
          value: environment,
        },
        {
          name: 'JAVA_TOOL_OPTIONS',
          value: '-XX:MaxRAMPercentage=90.0',
        },
      ],
      envFrom: [{ secret: 'komreg-kubernetes-secrets' }],
      liveness: {
        path: '/actuator/health',
        port: 8080,
      },
      readiness: {
        path: '/actuator/health',
        port: 8080,
      },
      prometheus: {
        path: '/actuator/metrics',
        port: 8080,
      },
      resources: {
        limits: {
          memory: '60Gi',
        },
        requests: {
          cpu: '30m',
        },
      },
      accessPolicy: {
        inbound: {
          rules: [
            { application: 'komreg-frontend-v2', namespace: 'komreg-main' },
          ],
        },
        outbound: {
          external: [
            {
              host: matrikkel_db_host,
              ip: matrikkel_db_ip,
              ports: [
                {
                  name: 'matrikkel-dev',
                  protocol: 'TCP',
                  port: 1521
                }
              ]
            },
            {
              host: komreg_db_host,
              ip: komreg_db_ip,
              ports: [
                {
                  name: 'komreg-dev',
                  protocol: 'TCP',
                  port: 5432
                }
              ]
            },
          ],
        },
      },
    },
  }
]
